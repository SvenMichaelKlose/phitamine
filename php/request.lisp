;;;;; phitamine – Copyright (c) 2012 Sven Michael Klose <pixel@copei.de>

(defvar *request-data* nil)

(defun has-request? ()
  (& *_REQUEST* (not (empty? *_REQUEST*))))

(defun request-data ()
  (| *request-data*
     (& (has-request?)
        (= *request-data* (aremove 'phpsessid (hash-alist *_REQUEST*))))))
