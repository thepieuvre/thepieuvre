package thepieuvre.member

import thepieuvre.core.Feed

class MemberService {

	def grailsApplication
	def mailService
	def tokenService

	def signUp(def details){
		Member m = new Member(details)
		m.enabled = true
		m.save(flush:true)
		UserRole.create(m, Role.findByAuthority('ROLE_MEMBER'), true)
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

    def addFeed(Member member, String link) {
        Feed feed = Feed.findByLink(link)
        if (! feed) {
            feed = new Feed(link: link)
            if (! feed.save()) {
                log.warn "Cannot save a feed: $feed.errors"
                return false
            }
        }
        if (! member.feeds.contains(feed)) {
            member.addToFeeds(feed)
        }
        return true
    }
}