package thepieuvre.member

import thepieuvre.core.Feed
import thepieuvre.security.User

class Member  extends User {

	String email

	static mappings = {
		discriminator 'MEMBER'
	}

	static hasMany = [feeds: Feed]

	static constraints = {
		email email: true, unique: true, blank: false
	}

	String toString() {
		"$email aka $username"
	}
}