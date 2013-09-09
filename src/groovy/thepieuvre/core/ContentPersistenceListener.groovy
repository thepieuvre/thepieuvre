package thepieuvre.core

import org.apache.log4j.Logger

import org.grails.datastore.mapping.core.Datastore
import org.grails.datastore.mapping.engine.event.AbstractPersistenceEvent
import org.grails.datastore.mapping.engine.event.AbstractPersistenceEventListener
import org.grails.datastore.mapping.engine.event.EventType

import org.springframework.context.ApplicationEvent

class ContentPersistenceListener extends AbstractPersistenceEventListener {
	private static final Logger log = Logger.getLogger(ContentPersistenceListener.class)

	def queuesService

	public ContentPersistenceListener(final Datastore datastore, def grailsApplication) {
    	super(datastore)
    	queuesService = grailsApplication.mainContext.queuesService
	}

	@Override
	protected void onPersistenceEvent(final AbstractPersistenceEvent event) {
		if (event.eventType == EventType.PostInsert && event.entityObject instanceof Content) {
			log.info "Content inserted"
			queuesService.enqueue(event.entityObject)
		}
	}

	@Override
	public boolean supportsEventType(Class<? extends ApplicationEvent> eventType) {
    	return true
	}
}