import feedparser
import json
import sys
import traceback

AGENT='The Pieuvre/1.0 +http://www.thepieuvre.com/'
REFERRER='http://www.thepieuvre.com/'

def escaping(str):
	return str.replace('\\','\\\\').replace('"','\\"').replace('\n',' ').replace("'","\\'")

def processing_task(task):
	feed = json.loads(task)
	data = feedparser.parse(feed['link'], etag=feed['eTag'], modified=feed['modified'], agent=AGENT, referrer=REFERRER)
	return process_data(data, id=feed['id'])

def redis_mode(redis):
	while True:
		try:
			task = redis.blpop('queue:feeder', 10)
			if task != None:
				print 'Getting: %s'%(task[1])
				redis.rpush('queue:feedparser',processing_task(task[1]))
				print 'Pushed to queue:feedparser'
		except KeyboardInterrupt:
			sys.exit(0)
		except:
			traceback.print_exc()

def get(url, id, etag, modified, redis=None):
	if redis != None:
		redis_mode(redis)
	else:
		data = feedparser.parse(url, etag=etag, modified=modified, agent=AGENT, referrer=REFERRER)
		print process_data(data)

def process_data(data, id=None):	
	str_list = []	
	str_list.append('{')
	if id != None:
		str_list.append(('"id": "%s",'% id))
	str_list.append(('"title": "%s",'% escaping((data.feed.get('title', 'null'))).encode('utf-8')))
	str_list.append(('"description": "%s",'% escaping((data.feed.get('description', 'null'))).encode('utf-8')))
	str_list.append(('"language": "%s",'% escaping((data.feed.get('language', 'en'))).encode('utf-8')))
	str_list.append(('"status": "%s",'% (data.get('status', '-1'))).encode('utf-8'))
	str_list.append(('"standard": "%s",'% escaping((data.get('version','null'))).encode('utf-8')))
	str_list.append(('"etag": "%s",'% escaping((data.get('etag', 'null')).replace('"','')).encode('utf-8')))
	str_list.append(('"modified": "%s",'% escaping((data.get('modified', 'null'))).encode('utf-8')))
	status = data.get('status', -1)
	if status == 301:
		str_list.append(('"moved": "%s",' % escaping((data.href)).encode('utf-8')))
	str_list.append(('"updated": "%s",'% escaping((data.feed.get('published', 'null'))).encode('utf-8')))
	str_list.append('"articles": ['.encode('utf-8'))
	size = len(data.entries)
	counter = 0
	for article in data.entries:
		counter = counter + 1
		str_list.append(('{ "title": "%s",' % escaping(article.get('title', 'null')).encode('utf-8')))
		str_list.append(('"link": "%s",' % escaping((article.get('link', 'null').encode('utf-8')))))
		str_list.append(('"author": "%s",' % escaping((article.get('author', 'null').encode('utf-8')))))
		str_list.append('"contents": [')
		if article.get('content'):
			contentSize = len(article.content)
			contentCounter = 0
			for content in article.content:
				contentCounter = contentCounter + 1
				str_list.append('"%s"' %escaping(content.get('value', 'null').encode('utf-8')))
				if contentCounter != contentSize:
					str_list.append(',')
		elif article.get('summary_detail'):
			str_list.append('"%s"' %escaping(article.summary_detail.get('value', 'null').encode('utf-8')))
		str_list.append('],')
		str_list.append(('"published": "%s",' % escaping((article.get('published', 'null'))).encode('utf-8')))
		str_list.append(('"id": "%s" }' % escaping((article.get('id', 'null'))).encode('utf-8')))
		if counter != size:
			str_list.append(",")
	str_list.append(']')
	str_list.append('}')
	return ''.join(str_list).replace('\n',' ')
	
