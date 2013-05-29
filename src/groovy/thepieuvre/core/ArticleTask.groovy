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
						def task = redis.blpop(60000, 'queue:article')
						if (task) {
							log.info "Getting original content from queue:article"
							def decoded = JSON.parse(task[1])
							if (decoded.nlp?.id) {
								log.info "updating nl processing"
								grailsApplication.mainContext.articleService.updateNlp(decoded.nlp)
							} else {
								log.info "updating content: $decoded.content.id"
								Content.withNewSession { session ->
								def query = Content.where {
										id == decoded.content.id
									}
									Content content = query.find()
									if (content) {
										grailsApplication.mainContext.feedService.update(content, decoded.content)
									} else {
										log.warn "Cannot find content for $decoded.content.id -> $decoded"
										// TODO push it to the next queue??
										// log.info "Pushing $article.id to queue:queue:extractor"
	  									// queuesService.enqueue(article.contents)
	  									// TODO force re-extractor of empty fullcontent articles...
									}
								}
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