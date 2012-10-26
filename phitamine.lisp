;;;;; Phitamine – Copyright (c) 2012 Sven Michael Klose <pixel@copei.de>

(defun phitamine ()
  (| (cons? *home-action*)
     (error "*HOME-ACTION* must be a list of components"))
  (= *current-language* (detect-language))
  (db-connect)
  (= *components* (request-path-components))
  (awhen (request-action)
    (call-navi-action !))
  (= *components* nil)
  (princ (call-actions))
  nil)
