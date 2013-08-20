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
			<li ><g:link action="list">Feeds</g:link></li>
			<li class="active"><g:link action="create">Add Feed</g:link></li>
		</ul>
	</div>
</div>

<h2>New Feed</h2>

<div class="row">
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
</div>
<div class="row">

	<form class="form-horizontal" action="save" method="post">
		<div class="form-group">
			<label for="link" class="col-lg-2 control-label">Link</label>
			<div class="col-lg-10">
				<input type="text" id="link" name="link" value="${fieldValue(bean:feed,field:'link')}" />

			<p></p>
			</div>
		</div>
		<div class="form-group">
			<label for="comment" class="col-lg-2 control-label">Comment</label>
			<div class="col-lg-10">
				<g:textArea name="comment" value="${fieldValue(bean:feed,field:'comment')}" rows="5" cols="40"/>

			<p></p>
			</div>
		</div>
		<div class="form-group">
			<label for="active" class="col-lg-2 control-label">Is Active</label>
			<div class="col-lg-offset-2 col-lg-10">
				<g:checkBox name="active" value="${true}" checked="${(fieldValue(bean:feed,field:'active'))?:'true'}" />
				<p></p>
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
