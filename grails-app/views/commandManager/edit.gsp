<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="thepieuvre"/>
    	<g:set var="section" scope="request" value="admin"/>
	</head>
	<body>

<div class="row">
	<div>
		<ul class="nav nav-tabs">
			<li ><g:link action="list">Command</g:link></li>
			<li><g:link action="create">Add Command</g:link></li>
			<li class="active"><a href="#">Edit Command</a></li>
		</ul>
	</div>
</div>

<h2>Edit Command: ${name}</h2>

<div class="row">
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
</div>

<div class="row">
	<g:form class="form-horizontal" action="update" id="${id}" method="post">
		<div class="form-group">
			<label for="name" class="col-lg-2 control-label">Name</label>
			<div class="col-lg-10">
				<input type="text" id="name" name="name" value="${name}" />
				<p></p>
			</div>
		</div>
		<div class="form-group">
			<label for="help" class="col-lg-2 control-label">Help</label>
			<div class="col-lg-10">
				<g:textArea name="help" value="${help}" rows="5" cols="40"/>
				<p></p>
			</div>
		</div>
		<div class="form-group">
			<label for="command" class="col-lg-2 control-label">Action</label>
			<div class="col-lg-10">
				<g:textArea name="command" value="${command}" rows="10" cols="40"/>
				<p></p>
			</div>
		</div>
		<div class="form-group">
			<label for="comment" class="col-lg-2 control-label">Comment</label>
			<div class="col-lg-10">
				<g:textArea name="comment" value="${comment}" rows="5" cols="40"/>
				<p></p>
			</div>
		</div>
		<div class="form-group">
			 <div class="col-lg-offset-2 col-lg-10">
			<div class="checkbox">
				<label>
				<input type="checkbox" name="active" value="${true}" checked="${(fieldValue(bean:cmd,field:'active'))?:'true'}">
					Is Active
				</label>
			</div>
			</div>
		</div>
		<div class="form-group">
			 <div class="col-lg-offset-2 col-lg-10">
			<div class="checkbox">
				<label>
				<input type="checkbox" name="sudo" value="${true}" checked="${(fieldValue(bean:cmd,field:'sudo'))?:'true'}">
					Is Sudo
				</label>
			</div>
			</div>
		</div>
		<div class="form-group">
			<div class="col-lg-offset-2 col-lg-10">
			<input type="submit" name="update" class="btn btn-primary" value="Save" id="update" />
				<p></p>
		</div>
		</div>
	</g:form>

</div>

	</body>
</html>
