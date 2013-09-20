package thepieuvre.web

import thepieuvre.core.Feed
import thepieuvre.member.Member

class ThePieuvreTagLib {

	static namespace = "pieuvre"

	def springSecurityService

	def follow = { attrs, body ->
		Member member = springSecurityService.currentUser
		Feed feed = attrs.feed
		if (member.feeds.contains(feed)) {
			out << "unfollow"
		} else {
			out << "<a href='${createLink(action: 'follow', controller: 'welcome', params: [feed: "${feed.link}" ])}'><span class='glyphicon glyphicon-record'></span> Follow</a>"
		}
	}

}