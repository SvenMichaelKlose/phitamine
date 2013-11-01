;;;;; phitamine – Copyright (c) 2012–2013 Sven Michael Klose <pixel@copei.de>

(defvar *template-parameters* nil)
(defvar *currently-processed-templates* nil)

(defun param-error (name)
  (princ "<br>Current template parameters:<br>")
  (print *template-parameters*)
  (princ "<br>")
  (error "template parameter ~A not found" (symbol-name name)))

(defun param (name &key (required? nil))
  (!?
    (assoc name *template-parameters* :test #'eq) .!
    required?      (param-error name)))

(defmacro define-template (name &key path)
  (print-definition `(define-template ,name :path ,path))
  `(defun ,name (&optional (params nil))
     (& (member ',name *currently-processed-templates*)
        (error "template ~A called recursively" ',name))
     (with-temporaries (*template-parameters*            (+ params *template-parameters*)
                        *currently-processed-templates*  (. ',name *currently-processed-templates*))
       (apply #'string-concat (filter #'lml2xml ,(list 'backquote (dot-expand (read-file-all path))))))))

(defun template-list (template records)
  (when records
    (let index 0
      (apply #'string-concat (filter [with-temporary *template-parameters* (. (. 'index (++! index)) *template-parameters*)
                                       (funcall template _)]
                                     records)))))
