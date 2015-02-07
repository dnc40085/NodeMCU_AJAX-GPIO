var xmlhttp = new XMLHttpRequest();

function update()
{
xmlhttp.open("GET", url, true);
xmlhttp.send();
}

xmlhttp.onreadystatechange = function() {
    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
        var myArr = JSON.parse(xmlhttp.responseText);
        /*console.log(xmlhttp.responseText);*/
        ProcessJSON(myArr);
    }
}


function ProcessJSON(arr) {
    var out = "";
    for(i = 0; i < arr.length; i++) 
    {
        document.getElementById("checkbox" + arr[i].gpio).checked = arr[i].state;
			console.log("document.getElementById(\"checkbox\"" + arr[i].gpio + ").checked = " + arr[i].state);

    }
}

function loadXMLDoc(gpio)
{
var xmlhttp2;
if (window.XMLHttpRequest)
  {
  xmlhttp2=new XMLHttpRequest();
  }
else
  {
  xmlhttp2=new ActiveXObject("Microsoft.XMLHTTP");
  }
xmlhttp2.open("GET","gpio=" + gpio+".pht",true);
xmlhttp2.send();
}
setInterval(function(){update()}, 10000);
update();


