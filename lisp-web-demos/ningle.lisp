;; 结论: ningle太轻量级, 没有模板系统, web处理流程不完整(request, response操作方式不明晰)

(defvar *app*  (make-instance 'ningle:<app> ))

(defun authorize (username password)
  (and
   (string= username "monk")
   (string= password "pwd")))
                                          

(setf (ningle:route *app* "/")
      "Welcome to ningle")

(setf (ningle:route *app* "/login" :method :POST)
      #'(lambda (params)
          (if (authorize (cdr (assoc "username" params :test #'string=))
                         (cdr (assoc "password" params :test #'string=)))
              "Authorized!"
              "Failed...Try again.")))

(clack:clackup *app*)

