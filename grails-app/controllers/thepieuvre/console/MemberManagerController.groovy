package thepieuvre.console

import grails.plugins.springsecurity.Secured

import thepieuvre.member.Member

@Secured(['ROLE_MEMBER_MANAGER'])
class MemberManagerController {

	private def withMember(id='id', Closure c) {
		Member member = Member.get(params[id])
		if (member) {
			c.call member
		} else {
			forward controller: 'error', action: 'notFound'
		}
	}

	def index() {
		redirect action: 'list'
	}

	def list() {
		log.debug "Listing members: $params"
		def members 

		def max = (params.max)?: 50

		if (params) {
			members = Member.createCriteria().list(buildRequest(params), max: max)
		} else {
			members = Member.list(max: max)
		}

		[results: members, filterParams: params, countedMembers: Member.count()]
	}

	private def buildRequest(params) {
		return {
			if (params.email) {
				and { ilike "email", "%${params.email}%"}
			}
			if (params.username) {
				and { ilike "username", "%${params.username}%" }
			}
			if (params.sort) {
				and { order "$params.sort", "$params.order" }
			}
		}
	}

	def show(long id) {
		withMember { member ->
			return ['member': member]
		}
	}

	def resetForm = {
		redirect action: 'list'
	}

}