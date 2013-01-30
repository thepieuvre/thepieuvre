<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
	</head>
	<body>

<div class="row-fluid">
	<div>
		<ul class="nav nav-tabs">
			<li ><g:link action="list">Feeds</g:link></li>
			<li><g:link action="create">Add Feed</g:link></li>
			<li class="active"><a href="#">Feed's Details</a></li>
		</ul>
	</div>
</div>

<h2>Feed: ${feed.title}</h2>
	
<p>Active: ${feed.active}</p>

<p>Global: ${feed.global}</p>		

<h3>Information</h3>
<table class="table table-striped">
	<tbody>
		<tr>
			<td><strong>Version</strong></td>
			<td>${feed.standard}</td>
		</tr>
		<tr>
			<td><strong>Link</strong></td>
			<td>${feed.link}</td>
		</tr>
		<tr>
			<td><strong>Description</strong></td>
			<td>${feed.description}</td>
		</tr>
		<tr>
			<td><strong>Language</strong></td>
			<td>${feed.language}</td>
		</tr>
		<tr>
			<td><strong>Updated</strong></td>
			<td>${feed.updated}</td>
		</tr>
	</tbody>
</table>

<h3>Comment</h3>

<p>${feed.comment}</p>

<h3>Life Cycle</h3>
<table class="table table-striped">
	<tbody>
		<tr>
			<td><strong>ETAG</strong></td>
			<td>${feed.eTag}</td>
		</tr>
		<tr>
			<td><strong>Modified on</strong></td>
			<td>${feed.modified}</td>
		</tr>
		<tr>
			<td><strong>Checked on</strong></td>
			<td>${feed.lastChecked}</td>
		</tr>
		<tr>
			<td><strong>Last Updated</strong></td>
			<td>${feed.lastUpdated}</td>
		</tr>
		<tr>
			<td><strong>Last HTTP Status</strong></td>
			<td>${feed.lastStatus}</td>
		</tr>
	</tbody>
</table>

<h3>Error</h3>
<p>${feed.lastError}</p>

<div class="form-horizontal">
	<div class="form-actions">
		<g:link action="edit" id="${feed.id}" class="btn btn-primary">Edit</g:link>
	</div>
</div>

	</body>
</html>
