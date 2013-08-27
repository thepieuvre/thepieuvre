<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="thepieuvre"/>
    	<g:set var="section" scope="request" value="admin"/>
	</head>
	<body>
	
<div>
	<ul class="nav nav-tabs">
		<li class="active"><g:link action="list">Commands</g:link></li>
		<li><g:link action="create">Add Command</g:link></li>
	</ul>
</div>

<h2>Command List</h2>

<div class="panel">
	<div class="row">
	<g:form class="form-inline" name="feedFilter" action="list" method="get">
	<div class="col-lg-4">
		<g:textField placeholder="Name" class="form-control" name="name" value="${filterParams.name}" />
	</div>
	<div class="col-lg-2">
		<g:textField  placeholder="Max Results" class="form-control" name="max" value="${(params.max)?:50}" />
	</div>
	<div class="col-lg-3">
		<label for="active">Active Only</label>
		<g:checkBox class="form-control" name="active" value="${(params.active == 'on')?true:false}" />
	</div>
	<div class="col-lg-3">
		<g:submitButton name="filter" value="Filter" class="btn btn-primary" />
		<g:actionSubmit action="resetForm" name="resetForm" value="Reset" class="btn btn-small" />
	</div>
	</g:form>
	</div>
</div>
<small>Number of commands: ${results.size()} of ${countedCommands}</small>

	
	<g:if test="${flash.message}">
		<div class="alert alert-info">
			<p>${flash.message}</p>
		</div>
	</g:if>

	<table class="table table-bordered table-striped">
		<thead>
			<tr>
				<g:sortableColumn property="name" params="${filterParams}" title="Name" />
				<g:sortableColumn property="help" params="${filterParams}" title="Help" />
				<g:sortableColumn property="dateCreated" params="${filterParams}" title="Created on" />
				<g:sortableColumn property="active" params="${filterParams}" title="Active" />
			</tr>
		</thead>
		<tbody>
			<g:each in="${results}" status="i" var="cmd">
				<tr class="${(i % 2) == 0 ? 'odd': 'even'}">
					<td>
						<g:link action="show" id="${cmd.id}">${cmd.name}</g:link>
					</td>
					<td>${cmd.help}</td>
					<td>${cmd.dateCreated}</td>
					<td>${cmd.active}</td>
				</tr>
			</g:each>
		</tbody>
	</table>

	</body>
</html>
