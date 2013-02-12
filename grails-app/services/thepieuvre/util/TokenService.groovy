package thepieuvre.util

import cr.co.arquetipos.crypto.Blowfish
import org.springframework.beans.factory.InitializingBean
import grails.converters.JSON

class TokenService implements InitializingBean {

	static transational = false

	def grailsApplication

	String secret

	void afterPropertiesSet() {
		def configSecret = grailsApplication.config.thepieuvre?.util?.secret
		secret = (configSecret)?:'Cléo'
	}

	def encrypt(Map map) {
		def data = map.encodeAsJSON()
		log.debug "Encrypting token: $data"
		return Blowfish.encrypt(data.getBytes('UTF-8'), secret).encodeAsBase64().encodeAsURL()
	}

	def decrypt(String token) {
		log.debug "Decrypting token: $token"
		String decrypted = new String(Blowfish.decrypt(token.decodeBase64(), secret), 'UTF-8')
		return JSON.parse(decrypted)
	}

}