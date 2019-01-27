(var *sql-table-definitions* nil)

(defstruct sql-table
  name
  fields)

(defstruct sql-field
  name
  sql-type
  type)

(fn add-sql-table-definition (name fields)
  (acons! name (make-sql-table :name name
                               :fields (@ [. _. (make-sql-field :name _. :sql-type ._. :type .._.)] fields))
          *sql-table-definitions*))
