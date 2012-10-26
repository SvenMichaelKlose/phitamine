;;;;; Caroshi – Copyright (c) 2012 Sven Michael Klose <pixel@copei.de>

(defvar *request-path-offset* 0)

(dont-obfuscate parse_url)

(defun request-path () 
  (href *_SERVER* "REQUEST_URI"))

(defun parse-url ()
  (parse_url (request-path)))

(defun request-path-components ()
  (subseq (path-pathlist (href (parse-url) "path")) *request-path-offset*))
