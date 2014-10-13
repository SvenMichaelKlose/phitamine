;;;;; phitamine – Copyright (c) 2012–2013 Sven Michael Klose <pixel@copei.de>

(session_start)

(defun session (x)
  (%%native "(isset ($_SESSION[$" x "->n])) ?" 
            "$_SESSION[$" x "->n] : " 
            "NULL;"))

(defun (= session) (v x)
  (%= nil (%%native "$_SESSION[$" x "->n] = $" v))
  v)
