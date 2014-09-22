;;;;; phitamine – Copyright (c) 2012 Sven Michael Klose <pixel@copei.de>

(defun phitamine ()
  (| (cons? *home-components*)
     (error "*HOME-COMPONENTS* must be a list of components"))
  (= *current-language* (detect-language))
  (db-connect)
  (call-url-actions))
