package thepieuvre.core

class SchedulerService {

	static transactional = true

	private static Timer scheduler = new Timer('pieuvre', false)

	def grailsApplication

	def schedule(TimerTask task, long period) {
		scheduler.schedule(task, 31415, period)
	}

	def cancel() {
		scheduler.cancel()
	}

	def startFeedParser() {
		new Thread(new FeedParser(grailsApplication), 'FeedParser').start()
	}

	def startArticleTask() {
		new Thread(new ArticleTask(grailsApplication), 'ArticleTask').start()
	}

	def startFeederTask() {
		new Thread(new FeederTask(grailsApplication), 'FeederTask').start()
	}
}