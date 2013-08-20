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
			<li ><g:link action="list">Articles</g:link></li>
			<li class="active"><a href="#">Article's Details</a></li>
		</ul>
	</div>
</div>

<h2>Article: ${article.title}</h2>

<p>Feed: <g:link action="show" id="${article.feed.id}" controller="feedManager">${article.feed.title}</g:link></p>

<p>Language: ${article.language}</p>

<h3>Contents</h3>
	<h4>Raw</h4>
	<div class="well">
	${article.contents.raw}
	</div>

<h3>Main Content (from original article)</h3>
<p>${article.contents.extractor}</p>
<div class="well">
${article.contents.fullText}	
</div>

<h3>Main Image (from original article)</h3>
<div class="well">
<img src="${article.contents.mainImage}" />
</div>

<h3>Information</h3>
<table class="table table-striped">
	<tbody>
		<tr>
			<td><strong>ID</strong></td>
			<td>${article.uid}</td>
		</tr>
		<tr>
			<td><strong>Link</strong></td>
			<td><a href="${article.link}">${article.link}</a></td>
		</tr>
		<tr>
			<td><strong>Author</strong></td>
			<td>${article.author}</td>
		</tr>
		<tr>
			<td><strong>Published</strong></td>
			<td>${article.published}</td>
		</tr>
		<tr>
			<td><strong>Date Created</strong></td>
			<td>${article.dateCreated}</td>
		</tr>
	</tbody>
</table>

<h3>Related articles</h3>

<ul>
	<g:each in="${related}" var="art">
		<li><g:link action="show" id="${art.key?.id}">${art.key?.title}</g:link>: ${art.value}</li>
	</g:each>
</ul>

<h3>Analysis</h3>

<h4>Trained gram</h4>
<table class="table table-striped">
	<thead>
		<tr>
			<td>Trained</td>
			<td>Score</td>
			<td>Related Articles</td>
		</tr>
	</thead>
	<tbody>
	<g:each in="${trainedgrams}" status="i" var="gram">
		<tr class="${(i % 2) == 0 ? 'odd': 'even'}">
			<td>${gram.name}</td>
			<td>${gram.score}</td>
			<td>
				<ul>
				<g:each in="${gram.articles}" var="art">
					<li><g:link action="show" id="${art?.id}">${art?.title}</g:link></li>
				</g:each>
				</ul>
			</td>
		</tr>
	</g:each>
	</tbody>
</table>

<h4>Ngram</h4>
<table class="table table-striped">
	<thead>
		<tr>
			<td>Ngram</td>
			<td>Score</td>
			<td>Related Articles</td>
		</tr>
	</thead>
	<tbody>
	<g:each in="${ngrams}" status="i" var="gram">
		<tr class="${(i % 2) == 0 ? 'odd': 'even'}">
			<td>${gram.name}</td>
			<td>${gram.score}</td>
			<td>
				<ul>
				<g:each in="${gram.articles}" var="art">
					<li><g:link action="show" id="${art?.id}">${art?.title}</g:link></li>
				</g:each>
				</ul>
			</td>
		</tr>
	</g:each>
	</tbody>
</table>

<h4>Bigram</h4>
<table class="table table-striped">
	<thead>
		<tr>
			<td>Bigram</td>
			<td>Score</td>
			<td>Related Articles</td>
		</tr>
	</thead>
	<tbody>
	<g:each in="${bigrams}" status="i" var="gram">
		<tr class="${(i % 2) == 0 ? 'odd': 'even'}">
			<td>${gram.name}</td>
			<td>${gram.score}</td>
			<td>
				<ul>
				<g:each in="${gram.articles}" var="art">
					<li><g:link action="show" id="${art?.id}">${art?.title}</g:link></li>
				</g:each>
				</ul>
			</td>
		</tr>
	</g:each>
	</tbody>
</table>

<h4>Unigram</h4>
<table class="table table-striped">
	<thead>
		<tr>
			<td>Unigram</td>
			<td>Score</td>
			<td>Related Articles</td>
		</tr>
	</thead>
	<tbody>
	<g:each in="${unigrams}" status="i" var="gram">
		<tr class="${(i % 2) == 0 ? 'odd': 'even'}">
			<td>${gram.name}</td>
			<td>${gram.score}</td>
			<td>
				<ul>
				<g:each in="${gram.articles}" var="art">
					<li><g:link action="show" id="${art?.id}">${art?.title}</g:link></li>
				</g:each>
				</ul>
			</td>
		</tr>
	</g:each>
	</tbody>
</table>

<div class="row">
<div class="form-horizontal">
	<div class="form-control">
		<g:link action="delete" id="${article.id}" class="btn btn-primary">Delete</g:link>
		<p></p>
	</div>
</div>
</div>

	</body>
</html>
