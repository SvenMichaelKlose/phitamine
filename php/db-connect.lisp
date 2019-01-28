(fn db-connect ()
  (= *db* (new db-mysql :name *db-name*
                        :host *db-host*
                        :user *db-user*
                        :password *db-password*)))
