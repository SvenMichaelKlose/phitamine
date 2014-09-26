;;;;; Caroshi – Copyright (c) 2009–2013 Sven Michael Klose <pixel@copei.de>

(defun sql-clause-where (alst)
  (!? alst
      (+ " WHERE "
         (? (string? !)
            !
            (alist-assignments ! :padding " AND ")))))

(defun sql-clause-select (&key table (fields nil) (where nil) (limit nil) (offset nil) (order-by nil) (direction nil))
  (when-debug
    (when (== 1 (length (remove-if #'not (list limit offset))))
      (error ":LIMIT and :OFFSET have to be used together.")))
  (apply #'string-concat
         `("SELECT " ,@(!? fields
                           (comma-separated-list (symbol-names ! :downcase? t))
                           (list "*"))
           " FROM " ,table
           ,(sql-clause-where where)
           ,(!? order-by  (+ " ORDER BY " !))
           ,(!? direction (+ " " !))
           ,(!? limit     (+ " LIMIT " !))
           ,(!? (& offset
                   (not (zero? offset)))
                (+ " OFFSET " !)))))
