(load "tre_modules/phitamine/compile-time-sql-info.lisp")

(fn phitamine-files (target)
  (| (in? target :php :nodejs)
     (error "Expecting TARGET to one of PHP or NODEJS. Got ~A." target))
  (& (eq target :nodejs)
     (warn "Target NODEJS is under construction."))
  `("tre_modules/shared/uuid.lisp"
    ,@(& (eq target :php)
         '("tre_modules/php/request-path.lisp"))
    ,@(list+ "tre_modules/sql-clause/"
             `("utils-querystring.lisp"
               "create-table.lisp"
               "delete.lisp"
               "insert.lisp"
               "selection-info.lisp"
               "select.lisp"
               "update.lisp"))
    "tre_modules/php-db-mysql/main.lisp"
    "tre_modules/l10n/lang.lisp"
    ,@(list+ "tre_modules/phitamine/"
             `(,@(& (eq target :php)
                    (list+ "php/"
                           '("db-connect.lisp"
                             "header.lisp"
                             "form.lisp"
                             "log-message.lisp"
                             "request.lisp"
                             "phitamine.lisp"
                             "server.lisp"
                             "session.lisp"
                             "sql-date.lisp")))
               ,@(& (eq target :nodejs)
                    '("growroom/nodejs/cookie.lisp"
                      "growroom/nodejs/server.lisp"))
              "terpri.lisp"
               "utils.lisp"
               "request.lisp"
               "detect-language.lisp"
               "db.lisp"
               "define-sql-table.lisp"
               "html.lisp"
               "lhtml.lisp"
               "template.lisp"
               "form.lisp"
               "action.lisp"
               "ports.lisp"
               "phitamine.lisp"))))

(fn print-htaccess-rules (out &key script-path)
  (format out "Options -indexes~%")
  (format out "RewriteEngine on~%")
  (format out "RewriteCond %{REQUEST_FILENAME} !-f~%")
  (format out "RewriteCond %{REQUEST_FILENAME} !-d~%")
  (format out "RewriteRule .? ~A/index.php$1 [L]~%" script-path))

(fn make-phitamine-transpiler (target transpiler)
  (case target
    :php     (| transpiler
                *php-transpiler*)
    :nodejs  (aprog1 (copy-transpiler (| transpiler
                                         *js-transpiler*))
               (= (transpiler-configuration ! :platform) :nodejs)
               (= (transpiler-configuration ! :nodejs-requirements) (merge (transpiler-configuration ! :nodejs-requirements) '("fs" "http" "https" "querystring" "crypto"))))))

(fn make-phitamine-project (name &key (target :php)
                                      files
                                      script-path
                                      (dest-path "compiled")
                                      (filename nil)
                                      (transpiler nil))
  (format t "; Making phitamine project ~A for target ~A.~%" name target)
  (| (cons? files)
     (error "FILES is missing."))
  (? (& (eq target :php)
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
                :emitter     [put-file (format nil "~A/~A" dest-path filename) _])
  (when (eq :php target)
    (with-output-file out (format nil "~A/htaccess.example" dest-path)
      (print-htaccess-rules out :script-path script-path))))
