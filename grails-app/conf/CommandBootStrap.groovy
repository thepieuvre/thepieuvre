
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

		help.save(failOnError: true)

		Command echo = new Command(
			name: 'echo',
			action: '{ def args -> if (args) {args.join(" ")} else { "" }}',
			help: 'write arguments',
			sudo: false
		)

		echo.save(failOnError: true)

		Command follow = new Command(
			name: 'follow',
			action: '''
{ def args ->
	args.each { link ->
		if(! memberService.addFeed(user, link)) {
			exit = 500
			msg += "Cannot follow the feed $link (check the URL) \\n"
		}
	}
	return (exit == 500)?"":"Your are now following $args"
}
			''',
			help: 'following the feeds, http links, passed as arguments',
			sudo: true
		)
		follow.save(failOnError: true)

		// TODO feeds feed
		// TODO unfollow feed

		println "Commands boostraped."
	}

	def destroy = {

	}
}