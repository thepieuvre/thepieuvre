package thepieuvre.member

import thepieuvre.security.User

class Member  extends User {

	String email

	static mappings = {
		discriminator 'MEMBER'
	}

	static constraints = {
		email email: true, unique: true, blank: false
	}

	String toString() {
		"$email aka $username"
	}
}