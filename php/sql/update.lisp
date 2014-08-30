;;;;; Caroshi – Copyright (c) 2009–2012 Sven Michael Klose <pixel@copei.de>

(defun sql-clause-update (&key table fields where)
  (+ "UPDATE " table
	 " SET " (apply #'+ (comma-separated-list (mapcar (fn sql= _. ._) fields)))
	 (sql-clause-where where)))
