package thepieuvre.core

import thepieuvre.exception.PieuvreException

class FeedService {

	static transactional = true

	def htmlCleaner
	def queuesService

	def grailsApplication

	def update(Content content, def json) {
		log.info "Updating content $content"
		content.refresh()
		content.fullText = json.fullText
		content.extractor = json.extractor
		content.mainImage = json.mainImage
		queuesService.enqueue(content.article)
	}

	def update(Feed feed, def json) {
		log.info "Updating Feed $feed "
		feed = Feed.get(feed.id)
		feed.lastChecked = new Date()
		feed.lastStatus = json.status as int

		if (feed.lastStatus != 304) {
			log.info "Updating info of feed $feed"
			feed.lastUpdated = new Date()
			feed.standard = (json.standard != 'null')?json.standard:feed.standard
			feed.title = (json.title != 'null')?json.title:feed.title
			feed.description =  (json.description != 'null')?json.description:feed.description
			feed.language = (json.language != 'null')?json.language:feed.language
			feed.updated = (json.updated != 'null')?json.updated:feed.updated
			feed.modified = (json.modified != 'null')?json.modified:feed.modified

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
						if (article.contents && article.contents.raw.size() < content.size()) {
							article.contents = new Content(raw: content, article: article)
						} else {
							article.contents = new Content(raw: content, article: article)
						} 
					}
					article.link = entry.link

					article.published = entry.published
					if(! article.save(flush: true)) {
						throw new PieuvreException(article.errors)
					}
					queuesService.enqueue(article.contents)
				}
			}
		} else {
			log.info "Nothing to update for feed $feed"
		}

		if (feed.lastStatus == 301) {
			feed.link = json.moved
		}

		feed.lastError = null
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