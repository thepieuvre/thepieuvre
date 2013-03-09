package thepieuvre.console

import grails.plugins.springsecurity.Secured

@Secured(['ROLE_ROOT'])
class HermesController {

	def queuesService

	def index() {
		render view: '/tools/queues', model: [queues: queuesService.queues, service: queuesService]
	}

	def clear(String queue) {
		queuesService.clear(queue)
		redirect action: 'index'
	}

	def create(String queue) {
		def res = queuesService.create(queue)
		flash.message = "$queue created: $res"
		redirect action: 'index'
	}

	def destroy(String queue) {
		def res = queuesService.destroy(queue)
		flash.message = "$queue destroyed: $res"
		redirect action: 'index'

	}

}