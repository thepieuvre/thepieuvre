package thepieuvre.member

import grails.plugins.springsecurity.Secured

@Secured(['ROLE_MEMBER'])
class BoardController {

	def springSecurityService


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


	def delete(Board board, Member member) {
		Board.findByIdAndMember(board.id, member)

		// TODO to be continued

		String name = board.name
		board.member.removeFromBoards(board)
		board.delete()
		flash.message = "$name deleted"
		render view: 'list'
	}

}