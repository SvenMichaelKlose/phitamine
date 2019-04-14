(fn empty? (x)
  (zero? (length x)))

(fn make-upcase-symbol (x)
  (make-symbol (upcase x)))

(define-filter make-upcase-symbols #'make-upcase-symbol)

(fn comma-separated-list (x)
  (pad x ","))

(fn aadjoin (key value lst &key (test #'eql) (to-end? nil))
  (? (assoc key lst :test test)
     (aprog1 (copy-alist lst)
       (= (cdr (assoc key ! :test test)) value))
     (? to-end?
        (+ lst (list (. key value)))
        (. (. key value) lst))))

(defmacro aadjoin! (key value lst &key (test #'eql) (to-end? nil))
  `(= ,lst (aadjoin ,key ,value ,lst :test ,test :to-end? ,to-end?)))
