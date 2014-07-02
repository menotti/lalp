<%@page import="org.json.JSONObject"%>
<%@page import="br.ufscar.dc.lalp.web.GoogleAuthHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="css/lalpHome.css"/>
<link rel="stylesheet" type="text/css" href="css/jquery.svg.css"/>
<link rel="stylesheet" type="text/css" href="css/style.css"/>

<link type="image/ico" rel="icon" href="images/favicon.ico">

<!-- PAGE SERVLET -->
<%

    final GoogleAuthHelper helper = new GoogleAuthHelper();
    String given_name = "";
    String family_name = "";
    String email = "";
            
    if (request.getParameter("code") == null || request.getParameter("state") == null) 
    {
            session.setAttribute("state", helper.getStateToken());
            response.sendRedirect("Default.jsp");
    } 
    else if (request.getParameter("code") != null && request.getParameter("state") != null
                    && request.getParameter("state").equals(session.getAttribute("state"))) 
    {
            session.setAttribute("ApplicationUserData", helper.getUserInfoJson(request.getParameter("code")));
            JSONObject json = new JSONObject(session.getAttribute("ApplicationUserData").toString());
            
            given_name = json.getString("given_name");
            family_name = json.getString("family_name");
            email = json.getString("email");     
    }
               

%>

<!-- PAGE SCRIPTS -->
<script type="text/javascript" src="js/head.min.js"></script>
<script type="text/javascript" src="js/jszip.js"></script>
<script>
	head.js("js/jquery-1.6.4.min.js",
			"js/jquery.svg.package-1.4.4/jquery.svg.js",	
			"js/ajaxfileupload.js", "js/lalpArgs.js");
</script>
<script>

//var path = "http://localhost:8080/"
var path = "http://lalp.dc.ufscar.br:9180/lalp/";

	
var lastName = "<%=family_name%>";
var fistName = "<%=given_name%>";
var emailA = "<%=email%>";
	
if (emailA === "") {
	window.location = path + "Default.jsp";
}
		
setTimeout(function() {checkUserRole();},1000);
	
function checkUserRole() {
	$.ajax({
		url : 'DATACheckServlet',
		type : 'POST',
		data : {
			email : emailA,
			index : "0"
		},
		error : function() {
			//alert("error");
			var urlindex = window.location.href.replace('idCheck.jsp','userData.jsp');
			window.location = urlindex;
		},
		success: function() {
			//alert("sucess");
			var urlindex = window.location.href.replace('idCheck.jsp','index.jsp');
			window.location = urlindex;
		}
	});
}
</script>

<title>LALP - Compiler</title>
</head>
<body>
	<div class='AllContent'>
		<jsp:include page="Template/Header.jsp"/>
		<div class='PageContent'>
		<!-- All the page content must to be placed here -->
			<br><br><br>
			<center><b>Checking your ID...</b></center>
			<br><br><br>
		<!-- End of Page Content -->
		</div>
		<jsp:include page="Template/Footer.jsp"/>
	</div>
	
</body>
</html>