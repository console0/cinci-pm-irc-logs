<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:chamdate="http://whapps.com/functions">
<xsl:import href="tmpl://_includes/date.format-date.function.xsl" />
    <xsl:template name="pr_pager">
	<!-- pager styles for tweaking and such, these are also used for hiding elements and tweaking styles for mobile support

	.results-pager  -  container for pager
	.page-number    -  page number list item
	.next-page      -  next page list item
	.prev-page      -  previous page list item

	-->


        <xsl:param name="results_node"/>

        <xsl:variable name="other_params" select="$results_node/pager_window/@other_params"/>
        <xsl:variable name="has_previous_page" select="$results_node/@has_previous_page"/>
        <xsl:variable name="has_next_page" select="$results_node/@has_next_page"/>
        <xsl:variable name="last_page" select="$results_node/@last_page"/>


        <div class="row results-pager">
            <div class="large-12 columns pagination-centered">
                <ul class="pagination">
                    <xsl:if test="$has_previous_page=1">
                        <li class="previous-page">
                            <a href="?{$other_params}{$results_node/pager_window/page[@previous_page=1]/@page_params}">&lt;&lt;</a>
                        </li>
                    </xsl:if>
                    <xsl:if test="$last_page &gt; 1">
                        <xsl:for-each select="$results_node/pager_window/page">
                            <li class="page-number">
                                <xsl:if test="@current_page=1"><xsl:attribute name="class">current</xsl:attribute></xsl:if>
                                <a href="?{$other_params}{@page_params}"><xsl:value-of select="@page"/></a>
                            </li>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="$has_next_page=1">
                        <li class="next-page">
                            <a href="?{$other_params}{$results_node/pager_window/page[@next_page=1]/@page_params}">&gt;&gt;</a>
                        </li>
                    </xsl:if>
                </ul>
            </div>
        </div>

    </xsl:template>

    <xsl:template name="paged_data">
        <xsl:param name="results_node"/>
        <table>
            <thead>
                <tr>
                    <xsl:for-each select="$results_node/rows/header/column">
                        <td>
                            <xsl:if test="@class != ''"><xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute></xsl:if>
                            <xsl:value-of select="@value"/>
                        </td>
                    </xsl:for-each>
                </tr>
            </thead>
            <tbody>
            	<xsl:choose>
		    <xsl:when test="$results_node/@total_results = 0">
			<tr>
			    <td colspan="{count($results_node/rows/header/column)}">
				    <em>No results</em>
			    </td>
			</tr>
		    </xsl:when>
		    <xsl:otherwise>
			<xsl:for-each select="$results_node/rows/row">
			    <tr>
				<xsl:for-each select="column">
				    <td>
					<xsl:if test="@class != ''"><xsl:attribute name="class"><xsl:value-of select="@class"/></xsl:attribute></xsl:if>

					<xsl:choose>
					    <!-- if a uri exists, render the value as a link -->
					    <xsl:when test="@uri">
						<a href="{@uri}"><xsl:value-of select="@value"/></a>
					    </xsl:when>
					    <!-- if a column ends with _at and is an unformatted date coming from mysql, format it -->
					    <xsl:when test="
						'_at' = substring(@column_name, string-length(@column_name) - 2) and
						chamdate:is-date(@value) = 1">
						 <xsl:value-of select="chamdate:short-date(@value)"/>&#160;<xsl:value-of select="chamdate:pretty-time(@value)"/>
					    </xsl:when>
					    <xsl:otherwise>
						<xsl:value-of select="@value"/>
					    </xsl:otherwise>
					</xsl:choose>
				</td>
				</xsl:for-each>
			    </tr>
			</xsl:for-each>
		    </xsl:otherwise>
		</xsl:choose>
            </tbody>
        </table>
    </xsl:template>

    <xsl:template name="paged_results">

	<!-- styles for table paging/sort options
	     these are also used for hiding elements and tweaking styles for mobile support

	.pager-options		container for all options
	.per-page-options	container for items per page links
	.sort-options		container for sort options
	.sort-option 		container for each sort option DD
	.sort-label-desktop 		label for sort options on desktop only
	.mobile-sort-label	label for sort options on mobile only

	-->


        <xsl:param name="results_node"/>
        <xsl:apply-templates select="//form[@key = name($results_node)]"/>

        <xsl:variable name="other_params" select="$results_node/pager_window/@other_params"/>

        <div class="row pager-options">
            <xsl:if test="$results_node/per_page">
                <div class="large-4 columns per-page-options">
                    <dl class="sub-nav">
                        <dt>Per Page:</dt>
                        <xsl:for-each select="$results_node/per_page/option">
                            <xsl:variable name="lvalue" select="@value"/>
                            <dd>
                                <xsl:if test="//form[@key = name($results_node)]/field[@widget = 'table_per_page']/@value = $lvalue">
                                    <xsl:attribute name="class">active</xsl:attribute>
                                </xsl:if>
                                <a href="?{$other_params}{@page_params}"><xsl:value-of select="@display"/></a>
                            </dd>
                        </xsl:for-each>
                    </dl>
                </div>
            </xsl:if>
            <xsl:if test="$results_node/sort">
                <div class="large-8 columns text-right sort-options">
                    <dl class="sub-nav">
                        <dt class="sort-label">Sort:</dt>
			<dt class="sort-label-mobile">
			    <i class="fa fa-sort"></i>
			</dt>
                        <xsl:for-each select="$results_node/sort/option">
                            <xsl:variable name="lvalue" select="@value"/>
                            <dd class="sort-option">
                                <xsl:if test="//form[@key = name($results_node)]/field[@widget = 'table_sort']/@value = $lvalue">
                                    <xsl:attribute name="class">active</xsl:attribute>
                                </xsl:if>
                                <a href="?{$other_params}{@page_params}"><xsl:value-of select="@display"/></a>
                            </dd>
                        </xsl:for-each>
                    </dl>
                </div>
            </xsl:if>
        </div>

        <div class="row">
            <div class="large-12 columns">
                <xsl:call-template name="paged_data">
                    <xsl:with-param name="results_node" select="$results_node"/>
                </xsl:call-template>
            </div>
        </div>
        <div class="row">
            <div class="large-12 columns text-right">
                <xsl:if test="$results_node/@allow_download = 1">
                        <xsl:choose>
                            <xsl:when test="$results_node//result">
                                    <!-- enable dl link -->
                                <a class="button" href="{//append/@path_info}?{$results_node/pager_window/@other_params}&amp;{name($results_node)}_dl=1">Export</a>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- in case we want a disabled dl button with no results -->
                            </xsl:otherwise>
                        </xsl:choose>
                </xsl:if>
            </div>
        </div>

        <xsl:call-template name="pr_pager">
            <xsl:with-param name="results_node" select="$results_node"/>
        </xsl:call-template>
    </xsl:template>

</xsl:stylesheet>
