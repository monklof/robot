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

使用`rlwrap sbcl`进入lisp REPL，启动服务器。

```sbcl
;; load robot-web
(ql:quickload :robot-web)
;; set envirment to set the application in production mode
(sb-posix:putenv "APP_ENV=production")
;; start 
(robot-web:start :debug nil)
```

4. 其他环境部署

创建日志目录: /home/robot/logs


5. 部署后端抓取服务

以上步骤将robot-web项目部署起来了。

现在部署robot-crawler，`crontab -e`

内容
```bash
python3 /home/robot/robot/robot-crawler/V2exRequest.py && python3 /home/robot/robot/robot-mining-bot/v2ex_recommend.py > /home/robot/logs/run.log 2>&1
```
