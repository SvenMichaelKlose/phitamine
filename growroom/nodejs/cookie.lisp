;;;; phitamine – Copyright (c) 2014 Sven Michael Klose <pixel@hugbox.org>

(defvar *cookie* nil)

(defun harvest-cookies (headers)
  (= *cookie* (cdar (remove-if-not [string== "cookie" (string-downcase _.)]
                                   (hash-alist headers)))))

(defun set-cookie (response)
  (alet (uuid)
    (console.log (+ "Setting new cookie." !))
    (= *cookie* !)
    (response.set-header "Set-Cookie" !)))

(defun ensure-cookie (headers response)
  (| (harvest-cookies headers)
     (set-cookie response)))
