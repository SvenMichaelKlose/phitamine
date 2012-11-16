;;;;; phitamine – Copyright (c) 2012 Sven Michael Klose <pixel@copei.de>

(defvar *template-parameters* nil)
(defvar *currently-processed-templates* nil)

(defun template-param-value (name &key (if-exists? nil))
  (!? (assoc name *template-parameters* :test #'eq)
      .!
      (unless if-exists?
        (princ "<br>Current template parameters:<br>")
        (print *template-parameters*)
        (princ "<br>")
        (error "template parameter ~A not found" (symbol-name name)))))

(defun template-param (name &key (if-exists? nil))
  (force-list (template-param-value name :if-exists? if-exists?)))

(defmacro define-template (name &key path)
  (print-definition `(define-template ,name :path ,path))
  `(defun ,name (&optional (params nil))
     (& (member ',name *currently-processed-templates*)
        (error "template ~A called recursively" ',name))
     (with-temporaries (*template-parameters* (append params *template-parameters*)
                        *currently-processed-templates* (cons ',name *currently-processed-templates*))
       (apply #'string-concat (filter #'lml2xml ,(list 'backquote (dot-expand (read-file-all path))))))))

(defun template-list (template records)
  (let index 0
    (apply #'string-concat (filter [with-temporary *template-parameters* (cons (cons 'index (1+! index)) *template-parameters*)
                                     (funcall template _)]
                                   records))))
