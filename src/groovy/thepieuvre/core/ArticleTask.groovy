package thepieuvre.core

import grails.converters.JSON
import org.apache.log4j.Logger
import redis.clients.jedis.Jedis

class ArticleTask implements Runnable {
	private static final Logger log = Logger.getLogger(FeedParser.class)

 	def grailsApplication

 	ArticleTask(def grailsApplication) {
 		this.grailsApplication = grailsApplication
 	}

 	@Override
 	void run() {
 		while(true) {
			grailsApplication.mainContext.redisService.withRedis { Jedis redis ->
				while(true) {
					try {
						def task = redis.blpop(10000, 'queue:article')
						if (task) {
							log.info "Getting original content from queue:article"
							def decoded = JSON.parse(task[1])
							Content content = Content.get(decoded.content.id)
							if (content) {
								grailsApplication.mainContext.feedService.update(content, decoded.content)
							} else {
								log.warn "Cannot find content for $decoded"
							}
						} else {
							continue
						}
					} catch (Exception e) {
						log.error "A problem occured while poping queue:article", e
						continue
					}
				}
			}

 		}
 	}
}