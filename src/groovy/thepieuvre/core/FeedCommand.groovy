package thepieuvre.core

@grails.validation.Validateable
class FeedCommand {

	String link
	String comment

	static constraints = {
		link url: true, nullable: false, blank: false
		comment nullable: true, blank: false, maxSize: 4096
	}
}