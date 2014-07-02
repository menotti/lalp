<%@page import="org.json.JSONObject"%>
<%@page import="br.ufscar.dc.lalp.web.GoogleAuthHelper"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link type="text/css" rel=StyleSheet href="css/style.css">
<link type="image/ico" rel="icon" href="images/favicon.ico">

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
            
            JSONObject json = new JSONObject(session.getAttribute("ApplicationUserData").toString());
            
            given_name = json.getString("given_name");
            family_name = json.getString("family_name");
            email = json.getString("email");     
    }
%>


<script type="text/javascript" src="js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="js/head.min.js"></script>
<script type="text/javascript" src="js/jszip.js"/></script>
<script type="text/javascript" src="js/compilerPage.js"/></script>

<script>
	head.js("js/jquery-1.6.4.min.js",
			"js/jquery.svg.package-1.4.4/jquery.svg.js",
			"js/ajaxfileupload.js", 
			"js/lalpArgs.js"
			//"http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js",
			//"http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.9/jquery-ui.min.js",	
			);
                
        $(document).ready(function(){
            document.getElementById('FirstName').innerHTML= "<%=given_name%>";
            document.getElementById('LastName').innerHTML= "<%=family_name%>";
            document.getElementById('email').innerHTML="<%=email%>";
        });
</script>


<title>LALP - Compiler</title>
</head>
<body>
        <div class="Hide">
            <span id="FirstName"></span>
            <span id="LastName"></span>
            <span id="email"></span>
        </div>
    
	<div class='AllContent' id='AllContent'>
		<jsp:include page="Template/Header.jsp"/>
		<div class='PageContent'>
		<!-- All the page content must to be placed here -->
		
		<div class="CompilerContent">
			<div class="CompilerContentTop">
				<div class="CompilerTitle">
					<center><h3>Welcome to LALP Compiler</h3></center>
				</div>
				
				<div class="CompilerWorkspace"> 
					<div class="CWLeft">
						<div class="CWExemple">
							<span>Select one sample:</span>
							<br>
							<select id='fooBar'></select>
						</div>
						
						<div class="CWUpload">
							<form id="file_upload">
								<div id="drop_zone_1">
									<span>Source upload:</span>
									<br>
									<input id="file_1" type="file" name="file_1">
									<br>
									<br>
									<input type="button" id="upload" name="upload" value="Upload File" >
								</div>
							</form>
						</div>
					</div>
					
					<div class="CWRight">
						<div id="sourceCode" class="sourceCode">
						
							<form id="downloadForm" action="DownloadServlet" method="post">
							
								<div class="CWCode">
									<textarea id="sourceCodeArea" name="sourceCode" rows="20" onkeyup="newColor('red')"></textarea>
								</div>
							
								<div class="CWButtons">
									
									<div class="CWCompile">
										<input	type="button" id="compile" name="compile" value="Compile" onclick="toggle('CompilerContentBottom');" />
									</div>
									<div class="CWOptions" id="CWOptions">
										<div id="compOptions" class="compOptions">
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
										</div>
										<input type='button' id='hsOptions' value='Compilation Options'>
									</div>
									<div class="CWDownload">
										<input type="text" id="fileName" name="fileName" readonly="readonly"/>
										<input type="button" id="download" value="Download" onClick="newColor('blue')"/>
									</div>
								</div>
								
							</form>
										
						</div>
						
					</div>
				</div>
				
				<div id="CompilerContentBottom" class="CompilerContentBottom">
					<fieldset>
						<legend><b>Compilation Results</b></legend>
						<div id="compilationFiles" class="targetCode">
							<span>Files: </span>
							<br>
							<input	type="button" id="downloadVhd" name="downloadVhd" value="Download .vhd file" ><br />
							<input	type="button" id="download_Vhd" name="download_Vhd" value="Download .vhd test file" ><br />
							<input	type="button" id="downloadMemo" name="downloadMemo" value="Download .vhd memory file" ><br />
							<input	type="button" id="downloadZip" name="downloadZip" value="Download all files (.zip)" ><br />
							<input	type="button" id="ssvgview" name="ssvgview" onclick="openSVGWindow('swSVG')" value="View SoftwareSVG" ><br />
							<div class='svgHide'>
								<div id="swSVG"></div>
							</div>
							<input	type="button" id="svgview" name="svgview" onclick="openSVGWindow('hwSVG')" value="View HardwareSVG" ><br />
							<div class='svgHide'>
								<div id="hwSVG"></div>
							</div>
						</div>
						
						<div class="compilationLog">
							<span>Log: </span>
							<br>
							<textarea id="logArea" name="log" rows="20" cols="100"></textarea>
						</div>
					</fieldset>
			</div>
		</div>

			
			<!-- Version -->
			<div class="clear"></div>
			<span id="version" class="version"></span>
			
			<!-- End of Page Content -->
		</div>
	</div>
			
			<jsp:include page="Template/Footer.jsp"/>
		</div>
</body>
</html>
