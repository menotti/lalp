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

$('#download').click(function() {
	$('#downloadForm').submit();
});

$('#upload').click(function() {
	$.ajaxFileUpload({
		url : 'UploadServlet',
		secureuri : false,
		fileElementId : 'file_1',
		dataType : 'multipart/form-data',
		success : function(data, status) {
			data = data.replace(/^<pre.*\n?/m,"");
			//data = data.replace("<pre>", "");
			data = data.replace("</pre>", "");
			data = data.trim();
			$('#sourceCodeArea').val(data);			
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
			sourceCode : $('#sourceCodeArea').val()
		},
		error : function() {
			alert('AJAX: Response from server failed!');
		},
		success : function(data) {
			alert(data);
		}
	});
});