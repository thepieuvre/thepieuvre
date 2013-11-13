package thepieuvre.member

import grails.plugins.springsecurity.Secured

@Secured(['ROLE_MEMBER'])
class BoardController {

	def springSecurityService

	def boardService

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

	private def buildBoardRequest(params) {
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
			flash.message = "Sorry we cannot delete the board."
		}
		render view: 'list'
	}

}