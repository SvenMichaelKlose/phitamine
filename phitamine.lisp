;;;;; phitamine – Copyright (c) 2012 Sven Michael Klose <pixel@copei.de>

(defun phitamine ()
  (| (list? *home-components*)
     (error "*HOME-COMPONENTS* must be a list of components"))
  (= *current-language* (detect-language))
  (call-url-actions))
