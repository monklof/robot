(in-package :cl-user)
(defpackage lispblog-test-asd
  (:use :cl :asdf))
(in-package :lispblog-test-asd)

(defsystem lispblog-test
  :author "monklof"
  :license ""
  :depends-on (:lispblog
               :prove)
  :components ((:module "t"
                :components
                ((:file "lispblog"))))
  :perform (load-op :after (op c) (asdf:clear-system c)))
