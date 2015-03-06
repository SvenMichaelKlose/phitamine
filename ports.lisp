; phitamine – Copyright (c) 2012–2015 Sven Michael Klose <pixel@copei.de>

(defvar *group-ports*     nil)
(defvar *requested-ports* nil)
(defvar *ports*           nil)

(defun request-port   (port fun)    (aadjoin! port fun *requested-ports* :test #'eq))
(defun (= group-port) (port group)  (acons! group port *group-ports*))
(defun group-port     (group)       (assoc-value group *group-ports*))
(defun generate-ports ()            (= *ports* (@ [. _. (funcall ._)] *requested-ports*)))
(defun port           (x)           (| (assoc-value x (| *ports* (generate-ports))) ""))
(defun action-group   (x)           ..x)
(defun component-port (x)           (group-port (action-group (component-action x))))
(defun components-w/o-port (port)   (remove-if [eq port (component-port _.)] *components*))

(defmacro set-port (&rest body)
  `(request-port (group-port ..*action*) #'(() ,@body)))

(= (group-port 'default) 'content)
