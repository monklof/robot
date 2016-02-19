(in-package :cl-user)
(defpackage robot-web.utils
  (:use :cl))
(in-package :robot-web.utils)

(defvar %cookie-secret% "foo secret")

(defun set-secure-cookie (name value &opt (expire-days 30))
  nil)

(defun get-secure-cookie (name)
  nil)

;;; 对cookie进行签名，防止伪造
(defun create-signed-value ()
  nil)

(defun decode-signed-value ()
  nil)


