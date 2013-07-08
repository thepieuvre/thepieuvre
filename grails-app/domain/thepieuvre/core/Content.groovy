package thepieuvre.core

class Content {

	String raw

	String fullText
	String extractor = 'None'

	String mainImage

    String language

	static belongsTo = [ article: Article ]

	static constraints = {
		raw maxSize: 1048576
		fullText nullable: true, maxSize: 1048576
		mainImage nullable: true, url: true
        language nullable: true
	}
}