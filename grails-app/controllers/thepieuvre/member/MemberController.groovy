package thepieuvre.member

class MemberController {

	def tokenService

	def verification = {
		log.info "Email verification: $params.id"
		def decrypted = tokenService.decrypt(params.id)
		log.debug "Decypted token: $decrypted"
		def m = Member.get(decrypted.member)
		if (m){
			log.info "Member $m just validated her/his email"
			m.verified = new Date()
			flash.message = 'Thank you for having validated your email. Please "Log In".'

			forward controller: 'welcome', action: 'index'
		} else {
			forward controller:'error', action: 'notFound'
		}
	}
}