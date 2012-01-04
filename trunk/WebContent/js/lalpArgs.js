/* global vars */
var selected = false;
var args = new Array();

// user args not working yet
/*
 * $('#graphMenu').hide(); var menuArgs = $('form input:radio[name=menu]');
 * menuArgs.click(function() { // select radio list option args[0] =
 * $(this).val(); if (args[0] == "-gv") { graphviz = true;
 * $('#graphType').val($('form input:radio[name=subMenu]').val());
 * $('#graphMenu').show(); } else { graphviz = false; $('#graphMenu').hide(); }
 * });
 * 
 * var graphMenuArgs = $('form input:radio[name=subMenu]');
 * graphMenuArgs.click(function() { // select radio list option
 * $('#graphType').val($(this).val()); });
 */

// download source code
$('#download').click(function() {
	$('#downloadForm').submit();
});

// download target code
$('#targetDownload').click(function() {
	$('#targetDownloadForm').submit();
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
	}, 5000); // waits 5sec after compilation to create SVG files (assures that .dot file was already created)	
});

/* AJAX & SVG */
function requestVHD() {
	$.ajax({
		url : 'LALPServlet',
		type : 'POST',
		data : {
			'args[]' : args,
			fileName : $('#fileName').val(),
			sourceCode : $('#sourceCodeArea').val(),
		},
		error : function() {
			alert('AJAX: Response from server failed!');
		},
		success : function(data) {
			$('#targetCodeArea').html(data);
			$('#_vhdCodeArea').html(data);
			$('#targetFileName').val(
					$('#fileName').val().replace(".alp", ".vhd"));
			$('#_vhdFileName').val('t_' +
					$('#fileName').val().replace(".alp", ".vhd"));
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
