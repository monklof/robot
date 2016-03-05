(in-package :cl-user)
(defpackage robot-web-asd
  (:use :cl :asdf))
(in-package :robot-web-asd)

(defsystem robot-web
  :version "0.1"
  :author "monklof"
  :license ""
  :depends-on (:clack
               :lack
               :caveman2
               :envy
               :cl-ppcre
               :uiop

               ;; for @route annotation
               :cl-syntax-annot

               ;; for session store
               :lack-session-store-dbi

               ;; HTML Template
               :djula

               ;; for DB
               :datafly
               :sxql
	       :cl-dbi )
  :components ((:module "src"
                :components
                ((:file "main" :depends-on ("config" "view" "db"))
                 (:file "web" :depends-on ("view" "model"))
                 (:file "view" :depends-on ("config"))
                 (:file "model" :depends-on ("config"))
                 (:file "db" :depends-on ("config"))
                 (:file "config"))))
  :description ""
  :in-order-to ((test-op (load-op robot-web-test))))
