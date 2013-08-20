
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
          <li class="${(section in ['index', 'home'] )? 'active' : ''}"><a href="${resource(dir:'/')}">Home</a></li>
          <li class="${section == 'about' ? 'active' : ''}"><a href="${createLink(controller: 'welcome', action: 'about')}">About</a></li>
          <li><a data-toggle="modal" href="#contactModal">Contact</a></li>
        <sec:ifLoggedIn>
            <li class="${section == 'help' ? 'active' : ''}"><a href="${createLink(controller: 'welcome', action: 'help')}">Help</a></li>
            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown"><sec:loggedInUserInfo field="username"/><b class="caret"></b></a>
                    <ul class="dropdown-menu pull-right">
                      <li><a href="#">Profile</a></li>
                      <li><a href="#">Settings</a></li>
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
        <h3 class="text-muted" style="font-family: 'Ubuntu', sans-serif;">The Pieuvre <small>Reading the Internet</small></h3>
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
                <g:form class="form-horizontal well" controller="welcome" action="message">
                    <legend>Please fill out the following form:</legend>
                    <fieldset>
                        <div class="control-group">
                            <label class="control-label" for="name">Your name</label>
                            <div class="controls">
                                <input type="text" class="input-xlarge" name="name" maxlength="255" />
                                <p class="help-block">Please tell us your name.</p>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="email">Your email</label>
                            <div class="controls">
                                <input type="text" class="input-xlarge" name="email" maxlength="255" />
                                <p class="help-block">We will use it for replying.</p>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="message">Your message</label>
                            <div class="controls">
                                <textarea cols="50" rows="10" type="textarea" class="input-xlarge" name="message" maxlength="255" ></textarea>
                                <p class="help-block">Your message to the Pieuvre.</p>
                            </div>
                        </div>
                        <div class="form-actions">
                            <button type="submit" class="btn btn-success">Send</button>
                        </div>
                    </fieldset>
                </g:form>
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
                    <form action='${request.contextPath}/j_spring_security_check' class="form-horizontal well" method='POST' id='loginForm' autocomplete='off'>
                        <fieldset>
                            <div class="control-group">
                                <label for='username' class="control-label"><g:message code="springSecurity.login.username.label" />:</label>
                                <input type='text' class='text_' name='j_username' id='username'/>
                            </div>
                            <div class="control-group">
                                <label for='password' class="control-label"><g:message code="springSecurity.login.password.label"/>:</label>
                                <input type='password' class='text_' name='j_password' id='password'/>
                                <p></p>
                            </div>
                            <div class="form-actions">
                                <button class="btn btn-success" type='submit' id="submit">${message(code: "springSecurity.login.button")}</button>
                            </div>
                        </fieldset>
                    </form>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->

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
