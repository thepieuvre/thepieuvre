
import thepieuvre.executor.Command

class CommandBootStrap {

	def init = { servletContext ->
		println "Bootstraping commands..."

		Command help = new Command(
			name: 'help',
			action:
			'''{ def args ->
if (args) {				
	def r = ""
	args.each {
		r += "<em>${it.name}</em>\\t-- $it.help\\n"
	}
	return r
} else {
	exit = 1
	msg = "The command your are looking for help does not exist"
}
			}''',
			help: 'display help for all commands',
			sudo: false
		)

		help.save()

		Command echo = new Command(
			name: 'echo',
			action: '{ def args -> if (args) {args.join(" ")} else { "" }}',
			help: 'write arguments',
			sudo: false
		)

		echo.save()
		println "Commands boostraped."
	}

	def destroy = {

	}
}