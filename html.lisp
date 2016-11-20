; phitamine – Copyright (c) 2016 Sven Michael Klose <pixel@copei.de>

(defun html-option (value name selected)
  (string-concat "<option value=\"" value "\""
                (& (string== selected value)
                   " selected")
                ">" name "</option>"))

(defun html-options (x selected)
  (apply #'string-concat (@ [html-option _. ._ selected] x)))
