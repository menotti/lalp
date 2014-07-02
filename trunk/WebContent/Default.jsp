<%@page import="br.ufscar.dc.lalp.web.GoogleAuthHelper"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link type="text/css" rel=StyleSheet href="css/style.css">
<link type="image/ico" rel="icon" href="images/favicon.ico">
<title>LALP - Compiler</title>

</head>
<body>
	<div class='AllContent' id='AllContent'>
		<jsp:include page="Template/Header.jsp" />
		<div class='PageContent'>
			<!-- All the page content must to be placed here -->
			<div class='HomeContent'>
				<div class='LoginArea'>
					<div class='LoginTextArea'>
						<center>

							<%
                                                            final GoogleAuthHelper helper = new GoogleAuthHelper();
                                                            if (request.getParameter("code") == null || request.getParameter("state") == null) {
                                                        %>

							<a href=<%= helper.buildLoginUrl() %>> <img
								src="images/google2.png" width="250px" name="Mainpic" id="image" />
							</a>

							<%
                                                            session.setAttribute("state", helper.getStateToken());

                                                            } else if (request.getParameter("code") != null && request.getParameter("state") != null
                                                                            && request.getParameter("state").equals(session.getAttribute("state"))) {

                                                                    session.removeAttribute("state");
                                                        %>

							<a href='index.jsp'> <img src="images/google.jpg"
								name="Mainpic" id="image" />
							</a>

							<%
                                                            }
                                                        %>
						</center>
					</div>
					<div class='LoginFooter'>
						<!-- <img src='images/oauth-2-sm.png'/> -->
					</div>
				</div>
			</div>
			<!-- End of Page Content -->
		</div>
		<jsp:include page="Template/Footer.jsp" />
	</div>
</body>
</html>