/**
 * Conteudo de script da pagina 'index.jsp' com o objetivo de reduzir a quantidade de codigo da pagina.
 */

var path = "http://lalp.dc.ufscar.br:9180/lalp/";
//var path = "http://localhost:8080/";

var lastName = ""; 
var fistName = "";
var emailC = "";

window.onload = function(){
    lastName = document.getElementById('LastName').innerHTML;
    fistName = document.getElementById('FirstName').innerHTML;
    emailC = document.getElementById('email').innerHTML;
};

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

setTimeout(function() {checkUserRole();},200);

function checkUserRole() {
	$.ajax({
		url : 'DATACheckServlet',
		type : 'POST',
		data : {
			email : document.getElementById('email').innerHTML,
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
			examples = data;
			
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
	 
	var element = document.createElement("option");
	
	element.setAttribute("value", type);
	element.setAttribute("label", type);
	element.setAttribute("id", type);
	element.setAttribute("onClick","loadExample('" + type + "');");
	
	var foo = document.getElementById("fooBar");
	foo.appendChild(element);
	document.getElementById(type).text=type;
}

$(document).ready(function(){
	$('#compOptions').hide();
	$('#hsOptions').click(function(){
		$('#compOptions').toggle();
	  });
	});

$(document).mouseup(function (e) {
	var container = $('#compOptions');
	
	if (!container.is(e.target)                  // if the target of the click isn't the container...
	    && container.has(e.target).length === 0) // ... nor a descendant of the container
	{
	    container.hide();
	}
});

function openSVGWindow(id){
	var divText = document.getElementById(id).outerHTML;
	var myWindow = window.open('','','scrollbars=yes,width=800px,height=600px');
	var doc = myWindow.document;
	
	doc.open();
	doc.write(divText);
	doc.close();
}

