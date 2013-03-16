<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="web"/>
	</head>
	<body>
 		<div class="row">
    		<div class="span10">
    			<g:form class="form-search" action="executor" controller="welcome">
	      			<input type="text" style="width:574px;" class="input-medium search-query" placeholder="Type some words or some commands (:help)..." name="command" value="${params.command}">
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
	    		</g:form>
    		</div>
  		</div>



  	<div class="row">
            <g:if test="${cmd}">
          <div id="container" class="span10">
             <p class="${(!exit)?'text-success':'text-error'}"><i class="icon-hand-right"></i>${cmd}</p>
<pre>
${(!exit)?result:msg}

${(!exit)?'':"Exit: ${exit}"}
</pre>
        </div>
      </g:if>
      <g:else>
  		<div id="container" class="span10">
        <g:if test='${flash.message}'>
          <div class='alert alert-success'>${flash.message}</div>
        </g:if>
  			<g:render template="/web/simpleArticle" bean="${article}" />
  		</div>
    </g:else>

  		<div class="span2">
  			<p><small>Feeds: ${tFeeds}</small></p>
  			<p><small>Articles: ${tArticles}</small></p>
        <!--
  			<div class="well">
      			<p><strong>Last Hour</strong></p>
      			<p><strong>Last Day</strong></p>
            	<p><strong>Last 7 Days</strong></p>
  			</div>
        -->
  		</div>

	</body>
</html>
