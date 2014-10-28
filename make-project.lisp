;;;;; phitamine – Copyright (c) 2012–2014 Sven Michael Klose <pixel@copei.de>

(load "phitamine/compile-time-sql-info.lisp")

(defun phitamine-files (target)
  (| (in? target 'php 'nodejs)
     (error "Expecting TARGET to one of PHP or NODEJS. Got ~A." target))
  (& (eq target 'nodejs)
     (warn "Target NODEJS is under construction."))
  `("environment/platforms/shared/url/path-pathlist.lisp"
    "environment/platforms/shared/url/url-assignments.lisp"
    "environment/platforms/php/request-path.lisp"
    "phitamine/lang.lisp"
    "phitamine/php/db-connect.lisp"
    "phitamine/php/header.lisp"
    "phitamine/php/form.lisp"
    "phitamine/php/log.lisp"
    "phitamine/php/request.lisp"
    "phitamine/php/phitamine.lisp"
    "phitamine/php/server.lisp"
    "phitamine/php/session.lisp"
    "phitamine/php/sql.lisp"
    "phitamine/php/sql-date.lisp"
    "phitamine/sql/utils-querystring.lisp"
    "phitamine/sql/create-table.lisp"
    "phitamine/sql/delete.lisp"
    "phitamine/sql/insert.lisp"
    "phitamine/sql/select.lisp"
    "phitamine/sql/update.lisp"
    "phitamine/terpri.lisp"
    "phitamine/utils.lisp"
    "phitamine/request.lisp"
    "phitamine/detect-language.lisp"
    "phitamine/db.lisp"
    "phitamine/define-sql-table.lisp"
    "phitamine/lhtml.lisp"
    "phitamine/template.lisp"
    "phitamine/form.lisp"
    "phitamine/action.lisp"
    "phitamine/ports.lisp"
    "phitamine/phitamine.lisp"))

(defun print-htaccess-rules (out &key script-path)
  (format out "Options -indexes~%")
  (format out "RewriteEngine on~%")
  (format out "RewriteCond %{REQUEST_FILENAME} !-f~%")
  (format out "RewriteCond %{REQUEST_FILENAME} !-d~%")
  (format out "RewriteRule .? ~A/index.php$1 [L]~%" script-path))

(defun make-phitamine-project (name &key (target 'php) files script-path (dest-path "compiled") (filename nil))
  (| (cons? files)
     (error "FILES is missing."))
  (| (string? script-path)
     (error "SCRIPT-PATH is missing."))
  (| (string? filename)
     (error "FILENAME is missing."))
  (unix-sh-mkdir dest-path)
  (make-project name
                (+ (phitamine-files target)
                   (? (file-exists? "config.lisp")
                      '("config.lisp"))
                   files)
                :transpiler  (case target
                               'php     *php-transpiler*
                               'nodejs  (aprog1 (copy-transpiler *js-transpiler*)
                                          (= (transpiler-configuration ! 'environment) 'nodejs)))
                :obfuscate?  nil
                :emitter     [put-file (format nil "~A/~A" dest-path filename) _])
  (with-output-file out (format nil "~A/.htaccess" dest-path)
    (print-htaccess-rules out :script-path script-path)))
