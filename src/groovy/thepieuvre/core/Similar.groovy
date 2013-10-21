package thepieuvre.core

class Similar implements Comparable<Similar> {

	Article article
	Article similarOf

	long id
	long score

	Similar(long id, String score, Article similarOf) {
		this.id = id
		this.score = score as long
		this.similarOf = similarOf
		init(id)
	}

	private void init(long id) {
		article = Article.load(id)
	}

	String title() {
		article.title
	}

	String feedName() {
		article.feed.title
	}

	Date dateCreated() {
		article.dateCreated
	}

	void setId(long id) {
		init(id)
	}

	void setScore(long score) {
		// nothing to do
	}

	int compareTo(Similar o) {
		score.compareTo(o.score)
	}

}