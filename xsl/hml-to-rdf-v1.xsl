<!DOCTYPE stylesheet [
<!ENTITY space "<xsl:text> </xsl:text>">
<!ENTITY cr "<xsl:text> 
</xsl:text>">

]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:output method="html" encoding="UTF-8"/>
    <xsl:include href="dos_urlmap.xsl"/>
    
    <!-- note: make sure you have a fresh urlmap generated -->
    
    <xsl:strip-space elements="*"/>
        
    <xsl:template match="/">
       
        <!-- find and process all top level records -->

        <!-- xsl:call-template name="model"/ -->

        <xsl:apply-templates select="hml/records/record"/>
           
    </xsl:template>


    <xsl:template match="record">

        <xsl:variable name="url-title">
            <xsl:call-template name="getPath">
                <xsl:with-param name="id" select="id"/>
            </xsl:call-template>
        </xsl:variable>


        <xsl:variable name="url-label">
            <xsl:choose>
                <xsl:when test="detail[@id=523] = 'Person'">
                    <xsl:value-of select="substring-after($url-title,'person/')"/>
                </xsl:when>
            </xsl:choose>

        </xsl:variable>

        
            
        
            <xsl:choose>
                <xsl:when test="type[@id=74]"> 
                    
                    <!-- multimedia -->
                    
                    <xsl:text>dos:Image_</xsl:text><xsl:value-of select="id"/>
                    <xsl:text> rdf:type dos:Image</xsl:text>
                    <xsl:call-template name="endLine"/>
                    
                    <xsl:choose>
                        <xsl:when test="detail[@id=538]">
                            <xsl:text>dos:hasContributor dos:</xsl:text>
                            <xsl:variable name="imageContrib">
                            <xsl:call-template name="getPath">
                                <xsl:with-param name="id" select="detail[@id=538]/record/id"/>
                            </xsl:call-template>
                            </xsl:variable>
                            <xsl:value-of select="substring-after($imageContrib,'/')"/>
                            <xsl:call-template name="endLine"/>
                        </xsl:when>
                    </xsl:choose>
                    
                    <xsl:text>rdfs:label "</xsl:text>
                    <xsl:value-of select="normalize-space(detail[@id=160])" disable-output-escaping="yes"/>
                    <xsl:text>"</xsl:text>
		    <xsl:call-template name="XMLSchemaString"/>
                    <xsl:call-template name="endLine"/>
                    
                    <xsl:text>dos:hasUrl "http://www.dictionaryofsydney.org/image/</xsl:text>
                    <xsl:value-of select="id"/>
                    <xsl:text>"</xsl:text>
                    <xsl:call-template name="XMLSchemaString"/>
                    
                    <xsl:choose>
                        <xsl:when test="relationships/record/detail[@id=199]">
                            <xsl:apply-templates select="relationships/record/detail[@id=199]/record">
                                <xsl:with-param name="parentid" select="id"/>
                                <xsl:with-param name="master_rec_type">mm</xsl:with-param>
                            </xsl:apply-templates>
                        </xsl:when>
                      
                    
                    </xsl:choose>
                    <xsl:call-template name="endStatement"/>
                    
                </xsl:when>
                
                <xsl:when test="type[@id=1]"> 
                    
                    <!-- external links -->
                    
                    <xsl:text>dos:External_link_</xsl:text>
                    <xsl:value-of select="id"/>
                    <xsl:text> rdf:type dos:External_link </xsl:text>
                    <xsl:call-template name="endLine"/>
                    
                    <xsl:text>rdfs:label ""</xsl:text>
                    <xsl:call-template name="XMLSchemaString"/>
                    <xsl:call-template name="endLine"/>
                    
                    <xsl:text>dos:hasUrl "</xsl:text>
                    <xsl:value-of select="detail[@id=198]"/>
                    <xsl:text>"</xsl:text>
                    <xsl:call-template name="XMLSchemaString"/>
                    <xsl:call-template name="endStatement"/>
                
                </xsl:when>
                
                
                <xsl:when test="type[@id=91]"> 
                    
                    <!-- roles -->
                    
                    <xsl:variable name="formated_title">
                        <xsl:call-template name="getPath">
                        <xsl:with-param name="id" select="id"/>
                    </xsl:call-template> </xsl:variable>
                    
                    <xsl:text>dos:</xsl:text>
                    
                    <xsl:value-of select="substring-after($formated_title,'/')"/>
                    
                    <xsl:text> </xsl:text> 
                    
                    <xsl:text> rdf:type dos:Role_</xsl:text><xsl:value-of select="detail[@id=591]"/> <xsl:text> </xsl:text>
                    <xsl:call-template name="endLine"/>
                    
                    <xsl:text>rdfs:label "</xsl:text><xsl:value-of select="title" disable-output-escaping="yes"/><xsl:text>"</xsl:text>
                    <xsl:call-template name="XMLSchemaString"/>
                    <xsl:call-template name="endLine"/>
                    
                    <xsl:text>dos:hasUrl "www.dictionaryofsydney.org/role/</xsl:text> 
                    <xsl:value-of select="substring-after($formated_title,'/')"/>
                    
                    <xsl:text>"</xsl:text>
                    <xsl:call-template name="XMLSchemaString"/>
                    <xsl:call-template name="endStatement"/>
                    
                </xsl:when>
                
                
                <xsl:when test="type[@id=152]"> 
                    
                    <!-- terms -->
                    
                    <xsl:variable name="formatted_title">
                        <xsl:call-template name="getPath">
                            <xsl:with-param name="id" select="id"/>
                        </xsl:call-template>
                    </xsl:variable>
                    
                    
                    <xsl:text>dos:</xsl:text>
                   <xsl:value-of select="substring-after($formatted_title,'/')"/>
                    <xsl:text> rdf:type dos:Subject</xsl:text> 
                    
                    <xsl:apply-templates select="relationships/record/detail[@id=199]/record">
                        <xsl:with-param name="parentid" select="id"/>
                        <xsl:with-param name="master_rec_type">term</xsl:with-param>
                    </xsl:apply-templates>
                    
                    <xsl:call-template name="endStatement"/>
                
                
                </xsl:when>
                
                <xsl:when test="type[@id=99] and (detail[@id=199] or detail[@id=359] = 'Annotation Gloss')"> 
                    
                    <!-- dos:Annotations -->
                    
                    <xsl:variable name="annotation_type">
                        <xsl:value-of select="substring-before(detail[@type = 'Annotation type'],' ')"/>
                        <xsl:text>_</xsl:text>
                        <xsl:value-of select="substring-after(detail[@type = 'Annotation type'],' ')"/>
                    </xsl:variable>
                    
                    <xsl:variable name="target_type">
                        <xsl:choose>
                            <xsl:when test="detail[@id=199]"><xsl:value-of select="detail[@id=199]/record/type"/></xsl:when>
                            <xsl:otherwise>Entry</xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    
                    <xsl:variable name="target_dctype">
                        <xsl:choose>
                            <xsl:when test="detail[@id=199]"><xsl:value-of select="detail[@id=199]/record/detail[@id=523]"/></xsl:when>
                            <xsl:otherwise>Entry</xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    
                    <xsl:variable name="target_id">
                        <xsl:choose>
                            <xsl:when test="$target_type != 'Entry'">
                                <xsl:value-of select="detail[@id=199]/record/id"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="detail[@id=322]/record/id"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                     
                     
                     
                    <xsl:variable name="type_short_name">
                    <xsl:choose>
                    <xsl:when test="starts-with($target_type,'Media')">
                            <xsl:choose>
                                <xsl:when test="starts-with(detail[@id=199]/record/detail[@id=289],'image')">Image</xsl:when>
                                <xsl:when test="starts-with(detail[@id=199]/record/detail[@id=289],'video')">Video</xsl:when>
                                <xsl:when test="starts-with(detail[@id=199]/record/detail[@id=289],'audio')">Audio</xsl:when>
                                <!-- need case to handle map mime types -->
                            </xsl:choose>
                        
                    </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="detail[@id=199]/record/detail[@id=523]"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    </xsl:variable>
                    
                  
                    
                    <xsl:text>dos:</xsl:text>
                    <xsl:value-of select="$annotation_type"/>
                    <xsl:text>_</xsl:text>
                    <xsl:value-of select="id"/>
                    <xsl:text> rdf:type dos:</xsl:text>
                    <xsl:value-of select="$annotation_type"/>
                    <xsl:call-template name="endLine"/>
                    
                    <xsl:text>dos:Annotation_hasSource dos:</xsl:text>
                    <xsl:call-template name="capitalise">
                        <xsl:with-param name="input">
                            <xsl:call-template name="search-and-replace">
                                <xsl:with-param name="input">
                                    <xsl:call-template name="getPath">
                                        <xsl:with-param name="id" select="detail[@id=322]/record/id"/>
                                    </xsl:call-template>
                                </xsl:with-param>
                                <xsl:with-param name="search-string">/</xsl:with-param>
                                <xsl:with-param name="replace-string">_</xsl:with-param>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                   <xsl:call-template name="endLine"/>
                   
                    <xsl:choose>
                        <xsl:when test="detail[@id=199]">
                    <xsl:text>dos:Annotation_hasTarget dos:</xsl:text>
                    
                   
                    <xsl:variable name="targetPathName">
                        <xsl:call-template name="getPath">
                            <xsl:with-param name="id" select="$target_id"/>
                        </xsl:call-template>
                    </xsl:variable>
                    
                    <xsl:value-of select="$type_short_name"/><xsl:text>_</xsl:text><xsl:value-of select="substring-after($targetPathName,'/')"/>
                    
                    
                    <xsl:call-template name="endLine"/>
                        </xsl:when>
                        </xsl:choose>
                    
                    <xsl:choose>
                        <xsl:when test="detail[@id=191]">
                            <xsl:text>dos:Annotation_hasDescription "</xsl:text> 
                            <xsl:value-of select="normalize-space(detail[@id=191])"/> 
                            <xsl:text>"</xsl:text>
                            <xsl:call-template name="XMLSchemaString"/>
                            <xsl:call-template name="endLine"/>
                        </xsl:when>
                        </xsl:choose>
                    
                    <xsl:text>dos:hasUrl "http://www.dictionaryofsydney.org/</xsl:text> 
                    <xsl:call-template name="getPath">
                         <xsl:with-param name="id" select="detail[@id=322]/record/id"/>
                    </xsl:call-template>
                    <xsl:text>#ref=</xsl:text>
                    <xsl:value-of select="id"/>
                    <xsl:text>"</xsl:text>
                    <xsl:call-template name="XMLSchemaString"/>
                    <xsl:call-template name="endLine"/>
                    
                    <xsl:text>rdfs:label "</xsl:text>
                    <xsl:value-of select="normalize-space(detail[@id=160])" disable-output-escaping="yes"/>
                    <xsl:text>"</xsl:text>
                    <xsl:call-template name="XMLSchemaString"/>
                    <xsl:call-template name="endStatement"/>              
                    
                </xsl:when>   
                
                
                <xsl:when test="type[@id=98]">
                    
                    <!-- entries -->
                    
                    <xsl:variable name="pathName">
                        <xsl:call-template name="getPath">
                            <xsl:with-param name="id" select="id"/>
                        </xsl:call-template>
                    </xsl:variable>
                    
                    <xsl:variable name="contribPathName">
                        <xsl:call-template name="getPath">
                            <xsl:with-param name="id" select="detail[@id=538]/record/id"/>
                        </xsl:call-template>
                    </xsl:variable>
                    
                    <xsl:text>dos:Entry_</xsl:text>
                    <xsl:value-of select="substring-after($pathName,'/')"/>
                    <xsl:text> rdf:type dos:Entry</xsl:text>
                    <xsl:call-template name="endLine"/>
                    
                    <xsl:text>dos:hasAuthor dos:</xsl:text>
                    <xsl:value-of select="substring-after($contribPathName,'/')"/>
                    <xsl:call-template name="endLine"/>
                    
                    <xsl:text>dos:hasUrl "http://www.dictionaryofsydney.org/</xsl:text>
                    <xsl:value-of select="$pathName"/>
                    <xsl:text>"</xsl:text>
                    <xsl:call-template name="XMLSchemaString"/>
                    <xsl:call-template name="endLine"/>
                    
                    <xsl:text>rdfs:label "</xsl:text>
                    <xsl:value-of select="title" disable-output-escaping="yes"/>
                    <xsl:text>"</xsl:text>
                    <xsl:call-template name="XMLSchemaString"/>
                    
                    
                    <xsl:apply-templates select="relationships/record/detail[@id=199]/record">
                        <xsl:with-param name="parentid" select="id"/>
                        <xsl:with-param name="master_rec_type">entry</xsl:with-param>
                    </xsl:apply-templates>
                    <xsl:call-template name="endStatement"/>
                    
                </xsl:when>
                
                
                <xsl:when test="type[@id=151]">
                    
                    <!-- entities -->
                    
                    <xsl:variable name="url_title">
                        <xsl:call-template name="getPath">
                            <xsl:with-param name="id" select="id"/>
                        </xsl:call-template>
                    </xsl:variable>
                    
                    <xsl:text>dos:</xsl:text>
                    <xsl:value-of select="substring-after($url-title,'/')"/> 
                    <xsl:text> rdf:type dos:</xsl:text>
                    
                    <xsl:variable name="entity_reformated_string">
                        <xsl:call-template name="search-and-replace">
                            <xsl:with-param name="input" select="detail[@id=523]"/>    
                            <xsl:with-param name="search-string"><xsl:text> </xsl:text></xsl:with-param>
                            <xsl:with-param name="replace-string"><xsl:text>_</xsl:text></xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>
                    
                    <xsl:value-of select="$entity_reformated_string"/>
                    
                    <xsl:call-template name="endLine"/>
                    <xsl:text>rdfs:label "</xsl:text>
                    <xsl:value-of select="normalize-space(detail[@id=160])" disable-output-escaping="yes"/>
                    <xsl:text>"</xsl:text>
                    
                    <xsl:choose>                    
                        <xsl:when test="detail[@id=508]">
                            <xsl:call-template name="endLine"/>
                            <xsl:text>dos:hasDefaultImage dos:Image_</xsl:text>
                            <xsl:value-of select="detail[@id=508]/record/id"/>
                        </xsl:when>
                    </xsl:choose>
                    
                    <xsl:choose>
                        <xsl:when test="$url_title">
                            <xsl:call-template name="endLine"/>
                            <xsl:text>dos:hasUrl "http://www.dictionaryofsydney.org/</xsl:text>
                            <xsl:value-of select="$url_title"/>
                            <xsl:text>"</xsl:text>
                            <xsl:call-template name="XMLSchemaString"/>
                        </xsl:when>
                    </xsl:choose>
                    
                    <xsl:choose>
                        <xsl:when test="relationships/record/detail[@name='dc.type'] = 'hasSubject' 
                            or relationships/record/detail[@name='dc.type'] = 'hasPrimarySubject' 
                            or relationships/record/detail[@name='dc.type'] = 'hasExternalLink'">
                            
                            <xsl:apply-templates select="relationships/record/detail[@id=199]/record">
                                <xsl:with-param name="parentid" select="id"/>
                                <xsl:with-param name="master_rec_type">entity</xsl:with-param>
                            </xsl:apply-templates>
                           
                            
                        </xsl:when>
                    </xsl:choose>     
               
                    
                    <xsl:call-template name="endStatement"/>
                
                </xsl:when>
                
                <xsl:when test="type[@id=150]">
                    <!-- factiods - draft -->
                    
                    <xsl:text>dos:Factoid_</xsl:text><xsl:value-of select="detail[@id=526]"/><xsl:text>_</xsl:text><xsl:value-of select="id"/> <xsl:text> rdf:type dos:Factoid_</xsl:text><xsl:value-of select="detail[@id=526]"/><xsl:text> ;</xsl:text>&cr;
                    
                    
                    <xsl:choose>
                        <xsl:when test="detail[@id=526] = 'Position'">
                             <xsl:text>rdfs:label "</xsl:text>
                            <xsl:value-of select="detail[@id=529]/record/detail[@id=160]" disable-output-escaping="yes"/>
                            <xsl:text>"</xsl:text>
                            <xsl:call-template name="XMLSchemaString"/>
                            <xsl:call-template name="endLine"/>
                        </xsl:when>
                    </xsl:choose> 
                    
                    <xsl:text>dos:Factoid_hasRole dos:</xsl:text>
                    
                    <xsl:call-template name="search-and-replace">
                        <xsl:with-param name="input"><xsl:value-of select="detail[@id=529]/record/detail[@id=160]"/></xsl:with-param>
                        <xsl:with-param name="search-string"><xsl:text> </xsl:text></xsl:with-param>
                        <xsl:with-param name="replace-string"><xsl:text>_</xsl:text></xsl:with-param>
                    </xsl:call-template>
                    <xsl:text> ;</xsl:text>&cr;
                    
                    
                    <xsl:text>rdfs:label "</xsl:text>
                    <xsl:value-of select="detail[@id=529]/record/detail[@id=160]" disable-output-escaping="yes"/>
                    <xsl:text>"</xsl:text>
                    <xsl:call-template name="XMLSchemaString"/>
                    <xsl:text> ;</xsl:text>&cr;
                    
                    <xsl:text>dos:Factoid_hasSource dos:</xsl:text> 
                    
                        <xsl:variable name="sourceTitle">
                            <xsl:call-template name="getPath">
                                <xsl:with-param name="id" select="detail[@id=528]/record/id"/>
                            </xsl:call-template> 
                        </xsl:variable>
                        
                        <xsl:value-of select="substring-after($sourceTitle,'/')"/>
                    
                    
                    <xsl:choose>
                        
                        <xsl:when test="detail[@id=527]">
                            <xsl:call-template name="endLine"/>
                            <xsl:text>dos:Factoid_hasTarget dos:</xsl:text> 
                            <xsl:variable name="targetTitle">
                                <xsl:call-template name="getPath">
                                    <xsl:with-param name="id" select="detail[@id=527]/record/id"/>
                                </xsl:call-template> 
                            </xsl:variable>
                            <xsl:value-of select="substring-after($targetTitle,'/')"/>
                        </xsl:when>
                        
                        <xsl:when test="detail[@id=179]">
                            
                            <xsl:variable name="reformated_string">
                                <xsl:call-template name="search-and-replace">
                                    <xsl:with-param name="input" select="detail[@id=179]"/>    
                                    <xsl:with-param name="search-string"><xsl:text> </xsl:text></xsl:with-param>
                                    <xsl:with-param name="replace-string"><xsl:text>_</xsl:text></xsl:with-param>
                                </xsl:call-template>
                            </xsl:variable>
                          
                            
                            <xsl:call-template name="endLine"/>
                            <xsl:text>dos:Factoid_hasTargetText "</xsl:text> 
                            <xsl:value-of select="$reformated_string"/><xsl:text>"</xsl:text>
                            <xsl:call-template name="XMLSchemaString"/>
                        </xsl:when>
                    </xsl:choose>    
                    
                    <xsl:choose>
                        <xsl:when test="detail[@id=177]">
                            <xsl:call-template name="endLine"/>
                            <xsl:text>dos:Factoid_hasStart "</xsl:text>
                            <xsl:value-of select="detail[@id=177]/raw"/>
                            <xsl:text>"</xsl:text>
                            <xsl:choose>
                                <xsl:when test="string-length(detail[@id=177]/raw) = 4">
                                    <xsl:call-template name="XMLSchemagYear"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:call-template name="XMLSchemaDate"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            
                            
                            
                        </xsl:when>
                        <xsl:when test="detail[@id=178]">
                            <xsl:call-template name="endLine"/>
                            <xsl:text>dos:Factoid_hasFinish "</xsl:text>
                            <xsl:value-of select="detail[@id=178]/raw"/>
                            <xsl:text>"</xsl:text>
                            
                            <xsl:choose>
                                <xsl:when test="string-length(detail[@id=178]/raw) = 4">
                                    <xsl:call-template name="XMLSchemagYear"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:call-template name="XMLSchemaDate"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                    
                    <xsl:call-template name="endStatement"/>
                    
                </xsl:when>
               
                <xsl:otherwise/>
            </xsl:choose>
        

    </xsl:template>
    
    
    
    <xsl:template name="relationships" match="relationships/record/detail[@id=199]/record"> <!-- return broader term -->
        <xsl:param name="parentid"/>
        <xsl:param name="master_rec_type"/>
        
       
        <xsl:variable name="this_rel_type" select="../../detail[@id=200]"/>
	       <xsl:variable name="full_item_path">
	    
	    <xsl:call-template name="getPath">
	        <xsl:with-param name="id" select="id"/>
	    </xsl:call-template>
	    
		
	</xsl:variable>        
	<xsl:variable name="short_item_path">
		<xsl:value-of select="substring-after($full_item_path,'/')"/>
	</xsl:variable>

   
        <xsl:choose>
            <xsl:when test="id != $parentid 
                and $master_rec_type = 'term'">
                
                <xsl:call-template name="endLine"></xsl:call-template>
                <xsl:text>dos:hasBroaderTerm dos:</xsl:text>
                <xsl:value-of select="$short_item_path"/>
            </xsl:when>
            <xsl:when test="$master_rec_type = 'mm' 
                and $this_rel_type = 'isOf'">
                
                <xsl:call-template name="endLine"/>
                <xsl:text>dos:</xsl:text>
                <xsl:value-of select="$this_rel_type"/> 
                <xsl:text> dos:</xsl:text>
                <xsl:value-of select="$short_item_path"/>
            </xsl:when>
            <xsl:when test="$master_rec_type = 'mm' 
                and $this_rel_type = 'isRelatedTo'">
                
                <xsl:call-template name="endLine"/>
                <xsl:text>dos:</xsl:text>
                <xsl:value-of select="$this_rel_type"/> 
                <xsl:text> dos:</xsl:text>
                 <xsl:value-of select="$short_item_path"/>
            </xsl:when>
            <xsl:when test="($this_rel_type = 'hasSubject' 
                or $this_rel_type = 'hasPrimarySubject' 
                or $this_rel_type = 'isAbout' 
                or $this_rel_type = 'hasSubject') 
                and $master_rec_type != 'term'">
                
                <xsl:call-template name="endLine"/>
                <xsl:text>dos:</xsl:text>
                <xsl:value-of select="$this_rel_type"/> 
                <xsl:text> dos:</xsl:text>
                 <xsl:value-of select="$short_item_path"/>
            </xsl:when>
            
        </xsl:choose>
        
     
        
    </xsl:template>

 
    
    <xsl:template match="detail[@name='dos.main_image']">
        <xsl:text>dos:hasDefaultImage dos:Image_</xsl:text>
        <xsl:value-of select="record/id"/>
        <xsl:text> ;</xsl:text>
    </xsl:template>
    

    <xsl:template match="detail[@name='dos.contributor']">
        <xsl:text>dos:hasContributor dos:</xsl:text>
        <xsl:value-of select="detail[@name=dc.type]"/>
        <xsl:value-of select="record/title" disable-output-escaping="yes"/>;&cr;
    </xsl:template>
    

 
    
    <xsl:template name="XMLSchemaString">
        
