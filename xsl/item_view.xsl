<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings" version="1.0">


	<!-- modifications made by Steven Hayes - Feb 26 - to integrate changes illustrated in   -->
	<xsl:param name="id"/>
	<xsl:param name="related_reftype_filter"/>
	<xsl:param name="flavour"/>

	<xsl:variable name="hbase">http://dos.heuristscholar.org/heurist</xsl:variable>
	<xsl:variable name="urlbase">/dos</xsl:variable>
	<xsl:variable name="cocoonbase">/cocoon/dos/browser</xsl:variable>

	<xsl:include href="author_editor.xsl"/>
	<xsl:include href="books-etc.xsl"/>
	<xsl:include href="factoid.xsl"/>
	<xsl:include href="historical_event.xsl"/>
	<xsl:include href="internet_bookmark.xsl"/>
	<xsl:include href="media.xsl"/>
	<xsl:include href="teidoc.xsl"/>
	<xsl:include href="teidoc_reference.xsl"/>
	<xsl:include href="entity.xsl"/>

	<xsl:variable name="currentid">
		<xsl:value-of select="export/references/reference/id"/>
	</xsl:variable>

	<xsl:template match="/">

		<html>
			<head>
				<title>
					<xsl:value-of select="export/references/reference/title"/>
				</title>
				<!-- structural styling -->
				<style type="text/css">
					/***** HEADINGS AND GENERIC FONT STYLING *****/

					H1 { font-family: Arial, Verdana, Helvetica; color:#0096E3; font-size: 12pt; vertical-align: middle}
					H2 { font-family: Arial, Verdana, Helvetica; color:#333; font-size: 11pt}
					H3 { font-family: Arial, Verdana, Helvetica; color:#DC8501; font-size: 10pt}
					H4 { font-family: Arial, Verdana, Helvetica; color:#000; font-size: 10pt }
					H5 { font-family: Arial, Verdana, Helvetica; color:#999; font-size: 9pt }

					P { font-family: Arial, Verdana, Helvetica; font-size: 10pt; color:#333 }
					TD { font-family: Arial, Verdana, Helvetica; font-size: 10pt; color:#333 }
					UL { font-family: Arial, Verdana, Helvetica; font-size: 10pt; color:#333 }

					P.sb_ttl { font-family: Arial, Verdana, Helvetica; font-size: 9pt; font-weight: bold; color:#666 }

					P.footer { font-family: Verdana, Arial, Helvetica; color:#999999; font-size: 8pt}
					P.intro { font-family: Arial, Verdana, Helvetica; font-size: 12pt; color:#666 }



					/***** LINK STYLING *****/


					A:link { font-family: Arial, Verdana, Helvetica; color:#0065CF; font-size: 10pt }
					A:visited { font-family: Arial, Verdana, Helvetica; color:#0065CF; font-size: 10pt }
					A:active { font-family: Arial, Verdana, Helvetica; color:#0096E3; font-size: 10pt }
					A:hover { font-family: Arial, Verdana, Helvetica; color:#0096E3; font-size: 10pt }

					A.bnnavsoff:link { font-family: Arial, Verdana, Helvetica; color:#FFFFFF; text-decoration:none; font-weight: normal; font-size: 10pt }
					A.bnnavsoff:visited { font-family: Arial, Verdana, Helvetica; color:#FFFFFF; text-decoration:none; font-weight: normal; font-size: 10pt }
					A.bnnavsoff:active { font-family: Arial, Verdana, Helvetica; color:#FFCC00; text-decoration:none; font-weight: normal; font-size: 10pt }
					A.bnnavsoff:hover { font-family: Arial, Verdana, Helvetica; color:#FFCC00; text-decoration:none; font-weight: normal; font-size: 10pt }

					A.sb_title:link { font-family: Arial, Verdana, Helvetica; color:#333333; text-decoration:none; font-weight: normal; font-size: 13pt }
					A.sb_title:visited { font-family: Arial, Verdana, Helvetica; color:#333333; text-decoration:none; font-weight: normal; font-size: 13pt }
					A.sb_title:active { font-family: Arial, Verdana, Helvetica; color:#004F98; text-decoration:none; font-weight: normal; font-size: 13pt }
					A.sb_title:hover { font-family: Arial, Verdana, Helvetica; color:#004F98; text-decoration:none; font-weight: normal; font-size: 13pt }

					A.sb_one:link { font-family: Arial, Verdana, Helvetica; color:#0065CF; text-decoration:none; font-weight: bold; font-size: 10pt }
					A.sb_one:visited { font-family: Arial, Verdana, Helvetica; color:#0065CF; text-decoration:none; font-weight: bold; font-size: 10pt }
					A.sb_one:active { font-family: Arial, Verdana, Helvetica; color:#0096E3; text-decoration:none; font-weight: bold; font-size: 10pt }
					A.sb_one:hover { font-family: Arial, Verdana, Helvetica; color:#0096E3; text-decoration:none; font-weight: bold; font-size: 10pt }

					A.sb_two:link { font-family: Arial, Verdana, Helvetica; color:#0065CF; text-decoration:none; font-weight: normal; font-size: 10pt }
					A.sb_two:visited { font-family: Arial, Verdana, Helvetica; color:#0065CF; text-decoration:none; font-weight: normal; font-size: 10pt }
					A.sb_two:active { font-family: Arial, Verdana, Helvetica; color:#0096E3; text-decoration:none; font-weight: normal; font-size: 10pt }
					A.sb_two:hover { font-family: Arial, Verdana, Helvetica; color:#0096E3; text-decoration:none; font-weight: normal; font-size: 10pt }

					A.bodynav:link { font-family: Arial, Verdana, Helvetica; color:#666666; text-decoration:none; font-weight: bold; font-size: 9pt }
					A.bodynav:visited { font-family: Arial, Verdana, Helvetica; color:#666666; text-decoration:none; font-weight: bold; font-size: 9pt }
					A.bodynav:active { font-family: Arial, Verdana, Helvetica; color:#0096E3; text-decoration:none; font-weight: bold; font-size: 9pt }
					A.bodynav:hover { font-family: Arial, Verdana, Helvetica; color:#0096E3; text-decoration:none; font-weight: bold; font-size: 9pt }

					A.footer:link { font-family: Verdana, Arial, Helvetica; color:#666666; text-decoration:none; font-size: 8pt }
					A.footer:visited { font-family: Verdana, Arial, Helvetica; color:#666666; text-decoration:none; font-size: 8pt }
					A.footer:active { font-family: Verdana, Arial, Helvetica; color:#0065CF; text-decoration:none; font-size: 8pt }
					A.footer:hover { font-family: Verdana, Arial, Helvetica; color:#0065CF; text-decoration:none; font-size: 8pt }



					/***** STYLING FOR FORM FIELD ELEMENTS *****/


					.inputone {  font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 8pt; color: #333333; background-color: #FCFCFC; width: 95%px; clip:  rect(   )}
					.formfield {  background-color: #FFFFFF; font-family: Arial, Courier, monospace; font-size:10pt; color: #000000; width: 95%; clip:   rect(   )}
					.formbutton { font-family: Arial, Helvetica, sans-serif; font-size: 9pt; color: #FFFFFF; font-weight: bold;  border: 1px; border-color: #FFFFFF; background-color: #000099; padding: 3pt;}


					/***** THESE ROW AND CELL STYLES BELOW ARE TO BE USED TO CONTROL BRANDING COLOURS *****/

					.colourcellone  { font-family: Arial, Helvetica, Verdana; color:#FFF; font-size: 10pt; font-weight: bold; background-color: #0096E3 }
					.colourcelltwo { font-family: Arial, Helvetica, Verdana; color:#FFF; font-size: 10pt; background-color: #888888 }
					.colourcellthree { font-family: Arial, Helvetica, Verdana; color:#333; font-size: 10pt; background-color: #EFEFEF }
					.colourcellfour { font-family: Arial, Helvetica, Verdana; color:#333; font-size: 10pt; background-color: #B1B1B1 }
					.colourcellfive { font-family: Arial, Helvetica, Verdana; color:#FFF; font-size: 10pt; background-color: #EEAC03 }
					.colourcellsix { font-family: Arial, Helvetica, Verdana; color:#333; font-size: 10pt; background-color: #F8E061 }
					.colourcellseven { font-family: Arial, Helvetica, Verdana; color:#333; font-size: 10pt; background-color: #DCE9FB }
					.sb_divider {margin-bottom: 6px };

					/**** annotation styles *****/

					A.annotation1{ font-family: Arial, Verdana, Helvetica; background-color: #ffff70; color:#0065CF; text-decoration:none; font-weight: bold; font-size: 16pt };
					//= (currentRefs.length > 1 ? "#ffff70" : "#ffffc0");

					-->
				</style>
				<style>
					html {
					overflow: hidden;
					}
					input[type=text] {
					border: 1px solid lightgrey;

					}
					#common-recordos-pretend-dropdown {
					font-size: 85%;
					}

					input[type=button] {
					font-weight:bold;
					font-size: 85%;
					}

					body {
					padding: 0;
					margin: 0;
					width: 100%;
					height: 100%;
					overflow: hidden;
					}

					#breadcrumbs {
					padding: 0;
					margin: 0;
					position: absolute;
					top: 0px;
					left: 0px;
					width: 100%;
					height: 100px;
					overflow: hidden;
					}

					#page {
					padding: 0;
					margin: 0;
					position: absolute;
					top: 125px;
					left: 0px;
					right: 250px;
					bottom: 0px;
					overflow: auto;
					/* IE only */
					height: expression(document.documentElement.clientHeight-100);
					width: expression(document.documentElement.clientWidth-250);
					}
					#page-inner { padding: 25px; }

					#entity {
					padding: 0;
					margin: 0;
					position: absolute;
					top: 20px;
					left: 20px;
					right:20px;
					bottom: 0;
					overflow: auto;
					background-color: white;
					z-index: 1;
					/* IE only */
					height: expression(document.documentElement.clientHeight-100);
					width: expression(document.documentElement.clientWidth-250);
					}

					#factoid {
					padding: 0;
					margin: 0;
					position: absolute;
					top: 20px;
					left: 20px;
					right: 20px;
					bottom: 0;
					overflow: auto;
					background-color: white;
					border: 1px solid black;
					z-index: 2;
					/* IE only */
					height: expression(document.documentElement.clientHeight-100);
					width: expression(document.documentElement.clientWidth-250);
					}

					#logo {
					padding: 0;
					margin: 0;
					position: absolute;
					top: 0px;
					right: 0px;
					width: 200px;
					height: 100px;
					overflow: auto;
					/* IE only */
					height: expression(document.documentElement.clientHeight-100);
					}

					#map {
					padding: 0;
					margin: 20px;
					margin-left: 0;
					width: 90%;
					height: 400px;
					}

					#sidebar {
					padding: 0;
					margin: 0;
					position: absolute;
					top: 125px;
					right: 0px;
					bottom: 0px;
					overflow: auto;
					width: 250px;
					/* IE only */
					height: expression(document.documentElement.clientHeight-100);
					}
					#sidebar-inner { padding: 5px; }

					#pagetopcolour {
					padding: 0;
					margin: 0;
					position: absolute;
					top: 100px;
					left: 0px;
					right: 251px;
					height: 25px;
					overflow: auto;
					/* IE only */
					width: expression(document.documentElement.clientWidth-151);
					}


					#sidebartopcolour {
					padding: 0;
					margin: 0;
					position: absolute;
					top: 100px;
					right: 0px;
					bottom: 0px;

					overflow: auto;
					width: 250px;
					}


					#footnotesleft {
					padding: 0;
					margin: 0;
					position: absolute;
					left: 0px;
					bottom: 0px;
					height: 170px;
					overflow: auto;
					display: none;
					/* IE only */
					width: expression(document.documentElement.clientWidth-250);
					}

					#footnotesright {
					padding: 0;
					margin: 0;
					position: absolute;
					right: 0px;
					bottom: 0px;
					height: 170px;
					overflow: auto;
					display: none;
					/* IE only */
					width: expression(document.documentElement.clientWidth-250);
					}

					#footnotes {
					padding: 0;
					margin: 0;
					border-top: 1px solid black;
					position: absolute;
					left: 0px;
					right: 250px;
					bottom: 0px;
					height: 170px;
					overflow: auto;
					display: none;
					/* IE only */
					width: expression(document.documentElement.clientWidth-250);
					}
					#footnotes-inner { padding: 25px; }

					.reftype-heading a { text-decoration: none; }
					.reftype-heading a img { margin: 0; }
					.reftype-heading a.open img.right { display: none; }
					.reftype-heading a.closed img.down { display: none; }

					#titleunderlinea {
					padding: 0;
					margin: 0;
					position: absolute;
					top: 60px;
					left 0px;
					bottom: 0px;
					overflow: auto;
					width: 200px;
					/* IE only */
					height: expression(document.documentElement.clientHeight-60);
					}

					# titleunderlineb {
					padding: 0;
					margin: 0;
					position: absolute;
					top: 60px;
					left 0px;
					bottom: 0px;
					overflow: auto;
					width: 200px;
					/* IE only */
					height: expression(document.documentElement.clientHeight-60);
					}
					.teidoc {
					border : 1px solid lightgrey;
					}

					#search {
						text-align: center;
						padding-top: 10px;
						padding-bottom: 10px;
						border-bottom: 2px solid #888888;
						margin-bottom: 20px;
					}


					#results-div {
						padding: 25px;
					}
					#results-div img {
						vertical-align: middle;
					}

					.add-annotation-button {
						margin-bottom: 4px;
					}

					a img {
						border: none;
						vertical-align: middle;
					}
					#login {

						padding-left: 5px;
						padding-top: 3px;
						vertical-align: middle;
						font-size: 70%;

					}

					#login a {
						font-size: 99%;
						color: white;

					}
					#common-recordos-drop-span {
						width: 120px;
						font-size: 85%;
						background-position:3px 1px;
						cursor:pointer;
					}
					#common-recordos-drop-div {
						border: 1px outset grey;
 						width: 140px;
 						position: absolute; top: -90px; left: 3px; /*was 650 px*/
 						background-color:white;
						color:black;
						font-weight:normal;
						font-size: 85%;
					}
					#common-recordos-drop-img{
						padding:0;

					}
					#saved-searches{
						padding-left: 15px;
						font-size: 90%;

					}

					#saved-searches a{
						font-size: 90%;
					}


					#saved-searches-header{
						padding-top: 15px;
						padding-bottom: 5px;
						font-weight: bold;
					}

					#relations-table{
						padding-left: 15px;
						padding-bottom: 5px;
						border-bottom:2px solid #888888;
					}
					#heurist-link  a{
						text-align: right;
						font-size: 80%;

					}

					/* TEI styles */
					
					p.DoSBlockquote {
						font-style: italic;
						padding-right: 50px;
						padding-left: 50px;
					}
					span.italics {
						font-style: italic;
					}
					span.bold {
						font-weight: bold;
					}
					span.note {
						display: none;
					}

					/* annotation styles */
					a.annotation {
						background-color: #ffffc0;
						border: 1px solid red;
						margin: 0 1px;
					}
					a.annotation.entity {
						color:white;
						background-color: #AB658A;
					}
					a.annotation.multimedia {
						color:white;
						background-color: #658AAB;
					}
					a.annotation.multiple {
						background-color: #ffff70;
					}
					a.annotation.superscript {
						display: none;
					}

				</style>

				<!-- text and table styling -->

				<script>
					var pathDos = "http://heuristscholar.org/cocoon/dos/browser/item/";
					var imgpath = "http://heuristscholar.org/dos/img/reftype/";

					function showFootnote(recordID) {
						document.getElementById("page").style.bottom = "205px";
						document.getElementById("footnotes").style.display = "block";

						var elts = document.getElementsByName("footnote");
						if (elts.length === 0) elts = document.getElementById("footnotes-inner").getElementsByTagName("div");  // fallback compatibility with IE
						for (var i = 0; i &lt; elts.length; ++i) {
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
						var notes = record.getDetail(HDetailManager.getDetailTypeById(303));
						var val = record.getDetail(HDetailManager.getDetailTypeById(199));
						if (val) {
							HeuristScholarDB.loadRecords(new HSearch("id:"+val.getID()),
                                  new HLoader(function(s,r){MM_loaded(r[0],record)})
							);
						}

						elts.innerHTML = "&lt;p&gt;" + record.getTitle() + "&lt;/p&gt;";
						if (! val  &amp;&amp;  notes) {
							elts.innerHTML += "&lt;p&gt;" + notes + "&lt;/p&gt;";
						}


				   }
				   function MM_loaded(val,record) {
				        var elts = document.getElementById("footnotes-inner");

						var title = val.getDetail(HDetailManager.getDetailTypeById(160));
						var notes = val.getDetail(HDetailManager.getDetailTypeById(303));
						var start = val.getDetail(HDetailManager.getDetailTypeById(177));
						var finish = val.getDetail(HDetailManager.getDetailTypeById(178));

						elts.innerHTML += "&lt;p&gt;" + title + "&lt;/p&gt;";
						if (notes) {
							elts.innerHTML += "&lt;p&gt;" + notes.replace(/\n/g, "&lt;br/&gt;\n") + "&lt;/p&gt;";
						}
						elts.innerHTML += "&lt;p&gt;" + start + (finish ? " - " + finish : "") + "&lt;/p&gt;";

						if (val.getRecordType().getID() == 74) {
							var img=val.getDetail(HDetailManager.getDetailTypeById(221)). getThumbnailURL() + "&amp;w=400";
							elts.innerHTML += "&lt;br&gt;&lt;a href=\""+pathDos+val.getID()+"\"&gt;&lt;img src=\"" + img+ "\"/&gt;&lt;/a&gt;";
						}
						else {
						   elts.innerHTML += "&lt;br&gt;&lt;br&gt;&lt;span style=\"padding-right:5px; vertical-align:top\"&gt;&lt;a href=\""+pathDos+val.getID()+"\"&gt;"+val.getTitle()+"&lt;/a&gt;&lt;/span&gt;"+"&lt;img src=\"" + imgpath+val.getRecordType().getID() +".gif\"/&gt;";
						}
				   }

				</script>

				<script src="http://hapi.heuristscholar.org/load?instance=dos&amp;key=1742ecefd4811cfde65b604f730363fe7a86bb45"></script>
				<script>
					if (!HCurrentUser.isLoggedIn()) {
						window.location = 'http://dos.heuristscholar.org/heurist/php/login-vanilla.php?logo=http://heuristscholar.org/dos/images/logo.png&amp;home=http://heuristscholar.org/dos';
					}
				</script>
				<script src="{$urlbase}/js/search.js"/>
				<script>
					top.HEURIST = {};
					top.HEURIST.fireEvent = function(e, e){};
				</script>
				<script src="http://dos.heuristscholar.org/heurist/php/js/heurist-obj-user.php"></script>

			</head>
			<body pub_id="{/export/@pub_id}"  >



				<div id="header">
					<iframe
						src="{$cocoonbase}/breadcrumbs?flavour={$flavour}&amp;title={export/references/reference/title}&amp;url=http://heuristscholar.org{$cocoonbase}/item/{$id}/{$related_reftype_filter}%3Fflavour={$flavour}"
						style="width: 100%; height: 100%; border: none; overflow: visible;"
						frameborder="0" allowtransparency="true"/>

					<div id="logo">
						<a href="{$urlbase}/index.html"><img src="{$urlbase}/images/logo.png" align="center"/></a>
					</div>


					<div id="pagetopcolour" class="colourcelltwo" style="overflow:visible;">
						<div style="padding-left:20px ">
							<!-- 2674 is ID of the "home page" file -->
							<xsl:if test="export/references/reference/reftype/@id = 98">
						    <table>
							<tr>
								<xsl:if test=" $id != 2674">
								<!--td style="font-size: 85%;padding-right:10px;">Add:</td-->
								<td style="font-size: 85%;padding-right:10px; "><a  href='#' onclick="window.open('{$urlbase}/edit-annotation.html?refid={export/references/reference/id}&amp;type=term','','status=0,scrollbars=1,resizable=1,width=800,height=600'); return false;" title="add Term"><img src='{$urlbase}/images/152.gif' align="absmiddle"/></a> Term</td>

									<td style="font-size: 85%;padding-right:10px;color: white;background-color: #658AAB; "><a  href='#' onclick="window.open('{$urlbase}/edit-annotation.html?refid={export/references/reference/id}&amp;type=multimedia','','status=0,scrollbars=1,resizable=1,width=800,height=600'); return false;" title="add Multimedia annotation"><img src='{$urlbase}/images/74.gif'  align="absmiddle"/></a>Multimedia</td>
									<td style="font-size: 85%;padding-right:10px; "><a  href='#' onclick="window.open('{$urlbase}/edit-annotation.html?refid={export/references/reference/id}&amp;type=hires','','status=0,scrollbars=1,resizable=1,width=800,height=600'); return false;" title="add HiRes annotation"><img src='{$urlbase}/images/74.gif'  align="absmiddle"/></a>Hi res</td>
									<td style="font-size: 85%;padding-right:10px; "><a  href='#' onclick="window.open('{$urlbase}/edit-annotation.html?refid={export/references/reference/id}&amp;type=map','','status=0,scrollbars=1,resizable=1,width=800,height=600'); return false;" title="add Map annotation"><img src='http://dos.heuristscholar.org/heurist/img/reftype/103.gif'  align="absmiddle"/></a>Map</td>

									<td style="font-size: 85%;padding-right:10px;color: white;background-color: #AB658A;" class="annotation entity"><a  href='#' onclick="window.open('{$urlbase}/edit-annotation.html?refid={export/references/reference/id}&amp;type=entity','','status=0,scrollbars=1,resizable=1,width=800,height=600'); return false;" title="add Entity"><img src='{$urlbase}/images/151.gif'  align="absmiddle"/></a> Entity</td>
									<td style="font-size: 85%;padding-right:10px; "><a  href='#' onclick="window.open('{$urlbase}/edit-annotation.html?refid={export/references/reference/id}&amp;type=text','','status=0,scrollbars=1,resizable=1,width=800,height=600'); return false;" title="add Text annotation"><img src='{$urlbase}/images/98.gif'  align="absmiddle"/></a> Text annotation</td>

									<td style="font-size: 85%;padding-right:10px;"><a  href='#' onclick="window.open('{$urlbase}/edit-annotation.html?refid={export/references/reference/id}&amp;type=glossary','','status=0,scrollbars=1,resizable=1,width=800,height=600'); return false;" title="add Glossary annotation"><img src='{$urlbase}/images/glossary1.gif'  align="absmiddle"/></a> Gloss</td>
								
									
									<td style="font-size: 85%;padding-right:10px;"><a  href='#' onclick="window.open('{$urlbase}/addrelationship.html?typeId=52&amp;source={export/references/reference/id}','','status=0,scrollbars=1,resizable=1,width=800,height=600'); return false;" title="add Relationship"><img src='{$urlbase}/images/52.gif'  align="absmiddle"/></a> Relationship</td>

								</xsl:if>
								<xsl:if test=" $id = 2674">
								<td><input type="text" id ="common-recordos-pretend-dropdown" readonly="readonly"/><img id ="common-recordos-drop-img" align="absmiddle"></img>
									<div id="common-recordos-drop-div" style="display:none;"></div>
									<script type="text/javascript" src="{$urlbase}/js/record-dropdown.js"></script>
								</td>
									</xsl:if>
							</tr>
						    </table>
							</xsl:if>
							<!-- Add relationship only needs to be available for Entities, Terms and Media -->
							<xsl:if test="export/references/reference/reftype/@id = 74 or export/references/reference/reftype/@id  = 151 or export/references/reference/reftype/@id  = 152 ">
								<table>
									<tr>
								<td style="font-size: 85%;padding-right:10px;"><a  href='#' onclick="window.open('{$urlbase}/addrelationship.html?typeId=52&amp;source={export/references/reference/id}','','status=0,scrollbars=1,resizable=1,width=800,height=600'); return false;" title="add Relationship"><img src='{$urlbase}/images/52.gif'  align="absmiddle"/></a> Relationship</td>
									</tr>
								</table>
							</xsl:if>
						</div>
					</div>
					<div id="sidebartopcolour" class="colourcelltwo">
					<table width="100%">
					<tr>
					<td id="login">
						<script type="text/javascript">

							var a = document.createElement("a");
							a.href ='http://dos.heuristscholar.org/heurist/php/login-vanilla.php?logo=http://heuristscholar.org/dos/img/logo.png&amp;home=http://heuristscholar.org/dos';


							if (HCurrentUser.isLoggedIn()) {
								document.getElementById("login").appendChild(document.createTextNode(HCurrentUser.getRealName() + " : "));
								a.appendChild( document.createTextNode("Log out"));
							} else {

								a.appendChild(document.createTextNode("Log in"));
							}

							document.getElementById("login").appendChild(a);

						</script>
						</td><td id="heurist-link"><a href="http://dos.heuristscholar.org/heurist/">Heurist</a></td></tr>
						</table>
					</div>


				</div>

				<div id="sidebar" class="colourcellthree">

					<div id="sidebar-inner">

						<div id="search">
							<form  method="post" onsubmit="search(document.getElementById('query-input').value); return false;">
							<input type="text" id="query-input" value=""></input>
							<input type="button" value="search"
							onclick="search(document.getElementById('query-input').value);"/>
							</form>

							<div style="padding-left: 150px;">
								<a title="Coming soon" onclick="alert('Coming soon!');" href="#"> (Advanced)</a>
							</div>
						</div>



						<xsl:call-template name="related_items_section">
							<xsl:with-param name="items"
								select="export/references/reference/related |
																 export/references/reference/pointer |
																 export/references/reference/reverse-pointer"
							/>
						</xsl:call-template>
					</div>
				</div>

				<div id="page">
					<div id="page-inner">
						<h1>
							<!-- <xsl:value-of select="export/references/reference[1]/title"/> -->
							 <span style="padding-right:5px; vertical-align:top">
							 	<a  href="#" onclick="window.open('{$urlbase}/edit.html?id={export/references/reference/id}','','status=0,scrollbars=1,resizable=1,width=800,height=600'); return false; " title="Edit main record">
								 <img src="{$hbase}/img/edit-pencil.gif"  style="vertical-align: top;"/></a>
							 </span>

							<xsl:value-of select="export/references/reference[1]/title"/>
						</h1>
						<!-- full version of record -->
						<xsl:apply-templates select="export/references/reference"/>
					</div>
				</div>

				<div id="footnotes">
					<div id="footnotes-inner">
						<xsl:apply-templates
							select="export/references/reference/reverse-pointer[reftype/@id=99]"
							mode="footnote"/>
					</div>
				</div>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="breadcrumbs">
		<xsl:for-each select="breadcrumb">
			<xsl:sort select="id"/>
			<a href="{url}">
				<xsl:value-of select="title"/>
			</a>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="related_items_section">
		<xsl:param name="items"/>

		<!-- top of sidebar before you start listing the type of relationships -->
		<table id = "relations-table"  cellpadding="2" border="0" width="100%">
			<!-- this step of the code aggregates related items into groupings based on the type of related item -->

			<xsl:for-each select="$items[not(@type = preceding-sibling::*/@type)] ">
				<xsl:choose>
					<xsl:when test="@type != 'Source entity reference' and @type != 'Entity reference' and @type != 'Target entity reference'">
						<xsl:call-template name="related_items_by_reltype">
							<xsl:with-param name="reftype_id" select="reftype/@id"/>
							<xsl:with-param name="reltype" select="@type"/>
							<xsl:with-param name="items" select="$items[@type = current()/@type and reftype/@id != 52]"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>

		</table>
		<div id= "saved-searches">
			<div id = "saved-searches-header"></div>
			<script>
			if (HCurrentUser.isLoggedIn()) {
				var savedSearches = top.HEURIST.user.workgroupSavedSearches["2"];
				document.getElementById("saved-searches-header").innerHTML = "Saved Searches";
				for (i in savedSearches) {
					var div = document.createElement("div");
					div.id = "saved-search-" + i;
					var a = document.createElement("a");
					a.href = "#";

					var regexS = "[\\?&amp;]q=([^&amp;#]*)";
					var regex = new RegExp( regexS );
					var results = regex.exec( savedSearches[i][1]);
					savedSearchesOnclick (a, results[1]);
					a.appendChild(document.createTextNode(savedSearches[i][0]));
					div.appendChild(a);
					document.getElementById("saved-searches").appendChild(div);

				}
			}
				function savedSearchesOnclick (e, res) {
					e.onclick = function() {
						document.getElementById('query-input').value = res;
						search (res);
					}
				}

			</script>
		</div>
	</xsl:template>


	<xsl:template name="related_items_by_reltype">
		<xsl:param name="reftype_id"/>
		<xsl:param name="reltype"/>
		<xsl:param name="items"/>

		<xsl:if test="count($items) > 0">
			<xsl:if test="$reftype_id != 150">
				<tr>
					<td>
						<b>
							<xsl:choose>
								<xsl:when test="$reftype_id = 99"
									>Annotations</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$reltype"/>
									<xsl:value-of select="../@id"/>
									<!--(<xsl:value-of select="count($items)"/>) number of items with this relation -->
								</xsl:otherwise>
							</xsl:choose>
						</b>
					</td>
				</tr>

				<tr>
					<td>
						<!-- (<xsl:value-of select="$items[1]"/>) -->

						<table width="100%">

							<!-- p>id: <xsl:value-of select="$currentid"/> - [<xsl:value-of select="id"/>] - </p -->
							<xsl:apply-templates select="$items[1]">
								<xsl:with-param name="matches" select="$items"/>
							</xsl:apply-templates>
						</table>
					</td>
				</tr>
			</xsl:if>

		</xsl:if>

	</xsl:template>

	<xsl:template name="related_items">
		<xsl:param name="reftype_id"/>
		<xsl:param name="reftype_label"/>
		<xsl:param name="items"/>

		<xsl:if test="count($items) > 0">
			<xsl:if test="$reftype_id != 150">
				<tr>
					<td>
						<b>
							<a href="#" onclick="openRelated({$reftype_id}); return false;">
								<xsl:value-of select="$reftype_label"/>
								<!-- (<xsl:value-of select="count($items)"/>) -->
							</a>
						</b>
					</td>
				</tr>

				<tr name="related" reftype="{$reftype_id}">
					<xsl:if test="$reftype_id!=$related_reftype_filter">
						<xsl:attribute name="style">display: none;</xsl:attribute>
					</xsl:if>
					<td>

						<table width="100%">
							<xsl:apply-templates select="$items[1]">
								<xsl:with-param name="matches" select="$items"/>
							</xsl:apply-templates>
						</table>
					</td>
				</tr>
			</xsl:if>
		</xsl:if>

	</xsl:template>



	<xsl:template match="related | pointer | reverse-pointer">
		<!-- this is where the display work is done summarising the related items of various types - pictures, events etc -->
		<!-- reftype-specific templates take precedence over this one -->
		<xsl:param name="matches"/>

		<!-- trickiness!
		     First off, this template will catch a single related (/ pointer / reverse-pointer) record,
		     with the full list as a parameter ("matches").  This gives the template a chance to sort the records
		     and call itself with those sorted records
		-->
		<xsl:choose>
			<xsl:when test="$matches">
				<xsl:apply-templates select="$matches">
					<xsl:sort select="detail[@id=160]"/>

				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>

				<tr>
					<td>
						<xsl:if test="detail[@id = 222 or @id=223 or @id=224]">
							<xsl:if test="detail/file_thumb_url">
								<a href="{$cocoonbase}/item/{id}">

									<img src="{detail/file_thumb_url}"/>


								</a>
								<br/>

							</xsl:if>
						</xsl:if>
						<a href="{$urlbase}/edit.html?id={id}"
							onclick="window.open(this.href,'','status=0,scrollbars=1,resizable=1,width=800,height=600'); return false;"
							title="edit">
						<img src="{$hbase}/img/edit-pencil.gif"/>
						</a>
						<a href="{$cocoonbase}/item/{id}" class="sb_two">
							<xsl:choose>
								<!-- related / notes -->
								<xsl:when test="@notes">
									<xsl:attribute name="title">
										<xsl:value-of select="@notes"/>
									</xsl:attribute>
								</xsl:when>
							</xsl:choose>
							<xsl:choose>
								<xsl:when test="detail[@id=160]">
									<xsl:value-of select="detail[@id=160]"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="title"/>
								</xsl:otherwise>
							</xsl:choose>
						</a>
					</td>
					<td align="right">
						<!-- change this to pick up the actuall system name of the reftye or to use the mapping method as in JHSB that calls human-readable-names.xml -->
						<img style="vertical-align: middle;horizontal-align: right"
							src="{$hbase}/img/reftype/{reftype/@id}.gif"/>
					</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



	<!-- fall-back template for any reference types that aren't already handled -->
	<xsl:template match="reference">
		<xsl:if test="detail[@id=221]">
			<img src="{detail[@id=221]/file_thumb_url}&amp;w=400"/>
		</xsl:if>
		<table>
			<tr>
				<td colspan="2">
					<img style="vertical-align: middle;"
						src="{$hbase}/img/reftype/{reftype/@id}.gif"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="reftype"/>
				</td>

			</tr>
			<xsl:if test="url != ''">
				<tr>
					<td style="padding-right: 10px;">URL</td>
					<td>
						<a href="{url}">
							<xsl:choose>
								<xsl:when test="string-length(url) &gt; 50">
									<xsl:value-of select="substring(url, 0, 50)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="url"/>
								</xsl:otherwise>
							</xsl:choose>
						</a>
					</td>
				</tr>
			</xsl:if>

			<!-- this calls  ? -->
			<xsl:for-each select="detail[@id!=222 and @id!=223 and @id!=224]">
				<tr>
					<td style="padding-right: 10px;">
						<nobr>
							<xsl:choose>
								<xsl:when test="string-length(@name)">
									<xsl:value-of select="@name"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="@type"/>
								</xsl:otherwise>
							</xsl:choose>
						</nobr>
					</td>
					<td>
						<xsl:choose>
							<!-- 268 = Contact details URL,  256 = Web links -->
							<xsl:when test="@id=268  or  @id=256  or  starts-with(text(), 'http')">
								<a href="{text()}">
									<xsl:choose>
										<xsl:when test="string-length() &gt; 50">
											<xsl:value-of select="substring(text(), 0, 50)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="text()"/>
										</xsl:otherwise>
									</xsl:choose>
								</a>
							</xsl:when>
							<!-- 221 = AssociatedFile,  231 = Associated File -->
							<xsl:when test="@id=221  or  @id=231">
								<a href="{file_fetch_url}">
									<xsl:value-of select="file_orig_name"/>
								</a>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="text()"/>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
			</xsl:for-each>


			<tr>
				<td style="padding-right: 10px;">
					<xsl:value-of select="pointer[@id=264]/@name"/>
				</td>
				<td>
					<xsl:apply-templates select="pointer[@id=264]"/>

				</td>
			</tr>
			<tr>
				<td style="padding-right: 10px;">
					<xsl:value-of select="pointer[@id=267]/@name"/>
				</td>
				<td>

					<xsl:apply-templates select="pointer[@id=267]"/>
				</td>
			</tr>

			<xsl:if test="notes != ''">
				<tr>
					<td style="padding-right: 10px;">Notes</td>
					<td>
						<xsl:value-of select="notes"/>
					</td>
				</tr>
			</xsl:if>

			<xsl:if test="detail[@id=222 or @id=223 or @id=224]">
				<tr>
					<td style="padding-right: 10px;">Images</td>
					<td>
						<!-- 222 = Logo image,  223 = Thumbnail,  224 = Images -->
						<xsl:for-each select="detail[@id=222 or @id=223 or @id=224]">
							<a href="{file_fetch_url}">
								<img src="{file_thumb_url}" border="0"/>
							</a> &#160;&#160; </xsl:for-each>
					</td>
				</tr>
			</xsl:if>
		</table>
	</xsl:template>

	<xsl:template name="paragraphise">
		<xsl:param name="text"/>
		<xsl:for-each select="str:split($text, '&#xa;&#xa;')">
			<p>
				<xsl:value-of select="."/>
			</p>
		</xsl:for-each>
	</xsl:template>


</xsl:stylesheet>
