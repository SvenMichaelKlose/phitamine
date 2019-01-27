(defun get-client-languages ()
  (maparray [make-symbol (upcase (subseq _ 0 2))]
            (explode "," (href *_server* "HTTP_ACCEPT_LANGUAGE"))))

(defun detect-language ()
  (switch-language (car (get-client-languages))))
