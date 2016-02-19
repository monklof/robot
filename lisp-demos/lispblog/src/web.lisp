(in-package :cl-user)
(defpackage lispblog.web
  (:use :cl
        :caveman2
        :lispblog.config
        :lispblog.view
        :lispblog.db
        :datafly
        :sxql)
  (:export :*web*))
(in-package :lispblog.web)

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

(defroute "/post/:post-id/" (&key post-id)
  (render #P"post.html"
          `(:post (:title "monklof's blog"
                          :link ,post-id))))

(defroute "/compare/*" (&key splat)
  (format nil "我们收到的URL的内容: ~a" (car splat)))

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
