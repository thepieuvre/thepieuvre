<div class="well">
<div class="page-header">
  <h2>${article.title} <small>@ ${article.feed.title}</small></h2>
</div>
 <blockquote>        
  <small>${article.published}</small>
</blockquote>
<div>
  <g:each var="content" in="${article.contents}">
    <div>${content.raw}</div>
  </g:each>
</div>
<div>
  <hr>
  <strong>Actions:</strong>
  <p><g:link action="related" id="${article.id}" ><i class="icon-eye-open"></i>Explore</g:link> <a href="${article.link}" target="_blank"><i class="icon-globe"></i>Read</a></p>
</div>
<div>
  <hr>
  <h4>Related articles:</h4>
 <g:each in="${articleService.relatedbyMaxArticles(article)}" var="related">
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
      <g:each var="cont" in="${related.key.contents}">
      <div class="well">
      ${cont.raw}
      </div>
        <p> <g:link action="related" id="${related.key.id}" ><i class="icon-eye-open"></i>Explore</g:link> <a href="${related.key.link}" target="_blank"><i class="icon-globe"></i>Read</a> </p>

      </g:each>

        </div>
      </div>
    </div>
    </g:each>
  </div>
</div>
