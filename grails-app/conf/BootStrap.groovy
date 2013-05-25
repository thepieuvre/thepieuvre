import grails.util.Environment

import thepieuvre.core.ArticleTask
import thepieuvre.core.FeederTask
import thepieuvre.core.FeedParser
import thepieuvre.member.Member
import thepieuvre.security.Role
import thepieuvre.security.User
import thepieuvre.security.UserRole

class BootStrap {

    def queuesService
    def schedulerService

    def grailsApplication

    def init = { servletContext ->
    	def roles = [
    		['ROLE_ROOT', 'The super administrator of the system'],
            ['ROLE_FEED_MANAGER', 'Manager of Feeds'],
            ['ROLE_FEED_API', 'API user for feed managing'],
            ['ROLE_MEMBER_MANAGER', 'Manager of Members'],
            ['ROLE_MEMBER', 'Member'],
            ['ROLE_COMMAND_MANAGER', 'Manager of Commands']
    	].each { name, description ->
    		def role = Role.findByAuthority(name)
    		if( ! role) {
    			role = new Role(authority: name, description: description)
    			role.save(failOnError: true, flush: true)
    		}
    	}

        // Alex is the super-administrator
        def alexUser = User.findByUsername('alex')
        if (!alexUser) {
            def alexpass = (Environment.PRODUCTION == Environment.current ? 'w=upc+6r' : 'alex')
            alexUser = new Member(
                email: 'alex@thepieuvre.com',
                username: 'alex',
                password: alexpass,
                enabled: 'true',
                canPasswordLogin: true,
                verified: new Date()
            )
            if (!alexUser.save()) {
                println alexUser.errors
            }
            
            UserRole.create(alexUser, Role.findByAuthority('ROLE_ROOT'), true)
            UserRole.create(alexUser, Role.findByAuthority('ROLE_MEMBER'), true)
        }

        queuesService.queues.each {k,v->
            queuesService.create(v)
        }

        schedulerService.schedule(new FeederTask(grailsApplication), 62830)

        schedulerService.startFeedParser()
        schedulerService.startArticleTask()

    }

    def destroy = {
        schedulerService.cancel()
    }
}
