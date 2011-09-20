<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript"
	src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
<script type="text/javascript" src="js/lalpArgs.js"></script>
<link rel="stylesheet" type="text/css" href="css/lalpHome.css"></link>
<title>A Web Interface for the LALP Compiler</title>
</head>
<body>
	<h1>LALP Web Compiler</h1>
	<div class="menuArgs">
		<h2>Options</h2>
		<form>
			<input id="r1" name="menu" type="radio" value="-as">run SCC	Algorithm<br /> 
			<input id="r2" name="menu" type="radio" value="-ad">run	Dijkstra Algorithm<br /> 
			<input id="rVersion" name="menu" type="radio" value="-version">view compiler version<br />
		</form>
	</div>
	<div class="submitForm">
		<form>
			<input id="submitBtn" type="button" value="Submit Choice" />
		</form>
	</div>
</body>
</html>