package thepieuvre.core

import thepieuvre.exception.PieuvreException

import grails.converters.JSON

class FeedService {

	static transactional = true

	def update(Feed feed, File out) {
		log.info "Updating Feed $feed - $out"
		feed = Feed.get(feed.id)
		feed.lastChecked = new Date()
		def json = JSON.parse(out.getText())
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
				Article previous = Article.findByLink(entry.link)
				if (! previous ||  previous.title != entry.title ) {
					Article article = (previous)?:new Article()
					article.feed = feed
					article.uid = entry.id
					article.title = entry.title
					entry.contents.each { content ->
						article.addToContents(new Content(raw: content, article: article))
					}
					article.link = entry.link
					article.published = entry.published
					if(! article.save()) {
						throw new PieuvreException(article.errors)
					}
				}
			}
		} else {
			log.info "Nothing to update for feed $feed"
		}

		if (feed.lastStatus == 301) {
			feed.link = json.moved
		}

		feed.lastError = null

		out.delete()
	}

	def desactive(Feed feed) {
		log.info "Desactiving Feed $feed"
		feed = Feed.get(feed.id)
		feed.active = false
	}

	def exitValue(long id, int exit, String error) {
		Feed feed = Feed.get(id)
		log.info "Updating exit value for feed $feed with $exit"
		feed.lastChecked = new Date()
		feed.lastStatus = exit
		feed.lastError = error
		feed.active = false
	}
}