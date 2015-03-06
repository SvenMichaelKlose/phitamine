; phitamine – Copyright (c) 2012,2015 Sven Michael Klose <pixel@copei.de>

(defun lhtml-option (value name selected)
  `(option :value ,value
           ,@(& (string== selected value)
                '(:selected "selected"))
     ,name))

(defun lhtml-options (x selected)
  (@ [lhtml-option _. ._ selected] x))
