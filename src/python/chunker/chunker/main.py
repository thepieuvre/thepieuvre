import locale
import optparse
import redis
import sys

if sys.hexversion < 0x0240000:
	print >> sys.stderr, 'The python version is too old (%s)' % \
		(sys.version.split()[0])
	print >> sys.stderr, 'At least Python 2.4 is required'
	sys.exit(1)

from chunker.version import VERSION
from chunker.extractor import redis_mode

def parse_cmdline():
	usage = '%s [OPTIONS]' % (sys.argv[0])
	parser = optparse.OptionParser(usage, version='The Pieuvre Chunker ' + VERSION) 
	parser.add_option('--verbose', action='store_true', dest='verbose',
		help='print verbose information')
	parser.add_option('--redis-mode', action='store_true', dest='redis_mode',
		help='consuming the chunker queue from the local Redis')

	options, args = parser.parse_args()

	return options, args

def main():
	"""Starting the Pieuvre feeder"""
	locale.setlocale(locale.LC_ALL, '')
	options, args = parse_cmdline()
	if options.redis_mode:
		r = redis.StrictRedis(host='localhost', port=6379, db=0)
		r.sadd('queues', 'chunker')
		redis_mode(r)