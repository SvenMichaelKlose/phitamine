;;;; phitamine – Copyright (c) 2014 Sven Michael Klose <pixel@hugbox.org>

(defvar *user-request-handler* nil)
(defvar *cookies* nil)

(defmacro with-standard-output-string (&rest body)
  `(with-string-stream s
     (with-temporary *standard-output* s
       ,@body)))

(defun harvest-cookies (headers)
  (= *cookies* (remove-if-not [string== "Cookie" _]
                              (hash-alist headers))))

(defun log-headers (headers)
  (dolist (i (hashkeys headers))
    (console.log (+ "Header: " i ": " (href headers i)))))

(defun phitamine-request-handler (req res)
  (console.log (+ "HTTP request from " (req.socket.address).address))
  (console.log (+ "HTTP request URL " req.url))
  (console.log (+ "Client HTTP version " req.http-version))
  (log-headers req.headers)
  (harvest-cookies req.headers)
  (res.write (with-standard-output-string
               (funcall *user-request-handler*)))
  (res.end))

(defun phitamine (request-handler)
  (| (function? request-handler)
     (error "REQUEST-HANDLER argument is not a function."))
  (= *user-request-handler* request-handler)
  ((http.create-server #'phitamine-request-handler).listen 8888 "127.0.0.1"))
