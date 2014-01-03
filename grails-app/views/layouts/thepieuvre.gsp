
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0">
    <meta name="description" content="The Pieuvre - Reading the Internet: next generation of Internet reader.">
    <meta name="author" content="The P-Team">

    <link rel="alternate" type="application/rss+xml" title="RSS" href="http://blog.thepieuvre.com/rss">

    <title>The Pieuvre</title>

    <!-- Bootstrap core CSS -->
    <link href="${resource(dir:'css/bootstrap', file:'bootstrap.css')}" rel="stylesheet">
    <!-- From Template: http://examples.getbootstrap.com/jumbotron-narrow/index.html -->
    <link href="${resource(dir:'css/bootstrap', file:'jumbotron-narrow.css')}" rel="stylesheet">
    <!-- The offcial 'the Pieuvre' font -->
    <link href='http://fonts.googleapis.com/css?family=Ubuntu' rel='stylesheet' type='text/css'>
    <!-- The Pieuvre customisation -->
    <link href="${resource(dir:'css', file:'thepieuvre.css')}" rel='stylesheet' type='text/css'>

    <!-- Icons -->
    <link rel="shortcut icon" type="image/x-icon" href="${resource(dir:'images', file:'favicon.ico')}">

    <g:javascript library="jquery" plugin="jquery"/>
    <r:layoutResources />
    <script src="${resource(dir:'js',file:'jquery.validate.min.js')}"></script>
    <script src="${resource(dir:'js',file:'additional-methods.min.js')}"></script>
    <script src="${resource(dir:'js/bootstrap', file:'bootstrap.min.js')}"></script>

  </head>

  <body>

    <div class="container-narrow">
      <div class="header">
        <ul class="nav nav-pills pull-right">
          <li class="${(section in ['index', 'home'] )? 'active' : ''}"><a href="${resource(dir:'/')}">Home</a></li>
          <li class="${section == 'about' ? 'active' : ''}"><a href="${createLink(controller: 'welcome', action: 'about')}">About</a></li>
          <li><a data-toggle="modal" href="#contactModal">Contact</a></li>
        <sec:ifLoggedIn>
            <li class="${section == 'help' ? 'active' : ''}"><a href="${createLink(controller: 'welcome', action: 'help')}">Help</a></li>
            <li class="dropdown ${section == 'profile' ? 'active' : ''}">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown"><sec:loggedInUserInfo field="username"/><b class="caret"></b></a>
                    <ul class="dropdown-menu pull-right">
                      <li><g:link controller="member" action="profile">Profile</g:link></li>
                     <!--  <li><a href="#">Settings</a></li> -->
                      <li class="divider"></li>
                      <li><g:link controller="logout">Logout</g:link></li>
                    </ul>
            </li>
            <!-- Admin menu -->
            <sec:ifAnyGranted roles="ROLE_ROOT, ROLE_FEED_MANAGER, ROLE_MEMBER_MANGER, ROLE_COMMAND_MANAGER">
                 <li class="${section == 'admin' ? 'active' : ''} dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">Admin<b class="caret"></b></a>
                        <ul class="dropdown-menu pull-right">
                            <sec:ifAnyGranted roles="ROLE_FEED_MANAGER">
                                <li><a href="${createLink(controller: 'feedManager')}">Feed Manager</a></li>
                                <li><a href="${createLink(controller: 'articleManager')}">Article Manager</a></li>
                            </sec:ifAnyGranted>     
                            <sec:ifAnyGranted roles="ROLE_MEMBER_MANAGER">
                                <li><a href="${createLink(controller: 'memberManager')}">Member Manager</a></li>
                            </sec:ifAnyGranted>     
                            <sec:ifAnyGranted roles="ROLE_COMMAND_MANAGER">
                                <li><a href="${createLink(controller: 'commandManager')}">Command Manager</a></li>
                            </sec:ifAnyGranted>     
                            <sec:ifAnyGranted roles="ROLE_ROOT">
                                <li><g:link controller="tools">Tools</g:link></li>
                            </sec:ifAnyGranted>         
                        </ul>
                </li>
            </sec:ifAnyGranted> 
            <!-- End Admin menu -->
          </sec:ifLoggedIn>
          <sec:ifNotLoggedIn>
            <li><a data-toggle="modal" href="#loginModal">Login</a></li>
          </sec:ifNotLoggedIn>
        </ul>
        <h3 class="text-muted" style="font-family: 'Ubuntu', sans-serif; color: #7e1929;"><img  src="${resource(dir:'images', file:'logo.png')}">The Pieuvre <small>Reading the Internet</small></h3>
      </div>

    <g:layoutBody/>

