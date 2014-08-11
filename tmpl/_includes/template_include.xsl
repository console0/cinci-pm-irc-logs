<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:template name="windowed_pager">
        <xsl:choose>
            <xsl:when test="//pager/@num_pages &gt; 1">
                <div class="row">
                    <div class="large-12 columns">
                        <ul class="pagination">
                            <xsl:for-each select="//pager/pager_window">
                                <li>
                                    <xsl:if test="@current_page = 1">
                                        <xsl:attribute name="class">current</xsl:attribute>
                                    </xsl:if>
                                    <a href=".#" data-page="{@page}">
                                        <xsl:value-of select="@page"/>
                                    </a>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </div>
                </div>
            </xsl:when>
            <xsl:otherwise />
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="hard_chop">
        <xsl:param name="text"/>
        <xsl:param name="length" select="'30'"/>

        <xsl:choose>
            <xsl:when test="string-length($text) &gt; $length">
                <!-- Too long -->
                <xsl:choose>
                    <xsl:when test="substring($text,$length,$length) = ' '">
                        <xsl:value-of select="substring($text,1,($length-1))" disable-output-escaping="yes"/>...
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring($text,1,$length)" disable-output-escaping="yes"/>...
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text" disable-output-escaping="yes"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="straight_date">
    	<xsl:param name="date"/>
    	<xsl:param name="date_only"/>
    	
    	<xsl:variable name="new_date">
    		<xsl:choose>
    			<xsl:when test="contains($date,'T')"><xsl:value-of select="substring-before($date,'T')" /></xsl:when>
    			<xsl:otherwise><xsl:value-of select="substring-before($date,' ')" /></xsl:otherwise>
    		</xsl:choose>
    	</xsl:variable>
    	<xsl:variable name="time">
    		<xsl:choose>
    			<xsl:when test="contains($date,'T')"><xsl:value-of select="substring-after($date,'T')" /></xsl:when>
    			<xsl:otherwise><xsl:value-of select="substring-after($date,' ')" /></xsl:otherwise>
    		</xsl:choose>
    	</xsl:variable>	
			
			
		<xsl:variable name="year" select="substring($new_date, 1, 4)"/>
        <xsl:variable name="month" select="substring($new_date, 6, 2)"/>
        <xsl:variable name="day" select="substring($new_date, 9, 2)"/>
        <xsl:variable name="hour" select="substring($time, 1, 2)"/>
        <xsl:variable name="twelve_hour">
        	<xsl:choose>
        		<xsl:when test="$hour &gt; 12">
        			<xsl:value-of select="$hour - 12" />
        		</xsl:when>
        		<xsl:otherwise><xsl:value-of select="$hour" /></xsl:otherwise>
        	</xsl:choose>
        </xsl:variable>
        <xsl:variable name="min" select="substring($time, 4, 2)"/>
        <xsl:variable name="sec" select="substring($time, 7, 2)"/>	
        <xsl:variable name="am_pm">
        	<xsl:choose>
        		<xsl:when test="$hour &gt; 11">
        			<xsl:value-of select="'PM'" />
        		</xsl:when>
        		<xsl:otherwise><xsl:value-of select="'AM'" /></xsl:otherwise>
        	</xsl:choose>
        </xsl:variable>
        
			
		<xsl:choose>
			<xsl:when test="string-length($date) = 0"></xsl:when>
			<xsl:when test="$date_only = '1'">
				<xsl:value-of select="$month"/>/<xsl:value-of select="$day"/>/<xsl:value-of select="$year"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$month"/>/<xsl:value-of select="$day"/>/<xsl:value-of select="$year"/> at <xsl:value-of select="$twelve_hour"/>:<xsl:value-of select="$min"/> <!-- :<xsl:value-of select="$sec"/> --><xsl:value-of select="$am_pm" />
			</xsl:otherwise>
		</xsl:choose>

    </xsl:template>
    
    
    
   <!-- english date is still a work in progress, do not use unless fully fleshing it out -->
    <xsl:template name="english_date">
    	<xsl:param name="date"/>
    	<xsl:variable name="current_date_time" select="date:date-time()" />
    	<xsl:variable name="current_date" select="substring-before($current_date_time,'T')" />
    	<xsl:variable name="current_time" select="substring-after($current_date_time,'T')" />
    	<xsl:variable name="new_date">
    		<xsl:choose>
    			<xsl:when test="contains($date,'T')"><xsl:value-of select="substring-before($date,'T')" /></xsl:when>
    			<xsl:otherwise><xsl:value-of select="substring-before($date,' ')" /></xsl:otherwise>
    		</xsl:choose>
    	</xsl:variable>
    	<xsl:variable name="time">
    		<xsl:choose>
    			<xsl:when test="contains($date,'T')"><xsl:value-of select="substring-after($date,'T')" /></xsl:when>
    			<xsl:otherwise><xsl:value-of select="substring-after($date,' ')" /></xsl:otherwise>
    		</xsl:choose>
    	</xsl:variable>	
			
			
		<xsl:variable name="year" select="substring($new_date, 1, 4)"/>
        <xsl:variable name="month" select="substring($new_date, 6, 2)"/>
        <xsl:variable name="day" select="substring($new_date, 9, 2)"/>
        <xsl:variable name="hour" select="substring($time, 1, 2)"/>
        <xsl:variable name="min" select="substring($time, 4, 2)"/>
        <xsl:variable name="sec" select="substring($time, 7, 2)"/>
    
        <xsl:variable name="current_year" select="substring($current_date, 1, 4)"/>
        <xsl:variable name="current_month" select="substring($current_date, 6, 2)"/>
        <xsl:variable name="current_day" select="substring($current_date, 9, 2)"/>
        <xsl:variable name="current_hour" select="substring($current_time, 1, 2)"/>
        <xsl:variable name="current_min" select="substring($current_time, 4, 2)"/>
        <xsl:variable name="current_sec" select="substring($current_time, 7, 2)"/>	
	
		<xsl:value-of select="date:difference($current_date_time, $date)" />
	
		<xsl:choose>
			<xsl:when test="$current_year &gt; $year">More than a year ago</xsl:when>
			<xsl:otherwise>this year sometime</xsl:otherwise> <!-- more tests down the line of time -->
		</xsl:choose>
	
	
	
    </xsl:template>

    
</xsl:stylesheet>