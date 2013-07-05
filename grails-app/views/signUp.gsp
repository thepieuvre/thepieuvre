<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="thepieuvre"/>
	</head>
	<body>
		<h1>Being a member at the Pieuvre</h1>

		<p class="lead">By signing up you are granted the right to subscribe to any feeds of your choice, to publish (privately or publicly) your own articles, to create your own feeds, and more...
		</p>

		<g:if test='${flash.message}'>
			<div class='alert alert-danger'>${flash.message}</div>
		</g:if>

		<g:form action="register" class="form-horizontal well">
        <fieldset>
          <legend>Sign Up</legend>
          <div class="control-group">
            <label class="control-label" for="username">Your Username</label>
            <div class="controls">
              <input type="text" class="input-xlarge" name="username">
              <p class="help-block">Your username will appear as author name in feeds and articles you publish.</p>
            </div>
          </div>
          <div class="control-group">
            <label class="control-label" for="email">Your Email</label>
            <div class="controls">
              <input type="text" class="input-xlarge" name="email">
              <p class="help-block">Your email is going to be verified, as this is how the Pieuvre communicate with you.</p>
            </div>
          </div>
          <div class="control-group">
            <label class="control-label" for="password">A Password</label>
            <div class="controls">
              <input type="password" class="input-xlarge" name="password">
              <p class="help-block">Well at least 8 characters long adn must look complex.</p>
            </div>
          </div>
         
          <div class="form-actions">
            <button type="submit" class="btn btn-success">Sign Up</button>
            <p class="muted"><small>By clicking Sign Up, you agree that the Pieuvre is not responsible for anything of what you do, the service is currently in beta thus your data might be lost, and you must follow the Law.</small></p>
          </div>
        </fieldset>
      </g:form>
	</body>
</html>