import thepieuvre.executor.Command

class CommandBootStrap {

	def init = { servletContext ->
		println "Bootstraping commands..."

		if (! Command.findByName('help')) {
			Command help = new Command(
				name: 'help',
				action:
				'''{ def args ->
	if (args) {				
		def r = ""
		args.each {
			r += "<em>${it.name}</em>\\t\\t-- ${(it.sudo)?"<strong>Members Only</strong>":""} $it.help\\n"
		}
		return r
	} else {
		exit = 1
		msg = "Help for the command you are looking for does not exist"
	}
				}''',
				help: 'display help for all commands',
				sudo: false
			)

			help.save(failOnError: true)
		}

		if (! Command.findByName('echo')) {
			Command echo = new Command(
				name: 'echo',
				action: '{ def args -> if (args) {args.join(" ")} else { "" }}',
				help: 'write arguments',
				sudo: false
			)

			echo.save(failOnError: true)
		}

		if (! Command.findByName('follow')) {
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
				help: 'following the feeds, http links as arguments',
				sudo: true
			)
			follow.save(failOnError: true)
		}

		if (! Command.findByName('feeds')) {
			Command feeds = new Command(
				name: 'feeds',
				action: '''
	{ def args ->
		def res = "<p> id title - description"
		memberService.listFeeds(user).each { feed ->
			res += "<p>$feed.id $feed.title - $feed.description</p>\\n"
		}
		return res
	}
				''',
				help: 'listing all followed feeds',
				sudo: true
			)
			feeds.save(failOnError: true)
		}

		if (! Command.findByName('unfollow')) {
			Command unfollow = new Command(
				name: 'unfollow',
				action: '''
	{def args ->
		args.each {
			if(! memberService.removeFeed(user, it)) {
				exit = 500
				msg += "Cannot unfollow the feed $it (check the id) \\n"
			}
		}
		return (exit == 500)?"":"Your are now following $args"
	}
				''',
				help: 'unfollowing the feeds, http links as arguments',
				sudo: true
			)
			unfollow.save(failOnError: true)
		}

		println "Commands boostraped."
	}

	def destroy = {

	}
}
