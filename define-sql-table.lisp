(defmacro define-sql-table (name singular-name &rest fields)
  (add-sql-table-definition name fields)
  (let table-name (downcase (symbol-name name))
    `(progn
       (fn ,($ 'find- name) (&optional (fields nil) ; TODO: Not used.
                             &key (limit nil) (offset nil) (order-by nil) (direction nil))
         (let column-names (make-upcase-symbols (*db*.column-names (+ *db-table-prefix* ,table-name)))
           (!= (make-selection-info :table      (+ *db-table-prefix* ,table-name)
                                    :where      (ensure-alist fields)
                                    :limit      limit
                                    :offset     offset
                                    :order-by   order-by
                                    :direction  direction)
             (@ [@ #'cons column-names _]
                (*db*.exec (sql-clause-select !))))))
      (fn ,($ 'find- singular-name) (&optional (fields nil))
         (car (funcall #',($ 'find- name) fields)))
       (fn ,($ 'insert- singular-name) (fields)
         (*db*.exec (sql-clause-insert :table   (+ *db-table-prefix* ,table-name)
                                       :fields  (ensure-alist fields))))
       (fn ,($ 'update- singular-name) (fields)
         (alet (ensure-alist fields)
           (*db*.exec (sql-clause-update :table   (+ *db-table-prefix* ,table-name)
                                         :fields  (aremove 'id !)
                                         :where   (list (assoc 'id !))))))
       (fn ,($ 'update- name) (records)
         (@ #',($ 'update- singular-name) records))
       (fn ,($ 'delete- name) (fields)
         (*db*.exec (sql-clause-delete :table  (+ *db-table-prefix* ,table-name)
                                       :where  (ensure-alist fields))))
       (fn ,($ 'get- singular-name '-count) (&optional (fields nil))
         (!= (make-selection-info :table   (+ *db-table-prefix* ,table-name)
                                  :fields  '("COUNT(1)")
                                  :where   (ensure-alist fields))
           (number (caar (*db*.exec (sql-clause-select !))))))
       (fn ,($ 'get-distinct- name) (field &key (where nil) (order-by nil) (direction nil))
         (!= (make-selection-info :table      (+ *db-table-prefix* ,table-name)
                                  :fields     `(,,(+ "DISTINCT(" (symbol-name field) ")"))
                                  :where      (ensure-alist where)
                                  :order-by   order-by
                                  :direction  direction)
           (carlist (*db*.exec (sql-clause-select !)))))
       (fn ,($ 'select- name) (&key (fields nil) (where nil) (limit nil) (offset nil)
                                    (order-by nil) (direction nil))
         (!= (make-selection-inf :table      (+ *db-table-prefix* ,table-name)
                                 :fields     fields
                                 :where      (ensure-alist where)
                                 :limit      limit
                                 :offset     offset
                                 :order-by   order-by
                                 :direction  direction)
           (*db*.exec (sql-clause-select !)))))))
