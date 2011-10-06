<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="css/custom-file.css"></link>
	<link rel="stylesheet" type="text/css" href="css/lalpHome.css"></link>
	<script type="text/javascript" src="js/head.min.js"></script>
	<script>
		head.js(//"http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js",
				"js/jquery-1.6.4.min.js",
				"js/jQuery.fileinput.js",
				"js/lalpArgs.js");						
	</script>
<title>A Web Interface for the LALP Compiler</title>
</head>
<body>
	<h1>LALP Web Compiler</h1>
	<div id="menuArgs" class="menuArgs">
		<form>
		<b>Options</b>
		<fieldset>		
			<input type="radio" id="r1" name="menu"  value="-as">run SCC Algorithm<br /> 
			<input type="radio" id="r2" name="menu"  value="-ad">run Dijkstra Algorithm<br /> 			
		</fieldset>
		</form>
	</div>
	<br />
	<div id="submitForm" class="submitForm">
		<form>
		<b>Choose .alp file</b>
			<fieldset>
				<input type="file" id="file" name="file" class="file" onchange="handleFiles(this.files);" />			
				<input type="button" name="upload" id="upload" value="Start Compilation" />
			</fieldset>
		</form>
	</div>
	<br />
	<div id="sourceCode" class="sourceCode">
	<form>
	<b>Source Code:</b>	
	<fieldset>	
	<textarea id="sourceCodeArea" disabled="disabled" rows="25" cols="50">	
	</textarea>
	</fieldset>
	</form>
	</div>
</body>
<footer>
LALP version 0.1, Copyright (c) 2011 Ricardo Menotti
</footer>
</html>