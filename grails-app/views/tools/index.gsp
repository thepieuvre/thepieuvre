<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="thepieuvre"/>
    	<g:set var="section" scope="request" value="admin"/>
	</head>
	<body>

    <h2>Information</h2>

    <p>Version: ${grailsApplication.metadata['app.version']}</p>
    <p>Build on Commit: <g:render template="/svn"/></p>

<h2>Administration Tools</h2>

<ul>
	<li><g:link controller="console">Grails Console</g:link></li>
	<li><g:link controller="monitoring">Monitoring</g:link></li>
	<li><g:link controller="hermes">Hermes (Queues Manager)</g:link></li>
</ul>

	</body>
</html>