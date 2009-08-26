<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<!-- tei to html basic style sheet written by Kim Jackson v.2 - 3 September 2008 -->
	<!-- identity transform -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>



	<!-- only use text/body/div from TEI, discard the rest -->
	<xsl:template match="TEI">
		<xsl:apply-templates select="text/body/div"/>
	</xsl:template>


	<xsl:template match="TEI/text/body/div">
		<xsl:copy>
			<xsl:apply-templates select="head|div|p|list|table|emph"/>
		</xsl:copy>
	</xsl:template>


	<xsl:template match="TEI/text/body/div/div">
		<xsl:apply-templates select="head|div|p|list|table|emph"/>
	</xsl:template>


	<!-- argh I am makink complete mess here -->

	<xsl:template match="TEI//div/head">
		<h2>
			<xsl:value-of select="."/>
		</h2>
	</xsl:template>



	<!-- not necessary - P elements will be copied by the identity transform above -->
	<xsl:template match="TEI//p">
		<p>
			<xsl:apply-templates/>
		</p>
	</xsl:template>


	<xsl:template match="TEI//hi[@rend='italics']">
		<i>
			<xsl:value-of select="."/>
		</i>
	</xsl:template>

	<xsl:template match="TEI//hi[@rend='bold']">
		<b>
			<xsl:value-of select="."/>
		</b>
	</xsl:template>

	<xsl:template match="quote">
		<p class="quote">
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="note">
		<!-- don't do anything yet -->
	</xsl:template>

	<!-- table -->
	<xsl:template match="TEI//table">
		<table cellpadding="2" cellspacing="2">
			<xsl:apply-templates select="row"/>
		</table>
	</xsl:template>
	<xsl:template match="TEI//table/row">
		<tr>
			<xsl:apply-templates select="cell"/>
		</tr>
	</xsl:template>
	<xsl:template match="TEI//table/row/cell">
		<td class="teidoc">
			<xsl:apply-templates/>
		</td>
	</xsl:template>


	<!-- list -->
	<xsl:template match="TEI//list">
		<ul>
			<xsl:apply-templates select="item"/>
		</ul>
	</xsl:template>

	<xsl:template match="TEI//item">
		<li>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

</xsl:stylesheet>
