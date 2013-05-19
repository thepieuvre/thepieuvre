<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="web"/>
	</head>
	<body>
    <g:render template="/web/searchBox" />
     <g:if test='${flash.message}'>
          <div style= "margin-top: 20px;" class='alert alert-success'>${flash.message}</div>
        </g:if>

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
          <hc:cleanHtml unsafe="${article.contents.raw}" whitelist="relaxed"/>
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
            <g:set var="similars" value="${false}"/>
            <g:each in="${articleService.similars(article)}" var="similars">
            <g:set var="similars" value="${true}"/>
            <div class="accordion-group">
              <div class="accordion-heading">
                <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion${similars.key?.id}" href="#collapse${similars.key?.id}">${similars.key?.title}  <small>@ ${similars.key?.feed?.title}</small></a>
              </div>
              <div id="collapse${similars.key?.id}" class="accordion-body collapse">
                <div class="accordion-inner">
                  <blockquote>
                    <small>${similars.key?.published}</small>
                  </blockquote>
                  <div class="well">
                  <hc:cleanHtml unsafe="${similars.key?.contents?.raw}" whitelist="basic"/>
                  </div>
                  <p> <g:link action="article" id="${similars.key?.id}" ><i class="icon-eye-open"></i>Explore</g:link> <a href="${similars.key?.link}" target="_blank"><i class="icon-globe"></i>Go to the Original</a> </p>
                </div>
              </div>
            </div>
            </g:each>
                <g:if test="${! similars}">
    <p>The Pieuvre is still processing data, please be patient.
  </g:if>
          </div>
        </div>
      </div>
    </div>
    </section>
    <!-- ############## End Similars ############## -->
  <div class="span2">
    <ul class="nav nav-list affix">
      <li class="nav-header">Reading</li>
      <li><a href="#article">Article</a></li>
      <sec:ifLoggedIn>
      <li><a href="#reader" data-toggle="modal">The Pieuvre Reader</a></li>
      </sec:ifLoggedIn>
      <li><a href="${article.link}" target="_blank">Go to the Original</a></li>
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
<sec:ifLoggedIn>
<!-- Modal Reader -->
<div id="reader" class="modal-reader hide fade" tabindex="-1" role="dialog" aria-labelledby="readerLabel" aria-hidden="true">
  <div class="modal-reader-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h4 id="readerLabel"><i class="icon-book"></i> The Pieuvre Reader</h4>
    <h2>${article.title} <br><small>@ ${article.feed.title} ${(article.author)?"by ${article.author}":''}</small></h2>
    <small>Content extracted from ${article.link}</small>
  </div>
  <div class="modal-reader-body">
    <center><img src="${article.contents.mainImage}" /></center>
    <div>
      <g:if test="${article.contents.fullText}">
        <g:each in="${article.contents.fullText?.tokenize('\n')}" var="sentence">
        <p>${sentence}</p>
        </g:each>
      </g:if>
      <g:else>
      <p> The Pieuvre is busy. Please come back later for the reading the content.</p>
      </g:else>
    </div>
  </div>
</div>
</sec:ifLoggedIn>

	</body>
</html>
