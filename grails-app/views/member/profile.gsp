<!DOCTYPE html>

<g:set var="articleService" bean="springSecurityService"/>
<g:set var="user" value="${springSecurityService.currentUser}"/>

<html>
	<head>
		<meta name="layout" content="thepieuvre"/>
		<g:set var="section" scope="request" value="profile"/>
	</head>
	<body>
		<div class="row">
			<div class="col-lg-6 col-lg-offset-3">
				<g:if test='${flash.message}'>
          			<div  class='alert alert-success'>${flash.message}</div>
        		</g:if>
				<h1><sec:loggedInUserInfo field="username"/>'s Profile</h1>
				<dl class="dl-horizontal">
  					<dt>Username</dt>
  					<dd><sec:username/></dd>
  					<dt>Email</dt>
  					<dd>${user.email}</dd>
  					<dt>Member since</dt>
  					<dd>${user.dateCreated}</dd>
				</dl>
				<hr>
				<h3>Stats</h3>
					<ul>
						<li>Number of Boards: ${user.boards.size()}</li>
						<li>Number of Feeds followed: ${user.feeds.size()}</li>
					</ul>
				<hr>
				<div class="alert alert-warning">
					<h3><span class="glyphicon glyphicon-warning-sign"></span>This is a danger zone: profile modification</h3>
				</div>

				<!-- Begin change password -->
				<div class="panel-group" id="accordion">
				  <div class="panel panel-info">
				    <div class="panel-heading">
				      <h4 class="panel-title">
				        <a data-toggle="collapse" data-parent="#accordion" href="#collapsePassword">
				          Change your Password
				        </a>
				      </h4>
				    </div>
				    <div id="collapsePassword" class="panel-collapse collapse">
				      <div class="panel-body">
				        <g:form name="changePassword" action="changePassword" class="form-horizontal" role="form">
				        	<input hidden="true" name="userId" value="${user.id}">
				        	<div class="form-group">
    							<label for="cPassword" class="col-sm-2 control-label">Current Password</label>
    							<div class="col-sm-10">
      								<input type="password" class="form-control" name="cPassword" placeholder="Your current Password" required>
    							</div>
  							</div>
				        	<div class="form-group">
    							<label for="password" class="col-sm-2 control-label">New Password</label>
    							<div class="col-sm-10">
      								<input type="password" class="form-control" name="password" placeholder="Your new Password" required>
    							</div>
  							</div>
  							<div class="alert alert-info">
  								<p>After validation, you will have to use your new password to log in.</p>
  							</div>
  							<div class="form-group">
    							<div class="col-sm-offset-2 col-sm-10">
      								<button type="submit" class="btn btn-info">Change it</button>
    							</div>
  							</div>
				    	</g:form>
				      </div>
				    </div>
				  </div>
				</div>
				<script type="text/javascript">
					$("#changePassword").validate();
				</script>
				<!-- End change password -->
				<p></p>
				<!-- Begin change email -->
				<div class="panel-group" id="accordion">
				  <div class="panel panel-warning">
				    <div class="panel-heading">
				      <h4 class="panel-title">
				        <a data-toggle="collapse" data-parent="#accordion" href="#collapseEmail">
				          Change your Email
				        </a>
				      </h4>
				    </div>
				    <div id="collapseEmail" class="panel-collapse collapse">
				      <div class="panel-body">
				        <g:form name="changeEmail" action="changeEmail" class="form-horizontal" role="form">
				        	<input hidden="true" id="userId" name="userId" value="${user.id}">
				        	<div class="form-group">
    							<label for="email" class="col-sm-2 control-label">Email</label>
    							<div class="col-sm-10">
      								<input type="email" class="form-control" id="email" name="email" placeholder="Your new Email" required>
    							</div>
  							</div>
  							<div class="alert alert-warning">
  								<p>After validation, we will use your new email.</p>
  							</div>
  							<div class="form-group">
    							<div class="col-sm-offset-2 col-sm-10">
      								<button type="submit" class="btn btn-warning">Change it</button>
    							</div>
  							</div>
				    	</g:form>
				      </div>
				    </div>
				  </div>
				</div>
				<script type="text/javascript">
					$("#changeEmail").validate();
				</script>
				<!-- End change email -->
				<p></p>
				<!-- Begin change username -->
				<div class="panel-group" id="accordion">
				  <div class="panel panel-danger">
				    <div class="panel-heading">
				      <h4 class="panel-title">
				        <a data-toggle="collapse" data-parent="#accordion" href="#collapseUsername">
				          Change your Username
				        </a>
				      </h4>
				    </div>
				    <div id="collapseUsername" class="panel-collapse collapse">
				      <div class="panel-body">
				        <g:form name="changeUsername" action="changeUsername" class="form-horizontal" role="form">
				        	<input hidden="true" name="userId" value="${user.id}">
				        	<div class="form-group">
    							<label for="username" class="col-sm-2 control-label">Username</label>
    							<div class="col-sm-10">
      								<input type="text" class="form-control" name="username" placeholder="Your new Username" required>
    							</div>
  							</div>
  							<div class="alert alert-danger">
  								<p>After validation, you will have to use your new username to log in.</p>
  								<p>Your previous username, <sec:username/>, will be available to be
  								used by someone else.</p>
  							</div>
  							<div class="form-group">
    							<div class="col-sm-offset-2 col-sm-10">
      								<button type="submit" class="btn btn-danger">Change it</button>
    							</div>
  							</div>
				    	</g:form>
				      </div>
				    </div>
				  </div>
				</div>
				<script type="text/javascript">
					$("#changeUsername").validate();
				</script>
				<!-- End change username -->
				<p></p>

			</div>
		</div>
	</body>
</html>