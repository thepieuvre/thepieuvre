
import thepieuvre.core.Feed
import thepieuvre.core.FeedGlobalEnum

class FeedBootStrap {

	def init = { servletContext ->
		println "Bootstraping feeds..."

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
			'http://feed.dilbert.com/dilbert/daily_strip',
			'http://feeds.mashable.com/Mashable',
			'http://www.rottentomatoes.com/syndication/rss/top_news.xml',
			'http://digg.com/rss/topstories.xml',
			'http://www.theverge.com/rss/index.xml',
			'http://rss.cnn.com/rss/edition.rss',
			'http://online.wsj.com/xml/rss/3_7085.xml',
			'http://cacm.acm.org/news.rss',
			'http://www.ibtimes.com/rss/tech-sci',
			'http://allthingsd.com/feed/',
			'http://feeds.nationalgeographic.com/ng/News/News_Main',
			'http://feeds.feedburner.com/design-milk',
			'http://feeds.feedburner.com/monday-note',
			'http://feeds.slate.com/slate',
			'http://www.forbes.com/real-time/feed2/'
		]

		links.each { link ->
			Feed feed = Feed.findByLink(link)
			if (! feed) {
				feed = new Feed(link: link, global: FeedGlobalEnum.GLOBAL)
				if (! feed.save(failOnError: true, flush: true)) {
					println feed.errors
				}
			}

		}

		println "Feeds bootstraped."
	}

	def destroy = {

	}
}