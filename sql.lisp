;;;;; Caroshi – Copyright (c) 2008–2012 Sven Michael Klose <pixel@copei.de>

(dont-obfuscate 
    mysql_connect
    mysql_set_charset
    mysql_select_db
    mysql_create_db
    mysql_drop_db
    mysql_close)

(defclass php-sql (&key name host user password)
  (= _name name
     _conn (mysql_pconnect host user password))
  (mysql_set_charset "utf8")
  (mysql_select_db _name _conn)
  this)

(defmember php-sql
	_name
	_conn)

(defmethod php-sql last-insert-row-i-d ()
  (mysql_insert_id))

(defmethod php-sql last-error ()
  (let err (mysql_error)
    (unless (empty-string? err)
      err)))

(defmethod php-sql last-error-string ()
  (mysql_error))

(defmethod php-sql _handle-error (method-name)
  (when (last-error)
    (log (+ "SQL " method-name ": " (last-error-string)))
    (error (+ "SQL " method-name ": " (last-error-string)))))

(dont-obfuscate is_bool)

(defmethod php-sql _log (statement)
  (log (+ "SQL: "
          (? (< 256 (length statement))
             (subseq statement (- (length statement) 200))
             statement))))

(defmethod php-sql exec (statement)
  (_log statement)
  (with (res (mysql_query statement _conn)
         ret (make-queue))
	(_handle-error "exec")
    (unless (is_bool res)
      (awhile (mysql_fetch_row res)
              (queue-list ret)
        (enqueue ret (array-list !))))))

(defmethod php-sql exec-simple (statement)
  (_log statement)
  (mysql_query statement _conn))

(defmethod php-sql column-names (table-name)
  (carlist (exec (+ "SHOW COLUMNS FROM " table-name))))

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
  (mysql_close)
  (clr _conn))

(defmethod php-sql create-db (name)
  (mysql_create_db name)
  (= _name name))

(defmethod php-sql remove ()
  (close)
  (reset-sql-iface-cache)
  (mysql_drop_db _name))

(defmethod php-sql escape (x)
  (mysql_real_escape_string x _conn))

(finalize-class php-sql)
