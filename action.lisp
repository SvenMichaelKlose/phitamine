;;;;; phitamine – Copyright (c) 2012 Sven Michael Klose <pixel@copei.de>

(defvar *actions* nil)
(defvar *action* nil)
(defvar *components* nil)
(defvar *home-action* nil)
(defvar *default-action* nil)

(defun add-parent-action (component &key (handler nil) (parent nil))
  (when parent
    `(!? (assoc parent *actions* :test #'eq)
         (= (cddr !) parent)
         (error "Cannot set undefined parent ~A for handler ~A." parent handler))))

(defun add-action (component &key (handler nil) (parent nil))
  (add-parent-action component :handler handler :parent parent)
  (acons! component (cons handler nil) *actions*))

(defmacro define-action (component &key (handler nil) (parent nil))
  (print-definition `(define-action ,component :handler ,handler :parent ,parent))
  (| handler           (= handler `#',component))
  (| (symbol? parent)  (error "PARENT is not a symbol"))
  `(add-action ',component :handler ,handler :parent ',parent))

(defun components-path (x)
  (apply #'string-concat (pad (filter [? (symbol? _)
                                         (string-downcase (symbol-name _))
                                         _]
                                      x)
                              "/")))

(defun action-url (components &key (params nil))
  (& (t? components)       (= components *components*))
  (& (symbol? components)  (= components (list components)))
  (& (atom components.)    (= components (list components)))
  (& (t? params)           (= params (request-data)))
  (+ *action-base-url* "/" (components-path (apply #'append components)) (url-assignments-tail params)))

(defun action-redirect (components &key (params nil))
  (header (+ "Location: http://" (%%%href *_SERVER* "HTTP_HOST")
             (action-url components :params params)))
  (quit))

(defun parse-components (x handlers)
  (& x
     (!? (assoc (? (symbol? x.)
                   x.
                   (make-symbol (string-upcase x.)))
                handlers :test #'eq)
         (parse-components (funcall .!. !. .x) (| ..! handlers))
         (tpl-error-404))))

(defun keep-components (n &rest x)
  (append! *components* (list (cons n x))))

(defun call-actions ()
  (parse-components (| (request-path-components) *home-action*) *actions*)
  (funcall (| *action* *default-action*)))

(defun required-component (x)
  (| x
     (progn
       (princ "URL hacking? Tsstsstss!")
       (quit))))

(defmacro set-action (&rest body)
  `(= *action* #'(() ,@body)))

(defun request-action-redirect (action &key (components t))
  (action-redirect components :params (list (cons :action action))))

(defun request-action ()
  (& (has-request?)
     (assoc-value :action (request-data))))
