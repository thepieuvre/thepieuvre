import urllib2
import lxml.html as LH
from urlparse import urljoin

def get_feed_url(html_url):
   '''From an HTML page, extract the first ATOM/RSS feed'''
   feedTypes = ['application/atom+xml', 'application/rss+xml']
  
   # partial download window
   delta_bytes = 4096
   last_stop = 0
   req = urllib2.Request(html_url)

   # incremental parsing
   parser=LH.HTMLParser()

   # loop on partial downloads
   while True:
      next = last_stop + delta_bytes
      req.headers['Range'] = 'bytes=%s-%s' % (last_stop, next)
      last_stop = next
      response = urllib2.urlopen(req)
      new_content = response.read()
      # to visualize the number of times a download occurs: 
      # print 'read :' + str(len(new_content))
      if (not new_content):
          # end of http stream reached
          break
      parser.feed(new_content)
      if ('</head>' in new_content):
          # the rest of the http stream is of no interest
          break
      
   link_xpath = parser.close().xpath("//link[@rel='alternate']")
  
   # just return the first <head><link rel='alternate' ... /> of RSS/ATOM type
   for element in link_xpath:  
      if element.get('type') in feedTypes:
          # print 'href=' + element.get('href') + ' rel=' + element.get('rel') + ' type=' + element.get('type')
          return urljoin(response.geturl(), element.get('href'))
                
class HeadRequest(urllib2.Request):
   def get_method(self):
      return "HEAD"

def is_html(url):
      ''' Does the header of a URL expose an HTML content-type? '''
      response = urllib2.urlopen(HeadRequest(url))
      content_type = response.info().dict['content-type'].split(';')[0] 
      # return content_type + ' from ' + response.geturl() 
      return content_type == 'text/html'
                   