<xsl:text>^^&lt;http://www.w3.org/2001/XMLSchema#string&gt;</xsl:text>
    </xsl:template>
    

    <xsl:template name="XMLSchemaDate">
        
<xsl:text>^^&lt;http://www.w3.org/2001/XMLSchema#date&gt;</xsl:text>
    </xsl:template>
    
    <xsl:template name="XMLSchemagYear">
        
        <xsl:text>^^&lt;http://www.w3.org/2001/XMLSchema#gYear&gt;</xsl:text>
    </xsl:template>
    
    <xsl:template name="endLine">
        <xsl:text> ;</xsl:text>&cr;
    </xsl:template>
    
    <xsl:template name="endStatement">
        <xsl:text> .</xsl:text>&cr;&cr;
    </xsl:template>

    <xsl:template name="search-and-replace">
        <xsl:param name="input"/>
        <xsl:param name="search-string"/>
        <xsl:param name="replace-string"/>
        <xsl:choose>
            <!-- see if the input contains the search string -->
            <xsl:when test="$search-string and contains($input,$search-string)">
                <!-- if so concatenate the substring before the search string to the replacement string 
                    and to the result of recursively applying this template to the remaining substring -->

                <xsl:value-of select="substring-before($input,$search-string)"/>
                <xsl:value-of select="$replace-string"/>
                <xsl:call-template name="search-and-replace">
                    <xsl:with-param name="input" select="substring-after($input,$search-string)"/>
                    <xsl:with-param name="search-string" select="$search-string"/>
                    <xsl:with-param name="replace-string" select="$replace-string"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <!-- there are no more occurences of the search string so ust return the current input string -->
                <xsl:value-of select="$input"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <xsl:template name="capitalise">
        <xsl:param name="input"/>
        
        <xsl:choose>
            <xsl:when test="starts-with($input,'entity')">
                <xsl:text>Entity</xsl:text><xsl:value-of select="substring-after($input,'entity')"/>        
            </xsl:when>
            <xsl:when test="starts-with($input,'entry')">
                <xsl:text>Entry</xsl:text><xsl:value-of select="substring-after($input,'entry')"/>        
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$input"/>
                </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template name="model">
       <xsl:text>
