<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
@import "css/jquery.svg.css";
</style>
<link rel="stylesheet" type="text/css" href="css/lalpHome.css"></link>
<script type="text/javascript" src="js/head.min.js"></script>

<script type="text/javascript" src="js/jszip.js"></script>
<script>
	head.js("js/jquery-1.6.4.min.js",
			"js/jquery.svg.package-1.4.4/jquery.svg.js",
			//"http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js",
			//"http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.9/jquery-ui.min.js",	
			"js/ajaxfileupload.js", "js/lalpArgs.js");
</script>
<script>

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
		window.location = "http://lalp.dc.ufscar.br:8080/lalp/index.html";
	}
	
	email = email.replace('%40','@');
		
	setTimeout(function() {checkUserRole();},1000);
	
	function checkUserRole() {
		$.ajax({
			url : 'DATACheckServlet',
			type : 'POST',
			data : {
				email : email,
				index : "0",
			},
			error : function() {
				alert("erro");
				var urlindex = window.location.href.replace('idCheck.jsp','userData.jsp');
				window.location = urlindex;
			},
			success: function() {
				alert("sucesso");
				var urlindex = window.location.href.replace('idCheck.jsp','index.jsp');
				window.location = urlindex;
			}
		});
	}
</script>

<title>Lalp Web Compiler</title>
</head>
<body>
	<b>Checking your ID...</b>
</body>
</html>