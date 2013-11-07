<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="thepieuvre">
		<link rel="stylesheet" href="${resource(dir: 'css', file: 'errors.css')}" type="text/css">
	</head>
	<body>
		<g:renderException exception="${exception}" />
	</body>
</html>
