
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="The Pieuvre - Reading the Internet: next generation of Internet reader.">
    <meta name="author" content="The P-Team">

    <title>The Pieuvre</title>

    <!-- Bootstrap core CSS -->
    <link href="${resource(dir:'css/bootstrap', file:'bootstrap.css')}" rel="stylesheet">
    <!-- From Template: http://examples.getbootstrap.com/jumbotron-narrow/index.html -->
    <link href="${resource(dir:'css/bootstrap', file:'jumbotron-narrow.css')}" rel="stylesheet">
    <!-- The offcial 'the Pieuvre' font -->
    <link href='http://fonts.googleapis.com/css?family=Ubuntu' rel='stylesheet' type='text/css'>

    <g:javascript library="jquery" plugin="jquery"/>
    <r:layoutResources />

  </head>

  <body>

    <div class="container-narrow">
      <div class="header">
        <ul class="nav nav-pills pull-right">
          <li class="active"><a href="#">Login</a></li>
          <li><a href="#">About</a></li>
          <li><a href="#">Contact</a></li>
        </ul>
        <h3 class="text-muted" style="font-family: 'Ubuntu', sans-serif;">The Pieuvre <small>Reading the Internet</small></h3>
      </div>
    
    <g:layoutBody/>

    <div class="footer">
        <p>Developed in Sophia Antipolis, France - ${new java.text.SimpleDateFormat('MMMM yyyy').format(new Date())}<span class="pull-right"><a href="#">Back to top</a></span></p>
    </div>

    </div> <!-- /container -->

    <script src="${resource(dir:'js/bootstrap', file:'bootstrap.min.js')}"></script>
    <script type="text/javascript">

        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', 'UA-38233353-1']);
        _gaq.push(['_trackPageview']);

        (function() {
            var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
            ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();

    </script>
  </body>
</html>
