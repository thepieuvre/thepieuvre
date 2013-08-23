<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="thepieuvre"/>
    <g:set var="section" scope="request" value="home"/>
	</head>
	<body>

<g:render template="/web/searchBox" />

<div class="row">
  <div class="span10"> 

            <g:if test="${cmd}">
          <div id="container">
             <p class="${(!exit)?'text-success':'text-error'}"><i class="icon-hand-right"></i>${cmd}</p>
<pre>
${(!exit)?result:msg}

${(!exit)?'':"Exit: ${exit}"}
</pre>
        </div>
      </g:if>
      <g:else>
        <g:if test='${flash.message}'>
          <div style= "margin-top: 20px;" class='alert alert-success'>${flash.message}</div>
        </g:if>
        </div>
      </div>

      <div class="row">

<div class="span10">
<p></p>
<ul class="nav nav-tabs">
  <g:if test="${boardName != 'The Pieuvre'}">
  <li class="dropdown active">
    <a class="dropdown-toggle"
       data-toggle="dropdown"
       href="#">
        ${boardName}
        <b class="caret"></b>
      </a>
    <ul class="dropdown-menu">
      <!-- links -->
      <li><a href="#follow" data-toggle="modal">Follow a feed</a></li>
      <li>Unfollow a feed</li>
       <g:if test="${boardName != 'Your Feeds'}">
        <li class="divider"></li>
        <li>Delete this board</li>
      </g:if>
    </ul>
  </li>
</g:if>
<g:else>
 <li class="dropdown active">
    <a href="#">
        ${boardName}
      </a>
  </li>
</g:else>
</ul>
  <div id="container">
    <g:if test="${! articles}">
    <h2>This board is empty. Please, add feeds by clicking on the caret.</h2>
    </g:if>
      <g:render template="/article/article" var="article" collection="${articles}" />
    </g:else>
  </div>
    <nav id="page-nav">
      <a href="${createLink(controller: 'welcome', action: 'index', params: [offset:25] )}"></a>
    </nav>
  </div>
  <div class="span2">
    <ul class="nav nav-list affix">
      <li class="nav-header">Boards</li>
      <li><g:link controller="welcome" action="index">The Pieuvre</g:link></li>
      <li><g:link controller="welcome" action="index" params="[board:'-1']" >Your Feeds</g:link></li>
      <li class="divider"></li>
      <g:each var="board" in="${boards}">
        <li><g:link controller="welcome" action="index" params="['board': board.id]" >${board.name}</g:link></li>
      </g:each>
      <li><a href="#newBoard" data-toggle="modal"><i class="icon-plus"></i> New Board...</a></li>
      <li class="divider"></li>
      <li><small>Sophia Antipolis - ${new java.text.SimpleDateFormat('MMMM yyyy').format(new Date())}</small></li>
    </ul>
  </div>
</div>

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
