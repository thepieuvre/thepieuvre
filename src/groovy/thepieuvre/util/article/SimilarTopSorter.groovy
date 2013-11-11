package thepieuvre.util.article

import org.apache.log4j.Logger

import thepieuvre.core.Similar

class SimilarTopSorter implements Sorter {
	private static final Logger log = Logger.getLogger(SimilarTopSorter.class)

	private Map similarsSorted = new LinkedHashMap(5)

	private Map links = [:]
	private Map uids = [:]

	private final List<Similar> similars

	SimilarTopSorter(List<Similar> similars) {
		this.similars = similars
	}

	public Map sorting() {
		similars.each { similar ->
			if (similarsSorted.size() > 4) {
				return // we got the top 5
			} else {
				if (! similarsSorted[similar.title()] && 
					! links.containsKey(similar.article.link) &&
					! uids.containsKey(similar.article.uid)) {
					similarsSorted[similar.title()] = similar
					links[similar.article.link] = similar
					uids[similar.article.uid] = similar
				}
			}
		}
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