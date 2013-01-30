
import thepieuvre.core.Feed
import thepieuvre.core.FeedGlobalEnum

class FeedBootStrap {

	def init = { servletContext ->

		def links = [
			'http://www.appleinsider.com/appleinsider.rss',
			'http://feeds.arstechnica.com/arstechnica/BAaf',
			'http://feeds.boingboing.net/boingboing/iBag',
			'http://feeds.feedburner.com/CoolTools',
			'http://www.engadget.com/rss.xml',
			'http://feeds.gawker.com/gizmodo/full',
			'http://lifehacker.com/index.xml',
			'http://www.nytimes.com/services/xml/rss/nyt/Technology.xml',
			'http://rss.slashdot.org/Slashdot/slashdot',
			'http://feeds.feedburner.com/TechCrunch/',
			'http://news.ycombinator.com/rss',
			'http://feeds.wired.com/wired/index',
			'http://feed.dilbert.com/dilbert/daily_strip'
		]

		links.each { link ->
			Feed feed = new Feed(link: link, global: FeedGlobalEnum.GLOBAL)
			if (! feed.save(failOnError: true, flush: true)) {
				println feed.errors
			}
		}
	}

	def destroy = {

	}
}