<g:set var="springSecurityService" bean="springSecurityService"/>
<g:set var="memberService" bean="memberService"/>

<g:set var="boards" value="${springSecurityService.currentUser?.boards}" />

<div class="row">
  <div class="col-lg-12">
    <nav class="sticky navbar navbar-default navbar-fixed-100" role="navigation">
   
      <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-search-collapse">
              <span class="sr-only">Toggle navigation</span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
            </button>
      </div>

      <div class="collapse navbar-collapse navbar-search-collapse">
        <g:form class="navbar-form navbar-left" role="form" action="executor" controller="welcome">
          <div class="form-group">
            <label class="sr-only" for="command">Type some words or :help</label>
            <input class="form-control input-sm" id="command" name="command" placeholder="Type some words..." value="${(params.command)?:''}">
          </div>
          <button type="submit" class="btn btn-primary btn-sm">Search</button>
        </g:form>

        <g:if test="${params.board != '-2'}">
          <div class="navbar-form navbar-right">
             <div class="btn-group">
              <a type="button" href="#followFeedModal" data-toggle="modal"  class="btn btn-sm btn-primary">Follow Feed</a>
              <button type="button" class="btn btn-sm btn-primary dropdown-toggle" data-toggle="dropdown">
                <span class="caret"></span>
                <span class="sr-only">Toggle Dropdown</span>
              </button>
              <ul class="dropdown-menu" role="menu">
                <li role="presentation" class="dropdown-header">Stream's Feeds</li>
                <g:each var="feed" in="${memberService.getFeeds(springSecurityService.currentUser, params.board)}">
                  <li><g:link controller="welcome" action="searchByFeed" params="[feed: feed.id]">${feed.title}</g:link></li>
                </g:each>
              </ul>
            </div>
          </div>
        </g:if>

         <ul class="nav navbar-nav navbar-right">
          <g:set var="activated" value="${(params.board == '-1') || (params.board == '-2') ||(! params.board)}" />
        <li class="${(params.board != '-1')?:'active'}"><g:link controller="welcome" action="index" params="[board:'-1']" >Your Articles</g:link></li>
        <li class="${(params.board != '-2')?:'active'}"><g:link controller="welcome" action="index" params="[board: '-2']">All Pieuvre</g:link></li>
        <li class="dropdown ${(! activated)?'active':''}">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown">${(! activated)?boardName:'Your Boards'} <b class="caret"></b></a>
          <ul class="dropdown-menu">
            <g:each var="board" in="${boards}">
              <li><g:link controller="welcome" action="index" params="['board': board.id]" >${board.name}</g:link></li>
            </g:each>
            <li class="divider"></li>
            <li><a  href="#newBoardModal" data-toggle="modal">New Board...</a></li>
            <li><g:link controller="board" action="list">Manage Boards</g:link></li>
          </ul>
        </li>
        <li><a href="#"></a></li>
       <!--  <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown">Your Reader <b class="caret"></b></a>
          <ul class="dropdown-menu">
            <li><a href="#">Action</a></li>
          </ul>
        </li> -->
      </ul>
      </div>

    </nav>
  </div>
</div>

<!-- Modal New Board -->
<div class="modal fade" id="newBoardModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <g:form action="newBoard" role="form">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
          <h4 class="modal-title">New Board...</h4>
        </div>
        <div class="modal-body">
          <div class="form-group">
            <label for="name">Board's Name</label>
            <input class="form-control" id="name" name="name" placeholder="Enter a name">
          </div>
        </div>
        <div class="modal-footer">
          <button type="submit" class="btn btn-primary">Create</button>
          <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
        </div>
      </g:form>
    </div> 
  </div>
</div>

<!-- Modal Follow Feed -->
<g:if test="${params.board}">
  <div class="modal fade" id="followFeedModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <g:form action="follow" role="form">
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
</g:if>