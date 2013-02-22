<div class="accordion article" id="accordion${article.id}">
  <div class="accordion-group">
    <div class="accordion-heading">
      <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion${article.id}" href="#collapse${article.id}">
        ${article.title} 
      </a>
    </div>
    <div id="collapse${article.id}" class="accordion-body collapse in">
      <div class="accordion-inner">
        <blockquote>
        
        <small>${article.published} @ ${article.feed.title}</small>
      </blockquote>
      <g:each var="content" in="${article.contents}">
      <div class="well">
      ${content.raw}
      </div>
      </g:each>

        <div class="well">
          <a href="${article.link}" target="_blank"><i class="icon-globe"></i>Read</a>
        </div>
      </div>
    </div>
  </div>
</div>