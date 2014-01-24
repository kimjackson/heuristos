
var resultsDiv;

function search(query) {
	if (! query) return;
	showSearch(query);
	var loader = new HLoader(
		function(s,r,c) {
			displayResults(s,r,c);
		},
		function(s,e) {
			alert("load failed: " + e);
		}
	);
	loadAllRecords(query, null, loader);
}

function loadAllRecords(query, options, loader) {
		var PAGE_SIZE = 500;
		var records = [];
		var baseSearch = new HSearch(query, options);
		var loadingMsgElem = document.getElementById('loading-msg');
		var loadMoreLinkTop = document.getElementById('load-more-link-top');
		var loadMoreLinkBottom = document.getElementById('load-more-link-bottom');

		var bulkLoader = new HLoader(
			function(s, r, c) {	// onload
				records.push.apply(records, r);
				loadingMsgElem.innerHTML = '<b>Loaded ' + records.length + ' of ' + c + ' records</b>';

				if (records.length < c) {
					// more records to retrieve
					if (records.length % PAGE_SIZE == 0) {
						// don't load any more for now; provide a link to load more
						loader.onload(baseSearch, records, c);
						loadMoreLinkTop.innerHTML = loadMoreLinkBottom.innerHTML = "Load more";
						loadMoreLinkTop.onclick = loadMoreLinkBottom.onclick = function() {
							var search = new HSearch(query + " offset:"+records.length, options);
							HeuristScholarDB.loadRecords(search, bulkLoader);
						};
					}
					else {
						//  do a search with an offset specified for retrieving the next page of records
						var search = new HSearch(query + " offset:"+records.length, options);
						HeuristScholarDB.loadRecords(search, bulkLoader);
					}
				}
				else {
					// we've loaded all the records: invoke the original loader's onload
					loader.onload(baseSearch, records, c);
					loadMoreLinkTop.innerHTML = loadMoreLinkBottom.innerHTML = '';
				}
			},
			loader.onerror
		);
		HeuristScholarDB.loadRecords(baseSearch, bulkLoader);
}


function showSearch(query) {
	// hide footnotes
	document.getElementById("footnotes").style.display = "none";
	document.getElementById("page").style.bottom = "0px";

	// turn off any highlighting
	if (window.highlightElem) {
		highlightElem("inline-annotation", null);
		highlightElem("annotation-link", null);
	}

	// hide page-inner and show results div
	var pageInner = document.getElementById("page-inner");
	pageInner.style.display = "none";
	if (resultsDiv) {
		resultsDiv.innerHTML = "";
		resultsDiv.style.display = "block";
	} else {
		resultsDiv = pageInner.parentNode.appendChild(document.createElement("div"));
		resultsDiv.id = "results-div";
	}

	resultsDiv.innerHTML += "<a style=\"float: right;\" href=# onclick=\"hideResults(); return false;\">Return to previous view</a>";
	resultsDiv.innerHTML += "<h2>Search results for query \"" + query + "\"</h2>";
	resultsDiv.innerHTML += "<p id=loading-msg>Loading...</p>";
	resultsDiv.innerHTML += "<p><a id=load-more-link-top href=\"#\"></a></p>";
	resultsDiv.innerHTML += "<div id=results-inner />";
	resultsDiv.innerHTML += "<p><a id=load-more-link-bottom href=\"#\"></a></p>";
}

function displayResults(s,r,c) {
	//var l = document.getElementById("loading-msg");
	//l.parentNode.removeChild(l);

	var innerHTML = "";
	for (var i = 0; i < r.length; i++) {
		innerHTML += "<img src=\"/dos/images/types/" + r[i].getRecordType().getID() + ".gif\"/>";
		innerHTML += " <a href=../" + r[i].getID() + "/ target=\"_blank\">" + r[i].getTitle() + "</a><br/>";
	}

	if (innerHTML.length) {
		document.getElementById("results-inner").innerHTML = innerHTML;
	} else {
		document.getElementById("results-inner").innerHTML = "<p>No matching records</p>";
	}
}

function hideResults() {
	resultsDiv.style.display = "none";
	document.getElementById("page-inner").style.display = "block";
	if (window.higlightOnLoad) highlightOnLoad();
}

