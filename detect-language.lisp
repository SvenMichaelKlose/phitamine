;;;;; phitamine – Copyright (c) 2012–2014 Sven Michael Klose <pixel@copei.de>

(defun get-client-languages ()
  (maparray [make-symbol (upcase (subseq _ 0 2))]
            (explode "," (%%%href *_SERVER* "HTTP_ACCEPT_LANGUAGE"))))

(defun detect-language ()
  (switch-language (car (get-client-languages))))