@prefix rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt; .
@prefix xsd: &lt;http://www.w3.org/2001/XMLSchema#&gt; .
@prefix dos: &lt;http://acl.arts.usyd.edu.au/~wallace/DoSOWL1.owl#&gt; .
@prefix pos: &lt;http://www.w3.org/2003/01/geo/wgs84_pos#&gt; .
@prefix owl: &lt;http://www.w3.org/2002/07/owl#&gt; .
@prefix rdf: &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#&gt; .
@prefix daml: &lt;http://www.daml.org/2001/03/daml+oil#&gt; .
&lt;http://acl.arts.usyd.edu.au/~wallace/DoSOWL1.owl&gt; rdf:type owl:Ontology ;
	owl:imports &lt;http://www.topbraidcomposer.org/owl/2006/07/tbcgeo.owl&gt; ,
		&lt;http://www.w3.org/2003/01/geo/wgs84_pos&gt; ;
	owl:versionInfo "Created with TopBraid Composer"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Role rdf:type owl:Class ;
	rdfs:subClassOf owl:Thing ;
	rdfs:label "Role"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Factoid_Type rdf:type owl:Class .
dos:Factoid rdf:type owl:Class .
dos:Factoid_Type rdfs:subClassOf dos:Factoid ;
	rdfs:label "Factoid_Type"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Building rdf:type owl:Class .
