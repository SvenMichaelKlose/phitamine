;;;;; Caroshi – Copyright (c) 2009–2011,2013–2014 Sven Michael Klose <pixel@copei.de>

(define-filter literal-strings #'literal-string)

(defun sql-clause-insert (&key table (fields nil) (default-values-if-empty? nil))
  (concat-stringtree
	 "INSERT INTO " table
	 (? fields
	    (concat-stringtree
		    " ("
	        (comma-separated-list (filter [? (symbol? _)
                                             (string-downcase (symbol-name _))
                                             _]
                                          (carlist fields)))
	        ") VALUES ("
	        (comma-separated-list (literal-strings (cdrlist fields)))
     		")")
		(? default-values-if-empty?
           " DEFAULT VALUES"
           ""))))
