(defun myserver ()      
  (start (make-instance 'easy-acceptor :port 7777))
  (define-easy-handler (greet :uri "/") ()
    (format nil "<html><body><h1>Of course this is a robot :)</h1><footer> - powered by lisp </footer></body></html>")))

(ql:quickload "hunchentoot")
(use-package :hunchentoot)
(load "~/robot/robot/main.lisp")
(myserver)

