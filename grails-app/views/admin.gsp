<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="thepieuvre"/>
	</head>
	<body>
	<div class="row">
		<div class="span12">
			<ul>
   				<sec:ifAnyGranted roles="ROLE_FEED_MANAGER">
					<li><a href="${createLink(controller: 'feedManager')}">Feed Manager</a></li>
					<li><a href="${createLink(controller: 'articleManager')}">Article Manager</a></li>
				</sec:ifAnyGranted>		
   				<sec:ifAnyGranted roles="ROLE_MEMBER_MANAGER">
					<li><a href="${createLink(controller: 'memberManager')}">Member Manager</a></li>
				</sec:ifAnyGranted>		
				<sec:ifAnyGranted roles="ROLE_COMMAND_MANAGER">
					<li><a href="${createLink(controller: 'commandManager')}">Command Manager</a></li>
				</sec:ifAnyGranted>		
   				<sec:ifAnyGranted roles="ROLE_ROOT">
					<li><g:link controller="tools">Tools</g:link></li>
				</sec:ifAnyGranted>					
			</ul>
		</div>
	</div>
	</body>
</html>