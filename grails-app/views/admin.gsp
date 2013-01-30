<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
	</head>
	<body>
	<div class="row">
		<div class="span12">
			<ul>
				<li><a href="${createLink(controller: 'feedManager')}">Feed Manager</a></li>
				<li><a href="${createLink(controller: 'articleManager')}">Article Manager</a></li>
   				<sec:ifAnyGranted roles="ROLE_ROOT">
					<li><g:link controller="tools">Tools</g:link></li>
				</sec:ifAnyGranted>					
			</ul>
		</div>
	</div>
	</body>
</html>