<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
	</head>
	<body>
	
<div class="row-fluid">
	<div>
		<ul class="nav nav-tabs">
			<li class="active"><g:link action="list">Feeds</g:link></li>
			<li><g:link action="create">Add Feed</g:link></li>
		</ul>
	</div>
</div>

<h2>Feed List</h2>

<div class="row-fluid search" style="text-align: center;">
	<g:form name="feedFilter" action="list" method="get">
	<div class="span2">
		<label for="title">Title</label>
		<g:textField name="title" value="${filterParams.title}" class="span12" />
	</div>
	<div class="span2">
		<label for="title">Link</label>
		<g:textField name="link" value="${filterParams.link}" class="span12" />
	</div>
	<div class="span2">
		<label for="title">Max Results</label>
		<g:textField name="max" value="${(params.max)?:50}" class="span12" />
	</div>
	<div class="span2">
		<label for="active">Active Only</label>
		<g:checkBox name="active" value="${(params.active == 'on')?true:false}" />
	</div>
	<div class="span2">
		<div class="go pull-right">
			<g:submitButton name="filter" value="Filter" class="btn btn-primary" />
			<g:actionSubmit action="resetForm" name="resetForm" value="Reset" class="btn btn-small" />
		</div>
	</div>
	</g:form>
</div>
<small>Number of feeds: ${results.size()} of ${countedFeeds}</small>

<div class="row-fluid">
	<div class="label label-info">
		<g:if test="${flash.message}">
			<p>${flash.message}</p>
		</g:if>
	</div>

	<table class="table table-bordered table-striped">
		<thead>
			<tr>
				<g:sortableColumn property="title" params="${filterParams}" title="Title" />
				<g:sortableColumn property="link" params="${filterParams}" title="Link" />
				<g:sortableColumn property="description" params="${filterParams}" title="Description" />
				<g:sortableColumn property="updated" params="${filterParams}" title="Updated on" />
				<g:sortableColumn property="lastStatus" params="${filterParams}" title="Status" />
				<g:sortableColumn property="active" params="${filterParams}" title="Active" />
			</tr>
		</thead>
		<tbody>
			<g:each in="${results}" status="i" var="feed">
				<tr class="${(i % 2) == 0 ? 'odd': 'even'}">
					<td>
						<g:link action="show" id="${feed.id}">${feed.title}</g:link>
					</td>
					<td>
						<g:link action="show" id="${feed.id}">${feed.link}</g:link>
					</td>
					<td>${feed.description}</td>
					<td>${feed.updated}</td>
					<td>${feed.lastStatus}</td>
					<td>${feed.active}</td>
				</tr>
			</g:each>
		</tbody>
	</table>

</div>

	</body>
</html>
