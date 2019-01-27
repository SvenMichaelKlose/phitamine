(fn lhtml-option (value name selected)
  `(option :value ,value
           ,@(& (string== selected value)
                '(:selected "selected"))
     ,name))

(fn lhtml-options (x selected)
  (@ [lhtml-option _. ._ selected] x))