dos:Entity rdf:type owl:Class .
dos:Building rdfs:subClassOf dos:Entity ;
	rdfs:label "Building"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Video rdf:type owl:Class .
dos:Multimedia rdf:type owl:Class .
dos:Video rdfs:subClassOf dos:Multimedia ;
	rdfs:label "Video"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Image rdf:type owl:Class ;
	rdfs:label "Picture"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Multimedia rdf:type owl:Class .
dos:Image rdfs:subClassOf dos:Multimedia .
dos:Contributor_author rdf:type owl:Class ;
	rdfs:label "Contributor_Author"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Contributor rdf:type owl:Class .
dos:Contributor_author rdfs:subClassOf dos:Contributor .
dos:Annotation_Entry rdf:type owl:Class .
dos:Annotation rdf:type owl:Class .
dos:Annotation_Entry rdfs:subClassOf dos:Annotation ;
	rdfs:label "Annotation_Entry"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Entry rdf:type owl:Class .
dos:Resource rdf:type owl:Class .
dos:Entry rdfs:subClassOf dos:Resource ;
	rdfs:label "Entry"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Role_Relationship rdf:type owl:Class ;
	rdfs:subClassOf dos:Role ;
	rdfs:label "Role_Relationship"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Role_Name rdf:type owl:Class ;
	rdfs:subClassOf dos:Role ;
	rdfs:label "Role_Name"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Contributor rdf:type owl:Class ;
	rdfs:subClassOf owl:Thing ;
	rdfs:label "Contributor"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Map rdf:type owl:Class .
