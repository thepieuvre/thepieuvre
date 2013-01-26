package thepieuvre.exception

import org.springframework.validation.Errors

class ApiException extends RuntimeException {

	Errors errors

	ApiException(String msg) {
		super(msg)
	}

	ApiException(Exception e) {
		super(e)
	}

	ApiException(String msg, Throwable th) {
		super(msg, th)
	}

	ApiException(Errors errors) {
		super("The Pieuvre: $errors".toString())
		this.errors = errors
	}

}