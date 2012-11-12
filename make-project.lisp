;;;;; phitamine – Copyright (c) 2012 Sven Michael Klose <pixel@copei.de>

(defun make-phitamine-project (name files)
  (make-project name
                :target 'php
                :obfuscate? nil
                :files (+ (read-file "phitamine/files.lisp") files)
                :emitter [with-open-file out (open "compiled/index.php" :direction 'output)
                           (princ _ out)]))
