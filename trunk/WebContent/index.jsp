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
	   if (state == 'block') {
	       document.getElementById(id).style.display = 'none';
	   } else {
	       document.getElementById(id).style.display = 'block';
	   }
	}

</script>

<title>A Web Interface for the LALP Compiler</title>
</head>
<body>

	<h1>LALP Web Compiler</h1>
	<div id="submitForm" class="submitForm">
		<form id="file_upload">
			<fieldset>
				<legend>
					<b>Choose .alp file</b>
				</legend>
				<div id="drop_zone_1">
					<input id="file_1" type="file" name="file_1" multiple>
				</div>
				<input type="button" id="upload" name="upload" value="Upload File" onclick="toggle('compileArea');"/>
			</fieldset>
		</form>
	</div>
	<br />
	<div id="compileArea" class="compileArea" style="display: none">
				<fieldset>
					<legend>
						<b>Compilation Options</b>
					</legend>
	
	
	<input name="check" type="checkbox" id="as" value="-as" checked disabled="disabled" /> Run SCC algorithm <br />
	<input name="check" type="checkbox" id="ad" value="-ad" checked disabled="disabled" /> Run Dijkstra algorithm <br />
	<input name="check" type="checkbox" id="ao" value="-ao" checked disabled="disabled" /> Run Dominators algorithm <br />
	<input name="check" type="checkbox" id="aa" value="-aa" checked disabled="disabled" /> Run AsapAlap scheduling algorithm <br />
	<input name="check" type="checkbox" id="at" value="-at" checked disabled="disabled" /> Run Topological algorithm <br />
	<input name="check" type="checkbox" id="ab" value="-ab" checked disabled="disabled" /> Run Balance algorithm <br />
	<input name="check" type="checkbox" id="do" value="-do" checked disabled="disabled" /> Generate debug output pins <br />
	<input name="check" type="checkbox" id="gv" value="-gv" checked disabled="disabled" /> Generate Graphviz <br />
	<input name="check" type="checkbox" id="gs" value="-gs" checked disabled="disabled" /> Generate Graphviz subgraphs <br />
	<input name="check" type="checkbox" id="vh" value="-vh" checked disabled="disabled" /> Generate VHDL <br />
	<input name="check" type="checkbox" id="vi" value="-vi" checked disabled="disabled" /> Generate VHDL memory initialization <br />
	<input name="check" type="checkbox" id="vt" value="-vt" checked disabled="disabled" /> Generate VHDL testbench <br />
	<input name="check" type="checkbox" id="apg" value="-apg" checked disabled="disabled" /> Generate ALPG source code <br />
	<input name="check" type="checkbox" id="verbose" value="-verbose" checked disabled="disabled" /> Print verbose output <br />
	<input name="check" type="checkbox" id="version" value="-version" checked disabled="disabled" /> Print product version and exit <br />
	<input name="check" type="checkbox" id="gui" value="-gui" checked disabled="disabled" /> Commence the LALP GUI <br /><br />
	
	
	<!-- 				<input type="radio" id="r1" name="menu" value="-as">Run SCC -->
	<!-- 				Algorithm<br /> <input type="radio" id="r2" name="menu" value="-ad">Run -->
	<!-- 				Dijkstra Algorithm<br /> <input type="radio" id="r3" name="menu" -->
	<!-- 					value="-gv">Generate Graphviz -->
	<!-- 				<div id="graphMenu"> -->
	<!-- 					<input type="radio" id="r3sub1" name="subMenu" value="sw" checked>SW -->
	<!-- 					File <br /> <input type="radio" id="r3sub2" name="subMenu" -->
	<!-- 						value="hw">HW File -->
	<!-- 				</div> -->
			<input	type="button" id="compile" name="compile" value="Begin Compilation" onclick="toggle('codeArea')">
			</fieldset>
			</div><br />
	
	<div id="codeArea" style="display: none"><fieldset>
		<legend>
			<b>Compilation Files</b>
		</legend>
		<a href="#" onclick="toggle('sourceCode');">View Source File</a><br />
		<div id="sourceCode" class="sourceCode" style="display: none">
			<form id="downloadForm" action="DownloadServlet" method="post">
				<fieldset>
					<legend>
						<b>Source code</b>
					</legend>
					<textarea id="sourceCodeArea" name="sourceCode" rows="20"
						cols="100" onkeyup="newColor('red')"></textarea>
					<br /> File name: <input type="text" id="fileName" name="fileName">
					<input type="button" id="download" value="Download" onClick="newColor('blue')">
					
				</fieldset>
			</form>			
		</div>
		
		
		<a href="#" onclick="toggle('targetCode');">View dotprod.vhd</a><br />
		<div id="targetCode" class="targetCode" style="display: none">
			<form id="targetDownloadForm" action="DownloadServlet" method="get">
				<fieldset>
					<legend>
						<b>dotprod.vhd</b>
					</legend>
					<textarea id="targetCodeArea" name="targetCode" rows="20"
						cols="100" readonly></textarea>
					<br /> File name: <input type="text" id="targetFileName"
						name="fileName">
				</fieldset>
			</form>
			</div>
			
		<a href="#" onclick="toggle('_vhdCode');">View t_dotprod.vhd</a><br />
		<div id="_vhdCode" class="_vhdcode" style="display: none">
			<form id="_vhdDownloadForm" action="DownloadServlet" method="get">
				<fieldset>
					<legend>
						<b>t_dotprod.vhd</b>
					</legend>
					<textarea id="_vhdCodeArea" name="_vhdCode" rows="20"
						cols="100" readonly></textarea>
					<br /> File name: <input type="text" id="_vhdFileName"
						name="fileName"> 
				</fieldset>
			</form>
			</div>
			
		<a href="#" onclick="toggle('memoryCode');">View memory.vhd</a><br />
		<div id="memoryCode" class="memorycode" style="display: none">
			<form id="_memoryDownloadForm" action="DownloadServlet" method="get">
				<fieldset>
					<legend>
						<b>Memory.vhd</b>
					</legend>
					<textarea id="memoryCodeArea" name="memoryCode" rows="20"
						cols="100" readonly></textarea>
					<br /> File name: <input type="text" id="memoryFileName"
						name="fileName"> 		
			</form>
			</div>
		
		<div id="SVG">
		<a href="#" onclick="toggle('swSVG');">View SofwareSVG</a><br />
		<div id="swSVG" style="display: none"></div>
		<a href="#" onclick="toggle('hwSVG');">View HardwareSVG</a>
		<div id="hwSVG" style="display: none"></div></div><br />	
		
		<input type="button" id="downloadZipFile" value="Download all .vhd files" >
		<input type="button" id="refresh" value="New compilation"  onClick="history.go(0)">
		
		</fieldset>
	</div>
</body>
<footer>
LALP version 0.1, Copyright (c) 2011 Ricardo Menotti </footer>
</html>