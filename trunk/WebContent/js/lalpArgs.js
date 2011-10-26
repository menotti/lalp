/* global vars */
var selected = false;
var graphviz = false;
var args = new Array();
$('#graphMenu').hide();

// parameters
var menuArgs = $('form input:radio[name=menu]');
menuArgs.click(function() { // select radio list option
	args[0] = $(this).val();
	if (args[0] == "-gv") {
		graphviz = true;		
		$('#graphType').val($('form input:radio[name=subMenu]').val());
		$('#graphMenu').show();
	} else {
		graphviz = false;
		$('#graphMenu').hide();
	}		
});

var graphMenuArgs = $('form input:radio[name=subMenu]');
graphMenuArgs.click(function() { // select radio list option	
	$('#graphType').val($(this).val());
});

// download source code
$('#download').click(function() {
	$('#downloadForm').submit();
});

// download target code
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
			data = data.replace(/^<pre.*>/m, "");
			// data = data.replace("<pre>", "");
			data = data.replace("</pre>", "");
			data = data.trim();
			$('#sourceCodeArea').html(data);
			$('#graphCode').html(data);
			fileName = $('form input:file').val();
			$('#fileName').val(fileName);
			$('#graphFileName').val(fileName);
			$('#targetCodeArea').html('');
		},
		error : function(data, status, e) {
			alert(e);
		}
	});
});

$('#compile').attr('disabled', false);
$('#compile').click(
		function() {
			if (graphviz) {			
				$('#graphForm').submit();							
			} else {
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
						$('#targetFileName').val(
								$('#fileName').val().replace(".alp", ".vhd"));
					}
				});
			}

		});