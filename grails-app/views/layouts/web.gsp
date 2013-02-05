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
            <a id="fire" href="${resource(dir:'/')}" style="display: none;"><i class="icon-fire icon-white"></i></a>
            <span class="label label-info">in Alpha</span>
                <sec:ifLoggedIn>

                <ul class="nav">
         					<li><a href="${createLink(controller: 'feedManager')}">Feeds</a></li>
                  <li><a href="${createLink(controller: 'articleManager')}">Articles</a></li>
         					<sec:ifAnyGranted roles="ROLE_ROOT">
         						<li><g:link controller="tools">Tools</g:link></li>
         					</sec:ifAnyGranted>
                </ul>
                  <ul class="nav pull-right">
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
  <script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-38233353-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

  </script>
	</body>
</html>
