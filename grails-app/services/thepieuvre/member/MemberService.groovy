package thepieuvre.member

class MemberService {

	def grailsApplication
	def mailService
	def tokenService

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
}