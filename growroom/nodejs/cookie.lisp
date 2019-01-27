(var *cookie* nil)

(fn harvest-cookies (headers)
  (= *cookie* (cdar (remove-if-not [string== "cookie" (downcase _.)]
                                   (hash-alist headers)))))

(fn set-cookie (response)
  (alet (uuid)
    (console.log (+ "Setting new cookie." !))
    (= *cookie* !)
    (response.set-header "Set-Cookie" !)))

(fn ensure-cookie (headers response)
  (| (harvest-cookies headers)
     (set-cookie response)))
