(fn sql-clause-update (&key table fields where)
  (+ "UPDATE " table
	 " SET " (apply #'+ (comma-separated-list (@ [sql= _. ._] fields)))
	 (sql-clause-where where)))
