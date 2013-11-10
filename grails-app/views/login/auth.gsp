<html>
<head>
	<meta name='layout' content='thepieuvre'/>
	<title><g:message code="springSecurity.login.title"/></title>
</head>

<body>
<div class="row">
	<g:if test='${flash.message}'>
		<div class='alert alert-danger'>${flash.message}</div>
	</g:if>
	
	<small><g:link action="signUp" controller="welcome">Not a member?</g:link></small>


	<form action='${postUrl}' method='POST' id='loginForm' class='cssform form-horizontal' autocomplete='off'>
		<fieldset>
			<div class="form-group">
				<label for='username' class="col-lg-5 control-label"><g:message code="springSecurity.login.username.label" />:</label>
				<div class="col-lg-4"><input type='text' class='text_' name='j_username' id='username'/><p></p></div>

			</div>
			<div class="form-group">
				<label for='password' class="col-lg-5 control-label"><g:message code="springSecurity.login.password.label"/>:</label>
				<div class="col-lg-4"><input type='password' class='text_' name='j_password' id='password'/><p></p></div>
			</div>
			<div class="form-group">
				<div class="col-lg-offset-5 col-lg-7">
				<input class="btn btn-primary" type='submit' id="submit" value='${message(code: "springSecurity.login.button")}'/><p></p>
			</div>

			</div>
		</fieldset>


		</form>

		<small><g:link action="passwordForgot" controller="login">Forgot your password?</g:link></small>
</div>
<script type='text/javascript'>
	<!--
	(function() {
		document.forms['loginForm'].elements['j_username'].focus();
	})();
	// -->
</script>
</body>
</html>
