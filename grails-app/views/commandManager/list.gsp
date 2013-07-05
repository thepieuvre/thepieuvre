<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="thepieuvre"/>
	</head>
	<body>
	
<div class="row-fluid">
	<div>
		<ul class="nav nav-tabs">
			<li class="active"><g:link action="list">Commands</g:link></li>
			<li><g:link action="create">Add Command</g:link></li>
		</ul>
	</div>
</div>

<h2>Command List</h2>

<div class="row-fluid search" style="text-align: center;">
	<g:form name="feedFilter" action="list" method="get">
	<div class="span2">
		<label for="name">Name</label>
		<g:textField name="name" value="${filterParams.name}" class="span12" />
	</div>
	<div class="span2">
		<label for="max">Max Results</label>
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
<small>Number of commands: ${results.size()} of ${countedCommands}</small>

<div class="row-fluid">
	<div class="label label-info">
		<g:if test="${flash.message}">
			<p>${flash.message}</p>
		</g:if>
	</div>

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

</div>

	</body>
</html>
