package thepieuvre.console

import thepieuvre.core.Feed
import thepieuvre.core.FeedCommand
import thepieuvre.core.FeedGlobalEnum

import grails.plugins.springsecurity.Secured

@Secured(['ROLE_FEED_MANAGER'])
class FeedManagerController {

	def feedService

	private def withFeed(id='id', Closure c) {
		Feed feed = Feed.get(params[id])
		if (feed) {
			c.call feed
		} else {
			forward controller: 'error', action: 'notFound'
		}
	}

	def index() {
		redirect action: 'list'
	}

	def list() {
		log.debug "Listing feeds: $params"
		def feeds 

		def max = (params.max)?: 50

		if (params) {
			feeds = Feed.createCriteria().list(buildRequest(params), max: max)
		} else {
			feeds = Feed.list(max: max)
		}

		[results: feeds, filterParams: params, countedFeeds: Feed.count()]
	}

	private def buildRequest(params) {
		return {
			if (params.title) {
				and { ilike "title", "%${params.title}%"}
			}
			if (params.link) {
				and { ilike "link", "%${params.link}%" }
			}
			if (params.active) {
				and { eq "active", (params.active == 'on')?true:false }
			}
			if (params.global) {
				and { eq "global", FeedGlobalEnum.fromString(params.global) }
			}
			if (params.sort) {
				and { order "$params.sort", "$params.order" }
			}
		}
	}

	def show(long id) {
		withFeed { feed ->
			return ['feed': feed]
		}
	}

	def save(String link, String comment, String active) {
		Feed feed = new Feed (
			link: link,
			comment: comment,
			active: (active == 'on')?true:false
			)
		if (! feed.save()) {
			render view: 'create', model: ['feed': feed]
		} else {
			redirect action: 'list'
		}
	}

	def create() {
		// Just the view
	}

	def update(long id, FeedCommand cmd, String active, String global) {
		withFeed { feed ->
			if (cmd.validate()) {
				feed.link = cmd.link
				feed.comment = cmd.comment
				feed.active = (active == 'on')?true:false
				feed.global = FeedGlobalEnum.fromString(global)
			} else {
				render view: 'edit', model: ['feed': cmd], params: params
			}
		}

		redirect action: 'show', id: id
	}

	def edit (long id) {
		withFeed { feed ->
			return [
				'link': feed.link,
				'comment': feed.comment,
				'active': feed.active,
				'global': feed.global,
				'title': feed.title,
				'id': feed.id
			]
		}
	}

	def delete(long id) {
		withFeed { feed ->
			feedService.desactive(feed)
			show(id)
		}
	}

	def resetForm = {
		redirect action: 'list'
	}
}