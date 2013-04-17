package thepieuvre.web

import thepieuvre.core.Article
import thepieuvre.core.Feed
import thepieuvre.core.FeedGlobalEnum
import thepieuvre.member.Board
import thepieuvre.member.Member
import thepieuvre.member.MemberCommand
import thepieuvre.security.Role
import thepieuvre.security.UserRole

import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils 

class WelcomeController {

	def springSecurityService

	def articleService
	def commandService
	def memberService

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
		if(SpringSecurityUtils.ifAnyGranted('ROLE_MEMBER')) {
			def articles
			def member = springSecurityService.currentUser
			def board = 'The Pieuvre'
			if (! params.board) {
				articles = Article.createCriteria().list {
					maxResults(25)
					order('dateCreated', 'desc')
					feed { eq 'global', FeedGlobalEnum.GLOBAL } 
				}
			} else if (params.board == '-1' || ! Board.get(params.board)) {
				board = 'Your Feeds'
				articles = Article.createCriteria().list {
					maxResults(25)
					order('dateCreated', 'desc')
					feed { 'in' ('id',  member.feeds.collect {it.id}) } 
				}
			} else {
				board = Board.get(params.board).name
				articles = Article.createCriteria().list {
					maxResults(25)
					order('dateCreated', 'desc')
					feed { 'in' ('id',  Board.get(params.board).feeds.collect {it.id}) } 
				}
			}

			render view: '/home', model: [
				'articles': articles, 
				'boardName': board,
				'board': Board.get(params.board),
				'boards': member?.boards,
				'articleService': articleService, 
			]
		} else {
			def articles = Article.createCriteria().list {
				maxResults(25)
				order('dateCreated', 'desc')
				feed { eq 'global', FeedGlobalEnum.GLOBAL } 
			}
			render view: '/index', model: [
				'articles': articles,
				'articleService': articleService,
				'tFeeds': Feed.count(), 
				'tArticles': Article.count()
			]
		}
	}

	def totalArticles() {
		render Article.count()
	}

	def searchByKeyWords = {
		def articles = articleService.getArticleFromNGram(params.keyWords)

		render view: '/index', model: ['articles': articles,
			'tFeeds': Feed.count(),
			'tArticles': Article.count(),
			'articleService': articleService,
			params: ['command': "'${params.keyWords}'"]]
	}

	def searchByAuthor = {
		def articles = Article.createCriteria().list {
			maxResults(25)
			order('dateCreated', 'desc')
			feed { eq 'global', FeedGlobalEnum.GLOBAL }
			ilike 'author', "%${params.author}%" 
		}

		render view: '/index', model: ['articles': articles,
			'tFeeds': Feed.count(),
			'tArticles': Article.count(),
			'articleService': articleService,
			params: ['command': "by ${params.author}"]]
	}

	def searchByFeed = {
		def articles = Article.createCriteria().list {
			maxResults(25)
			order('dateCreated', 'desc')
			feed { 
				eq 'id', params.feed as long
				eq 'global', FeedGlobalEnum.GLOBAL 
			}
		}

		render view: '/index', model: ['articles': articles,
			'tFeeds': Feed.count(),
			'tArticles': Article.count(),
			'articleService': articleService,
			params: ['command': "from ${Feed.get(params.feed)?.title}"]]
	}

	def similar = {
		def art = Article.get(params.id as long)
		def articles = articleService.similars(art).keySet()
		render view: '/index', model: ['articles': articles,
			'tFeeds': Feed.count(),
			'tArticles': Article.count(),
			'articleService': articleService,
			params: ['command': "similar ${art.id}"]]
	}

	def related = {
		def art = Article.get(params.id as long)
		def articles = articleService.related(art).keySet()
		render view: '/index', model: ['articles': articles,
			'tFeeds': Feed.count(),
			'tArticles': Article.count(),
			'articleService': articleService,
			params: ['command': "related ${art.id}"]]
	}

	def executor = {
		log.info "Executor: $params"
		if (! params.command){
			redirect action: 'index'
			return true
		}

		if (params.command.trim().startsWith(':')) {
			log.info "Executing  $params.command"
			 def res = commandService.execute(params.command.trim())

			render view: '/index', model: res + ['articles': [],
				'tFeeds': Feed.count(),
				'tArticles': Article.count(),
				'command': params.command]
		} else {
			def articles = Article.createCriteria().list {
				maxResults(25)
				order('dateCreated', 'desc')
				feed { eq 'global', FeedGlobalEnum.GLOBAL }
				ilike 'title', "%${params.command}%" 
			}

			render view: '/index', model: ['articles': articles,
				'tFeeds': Feed.count(),
				'tArticles': Article.count(),
				'articleService': articleService,
				'command': params.command]
		}
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

	def signUp(){
		render view: '/signUp'
	}

	def register(MemberCommand cmd) {
		if (cmd.validate()) {
			Member m = memberService.signUp(cmd.properties)
			memberService.verificationNotification(m)
			log.info "New member signed up: $m"
			redirect controller: 'login'
		} else {
			log.debug "Signing up invalid: ${cmd.errors}"
			flash.message = "${cmd.errors}"
			render view: '/signUp'
		}
	}

	def article = {
		Article article = Article.get(params.id)
		render view:'/web/article', model: ['article': article, 'articleService': articleService] 
	}

	def newBoard (String name) {
		def member = springSecurityService.currentUser
		Board board = new Board('name': name, 'member': member)
		board.save()
		member.addToBoards(board)
		forward action: "index", params: [board: board.id]
	}

	def follow (String feed, String board) {
		def boardInstance = Board.get(board)
		if (boardInstance) {
			memberService.addFeed(springSecurityService.currentUser, feed, boardInstance)
		} else {
			memberService.addFeed(springSecurityService.currentUser, feed)
		}

		forward action: "index", params: [board: board]
	}

}