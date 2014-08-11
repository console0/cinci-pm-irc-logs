<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" xmlns:date="http://exslt.org/dates-and-times" xmlns:cham="urn:cham">
 <xsl:import href="class://outer_shell.xsl"></xsl:import>
 <xsl:output method="html" omit-xml-declaration="no" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" indent="yes" />
 <xsl:template match="/">
  <xsl:call-template name="outer_shell">
   <xsl:with-param name="content_nodeset">
    <xsl:apply-templates select="/" mode="local"></xsl:apply-templates>
   </xsl:with-param>
  </xsl:call-template>
 </xsl:template>
 <xsl:template match="/" mode="local">
    <div class="row">
        <div class="large-12 columns">
        <xsl:call-template name="paged_results">
            <xsl:with-param name="results_node" select="/response/irc_log_list"/>
        </xsl:call-template>
        </div>
    </div>
 </xsl:template>

    <xsl:template name="paged_data">
    <div class="row">
        <div class="large-12 columns">
        <table class="history-table">
            <thead>
                <tr>
                    <th>Timestamp</th>
                    <th>Nick</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <xsl:choose>
                        <xsl:when test="//results/result">
                                <xsl:for-each select="//results/result">
                                    <tr>
                                        <td><xsl:value-of select="@logged_at"/></td>
                                        <td><xsl:value-of select="./irc_user/@shortname"/></td>
                                        <td><xsl:value-of select="@message"/></td>
                                    </tr>
                                </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <tr><td colspan="3">Nothing Today</td></tr>
                        </xsl:otherwise>
                </xsl:choose>
            </tbody>
        </table>
        </div>
    </div>
    </xsl:template>


</xsl:stylesheet>
