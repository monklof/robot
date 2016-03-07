#! /usr/bin/env python3

"""v站数据推荐 -- 将v站每天产生的文章内容，经过推荐计算后推送到已有用户的列表中去

语法: ./v2ex_recomment.py ${user_id} => 向user_id的用户推荐文章

v0.1: v2ex文章全量推送
"""

from models import *
import hashlib
import sys, os
import datetime
import contextlib
import logging
from sqlalchemy.sql import select


PROJECT_ROOT = os.path.realpath(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..'))
sys.path.append(PROJECT_ROOT)

def _hash_title(title):
    return hashlib.sha256(title.encode()).hexdigest()

def site_id(name="v2ex"):
    with session_scope() as s:
        site = s.query(Site).filter_by(name=name).all()
        if site:
            site = site[0]
        else:
            site = Site(name="v2ex", url="http://www.v2ex.com/", description="v", ico_url="")
            s.add(site)
            s.commit()
        return site.id

vsite_id = site_id("v2ex")
        

def extract_and_clean_v2ex_data():
    """将v2ex文章转换为清洗后的item数据返回"""
    items = []
    with session_scope() as s:
        for v in s.query(Article).all():
            item = Item(title=v.title,
                        title_hash=_hash_title(v.title),
                        content=v.content,
                        full_url=v.art_url,
                        author =v.author,
                        author_url=v.author_url,
                        site_id = vsite_id,
                        # TODO: 改为真实数据
                        created_at = datetime.datetime.now(),
                        updated_at = datetime.datetime.now())
            items.append(item)
    return items

def merge_item_to_database(items):
    """将item按照title唯一规则merge到数据库中"""
    # TODO 支持更新
    with session_scope() as s:
        for item in items:
            if not s.query(Item).filter_by(title=item.title).all():
                s.add(item)
        s.commit()

def populate_recommendation_for(user_id):
    """为指定用户生成推荐"""
    new_items = []
    with session_scope() as s:
        for item in s.query(Item).all():
            if not s.query(UserItem).filter_by(user_id=user_id, item_id=item.id).count():
                new_items.append(item)

        for item in new_items:
            logging.debug("%d: %s" % (user_id, item.title))
            s.add(UserItem(user_id=user_id, item_id=item.id))
        s.commit()

def recommend_for_user(user_id):
    """为单个用户生成每日推荐"""


def recommendation_daily_main():
    """为每个用户生成每日推荐"""
    logging.info("generating recommendations for all of the users ...")

    logging.info("fetching latest item data ...")
    items = extract_and_clean_v2ex_data()
    merge_item_to_database(items)

    logging.info("populating ... ")
    with contextlib.closing(engine.connect()) as conn:
        expr = select([User.id])
        result = conn.execute(expr)
        users = [row[0] for row in result]
        
    logging.info("users: %s", users)

    for userid in users:
        logging.info("populating for user: %d", userid)
        populate_recommendation_for(userid)
    


if __name__ == "__main__":
    from utils.outputdependhandler import init_logger
    init_logger()
    recommendation_daily_main()
