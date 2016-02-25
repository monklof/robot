;; install:
;; (ql:quickload :clsql)

(clsql:def-view-class post ()
  ((id
    :db-kind :key
    :db-constraints :not-null
    :type integer
    :initarg :id)
   (title
    :type (string 64)
    :initarg :title
    :accessor :title)
   (pub_date
    :type datetime
    :initarg :pub_date
    :accessor :pub_date)
   (is_published
    :type integer
    :initarg :is_published
    :accessor :is_published)
   (html_text
    :type (string 65535)
    :initarg :html_text
    :accessor :html_text)
   (md_text
    :type (string 65535)
    :initarg :md_text
    :accessor :md_text)
   (category_id
    :type integer
    :initarg :category_id
    :accessor :category_id)
   (summary
    :type (string 1024)
    :initarg :summary
    :accessor :summary))
  (:base-table post))


   
    
            
