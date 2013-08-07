<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="thepieuvre"/>
	</head>
	<body>

<div class="row">
	<div>
		<ul class="nav nav-tabs">
			<li ><g:link action="list">Feeds</g:link></li>
			<li><g:link action="create">Add Feed</g:link></li>
			<li class="active"><a href="#">Edit Feed</a></li>
		</ul>
	</div>
</div>

<h2>Edit Feed: ${title}</h2>

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

	<g:form class="form-horizontal" action="update" id="${id}" method="post">
		<div class="form-group">
			<label for="link" class="col-lg-2 control-label">Link</label>
			<div class="col-lg-10">
				<input type="text" id="link" name="link" value="${link}" />
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
			<label for="active" class="col-lg-2 control-label">Is Active</label>
			<div class="col-lg-10">
				<g:checkBox name="active" value="${active}" checked="${(active)?'true':'false'}" />
				<p></p>
			</div>
		</div>
		<div class="form-group">
			<label for="global" class="col-lg-2 control-label">Is Global</label>
			<div class="col-lg-2">
				<g:select name="global" from="${thepieuvre.core.FeedGlobalEnum}" value="${params.global}"/>
				<p></p>
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
