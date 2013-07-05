<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="thepieuvre"/>
	</head>
	<body>
	
<div class="row-fluid">
	<div>
		<ul class="nav nav-tabs">
			<li class="active"><g:link action="list">Members</g:link></li>
		</ul>
	</div>
</div>

<h2>Member List</h2>

<div class="row-fluid search" style="text-align: center;">
	<g:form name="memberFilter" action="list" method="get">
	<div class="span2">
		<label for="title">Email</label>
		<g:textField name="email" value="${filterParams.email}" class="span12" />
	</div>
	<div class="span2">
		<label for="title">Username</label>
		<g:textField name="username" value="${filterParams.username}" class="span12" />
	</div>
	<div class="span2">
		<label for="title">Max Results</label>
		<g:textField name="max" value="${(params.max)?:50}" class="span12" />
	</div>
	<div class="span2">
		<div class="go pull-right">
			<g:submitButton name="filter" value="Filter" class="btn btn-primary" />
			<g:actionSubmit action="resetForm" name="resetForm" value="Reset" class="btn btn-small" />
		</div>
	</div>
	</g:form>
</div>
<small>Number of members: ${results.size()} of ${countedMembers}</small>

<div class="row-fluid">
	<div class="label label-info">
		<g:if test="${flash.message}">
			<p>${flash.message}</p>
		</g:if>
	</div>

	<table class="table table-bordered table-striped">
		<thead>
			<tr>
				<g:sortableColumn property="email" params="${filterParams}" title="Email" />
				<g:sortableColumn property="username" params="${filterParams}" title="Username" />
				<g:sortableColumn property="dateCreated" params="${filterParams}" title="Since" />

			</tr>
		</thead>
		<tbody>
			<g:each in="${results}" status="i" var="member">
				<tr class="${(i % 2) == 0 ? 'odd': 'even'}">
					<td>
						<g:link action="show" id="${member.id}">${member.email}</g:link>
					</td>
					<td>${member.username}</td>
					<td>${member.dateCreated}</td>
				</tr>
			</g:each>
		</tbody>
	</table>

</div>

	</body>
</html>
