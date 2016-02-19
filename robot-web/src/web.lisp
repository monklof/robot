(in-package :cl-user)
(defpackage robot-web.web
  (:use :cl
        :caveman2
        :robot-web.config
        :robot-web.view
        :robot-web.db
        :robot-web.model
        :datafly
        :sxql)
  (:export :*web*))
(in-package :robot-web.web)

;; for @route annotation
(syntax:use-syntax :annot)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)

;;
;; Routing rules

(defroute "/" ()
  (render #P"index.html"))

@route GET "/ping"
(defun ping ()
  (format nil "pong"))

;; use |param| (only support x-www-form-urlencoded) to get access to parameters
;; Questions About HTTP Manipulation
;; 1. how to support form-data?
;; 2. how to get cookie or other header's option?
;; 3. how to get other env info?
;; 4. how to structure a response?


@route POST "/signin2"
(defun signin2 (&key |username| |password|)
  `(200
    (:content-type "application/json")
    ,(if (user-check-pwd |username| |password|)
        "{\"result\":\"success\", \"data\":\"登录成功\"}"
       "{\"result\":\"error\", \"data\":\"用户名和密码不匹配\"}")))

@route POST "/signin"
(defun signin (&key |username| |password|)
  (render-json
   (if (not (user-check-pwd |username| |password|))
       '(:|success| nil :|msg| "用户名密码不匹配！")
     (progn
       (setf (gethash :username *session*) |username|)
       '(:|success| T :|msg| "登录成功")))))

@route POST "/signup"
(defun signup (&key |username| |password| |email| |invitetoken|)
  (if (or
       (< (length |username|) 4)
       (> (length |username|) 20)
       ;; 增加用户名正则匹配
       (< (length |password|) 6))
      (return-from signup
        (render-json '(:|success| nil
                        :|msg| "注册失败，规则匹配失败: 1. 用户名需大于4位小于20位且不能包含奇怪的字符 \n2. 邮箱格式正确 3. 密码不能为空且大于6位"))))
  (if (user-exists |username|)
      (return-from signup
        (render-json '(:|success| nil
                        :|msg| "用户名已存在"))))
  (if (not (check-invite-token |invitetoken|))
      (return-from signup
        (render-json '(:|success| nil
                        :|msg| "邀请码不存在或已失效"))))
  (use-invite-token |invitetoken|)
  (user-create :username |username|
               :password |password|
               :email |email|
               :avatar-url "")
  (setf (gethash :username *session*) |username|)
  (render-json '(:|success| T
                  :|msg| "注册成功"
                  :|data| |username|)))

@route GET "/session"
(defun session ()
  (render-json `(:|username| ,(gethash :username *session*))))

@route GET "/home"
(defun home-page ()
  (let ((username (gethash :username *session*)))
    (if username
        (render #P"home.html" `(:username ,username :page "home"))
      ;; redirect to home page
      (redirect "/" 302))))

@route GET "/done"
(defun done-page ()
  (let ((username (gethash :username *session*)))
    (if username
        (render #P"done.html" `(:username ,username :page "done"))
      ;; redirect to home page
      (redirect "/" 302))))

@route GET "/stars"
(defun stars-page ()
  (let ((username (gethash :username *session*)))
    (if username
        (render #P"stars.html" `(:username ,username :page "stars"))
      ;; redirect to home page
      (redirect "/" 302))))

@route GET "/signout"
(defun signout ()
  (setf (gethash :username *session*) nil)
  (redirect "/" 302))

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
