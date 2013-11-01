;;;;; Copyright (c) 2012–2013 Sven Michael Klose <pixel@copei.de>

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

(defun form-string (x)
  (| (assoc-value x (form-data)) ""))

(defun form-complete? ()
  (& (has-form?)
     (!? (form-data)
         (dolist (i ! t)
           (& (empty-string-or-nil? .i)
              (return nil))))))

(defun has-form-files? ()
  (& *_FILES* (not (empty? *_FILES*))))

(defvar *form-file-fields* '(name tmp-name error size type))

(defun form-file-fields (name field)
  (%%%href (%%%href *_FILES* (symbol-component name))
           (? (eq 'tmp-name field)
              "tmp_name"
              (string-downcase (symbol-name field)))))

(defun form-file-field (name index field)
  (%%%href (form-file-fields name field) index))

(defun form-num-files (name)
  (length (form-file-fields name 'name)))

(defun form-file-uploaded? (name index)
  (form-file-field name index 'tmp-name))

(defun form-files (name)
  (& (has-form-files?)
     (with-queue q
       (dotimes (i (form-num-files name) (queue-list q))
         (awhen (form-file-uploaded? name i)
           (enqueue q (filter [. _ (form-file-field name i _)]
                              *form-file-fields*)))))))

(defun form-alists ()
  (with (f          (form-data)
         num-items  (length (cdar f)))
    (with-queue q
      (dotimes (i num-items (queue-list q))
        (enqueue q (filter [. _. (elt ._ i)] f))))))
