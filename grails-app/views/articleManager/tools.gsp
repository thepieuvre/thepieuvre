<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="thepieuvre"/>
    	<g:set var="section" scope="request" value="admin"/>
	</head>
	<body>
	
<div class="row">
	<div>
		<ul class="nav nav-tabs">
			<li><g:link action="list">Articles</g:link></li>
			<li class="active"><g:link action="tools">Tools</g:link></li>
		</ul>
	</div>
</div>

<h2>Tools</h2>

<h3>Indexing Articles</h3>

<div class="panel panel-default">
  <div class="panel-body">
    <h4 class="text-muted">Information</h4>
    <p>Number total of Articles: ${countedArticles}</p>
  </div>
</div>

<div class="panel panel-default">
  <div class="panel-body">
    <h4 class="text-muted">Forcing Indexation</h4>
    <p>Extracting main content, chuncking, keywords, similars, etc.</p>
    <g:form class="form-inline" action="indexing" role="form">
	  <div class="form-group">
	    <label class="sr-only" for="exampleInputEmail2">Number of articles to index</label>
	    <input name="max" class="form-control" id="exampleInputEmail2" placeholder="Max number">
	  </div>
	  <button type="submit" class="btn btn-default">Indexing</button>
	</g:form>
  </div>
</div>

</body>
</head>