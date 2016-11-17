; Caroshi – Copyright (c) 2008–2012,2016 Sven Michael Klose <pixel@copei.de>

(dont-obfuscate set_charset select_db close)

(defclass php-sql (&key name host user password)
  (= _name name)
  (= _conn (new mysqli host user password))
  (= _column-names (make-hash-table))
  (_conn.set_charset "utf8")
  (_conn.select_db _name)
  this)

(defmember php-sql
	_name
	_conn
    _column-names)

(defmethod php-sql last-insert-row-i-d ()
  _conn.insert_id)

(defmethod php-sql last-error ()
  (alet _conn.error
    (unless (empty-string? !)
      !)))

(defmethod php-sql last-error-string ()
  _conn.error)

(defmethod php-sql _handle-error (method-name)
  (when (last-error)
    (error (+ "Error: PHP-SQL." (upcase method-name) ": " (last-error-string)))))

(dont-obfuscate is_bool)

(defmethod php-sql _log (statement)
  (log (+ "SQL: "
          (? (< 256 (length statement))
             (subseq statement (- (length statement) 200))
             statement))))

(defmethod php-sql exec (statement)
  (_log statement)
  (with (res (_conn.query statement)
         ret (make-queue))
	(_handle-error "exec")
    (unless (is_bool res)
      (awhile (res.fetch_row)
              (queue-list ret)
        (enqueue ret (array-list !))))))

(defmethod php-sql exec-simple (statement)
  (_log statement)
  (_conn.query statement))

(defmethod php-sql column-names (table-name)
  (| (href _column-names table-name)
     (= (href _column-names table-name) (carlist (exec (+ "SHOW COLUMNS FROM " table-name))))))

(defmethod php-sql add-column (table-name column-name)
  (carlist (exec (+ "ALTER TABLE " table-name " ADD COLUMN " column-name))))

(defmethod php-sql table? (name)
  (prog1
    (== 1 (caar (exec (+ "SELECT COUNT(1) FROM information_schema.tables "
                         " WHERE table_schema='" _name "' AND table_name='" name "'"))))
    (_handle-error "table?")))

(defmethod php-sql begin-transaction ()
  (exec-simple "START TRANSACTION"))

(defmethod php-sql commit ()
  (exec-simple "COMMIT"))

(defmethod php-sql rollback ()
  (exec-simple "ROLLBACK"))

(defmethod php-sql close ()
  (_conn.close)
  (clr _conn))

;(defmethod php-sql create-db (name)
;  (mysql_create_db name)
;  (= _name name))

;(defmethod php-sql remove ()
;  (close)
;  (reset-sql-iface-cache)
;  (mysql_drop_db _name))

(defmethod php-sql escape (x)
  (mysqli_real_escape_string x))

(finalize-class php-sql)
