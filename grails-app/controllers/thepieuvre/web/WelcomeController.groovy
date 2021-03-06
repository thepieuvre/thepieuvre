package thepieuvre.web

import thepieuvre.core.Article
import thepieuvre.core.Feed
import thepieuvre.core.FeedGlobalEnum
import thepieuvre.member.Board
import thepieuvre.member.Member
import thepieuvre.member.MemberCommand
import thepieuvre.security.Role
import thepieuvre.security.UserRole

import grails.plugins.springsecurity.Secured

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

	@Secured(['ROLE_MEMBER'])
	def help() {
		render view: '/help'
	}

	def message(String name, String email, String message, String foo) {
		if (foo) {
			log.info "SPAM contact: $name $email \n $message"
			flash.message = 'It seams that you are a bot.'
			redirect action:'home'
			return
		}
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
		if(SpringSecurityUtils.ifAnyGranted('ROLE_MEMBER')) {
			forward action: 'home', params: params
		} else {
			render view: '/index'
		}
	}

	@Secured(['ROLE_MEMBER'])
	def home = {
		log.info "Welcome - Loading $params"
		int offSet = (params.offSet)? (params.offSet as int) : 0
		if(SpringSecurityUtils.ifAnyGranted('ROLE_MEMBER')) {
			def articles
			def member = springSecurityService.currentUser
			def board = 'The Pieuvre'
			if (params.board == '-2') {
				log.debug "welcome - all Pieuvre board"
				articles = Article.createCriteria().list {
					maxResults(10)
					firstResult(offSet)
					order('dateCreated', 'desc')
					feed { eq 'global', FeedGlobalEnum.GLOBAL } 
				}
			} else if (!  params.board || params.board == '-1' || ! Board.get(params.board as long)) {
				log.debug "welcome - your articles board"
				board = 'Your Articles'
				if (member.feeds?.size() > 0) {
					articles = Article.createCriteria().list {
						maxResults(10)
						firstResult(offSet)
						order('dateCreated', 'desc')
						feed { 'in' ('id',  member.feeds.collect {it.id}) } 
					}
				}
				params.board = '-1'
			} else {
				board = Board.get(params.board).name
				log.debug "welcome - $board board"
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
					'board': Board.get(params.board)
				]
			} else {
				render template: '/article/article', collection:articles, var: 'article'
			}
			log.info "Welcome - Rendered Home"
		} else {
			forward action: 'index'
		}
		log.info "Welcome - Loaded"
	}

	def totalArticles() {
		render Article.count()
	}

	@Secured(['ROLE_MEMBER'])
	def searchByKeyWords = {
		def articles = articleService.getArticleFromNGram(params.keyWords)

		render view: '/home', model: ['articles': articles,
			'tFeeds': Feed.count(),
			'tArticles': Article.count(),
			params: ['command': "'${params.keyWords}'"]]
	}

	@Secured(['ROLE_MEMBER'])
	def searchByAuthor = {
		def articles = Article.createCriteria().list {
			maxResults(10)
			order('dateCreated', 'desc')
			feed { eq 'global', FeedGlobalEnum.GLOBAL }
			ilike 'author', "%${params.author}%" 
		}

		render view: '/home', model: ['articles': articles,
			'tFeeds': Feed.count(),
			'tArticles': Article.count(),
			params: ['command': "by ${params.author}"]]
	}

	@Secured(['ROLE_MEMBER'])
	def searchByFeed = {
		def articles = Article.createCriteria().list {
			maxResults(10)
			order('dateCreated', 'desc')
			feed { 
				eq 'id', params.feed as long
				eq 'global', FeedGlobalEnum.GLOBAL 
			}
		}

		render view: '/home', model: ['articles': articles,
			'tFeeds': Feed.count(),
			'tArticles': Article.count(),
			params: ['command': "from ${Feed.get(params.feed)?.title}"]]
	}

	@Secured(['ROLE_MEMBER'])
	def similar = {
		def art = Article.get(params.id as long)
        if (! art) {
            forward controller: 'error', action: 'notFound'
            return false
        }
		def articles = articleService.similars(art).keySet()
		render view: '/home', model: ['articles': articles,
			'tFeeds': Feed.count(),
			'tArticles': Article.count(),
			params: ['command': "similar ${art.id}"]]
	}

	@Secured(['ROLE_MEMBER'])
	def related = {
		def art = Article.get(params.id as long)
        if (! art) {
            forward controller: 'error', action: 'notFound'
            return false
        }
		def articles = articleService.related(art).keySet()
		render view: '/home', model: ['articles': articles,
			'tFeeds': Feed.count(),
			'tArticles': Article.count(),
			params: ['command': "related ${art.id}"]]
	}

	@Secured(['ROLE_MEMBER'])
	def executor = {
		log.info "Executor: $params"
		if (! params.command){
			redirect action: 'index'
			return true
		}

		if (params.command.trim().startsWith(':')) {
			log.info "Executing  $params.command"
			 def res = commandService.execute(params.command.trim())

			render view: '/home', model: res + ['articles': [],
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

			render view: '/home', model: ['articles': articles,
				'tFeeds': Feed.count(),
				'tArticles': Article.count(),
				'command': params.command]
		}
	}

	def signUp(){
		render view: '/signUp'
	}

	def register(MemberCommand cmd) {
		if (Member.count() > grailsApplication.config.thepieuvre.member.limit) {
			log.info "Member limit reached: ${Member.count()}"
			flash.message = "Sorry, the Pieuvre reached the member limit. Please come back for signing up in a few days."
			render view: '/index'
			return
		}

		if (cmd.validate()) {
            Member m
			try {
				m = memberService.signUp(cmd.properties)
				memberService.verificationNotification(m)
				log.info "New member signed up: $m"
				springSecurityService.reauthenticate m.username
				redirect action: 'home'
			} catch (grails.validation.ValidationException e) {
				log.debug "Signing up failed", e
				render view: '/signUp', model: ['form': e]
			}
		} else {
			log.debug "Signing up invalid: ${cmd.errors}"
			render view: '/signUp', model: ['form': cmd]
		}
	}

	@Secured(['ROLE_MEMBER'])
	def article = {
		if (! params.id) {
	        flash.message = 'Sorry, the Pieuvre cannot find your article.'
	        forward action: 'home'
	        return true		
		}
		try {
			def member = springSecurityService.currentUser
			Article article = Article.get(params.id as long)
	        if (! article) {
	            forward controller: 'error', action: 'notFound'
	            return false
	        }
			if (! article?.language?.startsWith('en')) {
				flash.message = 'Sorry, the Pieuvre just started learning english. Other languages are not yet supported.'
			} else if (! article) {
	            flash.message = 'Sorry, the Pieuvre cannot find your article.'
	            forward action: 'home'
	            return true
	        }
			render view:'/article/article', model: [
				'article': article,
				'boardName': params.boardName,
				'board': member.boards.find { it.name == params.boardName }?.id
			] 
		} catch (java.lang.NumberFormatException e) {
			log.warn "Someone trying hacking: ", e
			forward controller: 'error', action: 'notFound'
		}
	}

	@Secured(['ROLE_MEMBER'])
	def newBoard (String name) {
		if (! name) {
			flash.message = "Sorry, the board's name cannot be blank."
			forward action: 'home'
			return true
		}
		def member = springSecurityService.currentUser
		Board board = new Board('name': name, 'member': member)
		board.save()
		member.addToBoards(board)
		forward action: "home", params: [board: board.id]
	}

	@Secured(['ROLE_MEMBER'])
	def follow (String feed, String board) {
		def boardInstance = Board.get(board)
		if (boardInstance) {
			memberService.addFeed(springSecurityService.currentUser, feed, boardInstance)
		} else {
			memberService.addFeed(springSecurityService.currentUser, feed)
		}
		flash.message = "You are now following ${Feed.findByLink(feed)?.title}"
		forward action: "home", params: [board: board]
	}

	@Secured(['ROLE_MEMBER'])
	def unfollow(String feed, String board) {
		Feed f = Feed.findByLink(feed)
		memberService.removeFeed(springSecurityService.currentUser, f)
		flash.message = "You stopped following $f.title"
		forward action: "home", params: [board: board]
	}

}