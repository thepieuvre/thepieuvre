package thepieuvre.member

import thepieuvre.core.Feed

class Board {

	String name

	static belongsTo = [ member: Member ]

	static hasMany = [ feeds: Feed ]

	static constraints = {
		name blank: false
	}

	String toString() {
		"$name"
	}
}