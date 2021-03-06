<!DOCTYPE html>
<g:set var="springSecurityService" bean="springSecurityService"/>
<g:set var="memberService" bean="memberService"/>

<g:set var="member" value="${springSecurityService.currentUser}" />
<g:set var="boards" value="${springSecurityService.currentUser?.boards}" />

<html>
	<head>
		<meta name="layout" content="thepieuvre"/>
	</head>
	<body>
		<div class="row">
    		<div class="col-lg-10">
				<h1>Managing your Boards</h1>
			</div>
		</div>
		<hr>
		<div class="row">
			<div class="col-lg-10">
				<h2>Your Boards</h2>
				<g:if test='${flash.message}'>
          			<div  class='alert alert-success'>${flash.message}</div>
        		</g:if>
				<div class="row">
					<div class="col-lg-3">
						<div class="list-group">
							<g:link action="list" class="list-group-item ${(params.current)?'':'active'}">
    							<h4 class="list-group-item-heading">All Feeds</h4>
    							<p class="list-group-item-text"><span class="badge pull-right">${member.feeds.size()}</span> Feeds:</p>
  							</g:link>
							<g:each var="board" in="${boards}">
  								<g:link action="list" params="[current: board.id]" class="list-group-item ${(params.current == board.id as String)?'active':''}">
    								<h4 class="list-group-item-heading">${board.name}</h4>
    								<p class="list-group-item-text"><span class="badge pull-right">${board.feeds.size()}</span> Feeds:</p>
  								</g:link>
  							</g:each>
						</div>
						<h4>New Board...</h4>
				      	<g:form action="newBoard" controller="welcome" class="form-inline" role="form">
				        	<div class="form-group">
				            	<label for="name" class="sr-only">Board's Name</label>
				            	<input class="form-control" id="name" name="name" placeholder="Enter a name">
				          	</div>
				          	<button type="submit" class="btn btn-primary">Create</button>
					    </g:form>
					</div>
					<div class="col-lg-9">
						<h2>Board: ${board?board.name:'All Feeds'} <g:if test="${board}"><small><a href="#editModal" data-toggle="modal" data-target="#editModal"><span class="glyphicon glyphicon-pencil"></span></a></small></g:if></h2>
						<div class="btn-group">
							<a type="button" href="#followFeedModal" data-toggle="modal" class="btn btn-primary">Add Feed</a>
						</div>
						<g:if test="${board}">
							<div class="btn-group">
								<g:link action="delete" params="[id: board.id]" type="button" class="btn btn-warning">Delete Board</g:link>
							</div>
						</g:if>
						<hr>
						<h3>Feeds</h3>
						<table class="table table-striped table-hover">
							<thead>
								<tr>
									<g:sortableColumn property="title" params="${filterParams}" title="Title" />
									<g:sortableColumn property="link" params="${filterParams}" title="Link" />
									<g:sortableColumn property="description" params="${filterParams}" title="Description" />
									<g:sortableColumn property="updated" params="${filterParams}" title="Updated on" />
									<g:sortableColumn property="lastStatus" params="${filterParams}" title="Status" />
									<th>Actions</th>
								</tr>
							</thead>
							<tbody>
								<g:each in="${feeds}" status="i" var="feed">
									<tr class="${(i % 2) == 0 ? 'odd': 'even'}">
										<td>${feed.title}</td>
										<td>${feed.link}</td>
										<td>${feed.description}</td>
										<td>${feed.updated}</td>
										<td>${feed.lastStatus}</td>
										<td>

<g:if test="${board}">
<div class="btn-group">
  <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
    Move to <span class="caret"></span>
  </button>
  <ul class="dropdown-menu" role="menu">
    <g:render template="boards" model="['feed': feed, 'action': 'moveTo', 'current': board?.id]"/>
  </ul>
</div>
</g:if>

<div class="btn-group">
  <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
    Copy to <span class="caret"></span>
  </button>
  <ul class="dropdown-menu" role="menu">
    <g:render template="boards" model="['feed': feed, 'action': 'copyTo', 'current': board?.id]"/>
  </ul>
</div>
<div class="btn-group">
	<g:if test="${board}">
		<g:link action="remove" controller="board" class="btn btn-default" params="['feed': feed.id, 'current': board.id]">Remove</g:link>
	</g:if>
	<g:else>
		<g:link action="unfollow" controller="board" class="btn btn-default" params="['feed': feed.id]">Unfollow</g:link>
	</g:else>
</div>
										</td>
									</tr>
								</g:each>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>


  <div class="modal fade" id="followFeedModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <g:form action="follow" controller="welcome" role="form">
        <input type="hidden" name="board" id="board" value="${(board)?board.id:-1}">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h4 class="modal-title">Follow Feed...</h4>
          </div>
          <div class="modal-body">
            <div class="form-group">
              <label for="feed">Feed or Web page address</label>
              <input class="form-control" id="feed" name="feed" placeholder="The address">
            </div>
          </div>
          <div class="modal-footer">
            <button type="submit" class="btn btn-primary">Follow</button>
            <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
          </div>
        </g:form>
      </div> 
    </div>
  </div>

  <!-- Edit Modal -->
<div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="editModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
    <g:form action="edit" controller="board" role="form">
        <input type="hidden" name="board" id="board" value="${(board)?board.id:-1}">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="editModalLabel">Edit Board: ${board?.name}</h4>
      </div>
      <div class="modal-body">
  		<div class="form-group">
            <label for="name">Change name</label>
            <input class="form-control" id="name" name="name" placeholder="New board's name">
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="submit" class="btn btn-primary">Save changes</button>
      </div>
  </g:form>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

	</body>
</html>