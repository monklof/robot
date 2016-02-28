以下安装均在项目目录下进行

1. 初始化数据库: 

```shell
python3 robot-craler/models.py
mysql -urobot -p"RoBOt%.%" robot_web < robot-web/tools/admin/schema.sql
```

2. 安装common lisp环境

```shell
sbcl --load quicklisp.lisp
sudo apt-get install install rlwrap
```

3. 创建web软链

ln -s ~/robot/robot-web ~/quicklisp/local-projects/robot-web

使用`rlwrap sbcl`进入REPL

```sbcl
;; load robot-web
(ql:quickload :robot-web)
;; set envirment to set the application in production mode
(sb-posix:putenv "APP_ENV=production")
;; start 
(robot-web:start )
```