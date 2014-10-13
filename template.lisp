;;;;; phitamine – Copyright (c) 2012–2014 Sven Michael Klose <pixel@copei.de>

(defvar *template-parameters* nil)
(defvar *currently-processed-templates* nil)

(defun param-error (name)
  (princ "<br>Current template parameters:<br>")
  (print *template-parameters*)
  (princ "<br>")
  (error "template parameter ~A not found." (symbol-name name)))

(defun param (name &key (required? nil))
  (!?
    (assoc name *template-parameters* :test #'eq) .!
    required?      (param-error name)))

(defun lml2xml-list (x)
  (apply #'string-concat (filter #'lml2xml x)))

(defmacro with-template (name params &body body)
  `(progn
     (& (member ',name *currently-processed-templates*)
        (error "Template ~A called recursively." ',name))
     (with-temporaries (*template-parameters*            (+ ,params *template-parameters*)
                        *currently-processed-templates*  (. ,name *currently-processed-templates*))
       ,@body)))

(defmacro define-template (name &key path)
  (print-definition `(define-template ,name :path ,path))
  `(defun ,name (&optional (params nil))
     (with-template ',name params
       (lml2xml-list ,(list 'backquote (dot-expand (read-file-all path)))))))

(defmacro with-template-parameter (name value &body body)
  `(with-temporary *template-parameters* (acons ,name ,value *template-parameters*)
      ,@body))

(defun template-list (template records)
  (when records
    (let index 0
      (apply #'string-concat (filter [with-template-parameter 'index (++! index)
                                       (funcall template _)]
                                     records)))))
