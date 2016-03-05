(in-package :cl-user)
(defpackage robot-web.db
  (:use :cl)
  (:import-from :robot-web.config
                :config)
  (:import-from :datafly
                :*connection*
                :connect-cached)
  (:export :connection-settings
           :db
           :with-connection))
(in-package :robot-web.db)

(defun connection-settings (&optional (db :maindb))
  (cdr (assoc db (config :databases))))

(defun db (&optional (db :maindb))
  (apply #'connect-cached (connection-settings db)))

(defmacro with-connection (conn &body body)
  `(let* ((*connection* ,conn) 
          (_query (dbi:prepare *connection* "SET names 'utf8';") )
          (_result (dbi:execute _query)))
     ,@body))
