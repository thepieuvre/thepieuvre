<div style="
border-bottom-color: rgb(221, 221, 221);
border-bottom-left-radius: 4px;
border-bottom-right-radius: 4px;
border-bottom-style: solid;
border-bottom-width: 1px;
border-left-color: rgb(221, 221, 221);
border-left-style: solid;
border-left-width: 1px;
border-right-color: rgb(221, 221, 221);
border-right-style: solid;
border-right-width: 1px;
border-top-color: rgb(221, 221, 221);
border-top-left-radius: 4px;
border-top-right-radius: 4px;
border-top-style: solid;
border-top-width: 1px;
margin-bottom: 15px;
margin-left: 0px;
margin-right: 0px;
margin-top: 10px;
padding-bottom: 14px;
padding-left: 19px;
padding-right: 19px;
padding-top: 0px;
">
<section id="article-${article.id}">
  <div class="page-header">
  <h2>${article.title} <br><small>@ ${article.feed.title} ${(article.author)?"by ${article.author}":''}</small></h2>
  </div>
 <blockquote>        
  <small>${article.published}</small>
</blockquote>
<div>
  <g:each var="content" in="${article.contents}">
    <div>${content.raw}</div>
  </g:each>
</div>
<div class="well">
  <strong>Actions:</strong>
  <p><g:link action="article" id="${article.id}" ><i class="icon-eye-open"></i>Explore</g:link> <a href="${article.link}" target="_blank"><i class="icon-globe"></i>Read</a></p>
</div>
<div>
  <h4>Similar articles:</h4>
 <g:each in="${articleService.similars(article)}" var="related">
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
        <p> <g:link action="article" id="${related.key.id}" ><i class="icon-eye-open"></i>Explore</g:link> <a href="${related.key.link}" target="_blank"><i class="icon-globe"></i>Read</a> </p>

      </g:each>

        </div>
      </div>
    </div>
    </g:each>
  </div>
</section>
</div>