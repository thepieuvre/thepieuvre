package thepieuvre.core

class FeederService {

	def transactional = true

	def notifyFeeder() {
		def scrollable = Feed.createCriteria().scroll { 
			'eq' ("active", true) 
		}

		try {
			while(scrollable.next()) {
				def feed = scrollable.get(0)
				def json = "{id: $feed.id, link: $feed.link, etag: $feed.eTag, modified: $feed.modified}"
				rabbitSend 'msgs', json
			}
		} catch(Exception e) {
			log.error "An error occurred while sending message to feeder", e
		} finally {
			if (scrollable != null) {
				scrollable.close()
			}
		}
	}
}