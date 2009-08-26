var state;

function highlight (root, refs) {
	// normalise addresses
	// if short addr but there are word offsets, normalise to full addr (add 1s) ?
	for (var i = 0; i < refs.length; ++i) {
		for (var j = 0; j < refs[i].startElems.length; ++j) {
			if (refs[i].endElems.length <= j) {
				refs[i].endElems.push(refs[i].startElems[j]);
			} else if (refs[i].endElems[j] == null) {
				refs[i].endElems[j] = refs[i].startElems[j];
			}
		}
		if (refs[i].startWord != null  &&  refs[i].endWord == null) {
			refs[i].endWord = refs[i].startWord;
		}
	}

//console.log("normalised refs: " + refs.toSource());
	state = [];
	traverse(root, refs, []);
}

function traverse (elem, refs, address) {
	// find child elements
	var children = [];
	for (var i = 0; i < elem.childNodes.length; ++i) {
		var childNode = elem.childNodes[i];
		if (childNode.nodeType == 1) {	// element
			children.push(childNode);
		}
	}
	var startMatches = [];
	var endMatches = [];

	// check for refs starting at this elem
	for (var i = 0; i < refs.length; ++i) {
		// only check refs which are not already current
		var skip = false;
		for (var j = 0; j < state.length; ++j) {
			if (state[j] == refs[i]) skip = true;
		}
		if (! skip) {
			var match = checkStart(address, refs[i].startElems);
			if (match) startMatches.unshift(i);
		}
	}

	// check for refs ending at this elem
	if (startMatches.length > 0  ||  state.length > 0) {
		for (var i = 0; i < refs.length; ++i) {
			var match = checkEnd(address, refs[i].endElems);
			if (match) endMatches.unshift(i);
		}
	}

//console.log("traverse " + address.join(",") + (startMatches.length ? " startMatches: " + startMatches.join(",") : "")
//											+ (endMatches.length ? " endMatches: " + endMatches.join(",") : "")
//											+ (state.length ? " state: " + state.join(",") : ""));

	var start = startMatches.length > 0;
	var end = endMatches.length > 0;

	if (children.length == 0) {
		if (state.length > 0  ||  start ||  end) {
			transformElement(elem, refs, state, startMatches, endMatches);
		}
	}

	// add refs that start at this elem
	if (start)
		state = startMatches.reverse().concat(state);

	// traverse child elements
	for (var i = 0; i < children.length; ++i) {
		traverse(children[i], refs, address.concat([i+1]));
	}

	// remove refs which end here
	if (state.length > 0  &&  end) {
		var newState = [];
		for (var i = 0; i < state.length; ++i) {
			var remove = false;
			for (var j = 0; j < endMatches.length; ++j) {
				if (state[i] == endMatches[j]) remove = true;
			}
			if (! remove) newState.push(state[i]);
		}
		state = newState;
	}

	for (var i = 0; i < endMatches.length; ++i) {
		// superscript refs for word-level references get inserted during transformElement
		if (refs[endMatches[i]].startWord == null) {
			if (children.length == 0) {
				insertRef(elem, refs, endMatches[i]);
			} else {
				insertRef(children[children.length - 1], refs, endMatches[i]);
			}
		}
	}
}

function checkStart (address, startElements) {
	var i;
	for (i = 0; i < startElements.length; ++i) {
		if (startElements[i] == null) break;
		if (address.length <= i) return false;
		if (address[i] != startElements[i]) return false;
	}
	if (address.length == i) return true;
	else return false;
}

function checkEnd (address, endElements) {
	var i;
	for (i = 0; i < endElements.length; ++i) {
		if (endElements[i] == null) break;
		if (address.length <= i) return false;
		if (address[i] != endElements[i]) return false;
	}
	if (address.length == i) return true;
	else return false;
}

