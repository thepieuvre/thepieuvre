<%--
  User: Alex
  Date: 9/06/13
  Time: 6:06 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="thepieuvre"/>
</head>
<body>
    <section id="container">
        <g:render template="/article/article" var="article" collection="${articles}" />

    </section>
<nav id="page-nav">
    <a href="${createLink(controller: 'welcome', action: 'index', params: [offset:25] )}"></a>
</nav>

<!-- Modal -->
<div id="modal" class="modal-reader hide fade" tabindex="-1" role="dialog" aria-labelledby="readerLabel" aria-hidden="true">
    <div class="modal-reader-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h4 id="readerLabel"><i class="icon-book"></i> The Pieuvre Reader</h34
    </div>
    <div class="modal-body" style="overflow-y:auto; padding:15px;">

    </div>
    <div class="modal-footer">

    </div>
</div>

<!-- Infinite Scroll -->
<script src="${resource(dir:'js',file:'jquery.infinitescroll.min.js')}"></script>
<script type="text/javascript">
    $(function(){
        $('#container').infinitescroll({
            navSelector  : "#page-nav",
            nextSelector : "#page-nav a",
            itemSelector : "#article",
            debug        : false,
            animate: false ,
            loading: {
                img: 'images/spinner.gif',
                msgText: '<em>Loading more articles...</em>'
            },
            path : function(page) {
                return "${createLink(controller: 'welcome', action: 'index' )}"+'?offSet='+(25*page)+"&${params.collect {k,v-> "$k=$v"}.join('&')}"
            }
        });
    });
</script>

</body>
</html>