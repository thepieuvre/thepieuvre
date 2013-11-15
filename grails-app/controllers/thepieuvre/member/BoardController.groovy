package thepieuvre.member

import grails.plugins.springsecurity.Secured

import thepieuvre.core.Feed

@Secured(['ROLE_MEMBER'])
class BoardController {

	def springSecurityService

	def boardService
	def memberService

	def index () {
		redirect action: 'list'
	}

	def list = {
		Member member = springSecurityService.currentUser

		// TODO Board.createCriteria().list(buildRequest(params)
		def feeds
		if (params.current) {
			feeds = Board.findByIdAndMember(params.current as long, member)?.feeds
		} else {
			feeds = member.feeds
		}

		render view: 'list', model: [
			current: params.current,
			board: Board.get(params.current), 
			feeds: feeds,
			filterParams: params]
	}

	private def buildFeedRequest(params) {
		return {
			if (params.title) {
				and { ilike "title", "%${params.title}%"}
			}
			if (params.link) {
				and { ilike "link", "%${params.link}%" }
			}
			if (params.sort) {
				and { order "$params.sort", "$params.order" }
			}
		}
	}

	def delete(String id) {
		Member member = springSecurityService.currentUser
		Board board = Board.findByIdAndMember(id, member)
		if (board) {
			String name = board.name
			boardService.delete(board, member)
			flash.message = "$name deleted"
		} else {
			flash.message = "Sorry we cannot do that."
		}
		render view: 'list'
	}

	// Current is the board id | Board is the current Domain

	def remove = {
		Board board = Board.findByIdAndMember(params.current, springSecurityService.currentUser)
		if (board) {
			boardService.removeFeed(board, Feed.get(params.feed as long))
			flash.message = "Feed $params.feed removed from $params.current"
		} else {
			flash.message = "Sorry we cannot do that."
		}
		redirect action: 'list', params: [ board: board, current: board.id ]
	}

	def copyTo = {
		Board board = Board.get(params.dest)
		memberService.addFeed(springSecurityService.currentUser, params.feed, board)
		flash.message = "Feed $params.feed copied to $params.dest"
		redirect action: 'list', params: [ 
			board: params.current?Board.get(params.current as long):null,
			current: params.current]
	}

	def moveTo = {
		Board source = Board.findById(params.current)
		Board destination = Board.findById(params.dest)
		Feed feed = Feed.findByLink(params.feed)
		if (source && destination && feed){
			boardService.moveTo(source, destination, feed)
		} else {
			flash.message = "Sorry we cannot do that."
		}
		redirect action: 'list', params: [ 
			board: source,
			current: params.current]
	}

	def unfollow = {
		Feed feed = Feed.get(params.feed)
		Member member = springSecurityService.currentUser
		memberService.removeFeed(member, feed)
		flash.message = "You do not follow $feed anymore"
		redirect action: 'list'
	}

	def edit = {
		Board board = Board.findByIdAndMember(params.board, springSecurityService.currentUser)
		if (board) {
			board.name = params.name
		} else {
			flash.message = "Sorry we cannot do that."
		}

		if (! board.validate()) {
			flash.message = "Sorry we cannot edit the board: $board.errors"
		}
		redirect action: 'list', params: [board: board, current: board.id]
	}

}