dos:Resource rdf:type owl:Class .
dos:Map rdfs:subClassOf dos:Resource ;
	rdfs:label "Map"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Annotation_Text rdf:type owl:Class ;
	rdfs:label ""^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Annotation rdf:type owl:Class .
dos:Annotation_Text rdfs:subClassOf dos:Annotation .
dos:Resource rdf:type owl:Class ;
	rdfs:subClassOf owl:Thing ;
	rdfs:label "Resource"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Audio rdf:type owl:Class .
dos:Multimedia rdf:type owl:Class .
dos:Audio rdfs:subClassOf dos:Multimedia ;
	rdfs:label "Audio"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Annotation rdf:type owl:Class ;
	rdfs:subClassOf owl:Thing ;
	rdfs:label "Annotation"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Factoid rdf:type owl:Class ;
	rdfs:subClassOf owl:Thing ;
	rdfs:label "Factoid"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Natural_feature rdf:type owl:Class .
dos:Entity rdf:type owl:Class .
dos:Natural_feature rdfs:subClassOf dos:Entity ;
	rdfs:label "Natural_feature"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Entity rdf:type owl:Class ;
	rdfs:subClassOf owl:Thing ;
	rdfs:label "Entity"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Annotation_Multimedia rdf:type owl:Class ;
	rdfs:label "Annotation_MM"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; ;
	rdfs:subClassOf dos:Annotation .
