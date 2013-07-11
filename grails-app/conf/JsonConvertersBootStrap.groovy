import thepieuvre.core.Article
import thepieuvre.core.Content

import grails.converters.JSON

class JsonConvertersBootStrap {

	def init = { servletContext ->
		JSON.registerObjectMarshaller(Article) { a ->
			def json = [:]
			json.id = a.id
			json.feed = a.feed.id
			json.uid = a.uid
			json.dateCreated = a.dateCreated
			json.link = a.link
			json.published = a.published
			json.title = a.title
			json.language = (a.language)?:'no-lang'
			//json.contents = a.contents.fullText
			json.contents = {
				def c = "<h1>${it.title}</h1>"
				c += it.contents.raw
				c += it.contents.fullText
				return c
			}.call(a)
			return json
		}

		JSON.registerObjectMarshaller(Content) { c ->
			def json = [:]
			json.id = c.id
			json.link = c.article.link
			json.raw = "$c.article.title $c.raw"
			return json
		}

	}

	def destroy = {}
}