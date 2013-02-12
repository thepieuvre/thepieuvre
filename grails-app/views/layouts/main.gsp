<!DOCTYPE html>
<html lang="en">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><g:layoutTitle default="The Pieuvre" /></title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<r:require modules="custom-bootstrap"/>
		<g:layoutHead/>
		<r:layoutResources />
		<!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
    	<!--[if lt IE 9]>
      	<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    	<![endif]-->

	</head>
	<body>
	<div class="navbar navbar-fixed-top">
   		<div class="navbar-inner">
     		<div class="container">
       			<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
         			<span class="icon-bar"></span>
         			<span class="icon-bar"></span>
         			<span class="icon-bar"></span>
       			</a>
       			<a class="brand" href="${resource(dir:'/')}">The Pieuvre</a>
                <sec:ifLoggedIn>

                <ul class="nav">
                  <sec:ifAnyGranted roles="ROLE_FEED_MANAGER">
                    <li><a href="${createLink(controller: 'feedManager')}">Feed Manager</a></li>
                    <li><a href="${createLink(controller: 'articleManager')}">Article Manager</a></li>
                  </sec:ifAnyGranted>   
                  <sec:ifAnyGranted roles="ROLE_MEMBER_MANAGER">
                    <li><a href="${createLink(controller: 'memberManager')}">Member Manager</a></li>
                  </sec:ifAnyGranted>   
         					<sec:ifAnyGranted roles="ROLE_ROOT">
         						<li><g:link controller="tools">Tools</g:link></li>
         					</sec:ifAnyGranted>
                </ul>
                  <ul class="nav pull-right">
                  <li><a href="#"><sec:loggedInUserInfo field="username"/></a></li>
                  <li><g:link controller="logout">Logout</g:link></li>
                </ul>
              </sec:ifLoggedIn>
     		</div>
   		</div>
 	</div>
<h1 style="color: white;">By Alexandre di Costanzo</h1>
 	<div class="container">
 		
		<g:layoutBody/>

	 	<footer class="footer">
	 		<p><small>Developed in Sophia Antipolis, France - ${new java.text.SimpleDateFormat('MMMM yyyy').format(new Date())}<span class="pull-right"><a href="#">Back to top</a></span></small></p>
	    </footer>
 	</div>
	<r:layoutResources />
	</body>
</html>
