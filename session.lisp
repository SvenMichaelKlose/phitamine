;;;;; phitamine – Copyright (c) 2012 Sven Michael Klose <pixel@copei.de>

(session_start)

(defun session (x)
  (%transpiler-native "(isset ($_SESSION[$" x "->n])) ?" 
                      "$_SESSION[$" x "->n] : " 
                      "NULL;"))

(defun (= session) (v x)
  (%setq nil (%transpiler-native "$_SESSION[$" x "->n] = $" v))
  nil)
