; Caroshi – Copyright (c) 2009–2012,2015 Sven Michael Klose <pixel@copei.de>

(defun sql-clause-update (&key table fields where)
  (+ "UPDATE " table
	 " SET " (apply #'+ (comma-separated-list (@ [sql= _. ._] fields)))
	 (sql-clause-where where)))
