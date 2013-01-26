package thepieuvre.core

import java.util.concurrent.ArrayBlockingQueue
import java.util.concurrent.ThreadPoolExecutor
import java.util.concurrent.TimeUnit

import org.apache.log4j.Logger

import org.codehaus.groovy.grails.commons.ApplicationHolder

class FeederTask extends TimerTask {
	private static final Logger log = Logger.getLogger(FeederTask.class)

	private static workers = new ThreadPoolExecutor(3, 
		20, 31415, TimeUnit.MILLISECONDS,
		new ArrayBlockingQueue<Feeder>(11))

 	def grailsApplication

 	FeederTask(def grailsApplication) {
 		this.grailsApplication = grailsApplication
 	}

	@Override
	void run() {
		log.info "Running feeder task"
		Feed.findAllByActive(true).each { feed ->
			log.debug "Adding $feed to the pool"
			try {
				workers.execute(new Feeder(feed, grailsApplication))
			} catch (Exception e) {
				log.error e
			}
		}
	}
	
}

class Feeder implements Runnable {
	private static final Logger log = Logger.getLogger(Feeder.class)

	Feed feed

 	def conf = ApplicationHolder.application.config
 	def python = conf.thepieuvre.feeder.python
 	def cmd = conf.thepieuvre.feeder.cmd
 	def dir = conf.thepieuvre.feeder.dir

 	def grailsApplication


	Feeder(Feed feed, def grailsApplication) {
		this.feed = feed
		this.grailsApplication = grailsApplication
	}
	
	@Override
	void run() {
		def timestamp = System.currentTimeMillis()
		def errFile = "error_${feed.id}_${timestamp}"
		File error = new File(dir, "${errFile}.log")
		def outFile = "output_${feed.id}_${timestamp}"
		File output = new File(dir, "${outFile}.json")
		int exitValue = -1
		try {
			log.info "Calling python for $feed.id / $feed"
			new File(dir, outFile).withWriter { oWriter ->
				new File(dir,errFile).withWriter { eWriter ->
					def cmdLine = [python, cmd,"--id=$feed.id"]
					if (feed.eTag != 'null') {
						cmdLine << "--etag=$feed.eTag"
					}
					if (feed.modified != 'null') {
						cmdLine << "--modified=$feed.modified"
					}
					cmdLine = cmdLine << "$feed.link"
					def p = cmdLine.execute()
					p.consumeProcessOutput(oWriter, eWriter)
					p.waitForOrKill(31415)
					log.info "Python for $feed.id / $feed exited with ${p.exitValue()}"
					exitValue = p.exitValue()
				}
			}

			new File(dir,errFile).renameTo(error)
			new File(dir,outFile).renameTo(output)

			if (exitValue) {
				grailsApplication.mainContext.feedService.exitValue(feed.id, exitValue, error.getText())
			} else {
				grailsApplication.mainContext.feedService.update(feed, output)

			}

		} catch (Exception e) {
			log.error e
			grailsApplication.mainContext.feedService.exitValue(feed.id, exitValue, "${e.getMessage()}\n ${e.stackTraceLines.join("\n")}")
			output.delete()
		} finally {
			error.delete()
		}
	}

}
