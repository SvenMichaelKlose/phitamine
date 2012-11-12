;;;;; phitamine – Copyright (c) 2012 Sven Michael Klose <pixel@copei.de>

(defmacro define-sql-table (name singular-name &rest fields)
  (acons name fields *sql-table-definitions*)
  (let table-name (string-downcase (symbol-name name))
    `(progn
       (defun ,($ 'find- name) (&optional (fields nil) &key (limit nil) (offset nil) (order-by nil) (direction nil))
         (let column-names (make-upcase-symbols (*db*.column-names ,table-name))
           (mapcar [mapcar #'cons column-names _]
                   (*db*.exec (sql-clause-select :table ,table-name
                                                 :where (force-alist fields)
                                                 :limit limit :offset offset :order-by order-by :direction direction)))))
       (defun ,($ 'find- singular-name) (&optional (fields nil))
         (car (funcall #',($ 'find- name) fields)))
       (defun ,($ 'insert- singular-name) (fields)
         (*db*.exec (sql-clause-insert :table ,table-name :fields fields)))
       (defun ,($ 'update- singular-name) (fields)
         (*db*.exec (sql-clause-update :table ,table-name :fields (aremove 'id fields) :where (list (assoc 'id fields)))))
       (defun ,($ 'delete- name) (fields)
         (*db*.exec (sql-clause-delete :table ,table-name :where fields)))
       (defun ,($ 'get- singular-name '-count) (&optional (fields nil))
         (let column-names (make-upcase-symbols (*db*.column-names ,table-name))
           (number (caar (*db*.exec (sql-clause-select :table ,table-name :fields '("COUNT(1)") :where fields))))))
       (defun ,($ 'get-distinct- name) (field &key (where nil) (order-by nil) (direction nil))
         (carlist (*db*.exec (sql-clause-select :table ,table-name :fields `(,,(+ "DISTINCT(" (symbol-name field) ")"))
                                                :where where))))
       (defun ,($ 'select- name) (&key (fields nil) (where nil) (limit nil) (offset nil) (order-by nil) (direction nil))
         (*db*.exec (sql-clause-select :table ,table-name :fields ,fields
                                       :where ,where
                                       :limit ,limit :offset offset :order-by order-by :direction direction))))))
