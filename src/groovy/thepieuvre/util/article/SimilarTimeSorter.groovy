package thepieuvre.util.article

import org.apache.log4j.Logger

import thepieuvre.core.Similar

public class SimilarTimeSorter implements Sorter {
	private static final Logger log = Logger.getLogger(SimilarTimeSorter.class)

	private static final String TODAY = 'Today'
	private static final String THIS_WEEK = 'This week'
	private static final String ELDERS = 'Elders'

	private Map similarsSorted
	private final List<Similar> similars
	private final Date today = new Date()

	SimilarTimeSorter(List<Similar> similars) {
		this.similars = similars
	}

	public Map sorting() {
		log.debug "Sorting..."
		similarsSorted = new LinkedHashMap(3)
		similarsSorted[TODAY] = []
		similarsSorted[THIS_WEEK] = []
		similarsSorted[ELDERS] = []

		similars.each { similar ->
			final Date dateCreated = similar.dateCreated()
			if (dateCreated > today - 1 ) {
				// today
				similarsSorted[TODAY] << similar
			} else if (dateCreated < today - 1 && dateCreated > today - 7 ) {
				// this week
				similarsSorted[THIS_WEEK] << similar
			} else {
				// slder
				similarsSorted[ELDERS] << similar
			}

		}

		similarsSorted[TODAY] = similarsSorted[TODAY].sort()
		similarsSorted[THIS_WEEK] = similarsSorted[THIS_WEEK].sort()
		similarsSorted[ELDERS] = similarsSorted[ELDERS].sort()

		log.debug "... sorted."
		return similarsSorted
	}

	public Map sorted() {
		if (similarsSorted) {
			return similarsSorted
		} else {
			return sorting()
		}
	}
}