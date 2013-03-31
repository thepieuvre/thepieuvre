import feedparser
import json
import sys
import traceback

AGENT='The Pieuvre/1.0 +http://www.thepieuvre.com/'
REFERRER='http://www.thepieuvre.com/'

def escaping(str):
	return str.replace('\\','\\\\').replace('"','\\"').replace('\n',' ')

def processing_task(task):
	feed = json.loads(task)
	data = feedparser.parse(feed['link'], etag=feed['eTag'], modified=feed['modified'], agent=AGENT, referrer=REFERRER)
	return process_data(data, id=feed['id'])

def redis_mode(redis):
	while True:
		try:
			task = redis.blpop('queue:feeder', 60)
			if task != None:
				print 'Getting: %s'%(task[1])
				redis.rpush('queue:feedparser',processing_task(task[1]))
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
	str_list.append(('"title": "%s",'% (data.feed.get('title', 'null'))).encode('utf-8'))
	str_list.append(('"description": "%s",'% (data.feed.get('description', 'null'))).encode('utf-8'))
	str_list.append(('"language": "%s",'% (data.feed.get('language', 'en'))).encode('utf-8'))
	str_list.append(('"status": "%s",'% (data.get('status', '-1'))).encode('utf-8'))
	str_list.append(('"standard": "%s",'% (data.version)).encode('utf-8'))
	str_list.append(('"etag": "%s",'% (data.get('etag', 'null').replace('"',''))).encode('utf-8'))
	str_list.append(('"modified": "%s",'% (data.get('modified', 'null'))).encode('utf-8'))
	if data.status == 301:
		str_list.append(('"moved": "%s",' % (data.href)).encode('utf-8'))
	str_list.append(('"updated": "%s",'% (data.feed.get('published', 'null'))).encode('utf-8'))
	str_list.append('"articles": ['.encode('utf-8'))
	size = len(data.entries)
	counter = 0
	for article in data.entries:
		counter = counter + 1
		str_list.append(('{ "title": "%s",' % (article.get('title', 'null').replace('"','\\"'))).encode('utf-8'))
		str_list.append(('"link": "%s",' % (article.get('link', 'null').encode('utf-8'))))
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
		str_list.append(('"published": "%s",' % (article.get('published', 'null'))).encode('utf-8'))
		str_list.append(('"id": "%s" }' % (article.get('id', 'null'))).encode('utf-8'))
		if counter != size:
			str_list.append(",")
	str_list.append(']')
	str_list.append('}')
	return ''.join(str_list).replace('\n',' ') 
	
