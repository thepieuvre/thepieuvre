package thepieuvre.core

class Feed {

	String title
	String link
	String moved // sometime it might target another feed's link
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

	static mapping = {
    	version false
  	}

	static constraints = {
		link url: true, nullable: false, blank: false, unique: true, maxSize: 1024
		moved url: true, nullable: true, blank: false, maxSize: 1024
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

	String getTitle() {
		if (! title || title == 'null') {
			return 'The Pieuvre is going to update this feed, soonly...'
		} else {
			return title
		}
	}

	String getDescription() {
		if (! description || description == 'null') {
			return '--'
		} else {
			return description
		}
	}

	String getLink() {
		if (moved) {
			return moved
		} else {
			return link
		}
	}
}