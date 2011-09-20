$(document).ready(function(){
	var selected = false;
	var args = new Array();	
	var menuArgs = $("form input:radio");    
	menuArgs.click(function() { //seleciona opção do radio list
		for (var i = 0; i < menuArgs.length; i++) {
			var j = 0;
			if (menuArgs[i].checked) {
				selected = true;
				args[j] = menuArgs[i].value.toString(); //analisar casos com passagem de mais de um parâmetro			
			}
	    }		
	});	
	$("#submitBtn").click(function(){ //envia parâmetros
		if (selected) {
			$.ajax({
				url: 'LALPServlet',
				type: "POST",
				data: {
					args:args[0], //analisar como passar o array Javascript dinâmicamente (JSON)
					length:args.length
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