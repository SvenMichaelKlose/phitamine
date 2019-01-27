(define-filter literal-strings #'literal-string)

(fn sql-clause-insert (&key table (fields nil) (default-values-if-empty? nil))
  (concat-stringtree
	 "INSERT INTO " table
	 (? fields
	    (concat-stringtree
		    " ("
	        (comma-separated-list (@ [? (symbol? _)
                                        (downcase (symbol-name _))
                                        _]
                                     (carlist fields)))
	        ") VALUES ("
	        (comma-separated-list (literal-strings (cdrlist fields)))
     		")")
		(? default-values-if-empty?
           " DEFAULT VALUES"
           ""))))
