<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="web"/>
	</head>
	<body>
 		<div class="row">
      <g:form class="form-search" action="executor" controller="welcome">
    		<div class="span7">
    			
	      			<input type="text" style="width:95%;" class="input-medium search-query" placeholder="Type some words or some commands (:help)..." name="command" value="${params.command}">
            </div>
            <div class="span3">
	      			<button type="submit" class="btn btn-primary">Execute</button>
	      			<div class="btn-group">
            			<a class="btn btn-primary" href="#">More</a>
            			<a class="btn btn-primary dropdown-toggle" data-toggle="dropdown" href="#"><span class="caret"></span></a>
            			<ul class="dropdown-menu">
                    <sec:ifNotLoggedIn>
                   <!-- <li><a href="${createLink(action: 'signUp')}">Sign Up</a></li>-->
                    </sec:ifNotLoggedIn>
			              <li><a href="${createLink(action: 'about')}">About</a></li>
			              <li><a href="${createLink(action: 'help')}">Help</a></li>
			              <li class="divider"></li>
			              <li><a href="${createLink(action: 'contact')}">Contact Us</a></li>
            			</ul>
          		</div>
    		  </div>
          </g:form>
  		</div>



  	<div class="row">
      <g:if test="${cmd}">
        <div id="container" class="span10">
        <p class="${(!exit)?'text-success':'text-error'}"><i class="icon-hand-right"></i>${cmd}</p>
<pre>
${(!exit)?result:msg}

${(!exit)?'':"Exit: ${exit}"}
</pre>
        </div>
      </g:if>
      <g:else>
  		<div id="container" class="span10">
        <g:if test='${flash.message}'>
          <div class='alert alert-success'>${flash.message}</div>
        </g:if>
      </div>
    </g:else>

<div class="row">
  <div class="span10"> 
<section id="article">
  <div class="page-header">
    <h1>${article.title} <small>@ ${article.feed.title}</small></h1>
    <p class="lead">${article.published}</p>
  </div>
  <div class="row">
    <div class="span10">
      <h2>In Brief <small>by the Pieuvre</small></h2>
      <p>${articleService.getTrainedGram(article)*.name.collect { if (it in articleService.getNGram(article)*.name){"<strong>${it}</strong>"} else {it}}.join(' ')}</P>
    </div>
  </div>
  <hr>
  <div class="row">
    <div class="span10">
      <h2>In Full <small>by TODO AUTHOR</small></h2>
    <g:each var="content" in="${article.contents}">
      <div>${content.raw}</div>
    </g:each>
    </div>
  </div>
</section>  
<section id="similar">
   <div class="page-header">
      <h2>Similar Articles</h2>
   </div>
   <div class="row">
    <div class="span10">
<!-- ############## Begin Similars ############## -->
<div class="accordion" id="accordionSimilars">
 <g:each in="${articleService.similars(article)}" var="similars">
 <div class="accordion-group">
  <div class="accordion-heading">
        <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion${similars.key.id}" href="#collapse${similars.key.id}">
          ${similars.key.title}  <small>@ ${similars.key.feed.title}</small>
        </a>
      </div>
      <div id="collapse${similars.key.id}" class="accordion-body collapse">
        <div class="accordion-inner">
           <blockquote>
        
        <small>${similars.key.published}</small>
      </blockquote>
      <g:each var="cont" in="${similars.key.contents}">
      <div class="well">
      ${cont.raw}
      </div>
        <p> <g:link action="related" id="${similars.key.id}" ><i class="icon-eye-open"></i>Explore</g:link> <a href="${similars.key.link}" target="_blank"><i class="icon-globe"></i>Read</a> </p>

      </g:each>

        </div>
      </div>
    </div>
 </g:each>
</div>
<!-- ############## End Similars ############## -->
    </div>
   </div>
</section>
<section id="related">
  <div class="page-header">
      <h2>Related Articles</h2>
  </div>
   <div class="row">
    <div class="span10">
      <!-- ############## Begin Related ############## -->
<div class="accordion" id="accordionSimilars">
 <g:each in="${articleService.related(article)}" var="related">
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
<!-- ############## End Related ############## -->
    </div>
   </div>
</section>

  </div>
  <div class="span2">
    <ul class="nav nav-list affix">
      <li class="nav-header">Actions</li>
      <li><a href="#article">Article</a></li>
      <li><a href="${article.link}" target="_blank">Full Article</a></li>
      <li><a href="#similar">Similar Articles</a></li>
      <li><a href="#related">Related Articles</a></li>
      <li class="divider"></li>
      <li class="nav-header">Key Words</li>
      <g:each in="${articleService.getNGram(article)[0..15]}" var="gram">
        <li><a href="#">${gram.name}</a></li>
      </g:each>
    </ul>
  </div>  
</div>    

	</body>
</html>
