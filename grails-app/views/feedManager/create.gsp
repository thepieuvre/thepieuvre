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
			<li class="active"><g:link action="create">Add Feed</g:link></li>
		</ul>
	</div>
</div>

<h2>New Feed</h2>

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

	<form class="form-horizontal" action="save" method="post">
		<div class="control-group">
			<label for="link" class="control-label">Link</label>
			<div class="controls">
				<input type="text" id="link" name="link" value="${fieldValue(bean:feed,field:'link')}" />
			</div>
		</div>
		<div class="control-group">
			<label for="comment" class="control-label">Comment</label>
			<div class="controls">
				<g:textArea name="comment" value="${fieldValue(bean:feed,field:'comment')}" rows="5" cols="40"/>
			</div>
		</div>
		<div class="control-group">
			<label for="active" class="control-label">Is Active</label>
			<div class="controls">
				<g:checkBox name="active" value="${true}" checked="${(fieldValue(bean:feed,field:'active'))?:'true'}" />
			</div>
		</div>
		<div class="form-actions">
			<input type="submit" name="create" class="btn btn-primary" value="Add" id="create" />
		</div>
	</form>

</div>

	</body>
</html>
