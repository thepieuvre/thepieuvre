package thepieuvre.web

import thepieuvre.core.Article
import thepieuvre.core.Feed
import thepieuvre.core.FeedGlobalEnum

class WelcomeController {

	def about() {
		render view: '/about'
	}

	def help() {
		render view: '/help'
	}

	def contact() {
		render view: '/contact'
	}

	def index = {
		def articles = Article.createCriteria().list {
			maxResults(25)
			order('dateCreated', 'desc')
			feed { eq 'global', FeedGlobalEnum.GLOBAL } 
		}
		render view: '/index', model: ['articles': articles, 'tFeeds': Feed.count(), 'tArticles': Article.count()]
	}

	def totalArticles() {
		render Article.count()
	}

	def executor = {
		log.info "Executor: $params"
		if (! params.command){
			redirect action: 'index'
			return true
		}

		def articles = Article.createCriteria().list {
			maxResults(25)
			order('dateCreated', 'desc')
			feed { eq 'global', FeedGlobalEnum.GLOBAL }
			ilike 'title', "%${params.command}%" 
		}

		render view: '/index', model: ['articles': articles,
			'tFeeds': Feed.count(),
			'tArticles': Article.count(),
			'command': params.command]
	}

	def scroll = {
		log.debug "Scrolling $params"
		int offSet = params.offSet as int
		def articles = Article.createCriteria().list {
			maxResults(25)
			firstResult(offSet)
			order('dateCreated', 'desc')
			feed { eq 'global', FeedGlobalEnum.GLOBAL } 
		}

		render template: '/web/simpleArticle', collection:articles, var: 'article'
	}

}