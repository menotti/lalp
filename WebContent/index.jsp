<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="css/lalpHome.css"></link>
<script type="text/javascript" src="js/head.min.js"></script>
<script>
	head.js("js/jquery-1.6.4.min.js",
	//"http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js",
	//"http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.9/jquery-ui.min.js",	
	"js/ajaxfileupload.js", "js/lalpArgs.js");
	/*"http://connect.facebook.net/en_US/all.js", head.ready(function() {
				FB.init({
					appId : '286442874716822',
					cookie : true,
					status : true,
					xfbml : true
				});
			}));*/
</script>
<script type="text/javascript">
function newColor(color)
{
document.getElementById('sourceCodeArea').style.color=color;
}
</script>
<title>A Web Interface for the LALP Compiler</title>
</head>
<body>
	<h1>LALP Web Compiler</h1>

	<div id="menuArgs" class="menuArgs">
		<form>
			<fieldset>
				<legend>
					<b>Options</b>
				</legend>
				<input type="radio" id="r1" name="menu" value="-as">Run SCC
				Algorithm<br /> <input type="radio" id="r2" name="menu" value="-ad">Run
				Dijkstra Algorithm<br />
			</fieldset>
		</form>
	</div>
	<br />

	<div id="submitForm" class="submitForm">
		<form id="file_upload">
			<fieldset>
				<legend>
					<b>Choose .alp file</b>
				</legend>
				<div id="drop_zone_1">
					<input id="file_1" type="file" name="file_1" multiple>
				</div>
				<input type="button" id="upload" name="upload" value="Upload File" />
			</fieldset>
		</form>
	</div>
	<br />

	<div id="sourceCode" class="sourceCode">
		<form id="downloadForm" action="DownloadServlet" method="post">
			<fieldset>
				<legend>
					<b>Source code</b>
				</legend>
				<textarea id="sourceCodeArea" name="sourceCode" rows="20" cols="100" onkeyup="newColor('red')"></textarea>
				<br /> File name: <input id="fileName" type="text" name="fileName">
				<input id="download" type="button" value="Download"> <input
					type="button" id="compile" name="compile" value="Begin Compilation"
					disabled="disabled">
			</fieldset>
		</form>
		<!-- 		<iframe -->
		<!-- 			src="http://www.facebook.com/plugins/like.php?href=http://200.18.98.61:8080/lalp" -->
		<!-- 			scrolling="no" frameborder="0" style="border: none; width: 450px;"></iframe> -->
	</div>
</body>
<footer> <!-- <div id="fb-root"> --> <!-- 	<fb:login-button>Login with Facebook</fb:login-button> -->
<!-- </div> --> <br />
LALP version 0.1, Copyright (c) 2011 Ricardo Menotti </footer>
</html>