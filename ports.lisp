(var *group-ports*     nil)
(var *requested-ports* nil)
(var *ports*           nil)

(fn request-port   (port fun)    (aadjoin! port fun *requested-ports* :test #'eq))
(fn (= group-port) (port group)  (acons! group port *group-ports*))
(fn group-port     (group)       (assoc-value group *group-ports*))
(fn generate-ports ()            (= *ports* (@ [. _. (funcall ._)] *requested-ports*)))
(fn port           (x)           (| (assoc-value x (| *ports*
                                                         (generate-ports)))
                                       ""))
(fn action-group   (x)           ..x)
(fn component-port (x)           (group-port (action-group (component-action x))))
(fn components-w/o-port (port)   (remove-if [eq port (component-port _.)] *components*))

(defmacro set-port (&rest body)
  `(request-port (group-port ..*action*) #'(() ,@body)))

(= (group-port 'default) 'content)