dos:Factoid_Milestone rdf:type owl:Class ;
	rdfs:subClassOf dos:Factoid ;
	rdfs:label "Factoid_Milestone"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Annotation_Gloss rdf:type owl:Class ;
	rdfs:subClassOf dos:Annotation ;
	rdfs:label "Annotation_Gloss"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Structure rdf:type owl:Class ;
	rdfs:subClassOf dos:Entity ;
	rdfs:label "Structure"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Subject rdf:type owl:Class ;
	rdfs:subClassOf owl:Thing ;
	rdfs:label "Subject"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Contributor_institution rdf:type owl:Class ;
	rdfs:label "Contributor_Institution"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; ;
	rdfs:subClassOf dos:Contributor .
dos:Annotation_Entity rdf:type owl:Class ;
	rdfs:subClassOf dos:Annotation ;
	rdfs:label "Annotation_Entity"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Role_Type rdf:type owl:Class ;
	rdfs:subClassOf dos:Role ;
	rdfs:label "Role_Type"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Factoid_TimePlace rdf:type owl:Class ;
	rdfs:subClassOf dos:Factoid ;
	rdfs:label "Factoid_TimePlace"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Factoid_Occupation rdf:type owl:Class ;
	rdfs:subClassOf dos:Factoid ;
	rdfs:label "Factoid_Occupation"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Reference rdf:type owl:Class ;
	rdfs:subClassOf dos:Resource ;
	rdfs:label "Reference"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Place rdf:type owl:Class ;
	rdfs:subClassOf dos:Entity ;
	rdfs:label "Place"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Multimedia rdf:type owl:Class ;
	rdfs:subClassOf dos:Resource ;
	rdfs:label "Multimedia"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Factoid_Name rdf:type owl:Class ;
	rdfs:subClassOf dos:Factoid ;
	rdfs:label "Factoid_Name"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Factoid_Position rdf:type owl:Class ;
	rdfs:subClassOf dos:Factoid ;
	rdfs:label "Factoid_Position"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Person rdf:type owl:Class ;
	rdfs:subClassOf dos:Entity ;
	rdfs:label "Person"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Artefact rdf:type owl:Class ;
	rdfs:subClassOf dos:Entity ;
	rdfs:label "Artefact"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Organisation rdf:type owl:Class ;
	rdfs:subClassOf dos:Entity ;
	rdfs:label "Organisation"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Contributor_public rdf:type owl:Class ;
	rdfs:label "Contributor_Other"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; ;
	rdfs:subClassOf dos:Contributor .
