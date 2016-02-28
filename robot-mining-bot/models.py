#! /usr/local/bin/python
#coding:utf-8
from sqlalchemy import create_engine, func, ForeignKey, Column
from sqlalchemy.types import String, Integer, DateTime, Text, Boolean
from sqlalchemy.orm import relationship, backref, sessionmaker,scoped_session
from sqlalchemy.ext.declarative import declarative_base
from contextlib import contextmanager

__author__ = 'frostpeng'
 
engine = create_engine("mysql+mysqlconnector://robot:RoBOt%.%@localhost:3306/robot_web")
# support emoji(utf8mb4) 
# engine.execute("set names utf8mb4;")
MapBase = declarative_base(bind=engine)
DBSession = sessionmaker(bind=engine)
ScopedSession = scoped_session(DBSession)

class ItemState:
    UNREAD = 1
    DONE = 2
    STAR = 4
    DELETED = 8

#创建一个映射类
class Article(MapBase):
    __tablename__ = 'v2exArticle'
    art_id = Column(Integer, primary_key=True)
    art_url=Column(String(300), nullable=False)
    title=Column(Text,nullable=False)
    author=Column(String(200), nullable=False)
    author_url=Column(String(200), nullable=True)
    content=Column(Text, nullable=False)
    reply_count=Column(Integer,default=0)
    time_create=Column(String(20))
    time_modify=Column(String(20))
    source=Column(Integer,default=0)
    source_name=Column(Text,nullable=True)

class Item(MapBase):

    __tablename__ = "item"
    id = Column(Integer, primary_key=True)
    title_hash=Column(String(128), unique = True)
    title=Column(String(1024),nullable=False)
    content=Column(Text, nullable=False)
    full_url = Column(String(1024))
    created_at = Column(DateTime)
    updated_at = Column(DateTime)
    site_id = Column(Integer)
    author=Column(String(64), nullable=False)
    author_url=Column(String(1024), nullable=True)

class UserItem(MapBase):

    __tablename__ = "user_item"
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer)
    item_id = Column(Integer)
    state = Column(Integer, default=ItemState.UNREAD)

class Site(MapBase):

    __tablename__ = "site"
    id = Column(Integer, primary_key=True)
    name = Column(String(128))
    url = Column(String(256))
    description = Column(String(256))
    ico_url = Column(String(128))

MapBase.metadata.create_all(engine) 

@contextmanager
def session_scope(scoped=True):
    """Provide a *thread-safe* transactional scope around a series of operations."""
    session = ScopedSession() if scoped else DBSession()
    try:
        yield session
        session.commit()
    except:
        session.rollback()
        raise
    finally:
        # detach all instances in this session
        # and release connection
        session.close()
