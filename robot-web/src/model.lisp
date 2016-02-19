(in-package :cl-user)
(defpackage robot-web.model
  (:use :cl
        :robot-web.db
        :sxql
        :datafly)
  (:export :user-exists
           :user-check-pwd
           :user-create
           :search-all-user
           :check-invite-token
           :use-invite-token))
(in-package :robot-web.model)


;;;
;;; `User` specific model and functions
(syntax:use-syntax :annot)

@model
(defstruct user
  id
  username
  email
  password
  role
  avatar-url)
  
(defun user-exists (username)
  (if (with-connection (db)
       (retrieve-one
        (select :*
                (from :user)
                (where (:= :username username)))
        :as 'user))
      T NIL))

(defun user-check-pwd (username password)
  (with-connection (db)
                   (retrieve-one
                    (select :*
                            (from :user)
                            (where (:and (:= :username username)
                                         (:= :password password))))
                    :as 'user)))

(defun user-create (&key username password email (role 0) avatar-url)
  (with-connection (db)
                   (execute
                    (insert-into :user
                                 (set= :username username
                                       :password password
                                       :email email
                                       :role role
                                       :avatar_url avatar-url)))))


(defun search-all-user ()
  (with-connection (db)
                   (retrieve-all
                    (select :*
                            (from :user))
                    :as 'user)))
                            

;;; 检查邀请码是否有效

(defun check-invite-token (token)
  (with-connection (db)
                   (let ( (invite-token (retrieve-one
                                         (select :*
                                                 (from :invitetoken)
                                                 (where (:and
                                                         (:= :token token)
                                                         (:> :max_use (fields :used))))))))
                     (if invite-token (- (getf invite-token :max-use )
                                           (getf invite-token :used))
                       nil))))
;;; 使用邀请码
(defun use-invite-token (token)
  T)


                                       
                   
                                        
