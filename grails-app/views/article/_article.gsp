<section id="article">
    <div class="row-fluid">
        <div class="span8 offset1">
            <div class="media">
                <g:if test="${article.contents.mainImage}">
                    <g:link class="pull-left" controller="article" action="modal" id="${article.id}" data-toggle="modal" data-target="#modal">
                        <img class="media-object" data-src="holder.js/64x64" src="${article.contents.mainImage}" style="width: 64px; height: 64px; border: none;">
                    </g:link>
                </g:if>
                <div class="media-body">
                    <h4 class="media-heading lead"><g:link controller="article" action="modal" id="${article.id}" data-toggle="modal" data-target="#modal">${article.title}</g:link></h4>
                    <p></p><small class="muted">${(article.author && article.author != 'null')?"${article.author}":''} @ ${article.feed.title} | ${article.published}</small></p>
                    <ul>
                    <g:each status="i" in="${articleService.getSimilars(article)}" var="related">
                        <g:if test="${i < 5 && related.key}">
                            <li>
                            <g:link class="pull-left" controller="article" action="modal" id="${related.key.id}" data-toggle="modal" data-target="#modal">${related.key.title}</g:link> <small class="muted">@ ${related.key.feed.title}</small>
                            </li>
                        </g:if>
                    </g:each>
                    </ul>

                </div>
            </div>
            <hr>

        </div>
        <div class="span3">
        </div>
    </div>
</section>