<section  class="article-box" id="article-${article.id}">
  <div class="page-header">
  <h2>${article.title} <br><small>@ ${article.feed.title} ${(article.author)?"by ${article.author}":''}</small></h2>
   <blockquote>        
  <small>${article.published}</small>
</blockquote>
  </div>
  <hc:cleanHtml unsafe="${article.contents.raw}" whitelist="relaxed"/>
  <hr>
<div class="well">
  <strong>Actions:</strong>
  <p><g:link action="article" id="${article.id}" ><i class="icon-eye-open"></i>Explore</g:link> <a href="${article.link}" target="_blank"><i class="icon-globe"></i>Complete Article</a></p>
</div>
  <h4>Similar articles:</h4>
 <g:each status="i" in="${articleService.similars(article)}" var="related">
  <g:if test="${i < 5}">
    <div class="accordion-group">
      <div class="accordion-heading">
        <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion${related.key.id}" href="#collapse${related.key.id}">
          ${related.key.title}  <small>@ ${related.key.feed.title}</small>
        </a>
      </div>
      <div id="collapse${related.key.id}" class="accordion-body collapse">
        <div class="accordion-inner">
           <blockquote>
        
        <small>${related.key.published}</small>
      </blockquote>
      <div class="well">
      <hc:cleanHtml unsafe="${related.key.contents.raw}" whitelist="basic"/>
      </div>
        <p> <g:link action="article" id="${related.key.id}" ><i class="icon-eye-open"></i>Explore</g:link> <a href="${related.key.link}" target="_blank"><i class="icon-globe"></i>Complete Article</a></p>
        </div>
      </div>
    </div>
  </g:if>
    </g:each>
</section>
