import locale
import optparse
import redis
import sys

if sys.hexversion < 0x0240000:
	print >> sys.stderr, 'The python version is too old (%s)' % \
		(sys.version.split()[0])
	print >> sys.stderr, 'At least Python 2.4 is required'
	sys.exit(1)

from feeder.parser import get
from feeder.version import VERSION

def parse_cmdline():
	usage = '%s [OPTIONS] RSS Feeds...' % (sys.argv[0])
	parser = optparse.OptionParser(usage, version='The Pieuvre Feeder ' + VERSION)
	parser.add_option('--verbose', action='store_true', dest='verbose',
		help='print verbose information')
	parser.add_option('--id', type='int', dest='id', help='id of the feed')
	parser.add_option('--etag', type='string', dest='etag', help='eTag for cache optimisation')
	parser.add_option('--modified', type='string', dest='modified', help='modified for cache optimisation')
	parser.add_option('--redis-mode', action='store_true', dest='redis_mode',
		help='consuming the feeder queue from the local Redis')

	options, args = parser.parse_args()

	if len(args) != 1 and not options.redis_mode:
		parser.error('No RSS feeds given')

	return options, args

def main():
	"""Starting the Pieuvre feeder"""
	locale.setlocale(locale.LC_ALL, '')
	options, args = parse_cmdline()
	if options.redis_mode:
		r = redis.StrictRedis(host='localhost', port=6379, db=0)
		r.sadd('queues', 'feedparser')
		get(None, options.id, options.etag, options.modified, redis=r)
	else:
		for url in args:
			get(url, options.id, options.etag, options.modified)