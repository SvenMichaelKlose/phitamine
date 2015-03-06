; Copyright (c) 2012–2015 Sven Michael Klose <pixel@copei.de>

(defvar *form-data* nil)

(defun has-form? ()
  (& *_POST* (not (empty? *_POST*))))

(defun form-data ()
  (| *form-data*
     (& (has-form?)
        (alet (phphash-alist *_POST*)
          (= *form-data* (pairlist (make-upcase-symbols (carlist !))
                                   (cdrlist !)))))))

(defun form-value (x)
  (assoc-value x (form-data)))

(defun form-string (x)
  (| (assoc-value x (form-data)) ""))

(defun form-complete? ()
  (& (has-form?)
     (!? (form-data)
         (@ (i ! t)
           (& (| (not .i)
                 (empty-string? .i))
              (return nil))))))

(defun has-form-files? ()
  (& *_FILES* (not (empty? *_FILES*))))

(defvar *form-file-fields* '(name tmp-name error size type))

(defun form-file-fields (name field)
  (%%%href (%%%href *_FILES* (symbol-component name))
           (? (eq 'tmp-name field)
              "tmp_name"
              (downcase (symbol-name field)))))

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
           (enqueue q (@ [. _ (form-file-field name i _)]
                         *form-file-fields*)))))))
