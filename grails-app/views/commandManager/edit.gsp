<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="thepieuvre"/>
	</head>
	<body>

<div class="row-fluid">
	<div>
		<ul class="nav nav-tabs">
			<li ><g:link action="list">Command</g:link></li>
			<li><g:link action="create">Add Command</g:link></li>
			<li class="active"><a href="#">Edit Command</a></li>
		</ul>
	</div>
</div>

<h2>Edit Command: ${name}</h2>

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

	<g:form class="form-horizontal" action="update" id="${id}" method="post">
		<div class="control-group">
			<label for="name" class="control-label">Name</label>
			<div class="controls">
				<input type="text" id="name" name="name" value="${name}" />
			</div>
		</div>
		<div class="control-group">
			<label for="help" class="control-label">Help</label>
			<div class="controls">
				<g:textArea name="help" value="${help}" rows="5" cols="40"/>
			</div>
		</div>
		<div class="control-group">
			<label for="command" class="control-label">Action</label>
			<div class="controls">
				<g:textArea name="command" value="${command}" rows="10" cols="40"/>
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
				<g:checkBox name="active" value="${true}" checked="${(active)?'true':'false'}" />
			</div>
		</div>
		<div class="control-group">
			<label for="sudo" class="control-label">Is Sudo</label>
			<div class="controls">
				<g:checkBox name="sudo" value="${true}" checked="${(sudo)?'true':'false'}" />
			</div>
		</div>
		<div class="form-actions">
			<input type="submit" name="update" class="btn btn-primary" value="Save" id="update" />
		</div>
	</g:form>

</div>

	</body>
</html>
