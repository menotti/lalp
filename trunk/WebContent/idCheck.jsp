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

<!-- PAGE SCRIPTS -->
<script type="text/javascript" src="js/head.min.js"></script>
<script type="text/javascript" src="js/jszip.js"></script>
<script>
	head.js("js/jquery-1.6.4.min.js",
			"js/jquery.svg.package-1.4.4/jquery.svg.js",	
			"js/ajaxfileupload.js", "js/lalpArgs.js");
</script>
<script>

/*var path = "http://localhost:9180/lalpProject/";*/
var path = "http://projetos.ppgcc.dc.ufscar.br:9180/lalp/";

function getUrlVars() {
   	var vars = {};
   	var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
   	    vars[key] = value;
      });
     return vars;
}
	
var lastName = getUrlVars()["openid.ext1.value.lastname"];
var fistName = getUrlVars()["openid.ext1.value.firstname"];
var email = getUrlVars()["openid.ext1.value.email"];
	
if (email == null) {
	window.location = path + "Default.jsp";
}
	
email = email.replace('%40','@').replace('#', '');
		
setTimeout(function() {checkUserRole();},1000);
	
function checkUserRole() {
	$.ajax({
		url : 'DATACheckServlet',
		type : 'POST',
		data : {
			email : email,
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