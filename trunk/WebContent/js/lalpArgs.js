/* global vars */

//var path = "http://localhost:8080/";
var path = "http://lalp.dc.ufscar.br:9180/lalp/";

var selected = false;
var args = new Array();
var lastName = ""; 
var fistName = "";
var emailL = "";
var urlindex = window.location.href.replace('userData.jsp','index.jsp');

window.onload = function(){
    lastName = document.getElementById('LastName').innerHTML;
    fistName = document.getElementById('FirstName').innerHTML;
    emailL = document.getElementById('email').innerHTML;
};


// download source code
$('#download').click(function() {
	$('#downloadForm').submit();
});

$('#userData').click(function(e) {
	sendUserData();
});

function sendUserData() {
	$.ajax({
		url : 'DATAServlet',
		type : 'POST',
		data : {
			first : fistName,
			last : lastName,
			email : emailL,
			org : $('#orgName').val(),
			why : $('#why').val(),
			url : urlindex
		},
		error : function() {
			window.location = (path + "index.jsp");
		},
		success : function() {
		    window.location = (path + "registeredUser.jsp");
		}
	});
}

function getUrlVars() {
  	 var vars = {};
   	 var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
   	    vars[key] = value;
 	 });
	 return vars;
	}

$('#downloadVhd').click(function(e) {
    e.preventDefault(); 
    location.href = './' + emailL + '/lalp/' + $('#fileName').val().replace(".alp", ".vhd");
    
});

$('#download_Vhd').click(function(e) {
    e.preventDefault();
    location.href = './' + emailL + '/lalp/' + 't_' + $('#fileName').val().replace(".alp", ".vhd");
});

$('#downloadMemo').click(function(e) {
    e.preventDefault();
    location.href = './' + emailL + '/lalp/' + 'memory.vhd';
});

$('#downloadZip').click(function(e) {
    e.preventDefault();
    location.href = './' + emailL + '/' + 'LalpFiles.zip';
});

// download target code
$('#targetDownload').click(function() {
	$('#targetDownloadForm').submit();
});

$('#downloadZipFile').click(function() {
	var zip = new JSZip();
    zip.add("sourceCode.alp", $('#sourceCodeArea').val());
    zip.add("dotprod.vhd", $('#targetCodeArea').val());
    zip.add("t_dotprod.vhd", $('#_vhdCodeArea').val());
    zip.add("memory.vhd", $('#memoryCodeArea').val());
    content = zip.generate();
    location.href="data:application/zip;base64," + content;
});

$('#_vhdDownload').click(function() {
	$('#_vhdDownloadForm').submit();
});


// upload .alp file
$('#upload').click(function() {
	$.ajaxFileUpload({
		url : 'UploadServlet',
		secureuri : false,
		fileElementId : 'file_1',
		dataType : 'multipart/form-data',
		success : function(data, status) {
			data = data.replace(/^<pre.*>/m, "");
			// data = data.replace("<pre>", "");
			data = data.replace("</pre>", "");
			data = data.trim();
			$('#sourceCodeArea').html(data);
			fileName = $('form input:file').val();
			$('#fileName').val(fileName);
			$('#targetCodeArea').html('');
		},
		error : function(data, status, e) {
			alert(e);
		}
	});
});



$('#compile').attr('disabled', false);
// compiles once and generate all files; SVG files are created from dot files
$('#compile').click(function() {
	requestVHD();
	setTimeout(function() {
		requestSVG('sw');
		requestSVG('hw');
	}, 5000);
	// waits 5sec after compilation to create SVG files (assures that .dot file was already created)
	doLoad();
});

function IO(U) {
    var X = !window.XMLHttpRequest ? new ActiveXObject('Microsoft.XMLHTTP') : new XMLHttpRequest();
    X.open('GET', U, false );
    X.setRequestHeader('Content-Type', 'text/html');
    X.send('');
return X.responseText;
}	

function doLoad(){
	document.getElementById("memoryCodeArea").value = IO("memory.vhd");
	document.getElementById("_vhdCodeArea").value = IO($('#_vhdFileName').val()); 
}

/* AJAX & SVG */
function requestVHD() {
	var user = document.getElementById('email').innerHTML;

	$.ajax({
		url : 'LALPServlet',
		type : 'POST',
		data : {
			'args[]' : args,
			fileName : $('#fileName').val(),
			sourceCode : $('#sourceCodeArea').val(),
			userEmail : emailL
		},
		error : function() {
			alert('AJAX: Response from server failed!');
		},
		success : function(data) {
			$('#targetCodeArea').html(data);
			//$('#_vhdCodeArea').html(data);
			$('#targetFileName').val(
					$('#fileName').val().replace(".alp", ".vhd"));
			$('#_vhdFileName').val('t_' +
					$('#fileName').val().replace(".alp", ".vhd"));
			$('#memoryFileName').val('memory.vhd');
		}
	});
}

function requestSVG(graphType) {
	args = null; // not working yet
	sourceCode = $('#sourceCodeArea').val();
	fileName = $('#fileName').val();
	if (graphType == 'sw') {
		$('#swSVG').svg();
		$('#swSVG').load('LALPServlet?&fileName=' + fileName + '&graphType=' + graphType);
	} else if (graphType == 'hw') {
		$('#hwSVG').svg();
		$('#hwSVG').load('LALPServlet?&fileName=' + fileName + '&graphType=' + graphType);
	}
}


