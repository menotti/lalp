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

/*var path = "http://localhost:9180/lalpProject/";*/
var path = "http://projetos.ppgcc.dc.ufscar.br:9180/lalp/";

function getUrlVars() {
    var vars = {};
    var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
        vars[key] = value;
    });
    return vars;
}

var dname0 = getUrlVars()["dname0"];
//dname0 = dname0.replace(/%20+/g,' ');
var dname1 = getUrlVars()["dname1"];
//dname1 = dname1.replace(/%20+/g,' ');
var dname2 = getUrlVars()["dname2"];
//dname2 = dname2.replace(/%20+/g,' ');
var dname3 = getUrlVars()["dname3"];
//dname3 = dname3.replace(/%20+/g,' ');
var dname4 = getUrlVars()["dname4"];
//dname4 = dname4.replace(/%20+/g,' ');

var dusr0 = getUrlVars()["dusr0"];
var dusr1 = getUrlVars()["dusr1"];
var dusr2 = getUrlVars()["dusr2"];
var dusr3 = getUrlVars()["dusr3"];
var dusr4 = getUrlVars()["dusr4"];

var dwhy0 = getUrlVars()["dwhy0"];
//dwhy0 = dwhy0.replace(/%20+/g,' ');
var dwhy1 = getUrlVars()["dwhy1"];
//dwhy1 = dwhy1.replace(/%20+/g,' ');
var dwhy2 = getUrlVars()["dwhy2"];
//dwhy2 = dwhy2.replace(/%20+/g,' ');
var dwhy3 = getUrlVars()["dwhy3"];
//dwhy3 = dwhy3.replace(/%20+/g,' ');
var dwhy4 = getUrlVars()["dwhy4"];
//dwhy4 = dwhy4.replace(/%20+/g,' ');

var ename0 = getUrlVars()["ename0"];
//ename0 = ename0.replace(/%20+/g,' ');
var ename1 = getUrlVars()["ename1"];
//ename1 = ename1.replace(/%20+/g,' ');
var ename2 = getUrlVars()["ename2"];
//ename2 = ename2.replace(/%20+/g,' ');
var ename3 = getUrlVars()["ename3"];
//ename3 = ename3.replace(/%20+/g,' ');
var ename4 = getUrlVars()["ename4"];
//ename4 = ename4.replace(/%20+/g,' ');

var eusr0 = getUrlVars()["eusr0"];
var eusr1 = getUrlVars()["eusr1"];
var eusr2 = getUrlVars()["eusr2"];
var eusr3 = getUrlVars()["eusr3"];
var eusr4 = getUrlVars()["eusr4"];

var ewhy0 = getUrlVars()["ewhy0"];
//ewhy0 = ewhy0.replace(/%20+/g,' ');
var ewhy1 = getUrlVars()["ewhy1"];
//ewhy1 = ewhy1.replace(/%20+/g,' ');
var ewhy2 = getUrlVars()["ewhy2"];
//ewhy2 = ewhy2.replace(/%20+/g,' ');
var ewhy3 = getUrlVars()["ewhy3"];
//ewhy3 = ewhy3.replace(/%20+/g,' ');
var ewhy4 = getUrlVars()["ewhy4"];
//ewhy4 = ewhy4.replace(/%20+/g,' ');

setTimeout(function() {getusr();},200);

