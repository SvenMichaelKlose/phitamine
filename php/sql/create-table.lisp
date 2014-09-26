;;;;; Caroshi – Copyright (c) 2009–2011,2014 Sven Klose <pixel@copei.de>

(defun sql-clause-create-table (table-definition &key (auto-increment-keyword nil) (have-types? nil))
  (concat-stringtree `("CREATE TABLE " ,table-definition. " ("
                       "id INTEGER PRIMARY KEY " ,auto-increment-keyword
                       ,(mapcar [+ "," _. " " (? have-types? ._. "")]
                                .table-definition.)
                       ")")))
