<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" xmlns:date="http://exslt.org/dates-and-times" version="1.0" xmlns:cham="urn:cham">
    
    <xsl:template name="category_box">
        <xsl:param name="selected_category_id"/>
        <xsl:param name="depth" select="1"/>
        <xsl:param name="hide_search"/>
        
        <div class="row">
            <div class="large-12 columns">
                <xsl:if test="$hide_search != '1'">  
                                
	    <div id="CategorySearch">
		<form class="category-search" action="/shop/search/">
		    <div class="row collapse">
			<div class="small-8 columns">
			    
			    <input type="text" name="search" placeholder="Search" class="no_margin_bottom"/>
			  
			</div>
			<div class="small-4 columns">
			     <input type="submit" name="submit" class="button postfix secondary" value="Search"/>
			</div>
		    </div>
		    
		</form>
	    </div>    
        </xsl:if>
	    <div id="Categories">
		
               <ul id="CategoryList" class="category_list">
		    		    
		    <xsl:for-each select="/response/categories/category">
			<xsl:sort select="@name"/>
			
		
			<li>
			    <xsl:if test="$selected_category_id = @category_id">
				<xsl:attribute name="class">active</xsl:attribute>
			    </xsl:if>
			    
			    
			    <xsl:variable name="url">
				/shop/category/<xsl:value-of select="@category_id"/>
			    </xsl:variable>
			    
			    <a href="{$url}" style="text-decoration: none;">
				    <xsl:choose>
							    <xsl:when test="contains(@name,' ')">
								    <i class="glyphicons {substring-before(@name,' ')}" style="margin-right: 5px;"></i> 
							    </xsl:when>
							    <xsl:otherwise>
								    <i class="glyphicons {@name}" style="margin-right: 5px;"></i> 
							    </xsl:otherwise>
						    </xsl:choose>
				   <xsl:value-of select="@name"/>
			    </a>
			</li>
		       
			<!-- Any relevant kids? -->
			<xsl:if test="descendant-or-self::*[@category_id = $selected_category_id]">
			    <xsl:call-template name="category_box_children">
				<xsl:with-param name="selected_category_id" select="$selected_category_id"/>
				<xsl:with-param name="category_id" select="@category_id"/>
				<xsl:with-param name="depth" select="$depth + 1"/>
			    </xsl:call-template>
			</xsl:if>
		
		    </xsl:for-each>
                </ul>
	    </div>
                
            </div>
        </div>
	
	
        
        
        
    </xsl:template>
    
    <xsl:template name="category_box_children">
        <xsl:param name="category_id"/>
        <xsl:param name="selected_category_id"/>
        <xsl:param name="depth" select="1"/>
        <xsl:for-each select="/response/categories//category[@category_id = $category_id]/category">
            <xsl:sort select="@name"/>
            
            <li class="sub_category_list extra_padding_{$depth}">
		<xsl:if test="$selected_category_id = @category_id">
		    <xsl:attribute name="class">sub_category_list active extra_padding_<xsl:value-of select="$depth" /></xsl:attribute>
		</xsl:if>
		<a href="/shop/category/{@category_id}/?item_grid_s=points%20asc">
		    <xsl:value-of select="@name" />
		</a>
	    </li>
            
            <!-- Any relevant kids? -->
            <xsl:if test="descendant-or-self::*[@category_id = $selected_category_id]">
                <xsl:call-template name="category_box_children">
                    <xsl:with-param name="selected_category_id" select="$selected_category_id"/>
                    <xsl:with-param name="category_id" select="@category_id"/>
                    <xsl:with-param name="depth" select="$depth + 1"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    
    
    
    <xsl:template name="mobile-shopping-options">
	
	<div id="MobileShopOptions">
	    <a onclick="shopMgr.showMobileCategories()" class="button tiny"><i class="fa fa-bars"></i> Shop By Category</a>
	    &#160;
	    <a onclick="shopMgr.showMobileSearch()" class="button tiny"><i class="fa fa-search"></i> Search Items</a>
	</div>
	
	
	<!--
	    container for displaying categories on mobile devices
	    see js/olr/shop.js and app.css for implementation
	-->
	
	<div id="MobileCategories" style="display: none;">
	    <a class="close-list"  onclick="shopMgr.closeMobileCategories();"><i class="fa fa-times"></i></a>
	    <h5 onclick="shopMgr.closeMobileCategories()"> Shop By Category</h5>
	    <div style="clear:both"></div>
	    <div id="MobileCategoriesListing"></div>
	</div>
	
	
	<div id="MobileSearch" style="display: none;">
	    <a class="close-search" onclick="shopMgr.closeMobileSearch()"><i class="fa fa-times"></i></a>
	    <h5 onclick="shopMgr.closeMobileSearch()">Search Catalog</h5>
	    <div style="clear:both"></div>
	    
	    <form class="mobile-category-search" action="/shop/search/">
		<div class="row collapse">
		    <div class="small-8 columns">
			<input type="text" name="search" placeholder="Search" class="no_margin_bottom"/>
		    </div>
		    <div class="small-4 columns">
			 <input type="submit" name="submit" class="button postfix secondary" value="Search"/>
		    </div>
		</div>
	    </form>
	    
	</div>
	
    </xsl:template>
    
</xsl:stylesheet>
