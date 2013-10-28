<!DOCTYPE html>
<g:set var="articleService" bean="articleService"/>

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
      <p class="text-muted"><small><a href="${article.link}" target="_blank"><span class="glyphicon glyphicon-new-window"></span> Open</a></small></p>
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

      <g:set var="sorts" value="${articleService.getSimilarTimeSorted(article)}" />
      <g:if test="${sorts}">
        <hr>
        <h3>Similars <small>found by the Pieuvre</small></h3>
        <g:each in="${sorts}" var="sorted">
          <h4>${sorted.key}</h4>
          <g:each in="${sorted.value}" var="similar">
            <g:link action="article" id="${similar.article.id}" class="list-group-item">
                <h4 class="list-group-item-heading">${similar.title()}  <small>@ ${similar.feedName()}</small></h4>
              </g:link>
          </g:each>
        </g:each>
      </g:if>
    </div>

    <div class="col-lg-2">
      <ul class="nav nav-pills nav-stacked" data-spy="affix">
        <li><strong>Actions</strong></li>
        <li><a href="#">Add to Reader (TODO)</a></li>
        <li><pieuvre:follow feed="${article.feed}"/></li>
        <li><strong>Sharing</strong></li>
        <li><a  href="https://twitter.com/share" class="twitter-share-button" data-url="${article.link}" data-text="${article.title}" data-hashtags="thepieuvre">Tweet</a></li>
      </ul>
    </div>
  </div>

	</body>
</html>
