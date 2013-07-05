<h2>${article.title} <br><small>@ ${article.feed.title} ${(article.author)?"by ${article.author}":''}</small></h2>
<p>
<small>Content extracted from ${article.link}</small>
</p>

TODO key words

<span>
    <hccleanHtml unsafe="${article.contents.raw}" whitelist="relaxed"/>
</span>


then a more button
<img data-src="holder.js/360x270" alt="360x270" style="width: 360px; height: 270px;" src="${article.contents.mainImage}">

<g:if test="${article.contents.fullText}">
    <g:each in="${article.contents.fullText?.tokenize('\n')}" var="sentence">
        <p>${sentence}</p>
    </g:each>
    </g:if>

Botoom action