; phitamine – Copyright (c) 2014–2015 Sven Michael Klose <pixel@hugbox.org>

(defvar *user-request-handler* nil)

(defmacro with-standard-output-string (&rest body)
  `(with-string-stream s
     (with-temporary *standard-output* s
       ,@body)))

(defun log-headers (headers)
  (@ (i (hashkeys headers))
    (console.log (+ "Header: " i ": " (href headers i)))))

(defun phitamine-request-handler (req res)
  (console.log (+ "HTTP request " req.http-version
                  " from " (req.socket.address).address
                  ": " req.url))
  (log-headers req.headers)
  (ensure-cookie req.headers res)
  (res.write (with-standard-output-string
               (funcall *user-request-handler*)))
  (res.end))

(defun phitamine (request-handler)
  (| (function? request-handler)
     (error "REQUEST-HANDLER argument is not a function."))
  (= *user-request-handler* request-handler)
  ((http.create-server #'phitamine-request-handler).listen 8888 "127.0.0.1"))
