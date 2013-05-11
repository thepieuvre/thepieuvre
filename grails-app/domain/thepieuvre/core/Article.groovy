package thepieuvre.core

class Article {

	String uid
	String title
	String link
	String author

	String published

	Date dateCreated

	Content contents

	static belongsTo = [ feed: Feed ]

	static transients = [ 'language' ]

	static constraints = {
		link maxSize: 1024
		uid maxSize: 1024 
		author nullable: true
		language nullable: true
	}

	String toString() {
		"$title @ $id / $uid"
	}

	String getLanguage() {
		feed.language
	}
}