<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="thepieuvre"/>
	</head>
	<body>

<div class="row">
	<div>
		<ul class="nav nav-tabs">
			<li ><g:link action="list">Members</g:link></li>
			<li class="active"><a href="#">Member's Details</a></li>
		</ul>
	</div>
</div>

<h2>Member: ${member.email} / ${member.username}</h2>	

<h3>Information</h3>
<table class="table table-striped">
	<tbody>
		<tr>
			<td><strong>Enabled</strong></td>
			<td>${member.enabled}</td>
		</tr>
		<tr>
			<td><strong>Account Expired</strong></td>
			<td>${member.accountExpired}</td>
		</tr>
		<tr>
			<td><strong>Account Locked</strong></td>
			<td>${member.accountLocked}</td>
		</tr>
		<tr>
			<td><strong>Password Expired</strong></td>
			<td>${member.passwordExpired}</td>
		</tr>
		<tr>
			<td><strong>Date Created</strong></td>
			<td>${member.dateCreated}</td>
		</tr>
		<tr>
			<td><strong>Last Updated</strong></td>
			<td>${member.lastUpdated}</td>
		</tr>
		<tr>
			<td><strong>Email Verified</strong></td>
			<td>${member.verified}</td>
		</tr>
	</tbody>
</table>

	</body>
</html>
