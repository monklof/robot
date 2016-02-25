;; testing of http://quickdocs.org/cl-dbi/
;; cl-dbi is a low level database driver (based on sql)
;; datafly wraps cl-dbi and provides some useful query functions and provides data->model mapping strategy

(ql:quickload :cl-dbi)

;; create connection
(defvar *connection*
  (dbi:connect :mysql
               :database-name "sim_blog"
               :username "monk"
               :password "test123"))

;; query data 
(let* ((query (dbi:prepare *connection*
                           "SELECT * FROM post WHERE id > ?"))
       (result (dbi:execute query 0)))
  (loop for row = (dbi:fetch result)
     while row
     do (format t "ID:~10t~a~%TITLE:~10t~a~%" (getf row :|id|) (getf row :|title|) )))

;; insert data

(dbi:do-sql *connection* "INSERT INTO post (title, pub_date, is_published, html_text, md_text) values (?, ?, ?, ?, ?)"
            "test" "2016-12-28 11:37:00" 1 "html;" "md")

;; delete data

(dbi:do-sql *connection* "DELETE post where id = ?"
            30)

;; update ....


       
