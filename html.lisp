(fn html-option (value name selected)
  (string-concat "<option value=\"" value "\""
                 (& (eql selected value)
                    " selected")
                 ">" name "</option>"))

(fn html-options (x selected)
  (apply #'string-concat (@ [html-option _. ._ selected] x)))
