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
<script language="JavaScript">

function newColor(color)
{
document.getElementById('sourceCodeArea').style.color=color;
}

function toggle(id) {
	   var state = document.getElementById(id).style.display;
	   document.getElementById(id).style.display = 'block';
}
	
function toggle1(id) {
	   var state = document.getElementById(id).style.display;
	   if (state == 'block') {
	       document.getElementById(id).style.display = 'none';
	   } else {
	       document.getElementById(id).style.display = 'block';
	   }
}

function getUrlVars() {
    var vars = {};
    var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
        vars[key] = value;
    });
    return vars;
}

var email = getUrlVars()["openid.ext1.value.email"];

if (email == null) {
	window.location = "http://lalp.dc.ufscar.br:8080/lalp/index.html";
}

email = email.replace('%40','@');

setTimeout(function() {checkUserRole();},200);

function checkUserRole() {
	$.ajax({
		url : 'DATACheckServlet',
		type : 'POST',
		data : {
			email : email,
			index : "0"
		},
		error : function() {
			var urlindex = window.location.href.replace('index.jsp','userData.jsp');
			window.location = urlindex;
		},
		success: function() {
		}
	});
}


</script>

<title>Lalp Web Compiler</title>
</head>
<body>

	<h1>LALP Web Compiler</h1>
	<fieldset>
				<legend><b>Source Code</b></legend>
	<div id="submitForm" class="submitForm">
		<form id="file_upload">
			
				Enter the ALP code in the box bellow or upload an .alp file from your computer: <br /><br />
				
				<div id="drop_zone_1">
					Source upload: <input id="file_1" type="file" name="file_1" multiple>
					<input type="button" id="upload" name="upload" value="Upload File" >
				</div></form></div>
				
				<div id="sourceCode" class="sourceCode">
					<form id="downloadForm" action="DownloadServlet" method="post">
					
							<textarea id="sourceCodeArea" name="sourceCode" rows="20"
								cols="100" onkeyup="newColor('red')"></textarea>
								<input	type="button" id="compile" name="compile" value="Compile!" onclick="toggle('compilationFiles');" >
							<br /> Source download: <input type="text" id="fileName" name="fileName">
							<input type="button" id="download" value="Download" onClick="newColor('blue')">

					</form>			
				</div>
				<br /><b>Compilation Options: </b><br /><br /> 
				<input name="check" type="checkbox" id="as" value="-as" checked  /> Run SCC algorithm<br />  
				<input name="check" type="checkbox" id="ad" value="-ad" checked  /> Run Dijkstra algorithm<br />
				<input name="check" type="checkbox" id="ao" value="-ao" checked  /> Run Dominators algorithm <br />
				<input name="check" type="checkbox" id="aa" value="-aa" checked  /> Run AsapAlap scheduling algorithm <br />
				<input name="check" type="checkbox" id="at" value="-at" checked  /> Run Topological algorithm <br />
				<input name="check" type="checkbox" id="ab" value="-ab" checked  /> Run Balance algorithm <br />
				<input name="check" type="checkbox" id="gv" value="-gv" checked  /> Generate Graphviz <br />
				<input name="check" type="checkbox" id="gs" value="-gs" checked  /> Generate Graphviz subgraphs <br />
				<input name="check" type="checkbox" id="vh" value="-vh" checked  /> Generate VHDL <br />
				<input name="check" type="checkbox" id="vi" value="-vi" checked  /> Generate VHDL memory initialization <br />
				<input name="check" type="checkbox" id="vt" value="-vt" checked  /> Generate VHDL testbench <br />
				<input name="check" type="checkbox" id="verbose" value="-verbose" checked  /> Print verbose output <br />
			</fieldset>
	<br />
	
	<div id="compilationFiles" class="targetCode" style="display: none">
		<fieldset><legend><b>Compilation Files</b></legend>
			<input	type="button" id="downloadVhd" name="downloadVhd" value="Download .vhd file                 " > <br />
			<input	type="button" id="download_Vhd" name="download_Vhd" value="Download .vhd test file         " > <br />
			<input	type="button" id="downloadMemo" name="downloadMemo" value="Download .vhd memory file" > <br />
			<!-- <input	type="button" id="downloadZip" name="downloadZip" value="Download all files (.zip)        " > <br /> -->
			<input	type="button" id="ssvgview" name="ssvgview" onclick="toggle1('swSVG');" value="View SoftwareSVG                " > <br />
			<div id="swSVG" style="display: none"></div>
			<input	type="button" id="svgview" name="svgview" onclick="toggle1('hwSVG');" value="View HardwareSVG              " > <br />
			<div id="hwSVG" style="display: none"></div>	
		</fieldset>
	</div>
		
	<!-- 				<input type="radio" id="r1" name="menu" value="-as">Run SCC -->
	<!-- 				Algorithm<br /> <input type="radio" id="r2" name="menu" value="-ad">Run -->
	<!-- 				Dijkstra Algorithm<br /> <input type="radio" id="r3" name="menu" -->
	<!-- 					value="-gv">Generate Graphviz -->
	<!-- 				<div id="graphMenu"> -->
	<!-- 					<input type="radio" id="r3sub1" name="subMenu" value="sw" checked>SW -->
	<!-- 					File <br /> <input type="radio" id="r3sub2" name="subMenu" -->
	<!-- 						value="hw">HW File -->
	<!-- 				</div> -->
			
	

		
</body>
<footer>
LALP version 0.1, Copyright (c) 2012 Ricardo Menotti </footer>
</html>