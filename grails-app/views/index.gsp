<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="thepieuvre"/>
		<g:set var="section" scope="request" value="index"/>
	</head>
	<body>
		<div class="jumbotron" style="color: white; text-shadow:3px 3px #0D0D0D;">
        <h1>The Pieuvre <small style="color: white;">&nbsp;[pj&oelig;v&#640;]</small></h1>
        <p class="lead">Pieuvre is the french word for octopus.</p>
        <p class="lead">Join the Pieuvre now and the Pieuvre will start reading the Internet for you!</p>
        <p><a class="btn btn-large btn-success" data-toggle="modal" href="#signupModal">Sign Up Now</a></p>
      </div>

      <div class="row marketing">
        <div class="col-lg-6">
          <h4>Following News</h4>
		  <p>Internet is full of feeds and sites to follow. The Pieuvre follows the Internet for you.</p>

          <h4>Sorting News</h4>
          <p>Internet generates so much news that it is impossible for a human to follow all the desired information. The Pieuvre uses natural language processing for sorting news and saving times to humans.</p>

          <h4>Finding News</h4>
          <p>On Internet, humans need to know what they look for to find it. The Pieuvre finds what you are looking for before you think of it.</p>
        </div>

        <div class="col-lg-6">
          <h4>Reading News</h4>
          <p>Well, the Pieuvre loves reading news on Internet. As she does it all the time, she  helps you for faster and better reading.</p>

          <h4>Exploring News</h4>
          <p>Curious, the Pieuvre is. She is always eager to share her knowledge with you.</p>

          <h4>Sharing News</h4>
          <p>Obviously, Internet is all about sharing!</p>
        </div>
      </div>

    <!-- Sign Up Modal -->
    <div id="signupModal" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Sign Up Now</h4>
                </div>
            <div class="modal-body">
                <p>By signing up you are granted the right to use the Pieuvre service for your own personnal usage.
                </p>
                <g:form action="register" controller="welcome" class="form-horizontal well">
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
              <p class="help-block">Well at least 8 characters long and must look complex.</p>
            </div>
          </div>
         
          <div class="form-actions">
            <button type="submit" class="btn btn-success">Sign Up</button>
            <p class="muted"><small>By clicking Sign Up, you agree that the Pieuvre is not responsible for anything of what you do, the service is currently in beta thus your data might be lost, and you must follow the Law.</small></p>
          </div>
        </fieldset>
      </g:form>
            </div>
                
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->
	</body>
</html>