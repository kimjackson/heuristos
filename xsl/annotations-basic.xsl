<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:str="http://exslt.org/strings" version="1.0">

	<xsl:template match="/">
		<p>count:
			<xsl:value-of select="count(export/references/reference)"/>
		</p>
		<xsl:for-each select="export/references/reference[reftype/@id=99][not(pointer[@id=322]/id = preceding-sibling::reference[reftype/@id=99]/pointer[@id=322]/id)] ">
			<h2><a href="/cocoon/dos/browser/item/{pointer[@id=322]/id}/"><xsl:value-of select="pointer[@id=322]/title"/></a></h2>
			<xsl:apply-templates select="/export/references/reference[reftype/@id=99][pointer[@id=322]/id = current()/pointer[@id=322]/id]">
				<xsl:sort select="id"/>
			</xsl:apply-templates>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="reference[reftype/@id=99]">
		<p>
			<xsl:value-of select="id"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="title"/>
		</p>
	</xsl:template>

</xsl:stylesheet>
