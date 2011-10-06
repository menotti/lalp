/* global vars */
var selected = false;
var uploaded = false;
var extension = false;
var args = new Array();

$(this).ready(function() {

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

// .alp file upload
$('#file').customFileInput();


// start compilation
$('#upload').click(function() { // send parameters
	/*var reader = new FileReader();
	reader.readAsText($('#file').data());
	$('#sourceCodeArea').val(reader);*/
	//alert(this.files);
	if ($('#file').val().toString().length > 0) {
		uploaded = true;
		if ($('#file').val().toString().substring($('#file').val().toString().length - 4, $('#file').val().toString().length) == '.alp') {
			extension = true;
		} else extension = false;
	} else {
		uploaded = false;
	}	
	if (selected & uploaded & extension) {
		$.ajax({
			url : 'LALPServlet',
			type : 'POST',
			data : {
				'args[]' : args, // must send the array object (JSON)
				length : args.length				
			},
			error : function() {
				alert('AJAX: Response from server failed!');
			},
			success : function(data) {
				alert(data);
			}
		});
	} else {
		if (!selected)
			alert('Select at least one option!');
		if (!uploaded) 
			alert('Select your .alp file.');
		else if (!extension)
			alert('File must have .alp extension');
	}
});

});