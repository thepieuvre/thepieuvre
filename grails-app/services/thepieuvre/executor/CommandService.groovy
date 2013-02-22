package thepieuvre.executor

class CommandService {

	def transactional = true

	def memberService

	def springSecurityService

	def delete (Command cmd) {
		log.info "Deleting command $cmd"
		cmd.delete(flush: true)
	}

	private def tokenize(String input){
		def tokens = [:]
		int sep = input.indexOf(' ')
		tokens.name = (sep > 0)?input[0..sep-1]:input
		tokens.name = (!tokens.name.startsWith(':'))?:tokens.name[1..-1]
		tokens.args = [:]
		tokens.args.raw = (sep > 0)?input[sep+1..-1]:null
		tokens.args.tokens = (sep > 0)?tokens.args.raw.tokenize():null

		log.debug "Tokenize: $tokens"
		return tokens
	}

	private def findCmd(String name) {
		Command.findByName(name)
	}

	private def evaluate(Command cmd, def tokens) {
		if (cmd.sudo && ! springSecurityService.isLoggedIn()) {
			return [exit: 403, msg: 'This command is reserved to logged in users']
		}
		Binding binding = new Binding()
		binding.setVariable('exit', 0)
		binding.setVariable('msg', '')
		if (cmd.sudo) {
			binding.setVariable('user', springSecurityService.currentUser)
			binding.setVariable('memberService', memberService)
		}
		GroovyShell sh = new GroovyShell(binding)
		def closure = sh.evaluate(cmd.action)
		def res = closure(tokens.args.tokens)
		if (binding.getVariable('exit') != 0) {
			return [result: res, exit: binding.getVariable('exit'), msg: binding.getVariable('msg')]
		}
		return [result: res]
	}

	def execute(String input) {
		def tokens = tokenize(input)

		Command cmd = findCmd(tokens.name)

		if (! cmd) {
			return [exit:404, msg:'Command not found', 'cmd': "$tokens.name ${(tokens.args.raw)?:''}"]
		}

		log.debug "Command find for $tokens.name @$cmd.id"

		def result = [:]

		if (cmd.name == 'help'){
			// Special handling for the help command
			if (! tokens.args.tokens) {
				log.debug "Help of all commands"
				tokens.args.tokens = Command.getAll()
			} else {
				log.debug "Help for: ${tokens.args.tokens[0]}"
				tokens.args.tokens = Command.findByName(tokens.args.tokens[0])
			}
		}
		result = evaluate(cmd, tokens)

		return result + ['cmd': "$tokens.name ${(tokens.args.raw)?:''}"]
	}

}