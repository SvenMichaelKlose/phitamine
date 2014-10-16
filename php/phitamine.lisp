;;;; phitamine – Copyright (c) 2014 Sven Michael Klose <pixel@hugbox.org>

(defun phitamine (request-handler)
  (phitamine-startup)
  (funcall request-handler))
