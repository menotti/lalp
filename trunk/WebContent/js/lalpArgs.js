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

$('#upload').click(function() {
	$.ajaxFileUpload({
			url : 'UploadServlet',
			secureuri : false,
			fileElementId : 'file_1',
			dataType : 'multipart/form-data',
			success : function(data, status) {
				$('#sourceCodeArea').html(data);
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
			length : args.length
		},
		error : function() {
			alert('AJAX: Response from server failed!');
		},
		success : function(data) {
			alert(data);
		}
	});
});
