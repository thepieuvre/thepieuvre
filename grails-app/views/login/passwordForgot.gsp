<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="thepieuvre"/>
		<g:set var="section" scope="request" value="about"/>
	</head>
	<body>
		<div class="row">
			<div class="col-lg-4 col-lg-offset-4">
				<h1>Forgot your password?</h1>
				<div class="well">
					<g:form name="forgotPasswordForm" controller="login" action="resetPassword" class="form-inline" role="form">
						<div class="form-group">
							<label class="sr-only" for="exampleInputEmail2">Email address</label>
    						<input type="email" class="form-control" name="email" placeholder="Enter your email" required>
						</div>
						<button type="submit" class="btn btn-primary">Send new password</button>
					</g:form>
				</div>
			</div>
		</div>
		<script type="text/javascript">
			$("#forgotPasswordForm").validate();
		</script>
	</body>
</html>
