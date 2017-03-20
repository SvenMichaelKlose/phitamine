(var *form-data* nil)

(fn has-form? ()
  (& *_POST* (not (empty? *_POST*))))

(fn form-data ()
  (| *form-data*
     (& (has-form?)
        (alet (properties-alist *_POST*)
          (= *form-data* (pairlist (make-upcase-symbols (carlist !))
                                   (cdrlist !)))))))

(fn form-value (x)
  (assoc-value x (form-data)))

(fn form-string (x)
  (| (assoc-value x (form-data)) ""))

(fn form-complete? ()
  (& (has-form?)
     (!? (form-data)
         (@ (i ! t)
           (& (| (not .i)
                 (empty-string? .i))
              (return nil))))))

(fn has-form-files? ()
  (& *_FILES* (not (empty? *_FILES*))))

(var *form-file-fields* '(name tmp-name error size type))

(fn form-file-fields (name field)
  (%%%href (%%%href *_FILES* (downcase (symbol-name name)))
           (? (eq 'tmp-name field)
              "tmp_name"
              (downcase (symbol-name field)))))

(fn form-file-field (name index field)
  (%%%href (form-file-fields name field) index))

(fn form-num-files (name)
  (length (form-file-fields name 'name)))

(fn form-file-uploaded? (name index)
  (form-file-field name index 'tmp-name))

(fn form-files (name)
  (& (has-form-files?)
     (with-queue q
       (dotimes (i (form-num-files name) (queue-list q))
         (awhen (form-file-uploaded? name i)
           (enqueue q (@ [. _ (form-file-field name i _)]
                         *form-file-fields*)))))))
