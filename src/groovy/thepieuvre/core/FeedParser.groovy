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
			try {
				while(true) {
					log.info "Checking message from queue:feedparser"
					Feed feed= null
					grailsApplication.mainContext.redisService.withRedis { Jedis redis ->
						try {
							def msg = redis.blpop(1000, 'queue:feedparser')
							if (msg) {
								log.info "Getting message from queue:feedparser"
								def decoded = JSON.parse(msg[1])
								feed= Feed.get(decoded.id as Long)
								log.debug "Updating feed $feed"
								if (feed) {
									grailsApplication.mainContext.feedService.update(feed, decoded)
									log.debug "Updated feed $feed"
								} else {
									log.warn "Cannot update $feed with $decoded"
								}
							} 
						} catch (Exception e) {
							log.error "A problem occured with a feed to update", e
						} 
					}
				}
			} catch (Exception e) {
				log.warn e
				continue
			}
		}
	}
}
