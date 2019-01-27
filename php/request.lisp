(var *request-data* nil)

(fn has-request? ()
  (& *_REQUEST* (not (empty? *_REQUEST*))))

(fn request-data ()
  (| *request-data*
     (& (has-request?)
        (= *request-data* (aremove 'phpsessid (hash-alist *_REQUEST*))))))
