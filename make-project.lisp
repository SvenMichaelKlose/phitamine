;;;;; phitamine – Copyright (c) 2012–2014 Sven Michael Klose <pixel@copei.de>

(load "phitamine/compile-time-sql-info.lisp")

(defun phitamine-files (target)
  (| (in? target 'php 'nodejs)
     (error "Expecting TARGET to one of PHP or NODEJS. Got ~A." target))
  (& (eq target 'nodejs)
     (warn "Target NODEJS is under construction."))
  `("environment/platforms/shared/url/path-pathlist.lisp"
    "environment/platforms/shared/url/url-assignments.lisp"
    "environment/platforms/shared/uuid.lisp"
    "phitamine/lang.lisp"
    ,@(& (eq target 'php)
         '("environment/platforms/php/request-path.lisp"
           "phitamine/php/db-connect.lisp"
           "phitamine/php/header.lisp"
           "phitamine/php/form.lisp"
           "phitamine/php/log.lisp"
           "phitamine/php/request.lisp"
           "phitamine/php/phitamine.lisp"
           "phitamine/php/server.lisp"
           "phitamine/php/session.lisp"
           "phitamine/php/sql.lisp"
           "phitamine/php/sql-date.lisp"))
    ,@(& (eq target 'nodejs)
         '("phitamine/growroom/nodejs/cookie.lisp"
           "phitamine/growroom/nodejs/server.lisp"))
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

(defun make-phitamine-transpiler (target transpiler)
  (case target
    'php     (| transpiler
                *php-transpiler*)
    'nodejs  (aprog1 (copy-transpiler (| transpiler
                                         *js-transpiler*))
               (= (transpiler-configuration ! :platform) 'nodejs)
               (= (transpiler-configuration ! :nodejs-requirements) '("fs" "http" "https" "querystring" "crypto")))))

(defun make-phitamine-project (name &key (target 'php)
                                         files
                                         script-path
                                         (dest-path "compiled")
                                         (filename nil)
                                         (transpiler nil))
  (format t "; Making phitamine project ~A for target ~A.~%" name target)
  (| (cons? files)
     (error "FILES is missing."))
  (? (& (eq target 'php)
        (not (string? script-path)))
     (error "SCRIPT-PATH is missing but it's required to make .htaccess rules."))
  (| (string? filename)
     (error "FILENAME is missing."))
  (format t "; Creating destination directory DEST-PATH in ~A.~%" target)
  (unix-sh-mkdir dest-path)
  (make-project name
                (+ (phitamine-files target)
                   (? (file-exists? "config.lisp")
                      '("config.lisp"))
                   files)
                :transpiler  (make-phitamine-transpiler target transpiler)
                :obfuscate?  nil
                :emitter     [put-file (format nil "~A/~A" dest-path filename) _])
  (when (eq 'php target)
    (with-output-file out (format nil "~A/.htaccess" dest-path)
      (print-htaccess-rules out :script-path script-path))))
