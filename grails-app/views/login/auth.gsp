<html>
<head>
	<meta name='layout' content='main'/>
	<title><g:message code="springSecurity.login.title"/></title>
</head>

<body>
<div class="row-fluid">
	<g:if test='${flash.message}'>
		<div class='alert alert-danger'>${flash.message}</div>
	</g:if>
	
	<form action='${postUrl}' method='POST' id='loginForm' class='cssform form-horizontal' autocomplete='off'>
		<fieldset>
			<div class="control-group">
				<label for='username' class="control-label"><g:message code="springSecurity.login.username.label" />:</label>
				<div class="controls"><input type='text' class='text_' name='j_username' id='username'/></div>
			</div>
			<div class="control-group">
				<label for='password' class="control-label"><g:message code="springSecurity.login.password.label"/>:</label>
				<div class="controls"><input type='password' class='text_' name='j_password' id='password'/></div>
			</div>
			<div class="form-actions">
				<input class="btn btn-primary" type='submit' id="submit" value='${message(code: "springSecurity.login.button")}'/>
			</div>
		</fieldset>
		</form>
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
