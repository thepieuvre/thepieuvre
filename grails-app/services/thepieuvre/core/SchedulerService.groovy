package thepieuvre.core

class SchedulerService {

	static transactional = true

	private static Timer scheduler = new Timer('pieuvre', false)

	def schedule(TimerTask task, long period) {
		scheduler.schedule(task, 31415, period)
	}

	def cancel() {
		scheduler.cancel()
	}
}