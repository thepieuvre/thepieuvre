package thepieuvre.console

import thepieuvre.core.Article

import grails.plugins.springsecurity.Secured

@Secured(['ROLE_FEED_MANAGER'])
class ArticleManagerController {

	def articleService
	def queuesService

	private def withArticle(id='id', Closure c) {
		Article article = Article.get(params[id])
		if (article) {
			c.call article
		} else {
			forward controller: 'error', action: 'notFound'
		}
	}

	def index() {
		redirect action: 'list'
	}

	def list() {
		log.debug "Listing articles: $params"
		def articles 

		def max = (params.max)?: 50

		if (params) {
			articles = Article.createCriteria().list(buildRequest(params), max: max)
		} else {
			articles = Article.list(max: max)
		}

		[results: articles, filterParams: params, countedArticles: Article.count()]
	}

	private def buildRequest(params) {
		return {
			if (params.title) {
				and { ilike "title", "%${params.title}%"}
			}
			if (params.link) {
				and { ilike "link", "%${params.link}%" }
			}
			if (params.feed) {
				and { feed { ilike "title", "%${params.feed}%"}}
			}
			if (params.sort) {
				and { order "$params.sort", "$params.order" }
			}
		}
	}

	def show(long id) {
		withArticle { article ->
			return [
				'article': article,
				'unigrams': articleService.getUniGram(article),
				'bigrams': articleService.getBiGram(article),
				'ngrams': articleService.getNGram(article),
				'related' : articleService.relatedbyMaxArticles(article),
				'trainedgrams': articleService.getTrainedGram(article)
			]
		}
	}

	def tools = {
		[countedArticles: Article.count()]
	}

	def delete(long id) {
		withArticle { article ->
			article.delete()
		}
		redirect action: 'list'
	}

	def resetForm = {
		redirect action: 'list'
	}

	def indexing (int max) {
		log.info "Forcing re-indexing of $max articles"
		def query = {
			isNull('keyWordsShort')
			maxResults(max)
			setReadOnly true
		}
		def criteria = Article.createCriteria()
		def scrollable = criteria.scroll(query)
		int counter = 0
		try {
			while(scrollable.next()) {
				def article = scrollable.get(0)
				queuesService.enqueue(article.contents)
				log.debug "Re-indexing -> $article.id"
				counter++
			}
		} catch(Exception e) {
			log.error "An error occurred while collecting the list of articles", e
		} finally {
			if (scrollable != null) {
				scrollable.close()
			}
		}
		flash.message = "$counter articles pushed for re-indexing"
		redirect controller: 'hermes', action: 'index'
	}
}