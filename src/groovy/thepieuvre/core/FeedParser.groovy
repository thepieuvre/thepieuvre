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

	private def sanitize(def s){
		return s.replaceAll(/\s/) { match ->
			' '
		}
	}

	@Override
	void run() {
		while(true) {
			try {
				while(true) {
					log.info "Checking message from queue:feedparser"
					try {
						def msg = null
						grailsApplication.mainContext.redisService.withRedis { Jedis redis -> 
							msg = redis.blpop(60000, 'queue:feedparser')
						}
						if (msg) {
							log.info "Getting message from queue:feedparser"
							def sanitized = sanitize(msg[1])
							def decoded = JSON.parse(sanitized)
							log.debug "Updating feed ${decoded?.id}"
							if (decoded?.id) {
								grailsApplication.mainContext.feedService.update(decoded)
								log.debug "Updated feed ${decoded.id}"
							} else {
								log.warn "Cannot update feed with $decoded"
							}
						} 
					} catch (Exception e) {
						log.error "A problem occured with a feed to update", e
					} 
				}
			} catch (Exception e) {
				log.warn e
				continue
			}
		}
	}
}
