package thepieuvre.exception

import org.springframework.validation.Errors

class PieuvreException extends RuntimeException {

	Errors errors

	PieuvreException(String msg) {
		super(msg)
	}

	PieuvreException(Exception e) {
		super(e)
	}

	PieuvreException(String msg, Throwable th) {
		super(msg, th)
	}

	PieuvreException(Errors errors) {
		super("The Pieuvre: $errors".toString())
		this.errors = errors
	}
}