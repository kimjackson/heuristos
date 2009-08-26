
function test1() { highlight(document.getElementById("tei"), [1,2,1], [1,2,1], 6, 7, "asdf"); }
function test2() { highlight(document.getElementById("tei"), [1,3,1], [1,3,1], null, 0, "asdf"); }
function test3() { highlight(document.getElementById("tei"), [1,1,1], [1,1,7], 0, 0, "asdf"); }
function test4() { highlight(document.getElementById("tei"), [1,3,4], [1,4,1], 3, 1, "asdf"); }

var state;

function highlight (root, refs) {
	// normalise addresses
	//if short addr but there are word offsets, normalise to full addr (add 1s)

	for (var i = 0; i < refs.length; ++i) {
		var ref = refs[i];
		state = 0;
		traverse(root, ref.startElems, ref.endElems, ref.startWord, ref.endWord, ref.href, ref.title, []);
	}
}

function traverse(elem, startElements, endElements, startWord, endWord, href, title, address) {
	// find child elements
	var children = [];
	for (var i = 0; i < elem.childNodes.length; ++i) {
		var childNode = elem.childNodes[i];
		if (childNode.nodeType == 1) {	// element
			children.push(childNode);
		}
	}
	var start = false;
	var end = false;

	if (state == 0)
		start = checkStart(address, startElements);
	if (start  ||  state == 1)
		end = checkEnd(address, startElements, endElements);

	if (children.length == 0) {
		if (start) {
			if (end) {
				transformElement(elem, startWord, endWord, href, title);
			} else {
				transformElement(elem, startWord, null, href, title);
			}
		} else if (state == 1) {
			if (end) {
				transformElement(elem, null, endWord, href, title);
			} else {
				transformElement(elem, null, null, href, title);
			}
		}
	}

	if (start  &&  ! end)
		state = 1;

	// traverse child elements
	for (var i = 0; i < children.length; ++i) {
		traverse(children[i], startElements, endElements, startWord, endWord, href, title, address.concat([i+1]));
	}

	if (state == 1  &&  end)
		state = 0;
}

function checkStart(address, startElements) {
	for (var i = 0; i < startElements.length; ++i) {
		if (startElements[i] == null) return true;
		if (address.length <= i) return false;
		if (address[i] != startElements[i]) return false;
	}
	return true;
}

function checkEnd(address, startElements, endElements) {
	for (var i = 0; i < endElements.length; ++i) {
		var endElem = (endElements[i] == null ? startElements[i] : endElements[i]);
		if (endElem == null) return true;
		if (address.length <= i) return false;
		if (address[i] != endElem) return false;
	}
	return true;
}

function transformElement(elem, startWord, endWord, href, title) {
	var text = elem.textContent;
	text = text.replace(/^\s+/, "").replace(/\s+$/, "");
	var words = text.split(/\s+/);

	if (startWord == null  ||  startWord == 0) {
		startWord = 1;
	}
	if (endWord == null  || endWord == 0) {
		endWord = words.length;
	}

	while (elem.lastChild) elem.removeChild(elem.lastChild);

	if (startWord > 1) {
		elem.appendChild(document.createTextNode(words.slice(0,startWord-1).join(" ") + " "));
	}

	var a = elem.appendChild(document.createElement("a"));
	a.style.backgroundColor = "yellow";
	a.href = href;
	a.title = title;
	a.appendChild(document.createTextNode(words.slice(startWord-1,endWord).join(" ")));

	if (endWord < words.length) {
		elem.appendChild(document.createTextNode(" " + words.slice(endWord,words.length).join(" ")));
	}
}



