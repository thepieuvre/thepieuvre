package thepieuvre.core

class Feed {

	String title
	String link
	String description
	String language	
	String updated

	String standard

	String eTag
	String modified

	Date lastChecked
	int lastStatus
	Date lastUpdated
	Date checkOn

	String comment
	boolean active = true

	String lastError

	FeedGlobalEnum global = FeedGlobalEnum.NOT_CHECKED

	static constraints = {
		link url: true, nullable: false, blank: false, unique: true
		comment nullable: true, blank: false, maxSize: 4096
		title nullable: true
		description nullable: true, maxSize: 4096
		language nullable: true
		updated nullable: true
		eTag nullable: true
		modified nullable: true
		lastChecked nullable: true
		standard nullable: true
		lastError nullable: true, maxSize: 4096
		checkOn nullable: true
	}

	String toString() {
		"$title @ $id"
	}
}