$(document).ready(function(){
	var selected = false;
	var args = new String();
	var menuArgs = $("form input:radio");    
	menuArgs.click(function() { //seleciona argumento do radio list
		for (var i = 0; i < menuArgs.length; i++) {
			if (menuArgs[i].checked) {
				selected = true;
				args = menuArgs[i].value.toString();				
			}
	    }
	});	
	$("#submitBtn").click(function(){ //envia argumentos
		if (selected) {
			$.ajax({
				url: 'LALPServlet',
				type: "POST",
				data: {
					args:args
				},
				error: function(){
					alert("AJAX: Response from server failed!")
				},
				success: function (data){
					alert(data) ;
				}
			});
		} else {
			alert("Select at least one option!")
		}
    });
});