<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="thepieuvre"/>
	</head>
	<body>

<div class="row-fluid">
	<div>
		<ul class="nav nav-tabs">
			<li ><g:link action="list">Feeds</g:link></li>
			<li><g:link action="create">Add Feed</g:link></li>
			<li class="active"><a href="#">Edit Feed</a></li>
		</ul>
	</div>
</div>

<h2>Edit Feed: ${title}</h2>

<div class="row-fluid">
	<g:if test="${flash.message}">
		<div class="alert alert-error">
			${flash.message}
		</div>
	</g:if>
	<g:else>
		<g:hasErrors bean="${feed}">
			<div class="alert alert-error">
				<g:renderErrors bean="${feed}" as="list" />
			</div>
		</g:hasErrors>
	</g:else>

	<g:form class="form-horizontal" action="update" id="${id}" method="post">
		<div class="control-group">
			<label for="link" class="control-label">Link</label>
			<div class="controls">
				<input type="text" id="link" name="link" value="${link}" />
			</div>
		</div>
		<div class="control-group">
			<label for="comment" class="control-label">Comment</label>
			<div class="controls">
				<g:textArea name="comment" value="${comment}" rows="5" cols="40"/>
			</div>
		</div>
		<div class="control-group">
			<label for="active" class="control-label">Is Active</label>
			<div class="controls">
				<g:checkBox name="active" value="${active}" checked="${(active)?'true':'false'}" />
			</div>
		</div>
		<div class="control-group">
			<label for="global" class="control-label">Is Global</label>
			<div class="controls">
				<g:select name="global" class="span2" from="${thepieuvre.core.FeedGlobalEnum}" value="${params.global}"/>
			</div>
		</div>
		<div class="form-actions">
			<input type="submit" name="update" class="btn btn-primary" value="Save" id="update" />
		</div>
	</g:form>

</div>

	</body>
</html>
