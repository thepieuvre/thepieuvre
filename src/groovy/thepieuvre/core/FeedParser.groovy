package thepieuvre.core

import grails.converters.JSON
import org.apache.log4j.Logger
import redis.clients.jedis.Jedis

class FeedParser implements Runnable {
	private static final Logger log = Logger.getLogger(FeedParser.class)

 	def grailsApplication

	FeedParser(def grailsApplication) {
		this.grailsApplication = grailsApplication
	}

	@Override
	void run() {
		while(true) {
			Feed feed= null
			try {
				grailsApplication.mainContext.redisService.withRedis { Jedis redis ->
					def msg = redis.blpop(60000, 'queue:feedparser')
					log.info "Getting message from queue:feedparser"
					def decoded = JSON.parse(msg[1])
					feed= Feed.get(decoded.id as Long)
					log.debug "Updating feed $feed"
					grailsApplication.mainContext.feedService.update(feed, decoded)
				}
			} catch (Exception e) {
				log.error e
				grailsApplication.mainContext.feedService.exitValue((feed)?feed.id:-1, "${e.getMessage()}\n ${e.getCause()}")
			} 
		}
	}
}
