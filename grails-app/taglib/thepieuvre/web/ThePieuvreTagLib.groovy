package thepieuvre.web

import thepieuvre.core.Feed
import thepieuvre.member.Member

class ThePieuvreTagLib {

	static namespace = "pieuvre"

	def springSecurityService

	def follow = { attrs, body ->
		Member member = springSecurityService.currentUser
		Feed feed = attrs.feed
		if (member.feeds.find { it.id == feed.id}) {
			out << "<a href='${createLink(action: 'unfollow', controller: 'welcome', params: [feed: "${feed.link}" ])}'><span class='glyphicon glyphicon-remove-circle'></span>  Unfollow</a>"
		} else {
			out << "<a href='${createLink(action: 'follow', controller: 'welcome', params: [feed: "${feed.link}" ])}'><span class='glyphicon glyphicon-record'></span> Follow</a>"
		}
	}

}