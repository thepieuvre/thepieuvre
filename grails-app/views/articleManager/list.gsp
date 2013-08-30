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
			<li class="active"><g:link action="list">Articles</g:link></li>
			<li><g:link action="tools">Tools</g:link></li>
		</ul>
	</div>
</div>

<h2>Article List</h2>

<div class="panel">
<div class="row search" style="text-align: center;">
	<g:form name="articleFilter" action="list" method="get">
	<div class="col-lg-2">
		<label for="title">Title</label>
		<g:textField name="title" value="${filterParams.title}" class="span12" />
	</div>
	<div class="col-lg-2">
		<label for="title">Link</label>
		<g:textField name="link" value="${filterParams.link}" class="span12" />
	</div>
	<div class="col-lg-2">
		<label for="title">Feed</label>
		<g:textField name="feed" value="${filterParams.feed}" class="span12" />
	</div>
	<div class="col-lg-2">
		<label for="title">Max Results</label>
		<g:textField name="max" value="${(params.max)?:50}" class="span12" />
	</div>
	<div class="col-lg-3">
		<div class="go pull-right">
			<g:submitButton name="filter" value="Filter" class="btn btn-primary" />
			<g:actionSubmit action="resetForm" name="resetForm" value="Reset" class="btn btn-small" />
		</div>
	</div>
	</g:form>
</div>
</div>
<small>Number of articles: ${results.size()} of ${countedArticles}</small>

		<g:if test="${flash.message}">
	<div class="alert alert-info">
			<p>${flash.message}</p>
	</div>
		</g:if>

	<table class="table table-bordered table-striped">
		<thead>
			<tr>
				<g:sortableColumn property="title" params="${filterParams}" title="Title" />
				<g:sortableColumn property="feed" params="${filterParams}" title="Feed" />
				<g:sortableColumn property="published" params="${filterParams}" title="Published on" />
			</tr>
		</thead>
		<tbody>
			<g:each in="${results}" status="i" var="article">
				<tr class="${(i % 2) == 0 ? 'odd': 'even'}">
					<td>
						<g:link action="show" id="${article.id}">${article.title}</g:link>
					</td>
					<td>${article.feed.title}</td>
					<td>${article.published}</td>
				</tr>
			</g:each>
		</tbody>
	</table>


	</body>
</html>
