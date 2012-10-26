;;;;; phitamine – Copyright (c) 2012 Sven Michael Klose <pixel@copei.de>

(defun lhtml-option (value name selected)
  `(option :value ,value ,@(when (string== selected value)
                             '(:selected "selected"))
       ,name))

(defun lhtml-options (x selected)
  (filter [lhtml-option _. ._ selected] x))
