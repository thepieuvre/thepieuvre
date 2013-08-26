package thepieuvre.member

import thepieuvre.core.Feed

class Board implements Comparable {

	String name

	static belongsTo = [ member: Member ]

	static hasMany = [ feeds: Feed ]

	static constraints = {
		name blank: false
	}

	String toString() {
		"$name"
	}

	int compareTo(obj) {
        name.compareTo(obj.name)
    }
}