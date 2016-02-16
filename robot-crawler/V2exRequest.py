#! /usr/local/bin/python
#coding:utf-8
import requests 
import models
import json
from models import getArticleByUrl,session_scope,Article
from  xml.dom import  minidom

SOURCE_V2EX=0

def get_attrvalue(node, attrname):
		return node.getAttribute(attrname) if node else ''

def get_nodevalue(node, index = 0):
	return node.childNodes[index].nodeValue if node else ''

def get_xmlnode(node,name):
	return node.getElementsByTagName(name) if node else []

def xml_to_string(filename='user.xml'):
	doc = minidom.parse(filename)
	return doc.toxml('UTF-8')

class V2exRequest:
	def __init__(self):
		self.v2exRSSUrl="http://www.v2ex.com/feed/tab/play.xml"

	def getFeedsContentBySource(self,source):
		contentUrl=None
		if source==SOURCE_V2EX:
			contentUrl=self.v2exRSSUrl
		if contentUrl != None:
			r=requests.get(contentUrl)
			if r.status_code==200:
				return r.text

		return None

	def grabFeedsToSql(self):
		articlesStr=self.getFeedsContentBySource(SOURCE_V2EX)
		doc=minidom.parseString(articlesStr)
		root = doc.documentElement
		entry_nodes=get_xmlnode(root,'entry')
		with session_scope() as session:
			for node  in entry_nodes:
				node_title = get_xmlnode(node,'title')
				node_link=get_xmlnode(node,'link')
				node_content=get_xmlnode(node,'content')
				node_author=get_xmlnode(node,'author')
				node_author_name=get_xmlnode(node_author[0],'name')
				node_author_url=get_xmlnode(node_author[0],'uri')
				node_published=get_xmlnode(node,'published')
				node_updated=get_xmlnode(node,'updated')

				title =get_nodevalue(node_title[0])
				herf = get_attrvalue(node_link[0],'href')
				replyIndex=herf.index('#reply')
				replyCount=0
				art_url=herf
				if replyIndex!=-1:
					replyCount=int(herf[replyIndex+6:len(herf)])
					art_url=herf[0:replyIndex]
				else :  
					replyCount=0
					art_url=herf
				
				content=get_nodevalue(node_content[0])
				author_name=get_nodevalue(node_author_name[0])
				author_uri=get_nodevalue(node_author_url[0])
				time_create=get_nodevalue(node_published[0])
				time_modify=get_nodevalue(node_updated[0])
				time_create=time_create.replace('T',' ')
				time_create=time_create.replace('Z','')
				time_modify=time_modify.replace('T',' ')
				time_modify=time_modify.replace('Z','')
				art=None
				existArt=models.getArticleByUrl(art_url)
				if existArt == None:
					art=models.Article()
				else:
					art=existArt

				art.title=title
				art.art_url=art_url
				art.reply_count=replyCount
				art.content=content
				art.author=author_name;
				art.author_url=author_uri
				art.time_create=time_create
				art.time_modify=time_modify
				art.source=0
				art.source_name="v2ex"
				if existArt==None:
					session.add(art)

				session.commit()





frostrequest=V2exRequest()
frostrequest.grabFeedsToSql()