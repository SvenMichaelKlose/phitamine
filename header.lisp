;;;;; Caroshi – Copyright (c) 2012 Sven Michael Klose <pixel@copei.de>

(dont-obfuscate gmdate time)

(defun send-header (&key (mime-type nil) (charset nil) (mod-time nil) (max-age 3600))
  (& max-age (header (+ "Cache-Control: private, max-age=" max-age ", pre-check=" max-age)))
  (& max-age (header "Pragma: private"))
  (& mod-time (header (+ "Last-Modified: " (gmdate "D, d M Y H:i:s T" mod-time) " GMT")))
  (?
    (| (& mime-type charset)
       mime-type)
      (header (+ "Content-type: " mime-type (!? charset (+ "; charset=" charset) "")))
    charset
      (error "CHARSET must be specified together with a MIME-TYPE.")))
