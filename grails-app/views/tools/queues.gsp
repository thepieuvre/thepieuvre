<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
	</head>
	<body>

<h2>Hermes: Queues Manager</h2>

	<g:if test='${flash.message}'>
		<div class='alert alert-info'>${flash.message}</div>
	</g:if>

	<table class="table table-bordered table-striped">
		<thead>
			<tr>
				<th>Name</th>
				<th>Length</th>
				<th>Actions</th>
			</tr>
		</thead>
		<tbody>
			<g:each in="${queues}" status="i" var="queue">
				<tr class="${(i % 2) == 0 ? 'odd': 'even'}">
					<td>${queue.value}</td>
					<td>${service.length(queue.value)}</td>
					<td>
						<g:link action="clear" params="[queue:queue.value]" class="btn btn-small btn-warning">Clear</g:link>
						<g:link action="destroy" params="[queue:queue.value]" class="btn btn-small btn-danger">Destroy</g:link>
						<g:link action="create" params="[queue:queue.value]" class="btn btn-small btn-success">Create</g:link>
					</td>
				</tr>
			</g:each>	
		</tbody>
	</table>

	</body>
</html>