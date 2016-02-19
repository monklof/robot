;; caveman http://8arrow.org/caveman/
;; main features:
;;   1. Server Independent: switch backend server without change any code. for example: 
;;      *Hunchentoot* during development
;;      *FastCGI*     in the production
;;   2. Database integration: ? useful for what?
;;   3. Template integration: Djula as default


;; a web page that render posts
;; 
;; /post/${id}/ will show the demo



(ql:quickload :caveman2)

