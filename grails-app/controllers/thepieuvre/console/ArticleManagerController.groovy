package thepieuvre.console

import thepieuvre.core.Article

import grails.plugins.springsecurity.Secured

@Secured(['ROLE_FEED_MANAGER'])
class ArticleManagerController {

	def markdownService

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
			return ['article': article, 'markdownService':markdownService]
		}
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
}