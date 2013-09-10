<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="thepieuvre"/>
	</head>
	<body>
    
  <g:render template="/web/searchBox" />

  <div class="row">
    <div class="col-lg-10">
      <ol class="breadcrumb" >
        <g:if test="${params.boardName}">
          <li><g:link controller="welcome" action="index" params="[board:'-1']" >Your Articles</g:link></li>
          <li><g:link controller="welcome" action="index" params="['board': params.board]" >${params.boardName}</g:link></li>
        </g:if>
        <g:else>
          <li><g:link controller="welcome" action="index">All Pieuvre</g:link></li>
        </g:else>
        <li><g:link controller="welcome" action="searchByFeed" params="[feed: article.feed.id]">${article.feed.title}</g:link></li>
        <g:if test="${article.author && article.author != 'null'}">
          <li><g:link controller="welcome" action="searchByAuthor" params="[author: article.author]">${article.author}</g:link></li>
        </g:if>
        <li class="active">${article.title.substring(0, (article.title.size() < 24)?article.title.size():24)}...</li>
      </ol>
      <h2>${article.title}</h2>
      <p class="lead">${article.published}</p>
      <p class="text-muted"><small><a href="${article.link}" target="_blank">Open the Source</a></small></p>
      <g:if test="${articleService.getKeyWordsShort(article)}">
      <hr>
      <h3>Keywords <small>Guessed by the Pieuvre</small></h3>
      <ul class="list-inline">
        <g:each in="${articleService.getKeyWordsShort(article)}" var="gram">
          <li><g:link controller="welcome" action="searchByKeyWords" params="[keyWords: gram]">${gram}</g:link></li>
        </g:each>
      </ul>
      </g:if>
      <hr>
      <div class="well">
        <g:if test="${article.contents.raw}">
          <hc:cleanHtml unsafe="${article.contents.raw}" whitelist="relaxed"/>
        </g:if>
        <g:else>
          <p>The content of this article is empty.</p>
        </g:else>
      </div>
      <g:if test="${article.contents.fullText}">
        <div class="panel-group" id="accordion_${article.id}">
          <div class="panel panel-default">
            <div class="panel-heading">
              <h4 class="panel-title">
                <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapse_${article.id}">
                  Read more? The Pieuvre extracted the content from the Source
                </a>
              </h4>
            </div>
            <div id="collapse_${article.id}" class="panel-collapse collapse">
              <div class="panel-body">
                <center><a href="#" class="thumbnail"><img data-src="holder.js/100%x180" src="${article.contents.mainImage}" /></a></center>
                <g:each in="${article.contents.fullText?.tokenize('\n')}" var="sentence">
                    <p>${sentence}</p>
                </g:each>
              </div>
            </div>
          </div>
        </div>
      </g:if>
      <g:set var="similarsList" value="${articleService.getSimilars(article)}" />
      <g:if test="${similarsList}">
      <hr>
      <h3>Similars</h3>
      <div class="list-group">
        <g:each in="${similarsList}" var="similars">
              <a href="#" class="list-group-item">
                <h4 class="list-group-item-heading">${similars.key?.title}  <small>@ ${similars.key?.feed?.title}</small></h4>
                <p class="list-group-item-text">TODO quick reader and explore / keywords</p>
              </a>
        </g:each>
      </div>
      </g:if>
    </div>

    <div class="col-lg-2">
      <ul class="nav nav-pills nav-stacked" data-spy="affix">
        <li><strong>Actions</strong></li>
        <li><a href="#">Add to Reader (TODO)</a></li>
        <li><a href="#">Follow this Feed (TODO)</a></li>
        <li><strong>Sharing</strong></li>
        <li><a href="#">Tweeter (TODO)</a></li>
      </ul>
    </div>
  </div>

	</body>
</html>
