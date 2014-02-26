<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="thepieuvre"/>
    	<g:set var="section" scope="request" value="admin"/>
	</head>
	<body>

	<div>
		<ul class="nav nav-tabs">
			<li ><g:link action="list">Commands</g:link></li>
			<li class="active"><g:link action="create">Add Command</g:link></li>
		</ul>
	</div>


<div class="row">
<h2>New Command</h2>
</div>

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
	<form class="form-horizontal" action="save" method="post">
		<div class="form-group">
			<label for="name" class="col-lg-2 control-label">Name</label>
			<div class="col-lg-10">
				<input type="text" class="form-control" id="name" name="name" value="${fieldValue(bean:cmd,field:'name')}" />
				<p></p>
			</div>
		</div>
		<div class="form-group">
			<label for="help" class="col-lg-2 control-label">Help</label>
			<div class="col-lg-10">
				<g:textArea name="help" class="form-control" value="${fieldValue(bean:cmd,field:'help')}" rows="5" cols="40"/>
				<p></p>
			</div>
		</div>
		<div class="form-group">
			<label for="command" class="col-lg-2 control-label">Action</label>
			<div class="col-lg-10">
				<g:textArea name="command" class="form-control" value="${fieldValue(bean:cmd,field:'command')}" rows="10" cols="40"/>
				<p></p>
			</div>
		</div>
		<div class="form-group">
			<label for="comment" class="col-lg-2 control-label">Comment</label>
			<div class="col-lg-10">
				<g:textArea name="comment" class="form-control" value="${fieldValue(bean:cmd,field:'comment')}" rows="5" cols="40"/>
				<p></p>
			</div>
		</div>
		<div class="form-group">
			 <div class="col-lg-offset-2 col-lg-10">
			<div class="checkbox">
				<label>
				<input type="checkbox" name="active" value="on" ${(active)?'checked':''}>
					Is Active
				</label>
			</div>
			</div>
		</div>
		<div class="form-group">
			 <div class="col-lg-offset-2 col-lg-10">
			<div class="checkbox">
				<label>
				<input type="checkbox" name="sudo" value="on" ${(sudo)?'checked':''}>
					Is Sudo
				</label>
			</div>
			</div>
		</div>
		<div class="form-group">
			<div class="col-lg-offset-2 col-lg-10">
				<input type="submit" name="create" class="btn btn-primary" value="Add" id="create" />
				<p></p>
			</div>
		</div>
	</form>
	</div>
	</body>
</html>
