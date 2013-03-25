<div class="row">
<g:form class="form-search" action="executor" controller="welcome">
	<div class="span7">
		
  			<input type="text" style="width:95%;" class="input-medium search-query" placeholder="Type some words or some commands (:help)..." name="command" value="${params.command}">
      </div>
      <div class="span3">
  			<button type="submit" class="btn btn-primary">Execute</button>
  			<div class="btn-group">
      			<a class="btn btn-primary" href="#">More</a>
      			<a class="btn btn-primary dropdown-toggle" data-toggle="dropdown" href="#"><span class="caret"></span></a>
      			<ul class="dropdown-menu">
              <sec:ifNotLoggedIn>
             <!-- <li><a href="${createLink(action: 'signUp')}">Sign Up</a></li>-->
              </sec:ifNotLoggedIn>
              <li><a href="${createLink(action: 'about')}">About</a></li>
              <li><a href="${createLink(action: 'help')}">Help</a></li>
              <li class="divider"></li>
              <li><a href="${createLink(action: 'contact')}">Contact Us</a></li>
      			</ul>
    		</div>
	</div>
</g:form>
</div>