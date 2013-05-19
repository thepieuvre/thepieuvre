package thepieuvre.core

import org.apache.log4j.Logger

class FeederTask extends TimerTask {
	private static final Logger log = Logger.getLogger(FeederTask.class)

 	def grailsApplication

 	static synchronized long lock 

 	FeederTask(def grailsApplication) {
 		this.grailsApplication = grailsApplication
 	}

	@Override
	void run() {
		log.info "Running feeder task"
		long now = new Date().time
		boolean takingLock = false
		if (! lock) {
			log.debug "Taking the lock"
			lock = now
			takingLock = true
		} else if ((lock + 600000) < now) {
			log.debug "Expired lock: taking the lock"
			lock = now
			takingLock = true
		} else {
			log.debug "Lock already took: nothing to do"
			takingLock = false
		}
		if (takingLock) {
			log.debug "Updating feeds"
			grailsApplication.mainContext.feedService.updateFeeds()
			lock = null
		}
		log.info "Ending run feeder task"
	}
	
}
