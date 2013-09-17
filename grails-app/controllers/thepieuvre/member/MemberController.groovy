package thepieuvre.member

class MemberController {

	def tokenService

	def springSecurityService

	def verification(String token){
		log.info "Email verification: $token"
		def decrypted = tokenService.decrypt(token)
		log.debug "Decypted token: $decrypted"
		def m = Member.get(decrypted.member)
		if (m){
			log.info "Member $m just validated her/his email"
			m.verified = new Date()
			flash.message = 'Thank you for having validated your email.'
			springSecurityService.reauthenticate m.username
			forward controller: 'welcome', action: 'home'
		} else {
			forward controller:'error', action: 'notFound'
		}
	}
}