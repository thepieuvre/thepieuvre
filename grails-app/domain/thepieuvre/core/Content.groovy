package thepieuvre.core

class Content {

	String raw

	static belongsTo = [ article: Article ]

	static constraints = {
		raw maxSize: 262144
	}
}