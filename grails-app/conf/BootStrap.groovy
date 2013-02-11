import grails.util.Environment


import thepieuvre.core.FeederTask
import thepieuvre.member.Member
import thepieuvre.security.Role
import thepieuvre.security.User
import thepieuvre.security.UserRole

class BootStrap {

    def schedulerService

    def grailsApplication

    def init = { servletContext ->
    	def roles = [
    		['ROLE_ROOT', 'The super administrator of the system'],
            ['ROLE_FEED_MANAGER', 'Manager of Feeds'],
            ['ROLE_FEED_API', 'API user for feed managing'],
            ['ROLE_MEMBER_MANAGER', 'Manager of Members'],
            ['ROLE_MEMBER', 'Member']
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
            def alexpass = (Environment.PRODUCTION == Environment.current ? '***REMOVED***' : 'alex')
            alexUser = new Member(email: 'alex@thepieuvre.com', username: 'alex', password: alexpass, enabled: 'true', canPasswordLogin: true)
            if (!alexUser.save()) {
                println alexUser.errors
            }
            
            UserRole.create(alexUser, Role.findByAuthority('ROLE_ROOT'), true)
            UserRole.create(alexUser, Role.findByAuthority('ROLE_MEMBER'), true)
        }
        
        new File(grailsApplication.config.thepieuvre.feeder.dir).eachFile { file ->
            file.delete()
        }

        schedulerService.schedule(new FeederTask(grailsApplication), 31415)

    }

    def destroy = {
        schedulerService.cancel()
    }
}
