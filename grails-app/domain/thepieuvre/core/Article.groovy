package thepieuvre.core

class Article {

	String uid
	String title
	String link
	String author

	String published

	Date dateCreated

	static hasMany = [ contents: Content ]

	static belongsTo = [ feed: Feed ]

	static constraints = {
		link maxSize: 1024
		uid maxSize: 1024 
		author nullable: true
	}

	String toString() {
		"$title @ $id / $uid"
	}
}