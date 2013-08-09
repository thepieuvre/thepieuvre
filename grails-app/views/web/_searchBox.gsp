<div class="row">
<g:form class="form-search" action="executor" controller="welcome">
	<div class="span7">
		
  			<input type="text" style="width:95%;" class="input-medium search-query" placeholder="Type some words or some commands (:help)..." name="command" value="${params.command}">
      </div>
      <div class="span3">
  			<button type="submit" class="btn btn-primary">Execute</button>
	    </div>
</g:form>
</div>