function getusr(){
	
	if (dname0 != null) { dname0 = dname0.replace(/%20+/g,' '); }
	if (dname1 != null) { dname1 = dname1.replace(/%20+/g,' '); }
	if (dname2 != null) { dname2 = dname2.replace(/%20+/g,' '); }
	if (dname3 != null) { dname3 = dname3.replace(/%20+/g,' '); }
	if (dname4 != null) { dname4 = dname4.replace(/%20+/g,' '); }
	
	if (ename0 != null) { ename0 = ename0.replace(/%20+/g,' '); }
	if (ename1 != null) { ename1 = ename1.replace(/%20+/g,' '); }
	if (ename2 != null) { ename2 = ename2.replace(/%20+/g,' '); }
	if (ename3 != null) { ename3 = ename3.replace(/%20+/g,' '); }
	if (ename4 != null) { ename4 = ename4.replace(/%20+/g,' '); }
	
	if (dwhy0 != null) { dwhy0 = dwhy0.replace(/%20+/g,' '); }
	if (dwhy1 != null) { dwhy1 = dwhy1.replace(/%20+/g,' '); }
	if (dwhy2 != null) { dwhy2 = dwhy2.replace(/%20+/g,' '); }
	if (dwhy3 != null) { dwhy3 = dwhy3.replace(/%20+/g,' '); }
	if (dwhy4 != null) { dwhy4 = dwhy4.replace(/%20+/g,' '); }
	
	if (ewhy0 != null) { ewhy0 = ewhy0.replace(/%20+/g,' '); }
	if (ewhy1 != null) { ewhy1 = ewhy1.replace(/%20+/g,' '); }
	if (ewhy2 != null) { ewhy2 = ewhy2.replace(/%20+/g,' '); }
	if (ewhy3 != null) { ewhy3 = ewhy3.replace(/%20+/g,' '); } 
	if (ewhy4 != null) { ewhy4 = ewhy4.replace(/%20+/g,' '); }
	
	$('#dname0').val(dname0);
	$('#dname1').val(dname1);
	$('#dname2').val(dname2);
	$('#dname3').val(dname3);
	$('#dname4').val(dname4);
	
	$('#dusr0').val(dusr0);
	$('#dusr1').val(dusr1);
	$('#dusr2').val(dusr2);
	$('#dusr3').val(dusr3);
	$('#dusr4').val(dusr4);
	
	$('#dwhy0').val(dwhy0);
	$('#dwhy1').val(dwhy1);
	$('#dwhy2').val(dwhy2);
	$('#dwhy3').val(dwhy3);
	$('#dwhy4').val(dwhy4);
	
	
	$('#ename0').val(ename0);
	$('#ename1').val(ename1);
	$('#ename2').val(ename2);
	$('#ename3').val(ename3);
	$('#ename4').val(ename4);
	
	$('#eusr0').val(eusr0);
	$('#eusr1').val(eusr1);
	$('#eusr2').val(eusr2);
	$('#eusr3').val(eusr3);
	$('#eusr4').val(eusr4);
	
	$('#ewhy0').val(ewhy0);
	$('#ewhy1').val(ewhy1);
	$('#ewhy2').val(ewhy2);
	$('#ewhy3').val(ewhy3);
	$('#ewhy4').val(ewhy4);
}

function updateusr(){
	
    var dmyarray = [];
    $("#ddiv input:checked").each(function() {
        dmyarray.push($(this).val());
     });
    
    var emyarray = [];
    $("#ediv input:checked").each(function() {
        emyarray.push($(this).val());
     });

	$.ajax({
		url : 'admServlet',
		type : 'POST',
		data : {
			dusr0 : dusr0,
			dusr1 : dusr1,
			dusr2 : dusr2,
			dusr3 : dusr3,
			dusr4 : dusr4,
			'dargs[]' : dmyarray,
			eusr0 : eusr0,
			eusr1 : eusr1,
			eusr2 : eusr2,
			eusr3 : eusr3,
			eusr4 : eusr4,
			'eargs[]' : emyarray
		},
		error : function() {
			//alert("erro");
			window.location = path + "adm";
		},
		success: function(data) {
			//alert("sucesso");
			window.location = path + "adm";
			
		}
	});
}

function dnextpage() {
	
	var dpage = getUrlVars()["dpage"];
	var epage = getUrlVars()["epage"];
	dpage++;
	window.location = path + "adm?dpage=" + dpage + "&epage=" + epage;
}

function dpreviouspage() {
	
	var dpage = getUrlVars()["dpage"];
	var epage = getUrlVars()["epage"];
	if (dpage > 0){
		dpage = dpage - 1;
		window.location = path + "adm?dpage=" + dpage + "&epage=" + epage;
	}
	else {
		alert("No previous page!");
	}
}

function enextpage() {
	
	var dpage = getUrlVars()["dpage"];
	var epage = getUrlVars()["epage"];
	epage++;
	window.location = path + "adm?dpage=" + dpage + "&epage=" + epage;
}

function epreviouspage() {
	
	var dpage = getUrlVars()["dpage"];
	var epage = getUrlVars()["epage"];
	if (epage > 0){
		epage = dpage - 1;
		window.location = path + "adm?dpage=" + dpage + "&epage=" + epage;
	}
	else {
		alert("No previous page!");
	}
}

</script>

