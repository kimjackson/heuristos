<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings" version="1.0">

	<!-- Heuristos entity rendering template
		entities have the reftype of 151 -->

	<xsl:param name="flavour"/>

	<xsl:template
		match="related[reftype/@id=151] | pointer[reftype/@id=151] | reverse-pointer[reftype/@id=151]">
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
					<xsl:element name="td">

						<xsl:attribute name="class">relateditem</xsl:attribute>
						<xsl:attribute name="title">{Relationship type: <xsl:value-of select="@type"
							/>} <xsl:if test="@notes"> &#160; <xsl:value-of select="@notes"/>
							</xsl:if>
						</xsl:attribute>
						<xsl:if test="detail/file_thumb_url">
							<a href="{$cocoonbase}/item/{id}/{/export/references/reference/reftype/@id}?flavour={$flavour}"
								class="sb_two">
								<img src="{detail/file_thumb_url}"/>
							</a>
							<br/>
						</xsl:if>
						<a href="{$urlbase}/edit.html?id={id}"
							onclick="window.open(this.href,'','status=0,scrollbars=1,resizable=1,width=800,height=600'); return false;"
							title="edit">
						<img src="{$hbase}/img/edit-pencil.gif"/>
						</a>
						<a
							href="{$cocoonbase}/item/{id}/{/export/references/reference/reftype/@id}?flavour={$flavour}"
							class="sb_two">
							<xsl:value-of select="detail[@id=291]"/>
							<xsl:text> </xsl:text>
							<xsl:value-of select="detail[@id=160]"/>
						</a>
					</xsl:element>
					<td align="right">
						<!-- change this to pick up the actuall system name of the reftye or to use the mapping method as in JHSB that calls human-readable-names.xml -->
						<img style="vertical-align: middle;horizontal-align: right"
							src="{$hbase}/img/reftype/{reftype/@id}.gif"/>
					</td>

				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="entity" match="reference[reftype/@id=151]">

		<div><xsl:attribute name="id">
			<xsl:choose>
				<!--xsl:when test="reverse-pointer/detail[@id=230]">entity_with_map</xsl:when-->
				<xsl:otherwise>entity</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>

		<table border="0" cellpadding="2">

			<xsl:if test="detail[@id=160]">
				<tr>
					<td colspan="2">
					     <h1>
							 <span style="padding-right:5px; vertical-align:top">
								 <a  href="#" onclick="window.open('{$urlbase}/edit.html?id={id}','','status=0,scrollbars=1,resizable=1,width=800,height=600'); " title="Edit main record">
								 <img src="{$hbase}/img/edit-pencil.gif"  style="vertical-align: top;"/></a>
							 </span>
							<xsl:value-of select="detail[@id=160]"/>
						</h1>
					</td>
				</tr>
			</xsl:if>


			<xsl:if test="detail[@id=523]">
				<tr>
					<td>
						Type:
					</td>
					<td>
						<b><xsl:value-of select="detail[@id=523]"/></b>
					</td>
				</tr>
			</xsl:if>

			<xsl:if test="detail[@id=399]">
				<tr>
					<td>
						Gender:
					</td>
					<td>
						<b><xsl:choose>
							<xsl:when test="detail[@id=399] = 'Male'">Male</xsl:when>
							<xsl:when test="detail[@id=399] = 'Female'">Female</xsl:when>
							<xsl:otherwise>Unknown</xsl:otherwise>
						</xsl:choose></b>
					</td>
				</tr>
			</xsl:if>

			<xsl:if test="detail[@id=524]">
				<tr>
					<td>
						Real/Fictional:
					</td>
					<td>
						<b><xsl:choose>
							<xsl:when test="detail[@id=524] = 'true'">Real</xsl:when>
							<xsl:otherwise>Fictional</xsl:otherwise>
						</xsl:choose></b>
					</td>
				</tr>
			</xsl:if>
		</table>
		<br/>


		<div id="factiod">
		<table border="0" cellpadding="2" width="100%" align="center">
			<tr  class="colourcellsix">
				<th>Type</th>
				<th>Source</th>
				<th>Related</th>
				<th>Start</th>
				<th>End</th>
				<th>Place</th>
			</tr>
			<xsl:apply-templates
				select="related[reftype/@id=150] | pointer[reftype/@id=150] | reverse-pointer[reftype/@id=150]"
			>
				<xsl:sort select="detail[@id=526]"/>
				<xsl:sort select="detail[@id=177]/year"/>
				<xsl:sort select="detail[@id=177]/month"/>
				<xsl:sort select="detail[@id=177]/day"/>
				<xsl:sort select="detail[@id=178]/year"/>
				<xsl:sort select="detail[@id=178]/month"/>
				<xsl:sort select="detail[@id=178]/day"/>
			</xsl:apply-templates>

			<tr>

				 <xsl:element name="td">
					<input type="button"
					class="add-annotation-button"
					onclick="window.open('{$urlbase}/edit.html?typeId=150&amp;source={id}','','status=0,scrollbars=1,resizable=1,width=800,height=600'); return false;"
					value="add factoid"/>
				 </xsl:element>
			</tr>

		</table>
			</div>

			<xsl:if test="related[reftype/@id=150]/detail/@id=230 or
			              pointer[reftype/@id=150]/detail/@id=230 or
			      reverse-pointer[reftype/@id=150]/detail/@id=230"
			>
				<div id="map"></div>
			</xsl:if>

		</div>

	</xsl:template>

	<xsl:template
		match="related[reftype/@id=150] | pointer[reftype/@id=150] | reverse-pointer[reftype/@id=150]">
		<xsl:param name="matches"/>
		<tr>
			<td><!-- Type -->
				<a href="{$urlbase}/edit.html?id={id}"
					onclick="window.open(this.href,'','status=0,scrollbars=1,resizable=1,width=800,height=600'); return false;"
					title="edit">
					<img src="{$hbase}/img/edit-pencil.gif"/>
				</a>
				<xsl:value-of select="detail[@id=526]"/>
			</td>
			<td><!-- Source -->
				<!-- small>[<xsl:value-of select="name(.)"/>]</small -->

				<!-- the following choose section looks at the source and target entities in the factiod and says
				if they exist and are no the same as the main entity display the title and create a link -->

				<xsl:choose>

					<xsl:when test="pointer[@id=528]/id and ../id != pointer[@id=528]/id">
						<a href="{$cocoonbase}/item/{pointer[@id=528]/id}" class="sb_two">
							<xsl:value-of select="pointer[@id=528]/title"/>
						</a>
					</xsl:when>
					<xsl:when test="pointer[@id=528]/id and ../id = pointer[@id=528]/id">
						<em>self</em>
					</xsl:when>
					<!-- xsl:when test="pointer[@id=528]">

						<a href="{$cocoonbase}/item/{pointer[@id=528]/id}" class="sb_two"><xsl:value-of select="detail[@id=160]"/></a>
					</xsl:when -->

					<!--test for case of alternate name, which by convention will be stored in the name field and identified in the type -->

				</xsl:choose>

			</td>
			<td><!-- Related -->
				<xsl:choose>
					<xsl:when test="pointer[@id=529]/id and ../id != pointer[@id=529]/id">
						<a href="{$cocoonbase}/item/{pointer[@id=529]/id}" class="sb_two">
							<xsl:value-of select="pointer[@id=529]/title"/>
						</a>
					</xsl:when>
					<xsl:when test="pointer[@id=529]/id and ../id = pointer[@id=529]/id">
						<em>self</em>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="detail[@id=160]"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>

			<td><!-- Start -->
				<xsl:if test="detail[@id=177]/year">
					<xsl:value-of select="detail[@id=177]/year"/>
				</xsl:if>
				<xsl:if test="detail[@id=177]/month">/<xsl:value-of select="detail[@id=177]/month"/></xsl:if>
				<xsl:if test="detail[@id=177]/day">/<xsl:value-of select="detail[@id=177]/day"
				/></xsl:if>
			</td>
			<td><!-- End -->
				<xsl:if test="detail[@id=178]/year">
					<xsl:value-of select="detail[@id=178]/year"/>
				</xsl:if>
				<xsl:if test="detail[@id=178]/month">/<xsl:value-of select="detail[@id=178]/month"/></xsl:if>
				<xsl:if test="detail[@id=178]/day">/<xsl:value-of select="detail[@id=178]/day"/></xsl:if>
			</td>
			<td><!-- Place -->
				<xsl:choose>
					<xsl:when test="pointer[@id=528] and detail/@id=230">
						<!-- nb detail 230 = type location so show map -->

						see map


						<script>
							var HEURIST = {};
						</script>
						<!-- yes you do need this -->
						<xsl:element name="script">
							<xsl:attribute name="src"><xsl:value-of select="$hbase"/>/mapper/tmap-data.php?w=all&amp;q=id:<xsl:value-of select="id"/>
								<xsl:for-each select="related">
									<xsl:text>,</xsl:text>
									<xsl:value-of select="id"/>
								</xsl:for-each>
							</xsl:attribute>
						</xsl:element>
						<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAGZugEZOePOFa_Kc5QZ0UQRQUeYPJPN0iHdI_mpOIQDTyJGt-ARSOyMjfz0UjulQTRjpuNpjk72vQ3w"></script>
						<script src="{$hbase}/mapper/epoly.js"></script>
						<script src="{$hbase}/mapper/mapper.js"></script>

						<!-- script>
							loadMap( { compact: true, highlight: [<xsl:value-of select="id"/>], onclick: function(record) { window.location = "<xsl:value-of select="$cocoonbase"/>/item/<xsl:value-of select="id"/>"; } } );
							</script -->

						<script>
							window.onload = function() {
								loadMap( { compact: true, highlight: [], onclick: function(record) { window.location = "/cocoon/dos/browser/item/"+record.bibID+"/"; } } );
							};
						</script>

					</xsl:when>
					<xsl:when test="pointer[@id=527]/id and ../id != pointer[@id=527]/id">
						<a href="{$cocoonbase}/item/{pointer[@id=527]/id}" class="sb_two">
							<xsl:value-of select="pointer[@id=527]/title"/>
						</a>
					</xsl:when>
					<xsl:when test="pointer[@id=527]/id and ../id = pointer[@id=527]/id">
						<em>self</em>
					</xsl:when>
				</xsl:choose>

			</td>
		</tr>

	</xsl:template>




</xsl:stylesheet>
