var pathDos = "/cocoon/dos/browser/item/";
var imgpath = "/dos/images/types/";

function showFootnote(recordID) {
	document.getElementById("page").style.bottom = "205px";
	document.getElementById("footnotes").style.display = "block";

	var elts = document.getElementsByName("footnote");
	if (elts.length === 0) elts = document.getElementById("footnotes-inner").getElementsByTagName("div");  // fallback compatibility with IE
	for (var i = 0; i < elts.length; ++i) {
		var e = elts[i];
		e.style.display = e.getAttribute("recordID") == recordID ? "" : "none";
	}
	load(recordID);
}

function load(id) {
	var loader = new HLoader(
		function(s,r) {
			annotation_loaded(r[0]);
		},
		function(s,e) {
			alert("load failed: " + e);
		});
	HeuristScholarDB.loadRecords(new HSearch("id:" + id), loader);
}

function annotation_loaded(record) {
	var elts = document.getElementById("footnotes-inner");
	var notes = record.getDetail(HDetailManager.getDetailTypeById(HAPI_commonData.magicNumbers['DT_SHORT_SUMMARY']));
	var val = record.getDetail(HDetailManager.getDetailTypeById(HAPI_commonData.magicNumbers['DT_RESOURCE']));
	if (val) {
		HeuristScholarDB.loadRecords(
			new HSearch("id:"+val.getID()),
			new HLoader(function(s,r){MM_loaded(r[0],record)})
		);
	}

	elts.innerHTML = "<p>" + record.getTitle() + "</p>";
	if (! val  &&  notes) {
		elts.innerHTML += "<p>" + notes + "</p>";
	}
}

function MM_loaded(val,record) {
	var elts = document.getElementById("footnotes-inner");
	var title = val.getDetail(HDetailManager.getDetailTypeById(HAPI_commonData.magicNumbers['DT_NAME']));
	var notes = val.getDetail(HDetailManager.getDetailTypeById(HAPI_commonData.magicNumbers['DT_SHORT_SUMMARY']));
	var start = val.getDetail(HDetailManager.getDetailTypeById(HAPI_commonData.magicNumbers['DT_START_DATE']));
	var finish = val.getDetail(HDetailManager.getDetailTypeById(HAPI_commonData.magicNumbers['DT_END_DATE']));

	elts.innerHTML += "<p>" + title + "</p>";
	if (notes) {
		elts.innerHTML += "<p>" + notes.replace(/\n/g, "<br/>\n") + "</p>";
	}
	elts.innerHTML += "<p>" + start + (finish ? " - " + finish : "") + "</p>";

	if (val.getRecordType().getID() == HAPI_commonData.magicNumbers['RT_MEDIA_RECORD']) {
		var matches = val.getDetail(HDetailManager.getDetailTypeById(HAPI_commonData.magicNumbers['DT_FILE_RESOURCE'])).getURL().match(/ulf_ID=([0-9a-f]+)/);
		if (matches) {
			var img='/h3/common/php/resizeImage.php?w=400&ulf_ID=' + matches[1];
			elts.innerHTML += "<br><a href=\""+pathDos+val.getID()+"\"><img src=\"" + img+ "\"/></a>";
		}
	}
	else {
		elts.innerHTML += "<br><br><span style=\"padding-right:5px; vertical-align:top\"><a href=\""+pathDos+val.getID()+"\">"+val.getTitle()+"</a></span>"+"<img src=\"" + imgpath+val.getRecordType().getID() +".gif\"/>";
	}
}

