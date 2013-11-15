<g:set var="springSecurityService" bean="springSecurityService"/>
<g:set var="boards" value="${springSecurityService.currentUser?.boards}" />

<g:each var="b" in="${boards}">
	<g:if test="${b != current}">
		<li><g:link controller="board" action="${action}"
			params="['feed': feed?.link, 'current': current, 'dest': b.id]">${b.name}</g:link></li>
	</g:if>
</g:each>
