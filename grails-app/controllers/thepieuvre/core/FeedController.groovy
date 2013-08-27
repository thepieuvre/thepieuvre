package thepieuvre.core

import thepieuvre.exception.ApiException

import grails.converters.JSON
import grails.plugins.springsecurity.Secured

@Secured(['ROLE_API'])
class FeedController {

	def feedService

	private static def binding = ['link', 'comment']

	private def withFeed(id='id', Closure c) {
		Feed feed = Feed.get(params[id])
		if (feed) {
			c.call feed
		} else {
			response.status = 404
			def res = [error: true, httpStatus: 404, message: "Feed ${params[id]} not found"]
			render res as JSON
		}
	}

	def show() {
		log.info "API Feed - show feed $params.id"
		withFeed { feed ->
			render feed as JSON
		}
	}

	def update(FeedCommand cmd) {
		log.info "API Feed - update feed $params"
		withFeed { feed ->
			if (cmd.hasErrors()) {
				throw new ApiException(cmd.errors)
			}
			bindData(feed, params, [include: binding])
			render (status: 200)
		}
	}

	def save(FeedCommand cmd) {
		log.info "API Feed - save feed $params"
		if (cmd.hasErrors()) {
			throw new ApiException(cmd.errors)
		} else {
			Feed feed = new Feed()
			bindData(feed, params, [include: binding])
			if (feed.save()) {
				render (status: 200)	
			} else {
				throw new ApiException(feed.errors)
			}
		}
	}

	def delete() {
		log.info "API Feed - delete feed $params.id"
		withFeed { feed ->
			feedService.desactive(feed)
			render (status: 200)
		}
	}

}