#! /usr/local/bin/python
#coding:utf-8
from sqlalchemy.orm import mapper, sessionmaker

__author__ = 'frostpeng'
 
from sqlalchemy import create_engine, Table, Column, Integer, String, MetaData
from sqlalchemy.sql.expression import Cast
from sqlalchemy.ext.compiler import compiles
from sqlalchemy.dialects.mysql import \
        BIGINT, BINARY, BIT, BLOB, BOOLEAN, CHAR, DATE, \
        DATETIME, DECIMAL, DECIMAL, DOUBLE, ENUM, FLOAT, INTEGER, \
        LONGBLOB, LONGTEXT, MEDIUMBLOB, MEDIUMINT, MEDIUMTEXT, NCHAR, \
        NUMERIC, NVARCHAR, REAL, SET, SMALLINT, TEXT, TIME, TIMESTAMP, \
        TINYBLOB, TINYINT, TINYTEXT, VARBINARY, VARCHAR, YEAR
from sqlalchemy import event

#表的属性描述对象
#依次是id，外部的id，标题，url，内容，创建时间，修改时间，内容来源（0为v2ex）
metadata = MetaData()
articleTable = Table(
    "v2exArticle",metadata,
    Column('art_id', Integer, primary_key=True),
    Column('art_url', VARCHAR(300), nullable=False,unique=True),
    Column('title',TEXT, nullable=False),
    Column('author', VARCHAR(200), nullable=False),
    Column('author_url', VARCHAR(200), nullable=True),
    Column('content', TEXT, nullable=False),
    Column('reply_count', INTEGER,default=0),
    Column('time_create', VARCHAR(20)),
    Column('time_modify', VARCHAR(20)),
    Column('source',INTEGER),
    Column('source_name',TEXT) 
)
#创建数据库连接,MySQLdb连接方式
mysql_db = create_engine('mysql+mysqlconnector://root:pxk123456@localhost:3306/frostDb?charset=utf8mb4',
                        echo=False,convert_unicode=True)
#创建数据库连接，使用 mysql-connector-python连接方式
#mysql_db = create_engine("mysql+mysqlconnector://用户名:密码@ip:port/dbname")
#生成表
metadata.create_all(mysql_db)


#创建一个映射类
class Article(object):
    pass
#把表映射到类
mapper(Article, articleTable)
#创建了一个自定义了的 Session类
Session = sessionmaker()
#将创建的数据库连接关联到这个session
Session.configure(bind=mysql_db)
#唯一的session
sessionInstance = None


def getDbSession():
    global sessionInstance
    if sessionInstance==None:
        sessionInstance = Session()

    return sessionInstance

def getArticleByUrl(url):
    session=getDbSession()
    article = session.query(Article).filter_by(art_url=url).first()
    return article

def closeSession():
    global sessionInstance
    if sessionInstance!=None:
        sessionInstance.close()
        sessionInstance=None