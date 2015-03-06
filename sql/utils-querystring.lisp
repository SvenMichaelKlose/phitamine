;;;;; Caroshi – Copyright (c) 2009–2010,2012,2014 Sven Michael Klose <pixel@copei.de>

(defmacro defsqlutil (name op)
  `(defun ,name (x y)
	 (+ " "
        (? (symbol? x)
           (downcase (symbol-name x))
           x)
        ,(+ op "\"") y "\"")))

(defsqlutil sql= "=")
(defsqlutil sql!= "!=")
(defsqlutil sql< "<")
(defsqlutil sql> ">")

(defun sql-like (field val)
  `(,field " LIKE \"%" ,(escape-string val) "%\" "))
