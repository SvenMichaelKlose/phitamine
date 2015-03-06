; phitamine – Copyright (c) 2012–2015 Sven Michael Klose <pixel@copei.de>

(defmacro define-sql-table (name singular-name &rest fields)
  (add-sql-table-definition name fields)
  (let table-name (downcase (symbol-name name))
    `(progn
       (defun ,($ 'find- name) (&optional (fields nil) &key (limit nil) (offset nil) (order-by nil) (direction nil))
         (let column-names (make-upcase-symbols (*db*.column-names (+ *db-table-prefix* ,table-name)))
           (@ [@ #'cons column-names _]
              (*db*.exec (sql-clause-select :table      (+ *db-table-prefix* ,table-name)
                                            :where      (ensure-alist fields)
                                            :limit      limit
                                            :offset     offset
                                            :order-by   order-by
                                            :direction  direction)))))
       (defun ,($ 'find- singular-name) (&optional (fields nil))
         (car (funcall #',($ 'find- name) fields)))
       (defun ,($ 'insert- singular-name) (fields)
         (*db*.exec (sql-clause-insert :table   (+ *db-table-prefix* ,table-name)
                                       :fields  (ensure-alist fields))))
       (defun ,($ 'update- singular-name) (fields)
         (alet (ensure-alist fields)
           (*db*.exec (sql-clause-update :table   (+ *db-table-prefix* ,table-name)
                                         :fields  (aremove 'id !)
                                         :where   (list (assoc 'id !))))))
       (defun ,($ 'update- name) (records)
         (@ #',($ 'update- singular-name) records))
       (defun ,($ 'delete- name) (fields)
         (*db*.exec (sql-clause-delete :table  (+ *db-table-prefix* ,table-name)
                                       :where  (ensure-alist fields))))
       (defun ,($ 'get- singular-name '-count) (&optional (fields nil))
         (number (caar (*db*.exec (sql-clause-select :table   (+ *db-table-prefix* ,table-name)
                                                     :fields  '("COUNT(1)")
                                                     :where   (ensure-alist fields))))))
       (defun ,($ 'get-distinct- name) (field &key (where nil) (order-by nil) (direction nil))
         (carlist (*db*.exec (sql-clause-select :table      (+ *db-table-prefix* ,table-name)
                                                :fields     `(,,(+ "DISTINCT(" (symbol-name field) ")"))
                                                :where      (ensure-alist where)
                                                :order-by   order-by
                                                :direction  direction))))
       (defun ,($ 'select- name) (&key (fields nil) (where nil) (limit nil) (offset nil) (order-by nil) (direction nil))
         (*db*.exec (sql-clause-select :table      (+ *db-table-prefix* ,table-name)
                                       :fields     fields
                                       :where      (ensure-alist where)
                                       :limit      limit
                                       :offset     offset
                                       :order-by   order-by
                                       :direction  direction))))))
