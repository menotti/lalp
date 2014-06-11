<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<link rel="stylesheet" type="text/css" href="css/lalpHome.css"></link>
<link rel="stylesheet" type="text/css" href="css/jquery.svg.css"></link>
<link type="text/css" rel=StyleSheet href="css/style.css">
<link type="image/ico" rel="icon" href="images/favicon.ico">
<title>LALP - Compiler</title>

<!-- SCRIPT AREA -->
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
	var firstName = getUrlVars()["openid.ext1.value.firstname"];
	var email = getUrlVars()["openid.ext1.value.email"];
	
	if (email == null) {
		window.location = path + "Default.jsp";
	}
	
	email = email.replace('%40','@').replace('#', '');
	
	setTimeout(function() {checkUserRole();},200);
	
	function checkUserRole() {
		$.ajax({
			url : 'DATACheckServlet',
			type : 'POST',
			data : {
				email : email,
				index : "1"
			},
			error : function() {
				window.location = path + "registeredUser.jsp";
			},
			success: function() {
			}
		});
	}
</script>

<script>
	function FillUserInfo(){
		document.getElementById('FirstName').innerHTML=firstName;
		document.getElementById('LastName').innerHTML=lastName;
		document.getElementById('email').innerHTML=email;
	}
</script>

</head>
<body onload="FillUserInfo()">
	<div class='AllContent'>
		<jsp:include page="Template/Header.jsp"/>
		<div class='PageContent'>
		<!-- All the page content must to be placed here -->
		
			<div class='UserDataContent'>
				<fieldset class='UserDataField'>
					<legend><b>Retrieved Info</b></legend>
					<span><b>First name: </b></span>
					<span id='FirstName'></span>
					<br />
					<span><b>Last name: </b></span>
					<span id='LastName'></span>
					<br/>
					<span><b>Email: </b></span>
					<span id='email'></span>
				</fieldset>
				
				<fieldset class='UserDataField'>
					<legend><b>User Info</b></legend>
					<span>Tell us about your interest in using the LALP compiler.</span><br /><br/>
					
					<span><b>Organization:</b></span><br>
					<input type="text" id="orgName" name="orgName"><br /><br/>
					
					<span><b>Comment:</b></span><br>
					<textarea id="why" name="why" rows="5" cols="60"></textarea>	
					
					<div>	
						<input class='btn' type="button" id="userData" name="userData" value="Submit" />
					</div>				
				</fieldset>
			</div>
			
		<!-- End of Page Content -->
		</div>
		<jsp:include page="Template/Footer.jsp"/>
	</div>
</body>
</html>