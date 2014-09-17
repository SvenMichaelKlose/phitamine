;;;;; phitamine – Copyright (c) 2012–2014 Sven Michael Klose <pixel@hugbox.org>

(defun empty? (x)
  (zero? (length x)))

(defun make-upcase-symbol (x)
  (make-symbol (string-upcase x)))

(define-filter make-upcase-symbols #'make-upcase-symbol)

(defun comma-separated-list (x)
  (pad x ","))
