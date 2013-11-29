// This script populates and manipulates "add record" fake-dropdown menu
// author: Maria Shvedova, 24/09/2008

var path = "/dos/";
var recordos = [];
  recordos[0] = new recordDetails("Term", "29");
  recordos[1] = new recordDetails("Multimedia", "5");
  recordos[2] = new recordDetails("Entity",  "25");
  recordos[3] = new recordDetails("XML document", "13");
  recordos[4] = new recordDetails("Contributor", "24");
  recordos[6] = new recordDetails("External Link", "2");

recordos.sort(sortrecordos);

function sortrecordos(a,b) {
	var x = a.title, y = b.title;
	return (x < y)? -1 : (x > y)? 1 : 0;
}

function recordDetails(title,image){
  	this.title = title;
  	this.image = image;
}

	var divo = document.getElementById("common-recordos-drop-div");
	var inp = document.getElementById("common-recordos-pretend-dropdown");

	inp.value = "Add record";
	var imgArrow = document.getElementById("common-recordos-drop-img");
	imgArrow.src = "/h3/common/images/tdown.gif";

	function setDropDownOnclick(imgArrow){
		imgArrow.onclick = function() {
			divo.style.display = "block";

			divo.onmouseover = function() {
				divo.style.display = "block";
			}
			divo.onmouseout  = function() {
				divo.style.display = "none";
				setDropDownOnclick(imgArrow);
			}
			imgArrow.onclick  = function() {
				divo.style.display = "none";
				setDropDownOnclick(imgArrow);
			}
		}
	}
	setDropDownOnclick(imgArrow);




 	for (s = 0; s < recordos.length; ++s){
 		var spaN = document.createElement("div");
		var img = document.createElement("img");
		if (recordos[s].image) {
			img.src = path + "images/types/" + recordos[s].image + ".gif";
		} else {
			img.src = path + "img/16x16.gif";
		}
		img.align = "absmiddle";
		spaN.appendChild(img);
		spaN.className = "common-recordos-drop-span";
		spaN.appendChild(document.createTextNode(" " + recordos[s].title));
		createrecordosDropDownOnclick(spaN, img.src, recordos[s], s );
		divo.appendChild(spaN);
 	}

	function createrecordosDropDownOnclick(e, img, obj, number){
		e.onclick = function () {

			inp.setAttribute ("style", "background-image: url(" + img + "); background-repeat: no-repeat; padding-left: 18px;");
			inp.value = obj.title;
			setTimeout("inp.value = \"Add record \"; inp.removeAttribute(\"style\");",5000);
			divo.style.display = "none";
			setDropDownOnclick(imgArrow);
			window.open(path + "edit.html?typeId=" + obj.image,'','status=0,scrollbars=1,resizable=1,width=800,height=600'); return false;

		}
	}

