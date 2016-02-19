(ql:quickload :robot-web)

(defpackage robot-web.app
  (:use :cl)
  (:import-from :lack.builder
                :builder)
  (:import-from :lack.middleware.session.store.dbi
                :make-dbi-store)
  (:import-from :ppcre
                :scan
                :regex-replace)
  (:import-from :robot-web.web
                :*web*)
  (:import-from :robot-web.config
                :config
                :productionp
                :*static-directory*))
(in-package :robot-web.app)

(builder
 (:static
  :path (lambda (path)
          (if (ppcre:scan "^/static(?:/images/|/css/|/js/|/robot\\.txt$|/favicon\\.ico$)" path)
              (progn
               (format t "~a" (subseq path (length "/static")))
               (subseq path (length "/static")))
              nil))
  :root *static-directory*)
 (if (productionp)
     nil
     :accesslog)
 (if (getf (config) :error-log)
     `(:backtrace
       :output ,(getf (config) :error-log))
     nil)
 (:session
  :store (make-dbi-store :connector (lambda ()
                                      (apply #'dbi:connect
                                             (robot-web.db:connection-settings)))))
 (if (productionp)
     nil
     (lambda (app)
       (lambda (env)
         (let ((datafly:*trace-sql* t))
           (funcall app env)))))
 *web*)
