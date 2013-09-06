package thepieuvre.core

import thepieuvre.exception.PieuvreException

import groovy.time.TimeCategory

class FeedService {

	static transactional = true

	def htmlCleaner
	def queuesService

	def grailsApplication

	def updateFeeds() {
		log.debug "Looking for feeds to update"
		def feeds
		Date now = new Date()
		try {
			feeds = Feed.createCriteria().scroll {
				eq 'active', true
				or {
					// First check
					isNull 'checkOn'
					le 'checkOn', now 
				}
				order 'checkOn', 'asc'
				maxResults 100
			}
			while(feeds.next()) {
				def feed = feeds.get(0)
				log.debug "Adding $feed to the queue"
				use(TimeCategory) {
					feed.checkOn = now + 60.minutes
				}
				queuesService.enqueue(feed)
			}
			log.debug "All feed pushed to queue:feedparser"
		} catch (Exception e) {
			log.error "Something wrong happened while updating feeds", e
		} finally {
			if (feeds) {
				try {
					feeds.close()
				} catch (Exception) {
					log.warn "Cannot close the scroll", e
				}
			}
		}
	}

	def updateContent(def json) {
		Content content = Content.lock(json.content.id as long)
		if (content) {
			log.info "Updating content $content"
			content.fullText = json.content.fullText
			content.extractor = json.content.extractor
			content.mainImage = json.content.mainImage
        	content.language = json.content.lang
        	content.save()
			queuesService.enqueue(content.article)
		} else {
			log.warn "Cannot find content for $json.content.id -> $json"
		}
	}

	def update(Feed feed, def json) {
		log.info "Updating Feed $feed "
		try {
			feed = Feed.lock(feed.id)
			feed.lastChecked = new Date()
			feed.lastStatus = json.status as int
			Date now = new Date()
			if (feed.lastStatus != 304) {
				log.info "Updating info of feed $feed"
				feed.lastUpdated = new Date()
				feed.standard = (json.standard != 'null')?json.standard:feed.standard
				feed.title = (json.title != 'null')?json.title:feed.title
				feed.description =  (json.description != 'null')?json.description:feed.description
				feed.language = (json.language != 'null')?json.language:feed.language
				feed.updated = (json.updated != 'null')?json.updated:feed.updated
				feed.modified = (json.modified != 'null')?json.modified:feed.modified
				use(TimeCategory) {
					feed.checkOn = now + 30.minutes
				}
				json.articles.each { entry ->
					Article previous = Article.findByUid(entry.id)
					previous = (previous)?:Article.findByLink(entry.link)
					if (! previous) {
						Article article = new Article()
						article.feed = feed
						article.uid = (entry.id != 'null')?entry.id:'-1'
						article.title = (entry.title != 'null')?entry.title:null
						article.author = (entry.author != 'null')?htmlCleaner.cleanHtml(entry.author, 'none'):null
						entry.contents.each { content ->
							article.contents = new Content(raw: content, article: article)
						}

						if (!article.contents) {
							article.contents = new Content(raw: 'null', article: article)
						}

						article.contents.save()

						article.link = entry.link

						article.published = entry.published
						if(! article.save(flush: true, deepValidate: true)) {
							log.error "Cannot save article for feed $feed -- ${article.errors as String}"
							feed.lastError = article.errors as String
						} else {
							queuesService.enqueue(article.contents)
							log.info "Updated feed $feed with $article and content $article.contents.id"
						}
					}
				}
			} else {
				log.info "Nothing to update for feed $feed"
				use(TimeCategory) {
					feed.checkOn = now + 15.minutes
				}
			}

			log.info "$feed will be checked on $feed.checkOn"

			if (feed.lastStatus == 301) {
				feed.link = json.moved
			}

			feed.lastError = null
		} catch (Exception e) {
			log.error "Cannot update feed", e
		}
	}

	def desactive(Feed feed) {
		log.info "Desactiving Feed $feed"
		feed = Feed.get(feed.id)
		feed.active = false
	}

	def exitValue(long id, String error) {
		if (id != -1) {
			Feed feed = Feed.get(id)
			log.info "Updating exit value for feed $feed with $exit"
			feed.lastChecked = new Date()
			feed.lastStatus = exit
			feed.lastError = error
			feed.active = false
		} else {
			throw new PieuvreException(error)
		}
	}

}