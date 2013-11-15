package thepieuvre.member

import thepieuvre.core.Feed

class BoardService {

	static transactional = true

	def delete(Board board, Member member) {
		log.debug "Deleting board $board for member $member"
		member.removeFromBoards(board)
		board.delete()
		log.debug "Board deleted for $member"
	}
	
	def removeFeed(Board board, Feed feed) {
		board.removeFromFeeds(feed)
	}

	def moveTo(Board source, Board destination, Feed feed) {
		removeFeed(source, feed)
		destination.addToFeeds(feed)
	} 
}