<g:if test="${section != 'home'}">
    <div class="footer">
        <p><span class="label label-danger">Beta</span>
Developed in Sophia Antipolis, France - ${new java.text.SimpleDateFormat('MMMM yyyy').format(new Date())}<span class="pull-right"><a href="#">Back to top</a></span></p>
    </div>
</g:if>

    </div> <!-- /container -->

    <!-- Contact Modal -->
    <div id="contactModal" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Contact the Pieuvre</h4>
                </div>
            <div class="modal-body">
                <p>We would love to hear about what you think: comments, feedback, reviews, ...</p>
                <g:form id="contactForm" class="form-horizontal well" controller="welcome" action="message">
                    <legend>Please fill out the following form: <br><small>All fields are required.</small></legend>
                    <fieldset>
                        <div class="control-group">
                            <label class="control-label" for="name">Your name</label>
                            <div class="controls">
                                <input type="text" class="input-xlarge" name="name" maxlength="255" minlength="2" type="text" required />
                                <p class="help-block">Please tell us your name.</p>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="email">Your email</label>
                            <div class="controls">
                                <input type="text" class="input-xlarge" type="email" name="email" maxlength="255" required />
                                <p class="help-block">We will use it for replying.</p>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="message">Your message</label>
                            <div class="controls">
                                <textarea cols="50" rows="10" type="textarea" class="input-xlarge" name="message" maxlength="255" minlength="2" type="text" required ></textarea>
                                <p class="help-block">Your message to the Pieuvre.</p>
                            </div>
                        </div>
                        <div id="fooDiv">
                            <label for="foo">Leave this field blank</label>
                            <input type="text" name="foo" id="foo">
                        </div>
                        <script>
                        (function () {
                            var e = document.getElementById("fooDiv");
                            e.parentNode.removeChild(e);
                        })();
                        </script>
                        <div class="form-actions">
                            <button type="submit" class="btn btn-success" id="contact" data-loading-text="Sending...">Send</button>
                        </div>
                    </fieldset>
                </g:form>
                <script type="text/javascript">
                    $("#contactForm").validate();
                </script>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->

    <!-- Login Modal -->
    <div id="loginModal" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Login on the Pieuvre</h4>
                </div>
                <div class="modal-body">
                    <small><g:link action="signUp" controller="welcome">Not a member?</g:link></small>

                    <form action='${request.contextPath}/j_spring_security_check' class="form-horizontal well" method='POST' id='loginForm' autocomplete='off' role="form">
                        <fieldset>
                            <div class="form-group">
                                <label for='username' class="control-label"><g:message code="springSecurity.login.username.label" />:</label>
                                <input type='text' class='text_' name='j_username' id='username' required/>
                            </div>
                            <div class="form-group">
                                <label for='password' class="control-label"><g:message code="springSecurity.login.password.label"/>:</label>
                                <input type='password' class='text_' name='j_password' id='password'required/>
                                <p></p>
                            </div>
                            <button class="btn btn-success" type='submit' id="submit"><g:message code="springSecurity.login.button" /></button>
                        </fieldset>
                    </form>
                    <small><g:link action="passwordForgot" controller="login">Forgot your password?</g:link></small>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->
    <script type="text/javascript">
        $("#loginForm").validate();
    </script>

    <script type="text/javascript">

    $('#contact').button('reset');
    $('#contact').click(function() {
        $('#contact').button('loading');
    });
$(function(){ // document ready
 
  var stickyTop = $('.sticky').offset().top; // returns number 
 
  $(window).scroll(function(){ // scroll event  
    var windowTop = $(window).scrollTop(); // returns number
 
    if (stickyTop < windowTop) {
        $(".sticky").removeClass("navbar-fixed-100")
        $(".sticky").addClass("navbar-fixed-top");
    }
    else {
        $(".sticky").addClass("navbar-fixed-100")
        $(".sticky").removeClass("navbar-fixed-top");    }
  });
 
});
    </script>
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

    <!-- Twitter button -->

    <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
  </body>
</html>
