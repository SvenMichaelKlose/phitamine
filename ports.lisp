;;;;; phitamine – Copyright (c) 2012 Sven Michael Klose <pixel@copei.de>

(defvar *group-ports* nil)
(defvar *requested-ports* nil)
(defvar *ports* nil)

(defun request-port (port fun)
  (assoc-adjoin fun port *requested-ports* :test #'eq))

(defun (= group-port) (port group)
  (acons! group port *group-ports*))

(defun group-port (group)
  (assoc-value group *group-ports*))

(defun generate-ports ()
  (= *ports* (filter [cons _. (funcall ._)] *requested-ports*)))

(defun port (x)
  (| (assoc-value x (| *ports* (generate-ports))) ""))

(defmacro set-port (&rest body)
  `(request-port (group-port ..*action*) #'(() ,@body)))

(defun component-port (x)
  (group-port (cddr (component-action x))))

(defun components-w/o-port (port)
  (remove-if [eq port (component-port _.)] *components*))

(= (group-port 'default) 'content)
