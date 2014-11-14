;;;; phitamine – Copyright (c) 2014 Sven Michael Klose <pixel@hugbox.org>

(defvar *user-request-handler* nil)

(defmacro with-standard-output-string (&rest body)
  `(with-string-stream s
     (with-temporary *standard-output* s
       ,@body)))

(defun phitamine-request-handler (req res)
   (res.write (with-standard-output-string
                (funcall *user-request-handler*)))
   (res.end))

(defun phitamine (request-handler)
  (| (function? request-handler)
     (error "REQUEST-HANDLER argument is not a function."))
  (= *user-request-handler* request-handler)
  ((http.create-server #'phitamine-request-handler).listen 8888 "127.0.0.1"))
