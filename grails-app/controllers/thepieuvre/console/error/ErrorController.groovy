package thepieuvre.console.error

import thepieuvre.exception.ApiException

import grails.converters.JSON

import java.text.SimpleDateFormat

class ErrorController {

	def grailsApplication

	def mailService
	def springSecurityService

	def internal = {
		def cause = getRootCause(request.exception)
		def requestUri = request.getAttribute('javax.servlet.error.request_uri')

		// Store the user because this method is called twice by error, then
		// the second time the user is null
		if (! request['user']) {
			request['user'] = springSecurityService.getPrincipal() 
		}

		int status = 500
		String message = 'The Pieuvre had an internal problem with your request. All our team is working on it ASAP.'
		if (cause instanceof ApiException) {
			status = 400
			message = (cause.errors)?cause.errors.allErrors[0]:cause.getMessage()
		}

		log.warn "Error: ${request['user']} - $requestUri - $status - $message - $params - ${request.getAttribute("javax.servlet.error.status_code")}: ${cause}", request.exception

		try {
			mailService.sendMail {
                    to grailsApplication.config.thepieuvre.mailalert.split(',').collect { it }
                    from "noreply@thepieuvre.com"
                    subject "Error The Pieurve  ${request['user']}"
                    body """
    Host: ${InetAddress.localHost.hostName}
    date ${new SimpleDateFormat("dd/MM/yyyy 'at' HH:mm:ss z").format(new Date())}
    error ${request.getAttribute("javax.servlet.error.status_code")}: ${cause}
    URI:  ${requestUri}
    USER: ${request['user']}
    Stack Trace :
${request.exception.stackTraceLines.join("\n")}
"""
                }
                } catch (Exception e) {
                	log.warn "Cannot send error by email", e
                }

		rendering(status, message, params)
		return true
	}

	def badRequest = {
		rendering(400, 'Sorry, your request cannot be understand by the Pieuvre', params)
		return true
	}

	def accessDenied = {
		rendering(403, 'Sorry, you don\'t access to this resource', params)
		return true
	}

	def notFound = {
		rendering(404, 'Sorry, the Pieuvre cannot find your requested resource', params)
		return true
	}
	
	private def htmlRendering(int status, String message) {
		render ('status': status, 
				view: '/error/view', 
				model: ['status': status, 'message': message]
		)
	}

	private def rendering(int status, String message, def params) {
		boolean formated = false
		withFormat {
			html {
				formated = true
				htmlRendering(status, message)
			}
			json {
				formated = true
				def json = [error: true, httpStatus: status, 'message': message]
				response.'status' = status
				render json as JSON
			}
		}

		if (! formated) {
			htmlRendering(status, message)
		}

		return true
	}

	private Throwable getRootCause(Throwable ex) {
		while(ex?.getCause() != null 
			&& ! ex.equals(ex?.getCause()) 
			&& ! (ex instanceof ApiException)) {
			log.debug "Root Cause of", ex
			ex = ex.getCause()
		}
		return ex
	}
}