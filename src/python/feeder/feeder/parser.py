import feedparser
import nltk
import json

def escaping(str):
	return str.replace('\\','\\\\').replace('"','\\"').replace('\n','')
	
def parsingTitle(title):
	if title == 'null':
		return
	cleaned = nltk.clean_html(title)
	tokens = nltk.word_tokenize(cleaned)
	print '"title_token": %s,'% json.dumps(nltk.pos_tag(tokens))

def get(url, id, etag, modified):
	data = feedparser.parse(url, etag=etag, modified=modified, agent='The Pieuvre/1.0 +http://www.thepieuvre.com/', referrer='http://www.thepieuvre.com/')
	print '{'
	print ('"title": "%s",'% (data.feed.get('title', 'null'))).encode('utf-8')
	print ('"description": "%s",'% (data.feed.get('description', 'null'))).encode('utf-8')
	print ('"language": "%s",'% (data.feed.get('language', 'en'))).encode('utf-8')
	print ('"status": "%s",'% (data.status)).encode('utf-8')
	print ('"standard": "%s",'% (data.version)).encode('utf-8')
	print ('"etag": "%s",'% (data.get('etag', 'null'))).encode('utf-8')
	print ('"modified": "%s",'% (data.get('modified', 'null'))).encode('utf-8')
	if data.status == 301:
		print ('"moved": "%s",' % (data.href)).encode('utf-8')
	print ('"updated": "%s",'% (data.feed.get('published', 'null'))).encode('utf-8')
	print '"articles": ['.encode('utf-8')
	size = len(data.entries)
	counter = 0
	for article in data.entries:
		counter = counter + 1
		print ('{ "title": "%s",' % (article.get('title', 'null').replace('"','\\"'))).encode('utf-8')
		#parsingTitle(article.get('title', 'null').encode('utf-8'))
		print ('"link": "%s",' % (article.get('link', 'null')))
		print '"contents": ['
		if article.get('content'):
			contentSize = len(article.content)
			contentCounter = 0
			for content in article.content:
				contentCounter = contentCounter + 1
				print '"%s"' %escaping(content.get('value', 'null').encode('utf-8'))
				if contentCounter != contentSize:
					print ','
		elif article.get('summary_detail'):
			print '"%s"' %escaping(article.summary_detail.get('value', 'null').encode('utf-8'))
		print '],'
		print ('"published": "%s",' % (article.get('published', 'null'))).encode('utf-8')
		print ('"id": "%s" }' % (article.get('id', 'null'))).encode('utf-8')
		if counter != size:
			print ","
	print ']'
	print '}'
	
