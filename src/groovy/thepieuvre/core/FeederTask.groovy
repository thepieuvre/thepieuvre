package thepieuvre.core

import org.apache.log4j.Logger

class FeederTask extends TimerTask {
	private static final Logger log = Logger.getLogger(FeederTask.class)

 	def grailsApplication

 	FeederTask(def grailsApplication) {
 		this.grailsApplication = grailsApplication
 	}

	@Override
	void run() {
		log.info "Running feeder task"
		while(true) {
			grailsApplication.mainContext.feedService.updateFeeds()
			Thread.sleep(60000)
		}
		log.info "Ending run feeder task"
	}
	
}
