package thepieuvre.executor

class Command {

	String name

	String action

	Date dateCreated

	String help

	String comment

	boolean active = true

	boolean sudo = true

	static constraints = {
		name unique: true, blank: false
		action blank: false, maxSize: 1024
		help blank: false, nullable: true, maxSize: 1024
		comment nullable: true, blank: false, maxSize: 4096
	}
}