dos:External_link rdf:type owl:Class ;
	rdfs:subClassOf dos:Resource ;
	rdfs:label "External_link"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Event rdf:type owl:Class ;
	rdfs:subClassOf dos:Entity ;
	rdfs:label "Event"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Role_Occupation rdf:type owl:Class ;
	rdfs:subClassOf dos:Role ;
	rdfs:label "Role_Occupation"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Factoid_Relationship rdf:type owl:Class ;
	rdfs:subClassOf dos:Factoid ;
	rdfs:label "Factoid_Relationship"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Role_Milestone rdf:type owl:Class ;
	rdfs:subClassOf dos:Role ;
	rdfs:label "Role_Milestone"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Annotation_isTargetOf rdf:type owl:ObjectProperty ;
	rdfs:label ""^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:hasContributor rdf:type owl:ObjectProperty ;
	rdfs:range dos:Contributor ;
	rdfs:label ""^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; ;
	rdfs:domain dos:Resource .
dos:isAbout rdf:type owl:ObjectProperty ;
	rdfs:label ""^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; ;
	rdfs:domain dos:Entry ;
	rdfs:range dos:Entity .
dos:IsInText rdf:type owl:ObjectProperty .
dos:isAbout owl:inverseOf dos:IsInText .
dos:Factoid_hasTarget rdf:type owl:ObjectProperty ;
	rdfs:domain dos:Factoid ;
	rdfs:label "Factoid_hasTarget"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; ;
	rdfs:range dos:Entity .
dos:Factoid_isTargetOf rdf:type owl:ObjectProperty .
dos:Factoid_hasTarget owl:inverseOf dos:Factoid_isTargetOf .
dos:hasSubject rdf:type owl:ObjectProperty ;
	rdfs:domain owl:Thing ;
	rdfs:label ""^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; ;
	rdfs:range dos:Subject .
dos:isSubjectOf rdf:type owl:ObjectProperty .
dos:hasSubject owl:inverseOf dos:isSubjectOf .
dos:Annotation_hasSource rdf:type owl:ObjectProperty .
dos:Annotation_isSourceOf rdf:type owl:ObjectProperty .
dos:Annotation_hasSource owl:inverseOf dos:Annotation_isSourceOf ;
	rdfs:range dos:Entry ;
	rdfs:domain dos:Annotation ;
	rdfs:label ""^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:hasDefaultImage rdf:type owl:ObjectProperty ;
	rdfs:label ""^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; ;
	rdfs:domain dos:Entity ;
	rdfs:range dos:Image .
dos:Annotation_isSourceOf rdf:type owl:ObjectProperty ;
	rdfs:label ""^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:hasExternalLink rdf:type owl:ObjectProperty ;
	rdfs:label ""^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; ;
	rdfs:domain dos:Entity ;
	rdfs:range dos:External_link .
