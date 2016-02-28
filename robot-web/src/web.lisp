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

@route POST "/signin"
(defun signin (&key |username| |password|)
  (let ((user (user-check-pwd |username| |password|)))
    (render-json
     (if (not user)
         '(:|success| nil :|msg| "用户名密码不匹配！")
       (progn
         (setf (gethash :username *session*) |username|)
         (setf (gethash :id *session*) (user-id user))
         '(:|success| T :|msg| "登录成功"))))))

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
  (let ((user (user-create :username |username|
               :password |password|
               :email |email|
               :avatar-url "")))
    (setf (gethash :username *session*) |username|)
    (setf (gethash :id *session*) (user-id user)))
  (render-json '(:|success| T
                  :|msg| "注册成功"
                  :|data| |username|)))

@route GET "/session"
(defun session ()
  (render-json `(:|username| ,(gethash :username *session*)
                  :|id| ,(gethash :id *session*))))

@route GET "/home"
(defun home-page ()
  (let ((username (gethash :username *session*))
        (userid (gethash :id *session*)))
    (if username
        (render #P"home.html" `(:username ,username
                                          :page "home"
                                          :items ,(get-user-item userid)))
      ;; redirect to home page
      (redirect "/" 302))))

@route GET "/done"
(defun done-page ()
  (let ((username (gethash :username *session*))
        (userid (gethash :id *session*)))
    (if username
        (render #P"done.html" `(:username ,username
                                          :page "done"
                                          :items ,(get-user-item userid :state +DONE+)))
      ;; redirect to home page
      (redirect "/" 302))))

@route GET "/stars"
(defun stars-page ()
  (let ((username (gethash :username *session*))
        (userid (gethash :id *session*)))
    (if username
        (render #P"stars.html" `(:username ,username
                                          :page "stars"
                                          :items ,(get-user-item userid :state +STAR+)))
      ;; redirect to home page
      (redirect "/" 302))))

@route GET "/item/:id"
(defun stars-page (&key id)
  (let ((username (gethash :username *session*)))
    (if username
        (progn
          (setf (getf (response-headers *response*) :x-frame-options) "SAMEORIGIN")
          (render #P"item-page.html" `(:item ,(get-item id))))
          
      ;; redirect to home page
      (redirect "/" 302))))



@route POST "/item/markas"
(defun api-mark-as (&key |command| |item-id|)
  (let ((userid (gethash :id *session*))
        (state (cond
                ((equal |command| "DELETE") +DELETE+)
                ((equal |command| "DONE") +DONE+)
                ((equal |command| "STAR") +STAR+)
                (T -1))))
    (if (and userid (not (= state -1)))
        (progn
          (set-user-item-state userid |item-id| state)
          (render-json '(:|success| T :|msg| "")))
      (render-json '(:|success| NIL :|msg| "未登录或参数不合法")))))
      
  

@route GET "/signout"
(defun signout ()
  (setf (gethash :username *session*) nil)
  (setf (gethash :id *session*) nil)
  (redirect "/" 302))

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