function transformElement (elem, refs, currentRefs, startingRefs, endingRefs) {
//console.log("transformElement:" + " currentRefs: " + currentRefs.join(",")
//								+ " startingRefs: " + startingRefs.join(",")
//								+ " endingRefs: " + endingRefs.join(","));
	var text = elem.textContent;
	text = text.replace(/^\s+/, "").replace(/\s+$/, "");
	var words = text.split(/\s+/);

	while (elem.lastChild) elem.removeChild(elem.lastChild);

	// trivial case: there are no references starting or ending within this element
	// so just highlight it and link to the ref on the top of the currentRefs stack
	if (startingRefs.length == 0  &&  endingRefs.length == 0) {
		var ref = refs[currentRefs[0]];
		var a = elem.appendChild(document.createElement("a"));
		a.style.backgroundColor = (currentRefs.length > 1 ? "#ffff70" : "#ffffc0");
		a.href = "#ref" + ref.recordID;
		a.title = ref.title;
		a.name = "ref" + ref.recordID;
		a.id = "ref" + ref.recordID;
		a.setAttribute("annotation-id", ref.recordID);
		a.onclick = function() { showFootnote(this.getAttribute("annotation-id")); highlightAnnotation(this.getAttribute("annotation-id")); };
		a.innerHTML = text;

	} else {

		var startPositions = [];
		var endPositions = [];

		for (var i = 0; i < currentRefs.length; ++i) {
			startPositions.push( { "word": 1, "refId": currentRefs[i] } );
			// if this ref is in endingRefs, ignore it here -- it will be entered into the endPositions list correctly below
			var skip = false;
			for (var j = 0; j < endingRefs.length; ++j) {
				if (endingRefs[j] == currentRefs[i]) skip = true;
			}
			if (! skip)
				endPositions.push( { "word": words.length, "refId": currentRefs[i] } );
		}
		for (var i = 0; i < startingRefs.length; ++i) {
			var refId = startingRefs[i];
			var startWord = refs[refId].startWord;
			if (startWord == null) startWord = 1;
			startPositions.push( { "word": startWord, "refId": refId } );
		}
		for (var i = 0; i < endingRefs.length; ++i) {
			var refId = endingRefs[i];
			var endWord = refs[refId].endWord;
			if (endWord == null) endWord = words.length;
			endPositions.push( { "word": endWord, "refId": refId } );
		}

		var sortfunc = function(a,b) {
            if (a.word == b.word)
                return a.refId - b.refId;
            else
				return a.word - b.word;
		};

		startPositions = startPositions.sort(sortfunc);
		endPositions = endPositions.sort(sortfunc);

//console.log("startPositions:");
//for (var i in startPositions) {
//	console.log("  " + startPositions[i].word + " " + startPositions[i].refId);
//}
//console.log("endPositions:");
//for (var i in endPositions) {
//	console.log("  " + endPositions[i].word + " " + endPositions[i].refId);
//}

		var refStack = [];
		var sections = [];
		var section = { "startWord": 1, "endWord": null, "refId": null, "refCount": 0, "refNums": [] };
		for (var w = 1; w <= words.length; ++w) {
			var startPos = null;
			// push any refs that start at this pos onto the stack
			while (startPositions.length > 0  &&  startPositions[0].word == w) {
				startPos = startPositions.shift();
				refStack.unshift(startPos.refId);

				if (section.startWord == w) {
					// there is already a section starting at this word
					// how?  either one finished at the previous word, or more than one ref starts here
					section.refId = startPos.refId;
					section.refCount = refStack.length;
				} else {
					// wrap up the current section and start a new one
					section.endWord = w - 1;
					sections.push(section);
					section = { "startWord": w, "endWord": null, "refId": startPos.refId, "refCount": refStack.length, "refNums": [] };
				}
			}

			var endPos = null;
			// remove any refs that end at this pos from the "stack"
			while (endPositions.length > 0  &&  endPositions[0].word == w) {
				endPos = endPositions.shift();
				var newRefStack = [];
				while (refStack.length) {
					var ref = refStack.shift();
					if (ref != endPos.refId) newRefStack.push(ref);
				}
				refStack = newRefStack;

				// a reference ends here
					section.endWord = w;
					if (refs[endPos.refId].endWord != null)
						section.refNums.push(endPos.refId);
					if (endPositions.length == 0  ||  endPositions[0].word != w) {
						// no more to come
						sections.push(section);
						if (w == words.length) {
							// this is the last word => no more sections
							section = null;
						} else {
							section = { "startWord": w + 1, "endWord": null, "refId": (refStack.length > 0 ? refStack[0] : null), "refCount": refStack.length, "refNums": [] };
						}
					}
			}
		}
		if (section) {
			section.endWord = words.length;
			sections.push(section);
		}
//console.log("sections: " + sections.toSource());

		for (var i = 0; i < sections.length; ++i) {
			var section = sections[i];

			var wordString = words.slice(section.startWord - 1, section.endWord).join(" ");
			if (section.refId != null) {
				var ref = refs[section.refId];
				var a = elem.appendChild(document.createElement("a"));
				a.style.backgroundColor = (section.refCount > 1 ? "#ffff70" : "#ffffc0");
				a.href = "#ref" + ref.recordID;
				a.title = ref.title;
				a.name = "ref" + ref.recordID;
				a.id = "ref" + ref.recordID;
				a.setAttribute("annotation-id", ref.recordID);
				a.onclick = function() { showFootnote(this.getAttribute("annotation-id")); highlightAnnotation(this.getAttribute("annotation-id")); };
				a.innerHTML = wordString;

/*
				var addRef = false;
				if (section.endWord < words.length) addRef = true;
				else {
					for (var e = 0; e < endingRefs.length; ++e) {
						if (endingRefs[e] == section.refId  &&  endingRefs[e].endWord != null) addRef = true;
					}
				}
				if (addRef) {
					a.innerHTML += "<sup>[" + (section.refId + 1) + "]</sup>";

				}
*/
				for (var r = 0; r < section.refNums.length; ++r) {
				//	if (section.endWord < words.length  ||  refs[section.refNums[r]].endWord != null) {
						var ref = refs[section.refNums[r]];
						var a = elem.appendChild(document.createElement("a"));
						a.style.backgroundColor = "#ffffc0";
						a.href = "#ref" + section.refNums[r] + 1;
						a.title = ref.title;
						a.onclick = function() { showFootnote(this.getAttribute("annotation-id")); highlightAnnotation(this.getAttribute("annotation-id")); };
						var s = a.appendChild(document.createElement("sup"));
						/*s.innerHTML = "[" + (section.refNums[r] + 1) + "]";*/
						s.innerHTML = "";

				//	}
				}

				elem.appendChild(document.createTextNode(" "));

			} else {
				elem.appendChild(document.createTextNode(wordString + " "));
			}

		}

	}
}

