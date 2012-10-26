;;;;; Copyright (C) 2012 Sven Michael Klose <pixel@copei.de>

(session_start)

(defun session (x)
  (%setq nil (%transpiler-native "return (isset ($_SESSION[$" x "->n])) ?" 
                                         "$_SESSION[$" x "->n] : " 
                                         "NULL;"))
  nil)

(defun (= session) (v x)
  (%setq nil (%transpiler-native "$_SESSION[$" x "->n] = $" v))
  nil)
