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
			<li><g:link action="create">Add Command</g:link></li>
			<li class="active"><a href="#">Command's Details</a></li>
		</ul>
	</div>

<h2>Name: ${cmd.name}</h2>
	
<p>Active: ${cmd.active}</p>

<p>Sudo: ${cmd.sudo}</p>

<p>Date Created: ${cmd.dateCreated}</p>

<h3>Help</h3>

<p>${cmd.help}</p>

<h3>Action</h3>
<pre>
${cmd.getAction()}	
</pre>

<h3>Comment</h3>

<p>${cmd.comment}</p>

<div class="panel">
	<g:link action="edit" id="${cmd.id}" class="btn btn-primary">Edit</g:link>
	<g:link action="delete" id="${cmd.id}" class="btn btn-link">Delete</g:link>
</div>

	</body>
</html>
