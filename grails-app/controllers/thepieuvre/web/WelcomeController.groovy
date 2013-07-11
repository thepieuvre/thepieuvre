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

	def mailService
	def grailsApplication
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

	def message(String name, String email, String message) {
		mailService.sendMail {
			to grailsApplication.config.thepieuvre.mailalert.split(',').collect { it }
			from "noreply@thepieuvre.com"
			subject "Contact Us Request"
			body """
A new contact request :
	Name: $name
	Email: $email
	Member: $springSecurityService.currentUser

The message:
$message
			"""
		}
		flash.message = 'Thank you for your message.'
		redirect action:'index'
	}

	def index = {
		log.info "Welcome - Loading"
		int offSet = (params.offSet)? (params.offSet as int) : 0
		if(SpringSecurityUtils.ifAnyGranted('ROLE_MEMBER')) {
			def articles
			def member = springSecurityService.currentUser
			def board = 'The Pieuvre'
			if (! params.board) {
				articles = Article.createCriteria().list {
					maxResults(10)
					firstResult(offSet)
					order('dateCreated', 'desc')
					feed { eq 'global', FeedGlobalEnum.GLOBAL } 
				}
			} else if (params.board == '-1' || ! Board.get(params.board as long)) {
				board = 'Your Feeds'
				if (member.feeds?.size() > 0) {
					articles = Article.createCriteria().list {
						maxResults(10)
						firstResult(offSet)
						order('dateCreated', 'desc')
						feed { 'in' ('id',  member.feeds.collect {it.id}) } 
					}
				}
			} else {
				board = Board.get(params.board).name
				if (Board.get(params.board).feeds?.size() > 0) {
					articles = Article.createCriteria().list {
						maxResults(10)
						firstResult(offSet)
						order('dateCreated', 'desc')
						feed { 'in' ('id',  Board.get(params.board).feeds.collect {it.id}) } 
					}
				}
			}

			log.info "Welcome - Rendering Home"
			if (offSet == 0) {
				render view: '/home', model: [
					'articles': articles, 
					'boardName': board,
					'board': Board.get(params.board),
					'boards': member?.boards,
					'articleService': articleService, 
				]
			} else {
				render template: '/web/simpleArticle', collection:articles, var: 'article', model: ['articleService': articleService]
			}
			log.info "Welcome - Rendered Home"
		} else {
			def articles = Article.createCriteria().list {
				maxResults(10)
				firstResult(offSet)
				order('dateCreated', 'desc')
				feed { eq 'global', FeedGlobalEnum.GLOBAL } 
			}
			log.info "Welcome - Rendering Index"
			if (offSet == 0) {
				render view: '/index', model: [
					'articles': articles,
					'articleService': articleService,
					'tFeeds': Feed.count(), 
					'tArticles': Article.count()
				]
			} else {
				render template: '/web/simpleArticle', collection:articles, var: 'article', model: ['articleService': articleService]
			}
			log.info "Welcome - Rendered Index"
		}
		log.info "Welcome - Loaded"
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
			maxResults(10)
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
			maxResults(10)
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
        if (! art) {
            forward controller: 'error', action: 'notFound'
            return false
        }
		def articles = articleService.similars(art).keySet()
		render view: '/index', model: ['articles': articles,
			'tFeeds': Feed.count(),
			'tArticles': Article.count(),
			'articleService': articleService,
			params: ['command': "similar ${art.id}"]]
	}

	def related = {
		def art = Article.get(params.id as long)
        if (! art) {
            forward controller: 'error', action: 'notFound'
            return false
        }
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
				maxResults(10)
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

	def signUp(){
		render view: '/signUp'
	}

	def register(MemberCommand cmd) {
		if (cmd.validate()) {
			try {
				Member m = memberService.signUp(cmd.properties)
				memberService.verificationNotification(m)
				log.info "New member signed up: $m"
				redirect action: 'index'
			} catch (grails.validation.ValidationException e) {
				log.debug "Signing up failed", e
				flash.message = "${e.errors}"
				render view: '/signUp'
			}
		} else {
			log.debug "Signing up invalid: ${cmd.errors}"
			flash.message = "${cmd.errors}"
			render view: '/signUp'
		}
	}

	def article = {
		try {
			Article article = Article.get(params.id as long)
	        if (! article) {
	              forward controller: 'error', action: 'notFound'
	            return false
	        }
			if (! article?.language?.startsWith('en')) {
				flash.message = 'Sorry, the Pieuvre just started learning english. Other languages are not yet supported.'
			} else if (! article) {
	            flash.message = 'Sorry, the Pieuvre cannot find your article.'
	            forward action: 'index'
	            return true
	        }
			render view:'/web/article', model: ['article': article, 'articleService': articleService] 
		} catch (java.lang.NumberFormatException e) {
			log.warn "Someone trying hacking: ", e
			forward controller: 'error', action: 'notFound'
		}
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