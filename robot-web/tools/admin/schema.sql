--- 以下数据皆为清洗干净，安全，准备好供线上使用的数据。
--- 原始数据不存在此表中。


CREATE TABLE `user` (
       id             integer(10) AUTO_INCREMENT,
       username       varchar(64) UNIQUE NOT NULL,
       email          varchar(64) UNIQUE NOT NULL,
       password       varchar(2048) NOT NULL,
       `role`         integer(4) NOT NULL DEFAULT 0,
       avatar_url     varchar(1024) DEFAULT "",

       PRIMARY KEY(`id`),
       KEY(`username`),
       KEY(`email`))
       DEFAULT CHARSET=utf8 ENGINE=Innodb COMMENT "用户基本信息";

CREATE TABLE `item` (
       id           integer(10) AUTO_INCREMENT,
       title_hash varchar(128) NOT NULL DEFAULT "" UNIQUE,
       title        varchar(1024) NOT NULL COMMENT "文章标题",
       content      text NOT NULL COMMENT "文章内容（经过安全格式化处理的）",
       full_url     varchar(1024) NOT NULL COMMENT "文章链接",
       author       varchar(64) DEFAULT "" COMMENT "作者",
       author_url   varchar(1024) DEFAULT "" COMMENT "作者链接",
       created_at   datetime    NOT NULL COMMENT "创建时间",
       updated_at   datetime    NOT NULL COMMENT "更新时间",
       site_id         integer(10) NOT NULL COMMENT "文章来源站点",
       PRIMARY KEY(`id`),
       KEY(title_hash),
       CONSTRAINT `FK_SITE` FOREIGN KEY (`site_id`) REFERENCES `site` (`id`)
       ) DEFAULT CHARSET=utf8 ENGINE=Innodb COMMENT "所有文章表，一个url是一篇文章";

CREATE TABLE `site`(
       id       integer(10) AUTO_INCREMENT,
       `name`   varchar(128) NOT NULL,
       url      varchar(256) NOT NULL,
       description varchar(256) NOT NULL,
       ico_url  varchar(128),
       PRIMARY KEY(`id`)) DEFAULT CHARSET=utf8 ENGINE=Innodb COMMENT "站点信息";

CREATE TABLE `user_item` (
       id            integer(10) AUTO_INCREMENT,
       user_id       integer(10),
       item_id       integer(10),
       `state`       integer(4) COMMENT "状态 1未读 2已读 4喜欢 8删除",
       PRIMARY KEY(`id`),
       KEY(`user_id`),
       CONSTRAINT `FK_USER` FOREIGN KEY (`user_id`) REFERENCES `user`  (`id`),
       CONSTRAINT `FK_ITEM` FOREIGN KEY (`item_id`) REFERENCES `item` (`id`))
       DEFAULT CHARSET=utf8 ENGINE=Innodb COMMENT "用户文章表";

CREATE TABLE `invitetoken` (
       id            integer(10) AUTO_INCREMENT,
       token         varchar(128) NOT NULL,
       max_use       integer(10) NOT NULL DEFAULT 10,
       used          integer(10) NOT NULL DEFAULT 0,
       PRIMARY KEY(`id`))
       DEFAULT CHARSET=utf8 ENGINE=Innodb COMMENT "邀请码";

CREATE TABLE `sessions` (
       id            integer(20) AUTO_INCREMENT,
       session_data  varchar(2048),
       PRIMARY KEY (`id`))
       DEFAULT CHARSET=utf8 ENGINE=Innodb COMMENT "Caveman用来存储会话信息";

-- 行为分析通过解析日志来实现，不在程序中打点了。

-- 花了一个小时来做这个数据库模型设计，究竟有没有必要呢。还是干脆用一个非关系型数据库快速搞起来就好了。
