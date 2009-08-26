<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:param name="flavour"/>

	<xsl:template match="related[reftype/@id=74] | pointer[reftype/@id=74] | reverse-pointer[reftype/@id=74]">
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
						<xsl:attribute name="title">{Relationship type: <xsl:value-of select="@type"/>}
							<xsl:if test="@notes">
								&#160; <xsl:value-of select="@notes"/>
							</xsl:if>
						</xsl:attribute>
						<xsl:if test="detail/file_thumb_url">
							<a href="{$cocoonbase}/item/{id}">
								<img src="{detail/file_thumb_url}" border="0"/>
							</a>
							<br/>
						</xsl:if>
						<a href="{$urlbase}/edit.html?id={id}"
							onclick="window.open(this.href,'','status=0,scrollbars=yes,resizable=1,width=800,height=600'); return false;"
							title="edit">
						<img src="{$hbase}/img/edit-pencil.gif"/>
						</a>
						<a href="{$cocoonbase}/item/{id}" class="sb_two">
							<xsl:value-of select="detail[@id=291]"/>
							<xsl:text> </xsl:text>
							<xsl:value-of select="detail[@id=160]"/>
						</a>
					</xsl:element>
					<td align="right">
						<!-- change this to pick up the actuall system name of the reftye or to use the mapping method as in JHSB that calls human-readable-names.xml -->
						<img style="vertical-align: middle;horizontal-align: middle" src="{$hbase}/img/reftype/{reftype/@id}.gif"/>
					</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="media" match="reference[reftype/@id=74]">
		<table>
			<tr>
				<td align="center">
					<xsl:if test="detail[@id=223]">
						<!-- thumbnail -->
						<div style="float: center;">
							<xsl:for-each select="detail[@id=223]">
								<img src="{file_fetch_url}" vspace="10" hspace="10" align="center"/>
							</xsl:for-each>
							<xsl:if test="detail/file_thumb_url">
								<a href="{$cocoonbase}/item/{id}/{/export/references/reference/reftype/@id}?flavour={$flavour}">
									<img src="{detail/file_thumb_url}"/>
								</a>
								<br/>
							</xsl:if>
						</div>
					</xsl:if>


					<br/>
					<xsl:if test="detail[@id=255]">
						<xsl:for-each select="detail[@id=255]">
							<!-- role -->
							<em>
								<xsl:value-of select="text()"/>
							</em>
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
					<xsl:if test="detail[@id=221]">
						<div align="center"><a href="{detail/file_fetch_url}" target="_top">
							<img src="{detail/file_thumb_url}&amp;w=560" border="1"/>
						</a></div>
						<br/>
						<!-- xsl:value-of select="detail/file_fetch_url"/ -->
					</xsl:if>

					<xsl:if test="notes">
						<em>
							<xsl:call-template name="paragraphise">
								<xsl:with-param name="text">
									<xsl:value-of select="notes"/>
								</xsl:with-param>
							</xsl:call-template>
						</em>
						<br/>
					</xsl:if>

					<xsl:if test="detail[@id=151]">
						<p>
							Technical notes:
							<xsl:call-template name="paragraphise">
								<xsl:with-param name="text">
									<xsl:value-of select="detail[@id=151]"/>
								</xsl:with-param>
							</xsl:call-template>
						</p>
					</xsl:if>

				</td>
			</tr>
		</table>
	</xsl:template>

</xsl:stylesheet>
