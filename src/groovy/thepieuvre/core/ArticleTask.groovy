package thepieuvre.core

import grails.converters.JSON
import org.apache.log4j.Logger
import redis.clients.jedis.Jedis

class ArticleTask implements Runnable {
	private static final Logger log = Logger.getLogger(ArticleTask.class)

 	def grailsApplication

 	ArticleTask(def grailsApplication) {
 		this.grailsApplication = grailsApplication
 	}

 	@Override
 	void run() {
 		while(true) {
				while(true) {
					try {
						def task
						grailsApplication.mainContext.redisService.withRedis { Jedis redis ->
							task = redis.blpop(60000, 'queue:article')
						}
						if (task) {
							log.info "Getting original content from queue:article"
							def decoded = JSON.parse(task[1])
							if (decoded.nlp?.id) {
								log.info "updating nl processing"
								grailsApplication.mainContext.articleService.updateNlp(decoded.nlp)
							} else if (decoded.content?.id) {
								log.info "updating content: ${decoded?.content?.id}"
								grailsApplication.mainContext.feedService.updateContent(decoded)
							} else {
								log.debug "Unknow message $decoded"
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