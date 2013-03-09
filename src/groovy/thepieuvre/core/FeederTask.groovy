package thepieuvre.core

import org.apache.log4j.Logger

class FeederTask extends TimerTask {
	private static final Logger log = Logger.getLogger(FeederTask.class)

	def queuesService
 	def grailsApplication

 	FeederTask(def grailsApplication) {
 		this.grailsApplication = grailsApplication
 	}

	@Override
	void run() {
		log.info "Running feeder task"
		Feed.findAllByActive(true).each { feed ->
			log.debug "Adding $feed to the queue"
			grailsApplication.mainContext.queuesService.enqueue(feed)
		}
		log.info "Ending run feeder task"
	}
	
}
