/* global vars */
var selected = false;
var uploaded = false;
var extension = false;
var args = new Array();

// parameters
var menuArgs = $('form input:radio');
menuArgs.click(function() { // select radio list option
	for ( var i = 0; i < menuArgs.length; i++) {
		var j = 0;
		if (menuArgs[i].checked) {
			selected = true;
			args[j] = menuArgs[i].value.toString();
		}
	}
});

//download source code
$('#download').click(function() {
	$('#downloadForm').submit();
});

//download target code
$('#targetDownload').click(function() {
	$('#targetDownloadForm').submit();
});

$('#upload').click(function() {
	$.ajaxFileUpload({
		url : 'UploadServlet',
		secureuri : false,
		fileElementId : 'file_1',
		dataType : 'multipart/form-data',
		success : function(data, status) {
			data = data.replace(/^<pre.*>/m,"");
			//data = data.replace("<pre>", "");
			data = data.replace("</pre>", "");
			data = data.trim();
			$('#sourceCodeArea').html(data);
			$('#fileName').val($('form input:file').val());
		},
		error : function(data, status, e) {
			alert(e);
		}
	});
});

$('#compile').attr('disabled', false);
$('#compile').click(function() {
	$.ajax({
		url : 'LALPServlet',
		type : 'POST',
		data : {
			'args[]' : args,
			fileName : $('#fileName').val(),
			sourceCode : $('#sourceCodeArea').val()
		},
		error : function() {
			alert('AJAX: Response from server failed!');
		},
		success : function(data) {
			$('#targetCodeArea').html('');
			$('#targetCodeArea').html(data);
			$('#targetFileName').val($('#fileName').val().replace(".alp", ".vhd"));
		}
	});
});