<title>Lalp Web Compiler</title>
</head>
<body>
<h1>LALP Web Compiler - User Control</h1>
<fieldset><legend> <b>Disabled users</b> </legend>
 	<div id="ddiv">	
	Check the users you wanna enable:
	<br />
	<br /><input name="check" type="checkbox" id="as0" value="dusr0" />
	<textarea id="dname0" name="dname0" rows="1" cols="50" disabled="true"></textarea>
	<textarea id="dusr0" name="dusr0" rows="1" cols="25" disabled="true"></textarea>
	<textarea id="dwhy0" name="dwhy0" rows="1" cols="60" disabled="true"></textarea>
	
	<br /><input name="check" type="checkbox" id="as1" value="dusr1" />
	<textarea id="dname1" name="dname1" rows="1" cols="50" disabled="true"></textarea>
	<textarea id="dusr1" name="dusr1" rows="1" cols="25" disabled="true"></textarea>
	<textarea id="dwhy1" name="dwhy1" rows="1" cols="60" disabled="true"></textarea>
	
	<br /><input name="check" type="checkbox" id="as2" value="dusr2" />
	<textarea id="dname2" name="dname2" rows="1" cols="50" disabled="true"></textarea>
	<textarea id="dusr2" name="dusr2" rows="1" cols="25" disabled="true"></textarea>
	<textarea id="dwhy2" name="dwhy2" rows="1" cols="60" disabled="true"></textarea>
	
	
	
	<br /><input name="check" type="checkbox" id="as3" value="dusr3" />
	<textarea id="dname3" name="dname3" rows="1" cols="50" disabled="true"></textarea>
	<textarea id="dusr3" name="dusr3" rows="1" cols="25" disabled="true"></textarea>
	<textarea id="dwhy3" name="dwhy3" rows="1" cols="60" disabled="true"></textarea>
	
	
	
	<br /><input name="check" type="checkbox" id="as4" value="dusr4" />
	<textarea id="dname4" name="dname4" rows="1" cols="50" disabled="true"></textarea>
	<textarea id="dusr4" name="dusr4" rows="1" cols="25" disabled="true"></textarea>
	<textarea id="dwhy4" name="dwhy4" rows="1" cols="60" disabled="true"></textarea>
	
	<br />
	<input type="button" id="previous" name="previouspage" value="<" onClick="dpreviouspage();">
	<input type="button" id="next" name="nextpage" value=">" onClick="dnextpage();">

	</div>
</fieldset>
<br />
<fieldset><legend> <b>Enabled users</b> </legend>	
	<div id="ediv">	
	Check the users you wanna disable:
	<br />
	<br /><input name="check" type="checkbox" id="eas0" value="eusr0" />
	<textarea id="ename0" name="ename0" rows="1" cols="50" disabled="true"></textarea>
	<textarea id="eusr0" name="dusr0" rows="1" cols="25" disabled="true"></textarea>
	<textarea id="ewhy0" name="ewhy0" rows="1" cols="60" disabled="true"></textarea>
	
	
	
	<br /><input name="check" type="checkbox" id="eas1" value="eusr1" />
	<textarea id="ename1" name="ename1" rows="1" cols="50" disabled="true"></textarea>
	<textarea id="eusr1" name="dusr1" rows="1" cols="25" disabled="true"></textarea>
	<textarea id="ewhy1" name="ewhy1" rows="1" cols="60" disabled="true"></textarea>
	
	
	
	<br /><input name="check" type="checkbox" id="eas2" value="eusr2" />
	<textarea id="ename2" name="ename2" rows="1" cols="50" disabled="true"></textarea>
	<textarea id="eusr2" name="dusr2" rows="1" cols="25" disabled="true"></textarea>
	<textarea id="ewhy2" name="ewhy2" rows="1" cols="60" disabled="true"></textarea>
	
	
	
	<br /><input name="check" type="checkbox" id="eas3" value="eusr3" />
	<textarea id="ename3" name="ename3" rows="1" cols="50" disabled="true"></textarea>
	<textarea id="eusr3" name="dusr3" rows="1" cols="25" disabled="true"></textarea>
	<textarea id="ewhy3" name="ewhy3" rows="1" cols="60" disabled="true"></textarea>
	
	
	<br /><input name="check" type="checkbox" id="eas4" value="eusr4" />
	<textarea id="ename4" name="ename4" rows="1" cols="50" disabled="true"></textarea>
	<textarea id="eusr4" name="dusr4" rows="1" cols="25" disabled="true"></textarea>
	<textarea id="ewhy4" name="ewhy4" rows="1" cols="60" disabled="true"></textarea>
	
	
	
	
	<br />
	<input type="button" id="previous" name="previouspage" value="<" onClick="epreviouspage();">
	<input type="button" id="next" name="nextpage" value=">" onClick="enextpage();">
	</div>
</fieldset>
<br />
<input type="button" id="submit" name="submit" value="Update!" onClick="updateusr();" >

</body>
</html>