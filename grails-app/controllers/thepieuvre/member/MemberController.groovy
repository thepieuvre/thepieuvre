package thepieuvre.member

import thepieuvre.exception.PieuvreException

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

	def profile() {
		// render the view
	}

	private Member userVerification(String id) {
		Member member = springSecurityService.currentUser
		log.debug "Validating user: $member.id with form $id"
		if (member.id as String == id) {
			return member
		} else {
			log.warn "Hacking try: logged user $member does not match id form $id"
			throw new PieuvreException("Sorry you user cannot do that!")
		}
	}

	def changeUsername(String username, String userId) {
		log.debug "Changing username: $username $userId"
		Member member = userVerification(userId)
		member.username = username
		if(member.validate()) {
			springSecurityService.reauthenticate member.username
			flash.message = "You successfully changed your username to $username"
		} else {
			flash.message = "Sorry we cannot change your username to $username"
			member.discard()
		}
		render view: 'profile'
	}

	def changeEmail(String email, String userId) {
		log.debug "Changing email: $email $userId"
		Member member = userVerification(userId)
		member.email = email
		if(member.validate()) {
			flash.message = "You successfully changed your email to $email"
		} else {
			flash.message = "Sorry we cannot change your email to $email"
			member.discard()
		}
		render view: 'profile'
	}

	def changePassword(String password, String cPassword, String userId) {
		log.debug "Changing password: $userId"
		Member member = userVerification(userId)
		if (member.password != springSecurityService.encodePassword(cPassword)) {
			flash.message = "Sorry we cannot change your password because you current password is incorrect"
			render view: 'profile'
			return false
		}

		member.password = password
		if(member.validate()) {
			flash.message = "You successfully changed your password"
		} else {
			flash.message = "Sorry we cannot change your password"
			member.discard()
		}
		render view: 'profile'
	}
}