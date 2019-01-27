(fn sql-clause-create-table (table-definition
                             &key (auto-increment-keyword nil)
                                  (have-types? nil))
  (concat-stringtree
      `("CREATE TABLE " ,table-definition. " ("
            "id INTEGER PRIMARY KEY " ,auto-increment-keyword
            ,(@ [+ "," _. " " (? have-types? ._. "")]
                .table-definition.)
        ")")))
