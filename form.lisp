;;;;; Copyright (c) 2012–2014 Sven Michael Klose <pixel@copei.de>

(defun form-alists ()
  (with (f          (form-data)
         num-items  (length (cdar f)))
    (with-queue q
      (dotimes (i num-items (queue-list q))
        (enqueue q (filter [. _. (elt ._ i)] f))))))