/*
	if (startWord > 1) {
		elem.appendChild(document.createTextNode(words.slice(0,startWord-1).join(" ") + " "));
	}
*/

function insertRef (elem, refs, refId) {
	var ref = refs[refId];

	var a = document.createElement("a");
	a.style.backgroundColor = "#ffffc0";
	a.href = ref.href;
	a.title = ref.title;
	var s = a.appendChild(document.createElement("sup"));
	s.innerHTML = "[" + (refId + 1) + "]";

	if (elem.nextSibling != null) {
		elem.parentNode.insertBefore(a, elem.nextSibling);
	} else {
		elem.parentNode.appendChild(a);
	}
}


var highlighted = {
	"inline-annotation" : null,
	"annotation-link" : null
};

function highlightAnnotation (id) {
	var links = document.getElementsByTagName("a");
	for (var i = 0; i < links.length; ++i) {
		var e = links[i];
		if (e.getAttribute("annotation-id") == id) {
			if (e.id.match(/^ref/)) {
				highlightElem("inline-annotation", e);
			} else {
				highlightElem("annotation-link", e);
			}
		}
	}
}

function highlightElem (name, e) {
	if (highlighted[name]) {
		var oldbg = highlighted[name].getAttribute("old-bg-color");
		highlighted[name].style.backgroundColor = oldbg;
		highlighted[name].setAttribute("old-bg-color", null);
	}
	if (e) {
		e.setAttribute("old-bg-color", e.style.backgroundColor);
		e.style.backgroundColor = "#ffbb00";
		highlighted[name] = e;
	}
}

function highlightOnLoad() {
	var matches = window.location.hash.match(/#ref([0-9]+)/);
	if (matches  &&  matches[1]) {
		showFootnote(matches[1]);
		highlightAnnotation(matches[1]);
	}
}
