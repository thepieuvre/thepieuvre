<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="web"/>
	</head>
	<body>
		<h1>Contact the Pieuvre</h1>
		<p>We would love to hear about what you think: comments, feedback, reviews, ...</p>
		<p>Please fill out the following form.</p>
		<g:form class="form-horizontal well" action="message">
			<legend>Contact us</legend>
			<fieldset>
				<div class="control-group">
					<label class="control-label" for="name">Your name</label>
					<div class="controls">
						<input type="text" class="input-xlarge" name="name" maxlength="255" />
						<p class="help-block">Please tell us your name.</p>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label" for="email">Your email</label>
					<div class="controls">
						<input type="text" class="input-xlarge" name="email" maxlength="255" />
						<p class="help-block">We will use it for replying.</p>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label" for="message">Your message</label>
					<div class="controls">
						<textarea cols="50" rows="10" type="textarea" class="input-xlarge" name="message" maxlength="255" ></textarea>
						<p class="help-block">Your message tot the Pieuvre.</p>
					</div>
				</div>
				<div class="form-actions">
					<button type="submit" class="btn btn-success">Send</button>
				</div>
			</fieldset>
		</g:form>
	</body>
</html>