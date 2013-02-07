<!DOCTYPE html>
<html>
	<head>
		<title>Grails Runtime Exception</title>
		<meta name="layout" content="web">
		<link rel="stylesheet" href="${resource(dir: 'css', file: 'errors.css')}" type="text/css">
	</head>
	<body>
		<g:renderException exception="${exception}" />

			 	<footer class="footer">
	 		<p><small>Developed in Sophia Antipolis, France - ${new java.text.SimpleDateFormat('MMMM yyyy').format(new Date())}<span class="pull-right"><a href="#">Back to top</a></span></small></p>
	    </footer>
	</body>
</html>
