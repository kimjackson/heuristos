<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<!-- In Heristos this type of record is actually called a factiod -->

	<xsl:param name="flavour"/>

	<xsl:template name="historical_event" match="reference[reftype/@id=51]">
		<table width="100%">
			<tr>
				<td width="100%">



					<!-- xsl:choose>
						<xsl:when test="detail@id = 230" -->

						<!-- test for the existence of detail id 230 - geographic type -->


						<!-- this is where the map goes -->
						<div id="map" style="width: 100%; height: 95%;"></div>

						<!--  /xsl:when>
						<xsl:otherwise>
							<xsl:if test="detail[@id=223]">


							</xsl:if>
						</xsl:otherwise>
					</xsl:choose -->

					<br/>
					<xsl:if test="detail[@id=255]">
						<xsl:for-each select="detail[@id=255]">
							<!-- role -->
							<em><xsl:value-of select="text()"/></em>
							<xsl:if test="position() != last()">,&#160; </xsl:if>
						</xsl:for-each>
					</xsl:if>
					<xsl:if test="detail[@id=266]">
						<xsl:call-template name="paragraphise">
							<xsl:with-param name="text">
								<xsl:value-of select="detail[@id=266]"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
					<br/>
					<br/>
				</td>
			</tr>
		</table>


		<!-- retrieve map data for main id and all related records -->
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

		<script>
			loadMap( { compact: true, highlight: [<xsl:value-of select="id"/>], onclick: function(record) { window.location = "<xsl:value-of select="$cocoonbase"/>/item/"+record.bibID+"/51?flavour=<xsl:value-of select="$flavour"/>"; } } );
		</script>

	</xsl:template>

	<!-- xsl:template name="person-summary" match="reference[reftype/@id=55]">
		<table>
			<tr>
				<td>
					<xsl:if test="detail[@id=223]">

						<div style="float: left;">
							<xsl:for-each select="detail[@id=223]">
								<img src="{file_thumb_url}" vspace="10" hspace="10"/>
							</xsl:for-each>
						</div>
					</xsl:if>

					<h1><xsl:value-of select="title"/></h1>
				</td>
			</tr>
		</table>
	</xsl:template -->

</xsl:stylesheet>
