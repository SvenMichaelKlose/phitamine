(session_start)

(fn session (x)
  (%%native "(isset ($_SESSION[$" x "->n])) ?" 
            "$_SESSION[$" x "->n] : " 
            "NULL;"))

(fn (= session) (v x)
  (%= nil (%%native "$_SESSION[$" x "->n] = $" v))
  v)
