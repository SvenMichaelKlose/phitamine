;;;;; phitamine – Copyright (c) 2012 Sven Michael Klose <pixel@copei.de>

(defun empty? (x)
  (| (not x)
     (== 0 (length x))))

(defun keywordassoc (x)
  (filter [cons (make-keyword (string-upcase _.)) ._] x))
