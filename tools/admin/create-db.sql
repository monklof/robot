CREATE DATABASE robot_web;
CREATE USER 'robot'@'%' identified by 'RoBOt%.%';
GRANT ALL PRIVILEGES ON robot_web.* to 'robot'@'%';
