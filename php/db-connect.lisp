(fn db-connect ()
  (= *db* (new php-sql :name *db-name*
                       :host *db-host*
                       :user *db-user*
                       :password *db-password*)))
