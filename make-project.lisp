;;;;; phitamine – Copyright (c) 2012–2014 Sven Michael Klose <pixel@copei.de>

(load "phitamine/compile-time-sql-info.lisp")

(defun print-htaccess-rules (out &key script-path)
  (format out "Options -indexes~%")
  (format out "RewriteEngine on~%")
  (format out "RewriteCond %{REQUEST_FILENAME} !-f~%")
  (format out "RewriteCond %{REQUEST_FILENAME} !-d~%")
  (format out "RewriteRule .? ~A/index.php$1 [L]~%" script-path))

(defun make-phitamine-project (name &key files script-path)
  (| (cons? files)
     (error "FILES is missing."))
  (| (string? script-path)
     (error "SCRIPT-PATH is missing."))
  (unix-sh-mkdir "compiled")
  (make-project name
                (+ (read-file "phitamine/files.lisp")
                   (? (file-exists? "config.lisp")
                      '("config.lisp"))
                   files)
                :transpiler  *php-transpiler*
                :obfuscate?  nil
                :emitter     [put-file "compiled/index.php" _])
  (with-output-file out "compiled/.htaccess"
    (print-htaccess-rules out :script-path script-path)))
