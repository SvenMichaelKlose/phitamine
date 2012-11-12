;;;;; phitamine – Copyright (c) 2012 Sven Michael Klose <pixel@copei.de>

(defvar *home-components* nil)
(defvar *components* nil)
(defvar *actions* nil)
(defvar *action* nil)

(defun add-action (component &key (group 'default) (handler nil))
  (& (assoc component *actions*)
     (error "action ~A is already defined" component))
  (acons! component (cons handler group) *actions*))

(defmacro define-action (component &key (group 'default) (handler nil))
  (print-definition `(define-action ,component :handler ,handler :group ,group))
  (| (symbol? group) (error "group is not a symbol"))
  `(add-action ',component :group ',group :handler ,(| handler `#',component)))

(defun set-action-group (action-name group)
  (= (cddr (assoc action-name *actions*)) group))

(defun symbol-component (x)
  (? (symbol? x)
     (string-downcase (symbol-name x))
     (string x)))

(defun symbol-components (x)
  (filter #'symbol-component (tree-list x)))

(defun components-path (x)
  (apply #'+ (pad (symbol-components x) "/")))

(defun action-url (&optional (components t) &key (remove nil) (update nil) (add nil) (params nil))
  (| (not update) (cons? update)
     (error "list or alist expected for :UPDATE"))
  (= components (? (t? components)
                   (copy-tree *components*)
                   (force-alist components)))
  (when remove
    (= remove (force-list remove))
    (= components (remove-if [member _ remove] components)))
  (dolist (i (force-alist update))
    (assoc-adjoin .i i. components :test #'eq))
  (append! components (force-alist add))
  (& (t? params) (= params (request-data)))
  (+ *base-url* "/" (components-path components) (url-assignments-tail (pairlist (carlist params) (symbol-components (cdrlist params))))))

(defun requested-actions ()
  (queue-list *requested-actions*))

(defun component-action (x)
  (assoc x *actions*))

(defun call-url-action (action x)
  (with-temporary *action* action
    (let n (| (funcall .action. x)
              (values x. .x))
      (?
        (number? n)
          (progn
            (+! *components* (list (subseq x 0 n)))
            (nthcdr n x))
        (values? n)
          (with ((kept next) n)
            (!? kept
                (+! *components* (list (force-list kept))))
            next)
        n))))

(defun call-url-actions-0 (x)
  (& x
     (let c (make-upcase-symbol x.)
       (!? (component-action c)
           (call-url-actions-0 (call-url-action ! (cons c .x)))
           (tpl-error-404)))))

(defun call-url-actions ()
  (= *components* nil)
  (call-url-actions-0 (| (request-path-components) *home-components*)))

(defun action-redirect (&optional (components t) &key (remove nil) (update nil) (add nil))
  (header (+ "Location: http://" (%%%href *_SERVER* "HTTP_HOST")
             (action-url components :remove remove :update update :add add)))
  (quit))

(defun request-action ()
  (& (has-request?)
     (assoc-value 'action (request-data))))
