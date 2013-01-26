import grails.util.GrailsUtil
import grails.util.Environment

import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH


eventWebXmlStart = { filename ->

	def grailsMelodyPlugin = pluginManager.allPlugins.find {
		'grailsMelody'.equalsIgnoreCase(it.name)
	}

	println "Setting the web.xml filter-mapping priority of ${grailsMelodyPlugin}:monitoring to 1110"

	grailsMelodyPlugin.pluginClass.metaClass.getWebXmlFilterOrder() { ->
		def FilterManager = getClass().getClassLoader().loadClass('grails.plugin.webxml.FilterManager')
		[monitoring: FilterManager.GRAILS_WEB_REQUEST_POSITION + 110]
	}
}
