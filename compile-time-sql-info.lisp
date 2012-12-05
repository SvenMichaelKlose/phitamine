;;;;; phitamine – Copyright (c) 2012 Sven Michael Klose <pixel@copei.de>

(defvar *sql-table-definitions* name)

(defstruct sql-table
  name
  fields)

(defstruct sql-field
  name
  sql-type
  type)

(defun add-sql-table-definition (name fields)
  (acons! name (make-sql-table :name name
                               :fields (filter [cons _. (make-sql-field :name _. :sql-type ._. :type .._.)] fields))
          *sql-table-definitions*))
