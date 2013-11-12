package thepieuvre.member

import thepieuvre.core.Feed
import thepieuvre.member.Board
import thepieuvre.security.Role
import thepieuvre.security.UserRole

class MemberService {

	def grailsApplication
	def mailService
	def tokenService

	def signUp(def details){
        Role rMember = Role.findByAuthority('ROLE_MEMBER')
		Member m = new Member(details)
		m.enabled = true
		m.save(flush:true, failOnError: true)
		UserRole.create(m, rMember, true)
        return m
	}

	def verificationNotification (Member member) {
    	log.info "Sending verification email to $member"
    	mailService.sendMail {
    		to member.email
    		subject "The Pieuvre - Email Address Verification"
    		body(
    			view: '/emails/memberVerification',
    			model: [
    				username: member.username,
    				validationUrl: "${grailsApplication.config.grails.serverURL}/member/verification/${getVerificationToken(member)}"
    			]
    		)
    	}
    }

    private String getVerificationToken(Member member) {
    	tokenService.encrypt([
    		birth: new Date(),
    		member: member.id
    	])
    }

    def removeFeed(Member member, Feed feed) {
        member.feeds.remove(feed)
        member.boards.each { board ->
            board.feeds.remove(feed)
        }
    }

    def addFeed(Member member, String link) {
        Feed feed = Feed.findByLink(link)
        if (! feed) {
            feed = new Feed(link: link)
            if (! feed.save(flush: true)) {
                log.warn "Cannot save a feed: $feed.errors"
                return false
            }
        }
        if (! member.feeds.contains(feed)) {
            member.addToFeeds(feed)
        }
        return true
    }

    def addFeed(Member member, String link, Board board) {
        Feed feed = Feed.findByLink(link)
        if (! feed) {
            feed = new Feed(link: link)
            if (! feed.save(flush: true)) {
                log.warn "Cannot save a feed: $feed.errors"
                return false
            }
        }
        if (! member.feeds.contains(feed)) {
            member.addToFeeds(feed)
        }
        board.addToFeeds(feed)
        return true
    }

    def removeFeed(Member member, String id) {
        member.removeFromFeeds(Feed.get(id as long))
    }

    def listFeeds(Member member) {
        member.feeds
    }

    def getFeeds(Member member, String board) {
        def feeds = null
        switch(board) {
            case null:
            case '-2':
                // All Pieure
                feeds = null
                break
            case '-1':
                // Your Articles
                feeds = member.feeds
                break
            default:
                feeds = Board.findByIdAndMember(board as long, member)?.feeds
            break
        }
        return feeds
    }
}