<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="web"/>
	</head>
	<body>
 		<div class="row">
    		<div class="span12">
    			<g:form class="form-search" action="executor" controller="welcome">
	      			<input type="text" style="width:730px;" class="input-medium search-query" placeholder="Type some words or some commands..." name="command" value="${params.command}">
	      			<button type="submit" class="btn btn-primary">Execute</button>
	      			<div class="btn-group">
            			<a class="btn btn-primary" href="#">More</a>
            			<a class="btn btn-primary dropdown-toggle" data-toggle="dropdown" href="#"><span class="caret"></span></a>
            			<ul class="dropdown-menu">
			              <li><a href="${createLink(action: 'about')}">About</a></li>
			              <li><a href="${createLink(action: 'help')}">Help</a></li>
			              <li class="divider"></li>
			              <li><a href="${createLink(action: 'contact')}">Contact Us</a></li>
            			</ul>
          			</div>
	    		</g:form>
    		</div>
  		</div>

  	<div class="row">
  		<div class="span10">
  			<g:render template="/web/simpleArticle" var="article" collection="${articles}" />
  		</div>
  		<div class="span2">
  			<p><small>Feeds: ${tFeeds}</small></p>
  			<p><small>Articles: ${tArticles}</small></p>
  			<div class="well">
      			<p><strong>Last Hour</strong></p>
      			<p><strong>Last Day</strong></p>
            	<p><strong>Last 7 Days</strong></p>
  			</div>
  		</div>
  	</div>

	<div class="row">
    	<div class="span12">
  			<div class="well weel-small"><center><small>Continue...</small></center></div>
  		</div>
  	</div>
	</body>
</html>
