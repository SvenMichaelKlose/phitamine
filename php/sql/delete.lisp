;;;;; Caroshi – Copyright (c) 2009–2012 Sven Michael Klose <pixel@copei.de>

(defun sql-clause-delete (&key table where)
  (+ "DELETE FROM " table (sql-clause-where where)))
