<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="thepieuvre"/>
    <g:set var="section" scope="request" value="home"/>
	</head>
	<body>

<g:render template="/web/searchBox" />

<!-- Command output -->
<div class="row">
  <div class="col-lg-12"> 

            <g:if test="${cmd}">
             <p class="${(!exit)?'text-success':'text-danger'}">${cmd}</p>
<pre>
${(!exit)?result:msg}

${(!exit)?'':"Exit: ${exit}"}
</pre>
      </g:if>
      <g:else>
        <g:if test='${flash.message}'>
          <div  class='alert alert-success'>${flash.message}</div>
        </g:if>
  </div>
</div>
<!-- End Command output -->

<!-- Article Stream -->
<div class="row">
  <div class="col-lg-12">
    <ol class="breadcrumb">
      <li class="active">${boardName}</li>
    </ol>
  </div>
</div>
<div class="row">
  <div id="article-stream" class="col-lg-12">
    <g:if test="${! articles}">
      <p class="text-warning">This board is empty.</p>
    </g:if>
      <g:render template="/article/article" var="article" collection="${articles}" />
    </g:else>
    <nav id="page-nav">
      <a href="${createLink(controller: 'welcome', action: 'index', params: [offset:25] )}"></a>
    </nav>
  </div>
</div>
<!-- End Article Stream -->



 <!-- Infinite Scroll -->
    <script src="${resource(dir:'js',file:'jquery.infinitescroll.min.js')}"></script>
    <script type="text/javascript">
    $(function(){
    $('#article-stream').infinitescroll({
      navSelector  : "#page-nav",            
      nextSelector : "#page-nav a",    
      itemSelector : "#article",
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
