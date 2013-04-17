<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="web"/>
	</head>
	<body>
    <g:render template="/web/searchBox" />

<div class="row">
  <div class="span10"> 
    <section id="article">
      <div class="page-header">
        <h1>${article.title} <br><small>@ ${article.feed.title} ${(article.author)?"by ${article.author}":''}</small></h1>
        <p class="lead">${article.published}</p>
      </div>
      <div class="row">
        <div class="span10">
          <h2>Synopsis <small>by the Pieuvre</small></h2>
          <p><strong>In Short</strong> ${articleService.synopsis(article)}</p>
        </div>
      </div>
      <hr>
      <div class="row">
        <div class="span10">
          <h2>Content <small>${(article.author)?"by ${article.author}":''}</small></h2>
          <g:each var="content" in="${article.contents}">
          <hc:cleanHtml unsafe="${content.raw}" whitelist="relaxed"/>
          </g:each>
        </div>
      </div>
    </section>  
    <!-- ############## Begin Similars ############## -->
    <section id="similar">
      <div class="page-header">
        <h2>Similar Articles</h2>
      </div>
      <div class="row">
        <div class="span10">
          <div class="accordion" id="accordionSimilars">
            <g:each in="${articleService.similars(article)}" var="similars">
            <div class="accordion-group">
              <div class="accordion-heading">
                <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion${similars.key.id}" href="#collapse${similars.key.id}">${similars.key.title}  <small>@ ${similars.key.feed.title}</small></a>
              </div>
              <div id="collapse${similars.key.id}" class="accordion-body collapse">
                <div class="accordion-inner">
                  <blockquote>
                    <small>${similars.key.published}</small>
                  </blockquote>
                  <g:each var="cont" in="${similars.key.contents}">
                  <div class="well">
                  <hc:cleanHtml unsafe="${cont.raw}" whitelist="basic"/>
                  </div>
                  <p> <g:link action="article" id="${similars.key.id}" ><i class="icon-eye-open"></i>Explore</g:link> <a href="${similars.key.link}" target="_blank"><i class="icon-globe"></i>Read</a> </p>
                  </g:each>
                </div>
              </div>
            </div>
            </g:each>
          </div>
        </div>
      </div>
    </section>
    <!-- ############## End Similars ############## -->
    <!-- ############## Begin Related ############## -->
    <section id="related">
      <div class="page-header">
        <h2>Related Articles</h2>
      </div>
      <div class="row">
        <div class="span10">
          <div class="accordion" id="accordionSimilars">
            <g:each in="${articleService.related(article)}" var="related">
            <div class="accordion-group">
              <div class="accordion-heading">
                <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion${related.key.id}" href="#collapse${related.key.id}">${related.key.title}  <small>@ ${related.key.feed.title}</small></a>
              </div>
              <div id="collapse${related.key.id}" class="accordion-body collapse">
                <div class="accordion-inner">
                  <blockquote>
                    <small>${related.key.published}</small>
                  </blockquote>
                  <g:each var="cont" in="${related.key.contents}">
                  <div class="well">
                  <hc:cleanHtml unsafe="${cont.raw}" whitelist="basic"/>
                  </div>
                  <p> <g:link action="article" id="${related.key.id}" ><i class="icon-eye-open"></i>Explore</g:link> <a href="${related.key.link}" target="_blank"><i class="icon-globe"></i>Complete Article</a> </p>
                  </g:each>
                </div>
              </div>
            </div>
            </g:each>
          </div>
        </div>
      </div>
    </section>
  </div>
    <!-- ############## End Related ############## -->
  <div class="span2">
    <ul class="nav nav-list affix">
      <li class="nav-header">Reading</li>
      <li><a href="#article">Article</a></li>
      <li><a href="${article.link}" target="_blank">Go to the Article</a></li>
      <li class="divider"></li>
      <li class="nav-header">More Reading</li>
      <li><g:link controller="welcome" action="similar" params="[id: article.id]">Similar Articles</g:link></li>
      <li><g:link controller="welcome" action="related" params="[id: article.id]">Related Articles</g:link></li>
      <g:if test="${article.author}">
      <li><g:link controller="welcome" action="searchByAuthor" params="[author: article.author]">By <small>${article.author}</small></g:link></li>
      </g:if>
      <li><g:link controller="welcome" action="searchByFeed" params="[feed: article.feed.id]">From <small>${article.feed.title}</small></g:link></li>
      <li class="divider"></li>
      <li class="nav-header">Key Words</li>
      <g:if test="${articleService.getNGram(article)}">
      <g:each in="${articleService.getNGram(article)[0..((articleService.getNGram(article).size() < 15)?articleService.getNGram(article).size()-1:14)]}" var="gram">
        <li><g:link controller="welcome" action="searchByKeyWords" params="[keyWords: gram.name]">${gram.name}</g:link></li>
      </g:each>
      </g:if>
    </ul>
  </div>  
</div>   

	</body>
</html>
