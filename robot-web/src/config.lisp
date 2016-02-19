;;;; 配置文件
;;; 接口函数
;;; config key => 获取配置内容 ;; 如 (config :databases) 获取数据库配置
;;; productionp => 判断是否为生产环境
;;; developmentp => 判断是否为开发环境

(in-package :cl-user)
(defpackage robot-web.config
  (:use :cl)
  (:import-from :envy
                :config-env-var
                :defconfig)
  (:export :config
           :*application-root*
           :*static-directory*
           :*template-directory*
           :appenv
           :developmentp
           :productionp))
(in-package :robot-web.config)

;; 使用#'defconfig宏来定义配置项
;; 用APP_ENV这个环境变量控制生产模式/开发环境配置，如用APP_ENV=development clackup app.lisp来切换为"development"的配置
;; :common的配置会被merge到所有的配置项中去
(setf (config-env-var) "APP_ENV")

(defparameter *application-root*   (asdf:system-source-directory :robot-web))
(defparameter *static-directory*   (merge-pathnames #P"static/" *application-root*))
(defparameter *template-directory* (merge-pathnames #P"templates/" *application-root*))

(defconfig :common
  `(
    :debug T
    :databases
    ((:maindb :mysql :database-name "robot_web" :username "robot" :password "RoBOt%.%"))))

(defconfig |development|
  '())

(defconfig |production|
  '())

(defconfig |test|
  '())

;; #. syntax see http://www.lispworks.com/documentation/HyperSpec/Body/02_dhf.htm
;; eval at reader time
(defun config (&optional key)
  (envy:config #.(package-name *package*) key))

(defun appenv ()
  (uiop:getenv (config-env-var #.(package-name *package*))))

(defun developmentp ()
  (string= (appenv) "development"))

(defun productionp ()
  (string= (appenv) "production"))
