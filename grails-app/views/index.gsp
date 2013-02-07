<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="web"/>
	</head>
	<body>
 		<div class="row">
    		<div class="span10">
    			<g:form class="form-search" action="executor" controller="welcome">
	      			<input type="text" style="width:574px;" class="input-medium search-query" placeholder="Type some words or some commands..." name="command" value="${params.command}">
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
  		<div id="container" class="span10">
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

      <nav id="page-nav">
       <a href="${createLink(controller: 'welcome', action: 'scroll', params: [offset:25] )}"></a>
      </nav>

    <!-- Checking for new articles -->
      <script type="text/javascript">
        $('.alert_articles').hide()
        function checkNewArticleLoop(newTArticles) {
          var tArticles = parseInt(${tArticles});
            this.timer = setTimeout('checkNewArticle()', 31415);
            if (tArticles < newTArticles) {
              clearTimeout(this.timer)
              delete this.timer
              $('#fire').show('slow')
            }
          }

        function checkNewArticle() {
          $.ajax({
              type: "GET",
              url: "${createLink(controller: 'welcome', action:'totalArticles', absolute:'true')}",
              success: function(result) {checkNewArticleLoop(parseInt(result))  }
          });
        }
        $(window).load(checkNewArticleLoop(parseInt(${tArticles})));
    </script>
    <!-- Infinite Scroll -->
    <script src="${resource(dir:'js',file:'jquery.infinitescroll.min.js')}"></script>
    <script type="text/javascript">
    $(function(){
    $('#container').infinitescroll({
      navSelector  : "#page-nav",            
      nextSelector : "#page-nav a",    
      itemSelector : ".article",
      debug        : true,
      animate: true ,
      path : function(page) {
          return "${createLink(controller: 'welcome', action: 'scroll' )}"+'?offSet='+(25*page)
      }              
    });
  });
    </script>
	</body>
</html>
