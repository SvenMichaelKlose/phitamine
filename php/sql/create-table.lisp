;;;;; Caroshi – Copyright (c) 2009-2011 Sven Klose <pixel@copei.de>

(defun sql-clause-create-table (table-definition &key (auto-increment-keyword nil) (have-types? nil))
  (with (name (first table-definition)
		 cols (second table-definition))
    (concat-stringtree `("CREATE TABLE " ,name " ("
                         "id INTEGER PRIMARY KEY " ,auto-increment-keyword
                         ,(mapcar (fn (+ "," _. " " (? have-types? ._. ""))) cols)
                         ")"))))
