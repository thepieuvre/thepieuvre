<div class="row">
  <nav class="navbar navbar-default" role="navigation">
 
    <div class="collapse navbar-collapse navbar-ex1-collapse">
      <g:form class="navbar-form navbar-left" role="form" action="executor" controller="welcome">
        <div class="form-group">
          <label class="sr-only" for="command">Type some words or :help</label>
          <input class="form-control input-sm" id="command" name="command" placeholder="Type some words...">
        </div>
        <button type="submit" class="btn btn-primary btn-sm">Search</button>
      </g:form>

       <ul class="nav navbar-nav navbar-right">
      <li class="${(params.board != '-1')?:'active'}"><g:link controller="welcome" action="index" params="[board:'-1']" >All Articles</g:link></li>
      <li class="${(params.board)?:'active'}"><g:link controller="welcome" action="index">All Pieuvre</g:link></li>
      <li class="dropdown">
        <a href="#" class="dropdown-toggle" data-toggle="dropdown">Your Boards <b class="caret"></b></a>
        <ul class="dropdown-menu">
          <li><a href="#">Action</a></li>
          <li><a href="#">Another action</a></li>
          <li><a href="#">Something else here</a></li>
          <li class="divider"></li>
          <li><a href="#">New Board...</a></li>
          <li><a href="#">Manage Boards</a></li>
        </ul>
      </li>
    </ul>
    </div>

 </nav>
</div>