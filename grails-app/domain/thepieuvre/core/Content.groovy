package thepieuvre.core

class Content {

	String raw
	// TODO String author

	static belongsTo = [ article: Article ]

	static constraints = {
		raw maxSize: 262144
	}
}