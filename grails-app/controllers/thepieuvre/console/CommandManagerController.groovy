package thepieuvre.console

import grails.plugins.springsecurity.Secured

import thepieuvre.executor.Command

@Secured(['ROLE_COMMAND_MANAGER'])
class CommandManagerController {

	def commandService

	private def withCommand(id='id', Closure c) {
		Command cmd = Command.get(params[id])
		if (cmd) {
			c.call cmd
		} else {
			forward controller: 'error', action: 'notFound'
		}
	}

	def index() {
		redirect action: 'list'
	}

	def list() {
		log.debug "Listing commands: $params"
		def commands 

		def max = (params.max)?: 50

		if (params) {
			commands = Command.createCriteria().list(buildRequest(params), max: max)
		} else {
			commands = Command.list(max: max)
		}

		[results: commands, filterParams: params, countedCommands: Command.count()]
	}

	private def buildRequest(params) {
		return {
			if (params.name) {
				and { ilike "name", "%${params.name}%"}
			}
			if (params.active) {
				and { eq "active", (params.active == 'on')?true:false }
			}
			if (params.sort) {
				and { order "$params.sort", "$params.order" }
			}
		}
	}

	def show(long id) {
		withCommand { cmd ->
			return ['cmd': cmd]
		}
	}

	def save(String name, String command, String help, String comment, String active, String sudo) {
		Command cmd = new Command(
			name: name,
			action: command,
			help: help,
			comment: comment,
			active: (active == 'on')?true:false,
			sudo: (sudo == 'on')?true:false
		)
		if (! cmd.save()) {
			render view: 'create', model: ['cmd': cmd]
		} else {
			redirect action: 'list'
		}
	}

	def create() {
		// Just the view
	}

	def update(long id, String name, String command, String help, String comment, String active, String sudo) {
		log.debug "Updating command: $params"
		withCommand { cmd ->
			cmd.name = name
			cmd.action = (command && command != '')?command:null
			cmd.help = help
			cmd.comment = (comment && comment != '')?comment:null
			cmd.active = (active && active == 'on')?true:false
			cmd.sudo = (sudo && sudo == 'on')?true:false
            cmd.validate()
			if (cmd.hasErrors()) {
				log.info "The  command contains some errors: ${cmd.errors}"
				render view: 'edit', model: ['cmd': cmd], params: params
				return true
			}
			log.debug "$cmd updated"
			redirect action: 'show', id: id
		}
	
	}

	def edit (long id) {
		withCommand {cmd ->
			return [
			'name': cmd.name,
			'command': cmd.action,
			'help': cmd.help,
			'comment': cmd.comment,
			'active': cmd.active,
			'sudo': cmd.sudo,
			'id': cmd.id
			]
		}
	}

	def delete(long id) {
		withCommand { cmd ->
			commandService.delete(cmd)
		}
		flash.message = "Command with id $id successfuly deleted"
		redirect action: 'list'
	}

	def resetForm = {
		redirect action: 'list'
	}

}