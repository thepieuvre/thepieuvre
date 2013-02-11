package thepieuvre.member

@grails.validation.Validateable
class MemberCommand {

	String username
	String email
	String password

	static constraints = {
		username blank: false, minSize: 3
		email email: true, blank: false
		password blank: false, minSize: 8
	}
}