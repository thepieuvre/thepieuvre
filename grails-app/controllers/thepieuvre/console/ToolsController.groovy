package thepeiuvre.console

import grails.plugins.springsecurity.Secured

@Secured(['ROLE_ROOT'])
class ToolsController {

	def index = {}
}