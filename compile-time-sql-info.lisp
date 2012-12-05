;;;;; phitamine – Copyright (c) 2012 Sven Michael Klose <pixel@copei.de>

(defvar *sql-table-definitions* name)

(defstruct sql-field
  name
  sql-type
  type)

(defun add-sql-table-definition (name fields)
  (acons! name [cons _. (make-sql-field :name _. :sql-type ._. :type .._.)] *sql-table-definitions*))
