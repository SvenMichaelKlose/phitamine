(var *home-components* nil)
(var *components* nil)
(var *defined-actions* nil)
(var *action* nil)

(fn add-action (component &key (group 'default) (handler nil))
  (& (assoc component *defined-actions*)
     (error "action ~A is already defined" component))
  (acons! component (. handler group) *defined-actions*))

(defmacro define-action (component &key (group 'default) (handler nil))
  (print-definition `(define-action ,component :handler ,handler :group ,group))
  (| (symbol? group)
     (error "group is not a symbol"))
  `(add-action ',component :group ',group :handler ,(| handler `#',component)))

(fn set-action-group (action-name group)
  (= (cddr (assoc action-name *defined-actions*)) group))

(fn symbols-components (x)
  (@ [? (symbol? _)
        (downcase (symbol-name _))
        (string _)]
     (apply #'append (@ #'ensure-list x))))

(fn components-path (x)
  (apply #'+ (pad (symbols-components x) "/")))

(fn url-assignments-tail (x)
  (& x (+ "?" (apply #'+ (@ [+ _. "=" ._] x)))))

(fn action-url (&optional (components t) &key (remove nil) (update nil) (add nil) (params nil))
  (= components (? (eq t components)
                   (copy-tree *components*)
                   (ensure-alist components)))
  (awhen remove
    (= remove (ensure-list !))
    (= components (remove-if [member _. remove] components)))
  (adolist ((ensure-alist update))
    (aadjoin! !. .! components :test #'eq :to-end? t))
  (when add
    (!= (ensure-alist add)
      (remove-if [eq !.  _.] components)
      (= components (append components !))))
  (& (eq t params)
     (= params (request-data)))
  (+ *base-url* "/" (components-path components) "/" (url-assignments-tail (pairlist (carlist params)
                                                                                     (symbols-components (cdrlist params))))))

(fn action-redirect (&optional (components t) &key (remove nil) (update nil) (add nil))
  (header (+ "Location: http://" (href *_SERVER* "HTTP_HOST")
             (action-url components :remove remove :update update :add add)))
  (quit))

(fn component-action (x)
  (assoc x *defined-actions*))

(fn call-url-action-keep (x n)
  (+! *components* (list (subseq x 0 n)))
  (nthcdr n x))

(fn call-url-action-replace (x)
  (with ((kept next) x)
    (!? kept
        (+! *components* (list (ensure-list kept))))
    next))

(fn call-url-action (action x)
  (with-temporary *action* action
    (let n (funcall .action. x)
      (?
        (number? n) (call-url-action-keep x n)
        (values? n) (call-url-action-replace n)
        n))))

(fn call-url-actions-0 (x)
  (when x
    (let c (make-upcase-symbol x.)
      (!? (component-action c)
          (call-url-actions-0 (call-url-action ! (. c .x)))
          (error "no action found for ~A" x)))));(tpl-error-404)))))

(fn call-url-actions ()
  (= *components* nil)
  (call-url-actions-0 (| (request-path-components)
                         *home-components*)))
