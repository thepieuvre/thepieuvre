<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
	</head>
	<body>

<div class="row-fluid">
	<div>
		<ul class="nav nav-tabs">
			<li ><g:link action="list">Articles</g:link></li>
			<li class="active"><a href="#">Article's Details</a></li>
		</ul>
	</div>
</div>

<h2>Article: ${article.title}</h2>

<p>Feed: <g:link action="show" id="${article.feed.id}" controller="feedManager">${article.feed.title}</g:link></p>
	
<h3>Contents</h3>
<g:each var="content" in="${article.contents}">
	<h4>RAW</h4>
	<span>${content.raw}</span>
</g:each>

<h3>Information</h3>
<table class="table table-striped">
	<tbody>
		<tr>
			<td><strong>ID</strong></td>
			<td>${article.uid}</td>
		</tr>
		<tr>
			<td><strong>Link</strong></td>
			<td><a href="${article.link}">${article.link}</a></td>
		</tr>
		<tr>
			<td><strong>Published</strong></td>
			<td>${article.published}</td>
		</tr>
		<tr>
			<td><strong>Date Created</strong></td>
			<td>${article.dateCreated}</td>
		</tr>
	</tbody>
</table>

<div class="form-horizontal">
	<div class="form-actions">
		<g:link action="delete" id="${article.id}" class="btn btn-primary">Delete</g:link>
	</div>
</div>

	</body>
</html>
