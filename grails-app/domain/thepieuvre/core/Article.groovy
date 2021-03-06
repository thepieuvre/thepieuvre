package thepieuvre.core

import grails.converters.JSON

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
		title maxSize: 1024
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
		if(! published || published == 'null') {
			dateCreated as String
		} else {
			published
		}
	}

	List<Similar> similarsAsObject() {
		if (similars) {
			def parsed = JSON.parse(similars)
			List<Similar> result = []

			parsed.each {articleId, score ->
				result << new Similar(articleId as long, score, this)
			}

			return result
		} else {
			return null
		}
	}

}