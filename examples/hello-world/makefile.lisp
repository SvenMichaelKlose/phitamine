(load "phitamine/make-project.lisp")
(make-phitamine-project "Hello World"
                        :files '("toplevel.lisp")
                        :script-path "/hello-world"
                        :dest-path ".")
(quit)
