/**
 * Conteúdo de script da página 'index.jsp' com o objetivo de reduzir a quantidade de código da página.
 */

/*var path = "http://localhost:9180/lalpProject/";*/
var path = "http://projetos.ppgcc.dc.ufscar.br:9180/lalp/";

function newColor(color)
{
document.getElementById('sourceCodeArea').style.color=color;
}

function toggle(id) {
	   var state = document.getElementById(id).style.display;
	   document.getElementById(id).style.display = 'block';
}
	
function toggle1(id) {
	   var state = document.getElementById(id).style.display;
	   if (state == 'block') {
	       document.getElementById(id).style.display = 'none';
	   } else {
	       document.getElementById(id).style.display = 'block';
	   }
}

function getUrlVars() {
    var vars = {};
    var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
        vars[key] = value;
    });
    return vars;
}

var email = getUrlVars()["openid.ext1.value.email"];

if (email == null) {
	window.location = path + "Default.jsp";
}

email = email.replace('%40','@').replace('#', '');


setTimeout(function() {checkUserRole();},200);

function checkUserRole() {
	$.ajax({
		url : 'DATACheckServlet',
		type : 'POST',
		data : {
			email : email,
			index : "0"
		},
		error : function() {
			//alert("erro");
			var urlindex = window.location.href.replace('index.jsp','userData.jsp');
			window.location = urlindex;
		},
		success: function(data) {
			//alert(data);
			//document.write(data);
			//$('#version').val(data);
			document.getElementById('version').innerHTML=data;
		}
	});
}
		
function loadExample(exampleName) {
	setTimeout(function() {
	$.ajax({
		url : 'ExamplesLoadServlet',
		type : 'POST',
		data : {
			file : exampleName
		},
		success : function(data) {
			//alert("Loaded: " + exampleName);
			$('#sourceCodeArea').html(data);
			filename = exampleName;
			$('#fileName').val(filename);
		},
		error : function(data) {
			alert("Error!");
		}
	});
	},200);
}

var examples;
setTimeout(function() {dinamicButtons();},200);
function dinamicButtons() {
	$.ajax({
		url : 'DinamicExamples',
		type : 'POST',
		success : function(data) {
			//alert("Sucesso");
			examples = data;
			
//			var ex1 = getExpVars()["ex1"];
//			var ex2 = getExpVars()["ex2"];
//			var ex3 = getExpVars()["ex3"];
//			var ex4 = getExpVars()["ex4"];
//			var ex5 = getExpVars()["ex5"];
//			var ex6 = getExpVars()["ex6"];
//			var ex7 = getExpVars()["ex7"];
//			
//			if (ex1 != "null") add(ex1);
//			if (ex2 != "null") add(ex2);
//			if (ex3 != "null") add(ex3);
//			if (ex4 != "null") add(ex4);
//			if (ex5 != "null") add(ex5);
//			if (ex6 != "null") add(ex6);
//			if (ex7 != "null") add(ex7);

			//Modificado para tornar dinamico o preenchimento dos exemplos
			var ex = getExpVars()["ex0"];
			var i = 0;
			
			while(ex != undefined)
			{
				add(ex);
				i++;
				ex = getExpVars()["ex" + i];
			}
			
		},
		error : function(data) {
			//alert("Error!");
		}
	});
}

function getExpVars() {
    var vars = {};
    var parts = examples.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
        vars[key] = value;
    });
    return vars;
}

function add(type) {
	 
//    var element = document.createElement("input");
// 
//    element.setAttribute("type", "button");
//    element.setAttribute("value", type);
//    element.setAttribute("name", type);
//    element.setAttribute("onClick","loadExample('" + type + "');");
// 
// 
//    var foo = document.getElementById("fooBar");
// 
//    foo.appendChild(element);
	
//Modificado para a implementação em forma de combobox.	
	var element = document.createElement("option");
	
	element.setAttribute("value", type);
	element.setAttribute("label", type);
	element.setAttribute("id", type);
	element.setAttribute("onClick","loadExample('" + type + "');");
	
	var foo = document.getElementById("fooBar");
	foo.appendChild(element);
	document.getElementById(type).text=type;
}

//jQuery adicionado por Jefferson Alves
// Exibe a janela de opções de compilação
$(document).ready(function(){
	$('#compOptions').hide();
	  $('#hsOptions').click(function(){
	    $('#compOptions').toggle();
	  });
	});

//Exibe SVG em outra janela
function openSVGWindow(id){
	var divText = document.getElementById(id).outerHTML;
	var myWindow = window.open('','','width=800px,height=600px');
	var doc = myWindow.document;
	
	doc.open();
	doc.write(divText);
	doc.close();
}

