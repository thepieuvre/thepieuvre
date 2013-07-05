<%--
  User: Alex
  Date: 8/06/13
  Time: 8:08 PM
--%>

<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<html lang="en">
<head>
  <title>The Pieuvre - Reading the Ineternet</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="The Pieuvre is the next generation of Internet reader, reading the Internet for you.">
  <meta name="author" content="The Pieuvre Team (aka Alex di Costanzo)">

    <!-- The Style -->
    <link href="${resource(dir:'css/bootstrap', file:'bootstrap.css')}" rel="stylesheet">
    <link href='http://fonts.googleapis.com/css?family=Ubuntu' rel='stylesheet' type='text/css'>
    <link href="${resource(dir:'css/bootstrap', file:'bootstrap-responsive.css')}" rel="stylesheet">
    <link href="${resource(dir:'css', file:'thepieuvre.css')}" rel="stylesheet">

    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

    <!-- Fav and touch icons
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="../assets/ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="../assets/ico/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="../assets/ico/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" href="../assets/ico/apple-touch-icon-57-precomposed.png">
    <link rel="shortcut icon" href="../assets/ico/favicon.png">   -->
    <g:javascript library="jquery" plugin="jquery"/>
    <r:layoutResources />

</head>
<body>

<div class="container">
    <h3 class="lead" style="font-family: 'Ubuntu', sans-serif;">The Pieuvre <small>Reading the Internet</small></h3>

    <div class="navbar">
        <div class="navbar-inner">
            <ul class="nav">
                <li class="active"><a href="${resource(dir:'/')}">Home</a></li>
            </ul>
            <g:form class="navbar-search pull-left" action="executor" controller="welcome">
                <input name="command" value="${params.command}" type="text" class="search-query" placeholder=" Search">
            </g:form>
        <sec:ifLoggedIn>
            <ul class="nav pull-right">
                <li><a href="#"><sec:loggedInUserInfo field="username"/></a></li>
                <li><g:link controller="logout">Logout</g:link></li>
            </ul>
        </sec:ifLoggedIn>
        <sec:ifNotLoggedIn>
            <ul class="nav pull-right">
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        More
                        <b class="caret"></b>
                    </a>
                    <ul class="dropdown-menu">
                        <li><a href="${createLink(action: 'settings')}">Settings</a></li>
                        <li class="divider"></li>
                        <li><a href="${createLink(action: 'help')}">Help</a></li>
                        <li class="divider"></li>
                        <li><a href="${createLink(action: 'about')}">About Us</a></li>
                        <li><a href="${createLink(action: 'news')}">News</a></li>
                        <li class="divider"></li>
                        <li><a href="${createLink(action: 'contact')}">Contact Us</a></li>
                    </ul>
                </li>
                <li><g:link controller="login">Log In</g:link></li>
            </ul>
        </sec:ifNotLoggedIn>

        </div>
    </div>

<sec:ifNotLoggedIn>
<p class="text-left muted"><small>Not a member? <a href="${createLink(action: 'signUp')}">Sign Up</a></small></p>
</sec:ifNotLoggedIn>

    <g:layoutBody/>

        <div class="footer">
            <hr>
            <p><small>Developed in Sophia Antipolis, France - ${new java.text.SimpleDateFormat('MMMM yyyy').format(new Date())}<span class="pull-right"><a href="#">Back to top</a></span></small></p>
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