package thepieuvre.core

class Content {

	String raw

	String fullText
	String extractor = 'None'

	String mainImage

	static belongsTo = [ article: Article ]

	static constraints = {
		raw maxSize: 262144
		fullText nullable: true, maxSize: 1048576
		mainImage nullable: true, url: true
	}
}