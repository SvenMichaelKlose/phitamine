(fn send-header (&key (mime-type nil) (charset nil) (mod-time nil) (max-age nil))
  (& max-age   (header (+ "Cache-Control: private, max-age=" max-age ", no-cache")))
  (& mod-time  (header (+ "Last-Modified: " (gmdate "D, d M Y H:i:s T" mod-time) " GMT")))
  (?
    mime-type  (header (+ "Content-type: " mime-type (!? charset (+ "; charset=" charset) "")))
    charset    (error "CHARSET must be specified together with a MIME-TYPE.")))
