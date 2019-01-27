(fn empty? (x)
  (zero? (length x)))

(fn make-upcase-symbol (x)
  (make-symbol (upcase x)))

(define-filter make-upcase-symbols #'make-upcase-symbol)

(fn comma-separated-list (x)
  (pad x ","))
