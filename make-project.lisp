;;;;; phitamine – Copyright (c) 2012–2013 Sven Michael Klose <pixel@copei.de>

(load "phitamine/compile-time-sql-info.lisp")

(defun make-phitamine-project (name files)
  (unix-sh-mkdir "compiled")
  (make-project name
                :transpiler  *php-transpiler*
                :obfuscate?  nil
                :files       (+ (read-file "phitamine/files.lisp")
                                files)
                :emitter     [put-file "compiled/index.php" _]))
