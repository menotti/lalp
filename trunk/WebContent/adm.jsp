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

var path = "http://lalp.dc.ufscar.br:8080/lalp/";

function getUrlVars() {
    var vars = {};
    var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
        vars[key] = value;
    });
    return vars;
}

var dusr0 = getUrlVars()["dusr0"];
var dusr1 = getUrlVars()["dusr1"];
var dusr2 = getUrlVars()["dusr2"];
var dusr3 = getUrlVars()["dusr3"];
var dusr4 = getUrlVars()["dusr4"];

var eusr0 = getUrlVars()["eusr0"];
var eusr1 = getUrlVars()["eusr1"];
var eusr2 = getUrlVars()["eusr2"];
var eusr3 = getUrlVars()["eusr3"];
var eusr4 = getUrlVars()["eusr4"];

setTimeout(function() {getusr();},200);

function getusr(){
	$('#dusr0').val(dusr0);
	$('#dusr1').val(dusr1);
	$('#dusr2').val(dusr2);
	$('#dusr3').val(dusr3);
	$('#dusr4').val(dusr4);
	
	$('#eusr0').val(eusr0);
	$('#eusr1').val(eusr1);
	$('#eusr2').val(eusr2);
	$('#eusr3').val(eusr3);
	$('#eusr4').val(eusr4);
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
	<br /><textarea id="dusr0" name="dusr0" rows="1" cols="50" disabled="true"></textarea>
	<input name="check" type="checkbox" id="as0" value="dusr0" />
	<br /><textarea id="dusr1" name="dusr1" rows="1" cols="50" disabled="true"></textarea>
	<input name="check" type="checkbox" id="as1" value="dusr1" />
	<br /><textarea id="dusr2" name="dusr2" rows="1" cols="50" disabled="true"></textarea>
	<input name="check" type="checkbox" id="as2" value="dusr2" />
	<br /><textarea id="dusr3" name="dusr3" rows="1" cols="50" disabled="true"></textarea>
	<input name="check" type="checkbox" id="as3" value="dusr3" />
	<br /><textarea id="dusr4" name="dusr4" rows="1" cols="50" disabled="true"></textarea>
	<input name="check" type="checkbox" id="as4" value="dusr4" />
	
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
	<br /><textarea id="eusr0" name="dusr0" rows="1" cols="50" disabled="true"></textarea>
	<input name="check" type="checkbox" id="eas0" value="eusr0" />
	<br /><textarea id="eusr1" name="dusr1" rows="1" cols="50" disabled="true"></textarea>
	<input name="check" type="checkbox" id="eas1" value="eusr1" />
	<br /><textarea id="eusr2" name="dusr2" rows="1" cols="50" disabled="true"></textarea>
	<input name="check" type="checkbox" id="eas2" value="eusr2" />
	<br /><textarea id="eusr3" name="dusr3" rows="1" cols="50" disabled="true"></textarea>
	<input name="check" type="checkbox" id="eas3" value="eusr3" />
	<br /><textarea id="eusr4" name="dusr4" rows="1" cols="50" disabled="true"></textarea>
	<input name="check" type="checkbox" id="eas4" value="eusr4" />
	
	<br />
	<input type="button" id="previous" name="previouspage" value="<" onClick="epreviouspage();">
	<input type="button" id="next" name="nextpage" value=">" onClick="enextpage();">
	</div>
</fieldset>
<br />
<input type="button" id="submit" name="submit" value="Update!" onClick="updateusr();" >

</body>
</html>