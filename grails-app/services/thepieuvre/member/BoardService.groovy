package thepieuvre.member

class BoardService {

	static transactional = true

	def delete(Board board, Member member) {
		log.debug "Deleting board $board for member $member"
		member.removeFromBoards(board)
		board.delete()
		log.debug "Board deleted for $member"
	}
	
}