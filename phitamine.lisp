;;;;; phitamine – Copyright (c) 2012–2014 Sven Michael Klose <pixel@hugbox.org>

(defun phitamine-startup ()
  (| (list? *home-components*)
     (error "*HOME-COMPONENTS* must be a list of components"))
  (= *current-language* (detect-language))
  (call-url-actions))
