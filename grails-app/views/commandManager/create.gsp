<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
	</head>
	<body>

<div class="row-fluid">
	<div>
		<ul class="nav nav-tabs">
			<li ><g:link action="list">Commands</g:link></li>
			<li class="active"><g:link action="create">Add Command</g:link></li>
		</ul>
	</div>
</div>

<h2>New Command</h2>

<div class="row-fluid">
	<g:if test="${flash.message}">
		<div class="alert alert-error">
			${flash.message}
		</div>
	</g:if>
	<g:else>
		<g:hasErrors bean="${cmd}">
			<div class="alert alert-error">
				<g:renderErrors bean="${cmd}" as="list" />
			</div>
		</g:hasErrors>
	</g:else>

	<form class="form-horizontal" action="save" method="post">
		<div class="control-group">
			<label for="name" class="control-label">Name</label>
			<div class="controls">
				<input type="text" id="name" name="name" value="${fieldValue(bean:cmd,field:'name')}" />
			</div>
		</div>
		<div class="control-group">
			<label for="help" class="control-label">Help</label>
			<div class="controls">
				<g:textArea name="help" value="${fieldValue(bean:cmd,field:'help')}" rows="5" cols="40"/>
			</div>
		</div>
		<div class="control-group">
			<label for="command" class="control-label">Action</label>
			<div class="controls">
				<g:textArea name="command" value="${fieldValue(bean:cmd,field:'command')}" rows="10" cols="40"/>
			</div>
		</div>
		<div class="control-group">
			<label for="comment" class="control-label">Comment</label>
			<div class="controls">
				<g:textArea name="comment" value="${fieldValue(bean:cmd,field:'comment')}" rows="5" cols="40"/>
			</div>
		</div>
		<div class="control-group">
			<label for="active" class="control-label">Is Active</label>
			<div class="controls">
				<g:checkBox name="active" value="${true}" checked="${(fieldValue(bean:cmd,field:'active'))?:'true'}" />
			</div>
		</div>
		<div class="control-group">
			<label for="sudo" class="control-label">Is Sudo</label>
			<div class="controls">
				<g:checkBox name="sudo" value="${true}" checked="${(fieldValue(bean:cmd,field:'sudo'))?:'true'}" />
			</div>
		</div>
		<div class="form-actions">
			<input type="submit" name="create" class="btn btn-primary" value="Add" id="create" />
		</div>
	</form>

</div>

	</body>
</html>
