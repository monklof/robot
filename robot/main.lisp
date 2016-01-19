(defun myserver ()      
  (start (make-instance 'easy-acceptor :port 7777))
  (define-easy-handler (greet :uri "/") ()
    (format nil "<html><body><h1><a href=\"https://github.com/monklof/robot\">A robot that help me dig up informations in the world that I should like :)</a></h1><footer>Powered by Lisp </footer></body></html>")))

;;(ql:quickload "hunchentoot")
;;(use-package :hunchentoot)
;;(load "~/robot/robot/main.lisp")
;;(myserver)

