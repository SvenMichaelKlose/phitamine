; Caroshi – Copyright (c) 2009–2011,2014–2015 Sven Michael Klose <pixel@copei.de>

(defun sql-clause-create-table (table-definition
                                &key (auto-increment-keyword nil)
                                     (have-types? nil))
  (concat-stringtree
      `("CREATE TABLE " ,table-definition. " ("
            "id INTEGER PRIMARY KEY " ,auto-increment-keyword
            ,(@ [+ "," _. " " (? have-types? ._. "")]
                .table-definition.)
        ")")))
