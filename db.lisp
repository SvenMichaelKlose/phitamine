;;;;; phitamine – Copyright (c) 2012 Sven Michael Klose <pixel@copei.de>

(defvar *db-user*)
(defvar *db-password*)
(defvar *db-name*)
(defvar *db-host*)
(defvar *db* nil)

(defun db-connect ()
  (= *db* (new php-sql :name *db-name*
                       :host *db-host*
                       :user *db-user*
                       :password *db-password*)))
