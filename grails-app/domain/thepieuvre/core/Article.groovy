package thepieuvre.core

class Article {

	String uid
	String title = 'No title'
	String link
	String author

	String published = new Date() as String

	Date dateCreated

	Content contents

	String synopsis
	String keyWords
	String keyWordsShort
	String similars

	static belongsTo = [ feed: Feed ]

	static transients = [ 'language' ]

	static constraints = {
		link maxSize: 1024
		uid maxSize: 1024 
		author nullable: true
		language nullable: true
		synopsis nullable: true, maxSize: 2048
		keyWords nullable: true, maxSize: 2048
		keyWordsShort nullable: true, maxSize: 2048
		similars nullable: true, maxSize: 2048
		published nullable: true
	}

	String toString() {
		"$title @ $id / $uid"
	}

	String getLanguage() {
        if (contents?.language) {
            contents.language
        } else {
		    feed.language
        }
	}

	String getPublished() {
		if(published == 'null') {
			dateCreated as String
		} else {
			published
		}
	}

}