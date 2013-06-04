package thepieuvre.security


class User {

	transient springSecurityService

	String username
	String password
	boolean enabled
	boolean accountExpired
	boolean accountLocked
	boolean passwordExpired
	Date verified

	Date dateCreated
	Date lastUpdated 

	static constraints = {
		username blank: false, unique: true
		password blank: false
		verified nullable: true
	}

	static mapping = {
		password column: '`password`'
		table '`user`'
	}

	Set<Role> getAuthorities() {
		UserRole.findAllByUser(this).collect { it.role } as Set
	}

	def beforeInsert() {
		encodePassword()
	}

	def beforeUpdate() {
		if (isDirty('password')) {
			encodePassword()
		}
	}

	protected void encodePassword() {
		password = springSecurityService.encodePassword(password)
	}
}
