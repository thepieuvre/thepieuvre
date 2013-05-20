package thepieuvre.core

import org.apache.log4j.Logger

class FeederTask extends TimerTask {
	private static final Logger log = Logger.getLogger(FeederTask.class)

 	def grailsApplication

 	static long lock 

 	FeederTask(def grailsApplication) {
 		this.grailsApplication = grailsApplication
 	}

	@Override
	void run() {
		log.info "Running feeder task"
		long now = new Date().time
		boolean takingLock = false
		synchronized(lock) {
			if (lock == 0) {
				log.debug "Taking the lock"
				lock = now
				takingLock = true
			} else if ((lock + 360000) < now) {
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
				lock = 0
			}
		}
		log.info "Ending run feeder task"
	}
	
}
