;;;;; Copyright (c) 2012 Sven Michael Klose <pixel@copei.de>

(defvar *request-data* nil)

(defun has-request? ()
  (& *_REQUEST* (not (empty? *_REQUEST*))))

(defun request-data ()
  (| *request-data*
     (& (has-request?)
        (= *request-data* (aremove 'phpsessid (hash-assoc *_REQUEST*))))))

(defun request (name)
  (assoc-value name (request-data)))
