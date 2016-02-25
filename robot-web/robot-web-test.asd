(in-package :cl-user)
(defpackage robot-web-test-asd
  (:use :cl :asdf))
(in-package :robot-web-test-asd)

(defsystem robot-web-test
  :author "monklof"
  :license ""
  :depends-on (:robot-web
               :prove)
  :components ((:module "t"
                :components
                ((:file "robot-web"))))
  :perform (load-op :after (op c) (asdf:clear-system c)))
