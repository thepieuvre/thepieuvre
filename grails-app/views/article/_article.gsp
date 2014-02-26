<g:set var="articleService" bean="articleService"/>

<div id="article">
<div class="panel panel-default">
    <div class="panel-heading">
        <a data-toggle="modal" href="#articleModal_${article.id}"><strong>${article.title}</strong></a><small class="text-muted"> @ ${article.feed.title}</small>                    
    </div>
    <div class="panel-body">
        <p class="text-muted">On ${article.published}</p>
         <div class="media">
                <g:if test="${article.contents.mainImage}">
                    <g:link class="pull-left" controller="article" action="modal" id="${article.id}" data-toggle="modal" data-target="#modal">
                        <img class="media-object" data-src="holder.js/64x64" src="${article.contents.mainImage}" style="width: 64px; height: 64px; border: none;">
                    </g:link>
                </g:if>
                <div class="media-body">
                    <g:if test="${article.author && article.author != 'null'}">
                        <p><strong>By</strong> <g:link controller="welcome" action="searchByAuthor" params="[author: article.author]">${article.author}</g:link></p>
                    </g:if>
                    <g:if test="${articleService.getKeyWordsShort(article)}">
                    <p><strong>Keywords</strong></p>
                    <ul class="list-inline">
                        <g:each in="${articleService.getKeyWordsShort(article)}" var="gram">
                            <li><g:link controller="welcome" action="searchByKeyWords" params="[keyWords: gram]">${gram}</g:link></li>
                        </g:each>
                    </ul>
                    </g:if>
                </div>
            </div>
            <g:set var="similars" value="${articleService.getTopSimilars(article)}" />
            <g:if test="${similars}">
            <hr>
            <strong>Top Similars</strong>
            </g:if>
    </div>
    <g:if test="${similars}">
    <ul class="list-group">
        <g:each status="i" in="${similars.values()}" var="similar">
            <li class="list-group-item">
                <g:link action="article" id="${similar.article.id}">${similar.title()}</g:link> <small class="muted">@ ${similar.feedName()} on ${similar.article.published}</small>
            </li>
        </g:each>
    </ul>
    </g:if>
    <div class="panel-footer">
        <ul class="list-inline">
            <li><g:link action="article" id="${article.id}" params="${(board)?['boardName': board]:[:]}"><span class="glyphicon glyphicon-eye-open"></span> Explore</g:link></li>
            <li><a href="${article.link}" target="_blank"><span class="glyphicon glyphicon-new-window"></span> Open</a></li>    
            <!--<li>Add to Reader</li>-->
            <li><pieuvre:follow feed="${article.feed}"/></li>
            <li><a  href="https://twitter.com/share" class="twitter-share-button" data-url="${article.link}" data-text="${article.title} via http://thepieuvre.com">Tweet</a></li>
        </ul>
    </div>
</div>

<!-- Modal -->
<div class="modal fade" id="articleModal_${article.id}" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
<div class="modal-dialog quick-reader">
  <div class="modal-content">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
    <h4 class="modal-title">The Pieuvre Quick Reader</h4>
    <h2>${article.title} <br><small>@ ${article.feed.title} ${(article.author)?"by ${article.author}":''} | On ${article.published}</small></h2>
    </div>
    <div class="modal-body">
        <div class="well">
            <hc:cleanHtml unsafe="${article.contents.raw}" whitelist="relaxed"/>
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
 <g:if test="${similars}">
    <hr>
    <h4>Top Similars</h4>
    <ul class="list-group">
        <g:each status="i" in="${similars.values()}" var="similar">
            <li class="list-group-item">
                <g:link action="article" id="${similar.article.id}">${similar.title()}</g:link> <small class="muted">@ ${similar.feedName()} on ${similar.article.published}</small>
            </li>
        </g:each>
    </ul>
    </g:if>
    </div>
    <div class="modal-footer">
        <g:link action="article" id="${article.id}" class="btn btn-default" params="${(board)?['boardName': board]:[:]}">
            <span class="glyphicon glyphicon-eye-open"></span> Explore
        </g:link>
        <a href="${article.link}" target="_blank" class="btn btn-default">
            <span class="glyphicon glyphicon-new-window"></span> Open
        </a>
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
    </div>
  </div><!-- /.modal-content -->
</div><!-- /.modal-dialog -->
</div><!-- /.modal -->
</div>