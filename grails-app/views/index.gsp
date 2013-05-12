<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="web"/>
	</head>
	<body>

<g:render template="/web/searchBox" />

<div class="row">
  <div class="span10"> 

            <g:if test="${cmd}">
             <p class="${(!exit)?'text-success':'text-error'}"><i class="icon-hand-right"></i>${cmd}</p>
<pre>
${(!exit)?result:msg}

${(!exit)?'':"Exit: ${exit}"}
</pre>
      </g:if>
      <g:else>
        <g:if test='${flash.message}'>
          <div style= "margin-top: 20px;" class='alert alert-success'>${flash.message}</div>
        </g:if>

          <section id="container">
        <g:render template="/web/simpleArticle" var="article" collection="${articles}" />
      </section>
    </g:else>
    <nav id="page-nav">
      <a href="${createLink(controller: 'welcome', action: 'index', params: [offset:25] )}"></a>
    </nav>
  </div>
  <div class="span2">
     <ul class="nav nav-list affix">
      <li class="nav-header">The Pieuvre</li>
      <li>Feeds: ${tFeeds}</li>
      <li>Articles: ${tArticles}</li>
      <li class="divider"></li>
      <li><small>Sophia Antipolis - ${new java.text.SimpleDateFormat('MMMM yyyy').format(new Date())}</small></li>
    </ul>
        <!--
        <div class="well">
            <p><strong>Last Hour</strong></p>
            <p><strong>Last Day</strong></p>
              <p><strong>Last 7 Days</strong></p>
        </div>
        -->
  </div>
</div>

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
      itemSelector : ".article-box",
      debug        : false,
      animate: true ,
      loading: {
        img: 'images/spinner.gif',
        msgText: '<em>Loading more articles...</em>'
      },
      path : function(page) {
          return "${createLink(controller: 'welcome', action: 'index' )}"+'?offSet='+(25*page)+"&${params.collect {k,v-> "$k=$v"}.join('&')}"
      }              
    });
  });
    </script>
	</body>
</html>