dos:isExternalLinkOf rdf:type owl:ObjectProperty .
dos:hasExternalLink owl:inverseOf dos:isExternalLinkOf .
dos:Factoid_isSourceOf rdf:type owl:ObjectProperty ;
	rdfs:label "Factoid_isSourceOf"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Factoid_hasSource rdf:type owl:ObjectProperty .
dos:Factoid_isSourceOf owl:inverseOf dos:Factoid_hasSource ;
	rdfs:domain dos:Entity ;
	rdfs:range dos:Factoid .
dos:hasBroaderTerm rdf:type owl:ObjectProperty ;
	rdfs:label "hasBroaderTerm"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:hasNarrowerTerm rdf:type owl:ObjectProperty .
dos:hasBroaderTerm owl:inverseOf dos:hasNarrowerTerm ;
	rdfs:domain dos:Subject ;
	rdfs:range dos:Subject .
dos:Annotation_hasTarget rdf:type owl:ObjectProperty ;
	owl:inverseOf dos:Annotation_isTargetOf ;
	rdfs:range owl:Thing ;
	rdfs:label ""^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; ;
	rdfs:domain dos:Annotation .
dos:isOf rdf:type owl:ObjectProperty ;
	rdfs:label ""^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; ;
	rdfs:domain dos:Multimedia ;
	rdfs:range dos:Entity .
dos:IsInMM rdf:type owl:ObjectProperty .
dos:isOf owl:inverseOf dos:IsInMM .
dos:Factoid_isTargetOf rdf:type owl:ObjectProperty ;
	rdfs:label "Factoid_isTargetOf"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; ;
	owl:inverseOf dos:Factoid_hasTarget ;
	rdfs:domain dos:Entity ;
	rdfs:range dos:Factoid .
dos:Factoid_isRoleOf rdf:type owl:ObjectProperty ;
	rdfs:label "Factoid_isRoleOf"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Factoid_hasRole rdf:type owl:ObjectProperty .
dos:Factoid_isRoleOf owl:inverseOf dos:Factoid_hasRole ;
	rdfs:domain dos:Role ;
	rdfs:range dos:Factoid .
dos:isPrimarySubjectOf rdf:type owl:ObjectProperty ;
	rdfs:label ""^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:IsInText rdf:type owl:ObjectProperty ;
	rdfs:label ""^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:IsInMM rdf:type owl:ObjectProperty ;
	rdfs:label ""^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:Factoid_hasSource rdf:type owl:ObjectProperty ;
	rdfs:range dos:Entity ;
	rdfs:domain dos:Factoid ;
	rdfs:label "Factoid_hasSource"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; ;
	owl:inverseOf dos:Factoid_isSourceOf .
dos:Factoid_hasRole rdf:type owl:ObjectProperty ;
	rdfs:label "Factoid_hasRole"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; ;
	rdfs:domain dos:Factoid ;
	rdfs:range dos:Role ;
	owl:inverseOf dos:Factoid_isRoleOf .
dos:isExternalLinkOf rdf:type owl:ObjectProperty ;
	rdfs:label ""^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:hasNarrowerTerm rdf:type owl:ObjectProperty ;
	rdfs:label "hasNarrowerTerm"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; ;
	rdfs:domain dos:Subject ;
	rdfs:range dos:Subject ;
	owl:inverseOf dos:hasBroaderTerm .
dos:isSubjectOf rdf:type owl:ObjectProperty ;
	rdfs:label ""^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; .
dos:hasPrimarySubject rdf:type owl:ObjectProperty ;
	rdfs:label ""^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; ;
	rdfs:domain owl:Thing ;
	rdfs:range dos:Subject ;
	owl:inverseOf dos:isPrimarySubjectOf .
dos:Factoid_hasTargetText rdf:type owl:DatatypeProperty ;
	rdfs:label ""^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; ;
	rdfs:domain dos:Factoid ;
	rdfs:range xsd:string .
dos:Factoid_hasStart rdf:type owl:DatatypeProperty ;
	rdfs:label "Factoid_hasStart"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; ;
	rdfs:domain dos:Factoid ;
	rdfs:range xsd:date .
dos:hasUrl rdf:type owl:DatatypeProperty ;
	rdfs:label ""^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; ;
	rdfs:domain owl:Thing ;
	rdfs:range xsd:string .
dos:Annotation_hasDescription rdf:type owl:DatatypeProperty ;
	rdfs:label ""^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; ;
	rdfs:domain dos:Annotation ;
	rdfs:range xsd:string .
dos:Factoid_hasFinish rdf:type owl:DatatypeProperty ;
	rdfs:label "Factoid_hasFinish"^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; ;
	rdfs:domain dos:Factoid ;
	rdfs:range xsd:date .
dos:isRelatedTo rdf:type owl:SymmetricProperty ;
	owl:inverseOf dos:isRelatedTo ;
	rdfs:range owl:Thing ;
	rdfs:domain owl:Thing ;
	rdfs:label ""^^&lt;http://www.w3.org/2001/XMLSchema#string&gt; ;
	rdf:type owl:ObjectProperty .
    </xsl:text>
        
    </xsl:template>
    

</xsl:stylesheet>
