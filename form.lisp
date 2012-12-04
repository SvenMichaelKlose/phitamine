;;;;; Copyright (c) 2012 Sven Michael Klose <pixel@copei.de>

(defvar *form-data* nil)

(defun has-form? ()
  (& *_POST* (not (empty? *_POST*))))

(defun form-data ()
  (| *form-data*
     (& (has-form?)
        (alet (hash-alist *_POST*)
          (= *form-data* (pairlist (make-upcase-symbols (carlist !))
                                   (cdrlist !)))))))

(defun form-value (x)
  (assoc-value x (form-data)))

(defun form-complete? ()
  (& (has-form?)
     (!? (form-data)
         (dolist (i ! t)
           (& (empty-string-or-nil? .i)
              (return nil))))))

(defun has-form-files? ()
  (& *_FILES* (not (empty? *_FILES*))))

(defun form-files (name)
  (& (has-form-files?)
     (let n (symbol-component name)
       (with-queue q
         (dotimes (i (length (%%%href (%%%href *_FILES* n) "name"))
                   (queue-list q))
           (awhen (%%%href (%%%href (%%%href *_FILES* n) "tmp_name") i)
             (| (empty-string? !)
                (enqueue q (list (cons 'name (%%%href (%%%href (%%%href *_FILES* n) "name") i))
                                 (cons 'tmp-name (%%%href (%%%href (%%%href *_FILES* n) "tmp_name") i))
                                 (cons 'error (%%%href (%%%href (%%%href *_FILES* n) "error") i))
                                 (cons 'size (%%%href (%%%href (%%%href *_FILES* n) "size") i))
                                 (cons 'type (%%%href (%%%href (%%%href *_FILES* n) "type") i)))))))))))

(defun form-alists ()
  (with (f (form-data)
         num-items (length (cdar f)))
    (with-queue q
      (dotimes (i num-items (queue-list q))
        (enqueue q (filter [cons _. (elt ._ i)] f))))))
