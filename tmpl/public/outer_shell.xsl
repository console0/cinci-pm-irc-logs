<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" xmlns:date="http://exslt.org/dates-and-times" version="1.0" xmlns:cham="urn:cham">
    <xsl:import href="tmpl://_includes/template_include.xsl"/>
    <xsl:import href="tmpl://_includes/paged_results.xsl"/>
    <xsl:import href="tmpl://_includes/forms.xsl"/>
    <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />
    <xsl:decimal-format NaN="0" name="nonan"/>
    <xsl:template name="outer_shell">
        <xsl:param name="title"/>
        <xsl:param name="headers"/>
        <xsl:param name="footers"/>
        <xsl:param name="breadcrumbs"/>
        <xsl:param name="content_nodeset"/>
        <xsl:comment>[if IE 7]&gt;&lt;html class="no-js lt-ie10 lt-ie9 lt-ie8" lang="en"&gt;&lt;![endif]</xsl:comment>
	<xsl:comment>[if IE 8]&gt;&lt;html class="no-js lt-ie10 lt-ie9" lang="en"&gt;&lt;![endif]</xsl:comment>
	<xsl:comment>[if IE 9]&gt;&lt;html class="no-js lt-ie10" lang="en"&gt;&lt;![endif]</xsl:comment>
        <html class="no-js" lang="en">
            <xsl:comment>&lt;![endif]</xsl:comment>
            <head>
                <meta charset="UTF-8"/>
                <meta name="viewport" content="width=device-width"/>
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />

                <title><xsl:value-of select="$title"/> | IRC Logs</title>

                <link rel="stylesheet" href="/css/normalize-2.1.2.css" />
		<link rel="stylesheet" href="/css/foundation-5.3.1.min.css" />
		<link rel="stylesheet" href="/css/jquery-ui-1.10.4.custom.min.css"/>
		<link rel="stylesheet" href="/css/font-awesome/css/font-awesome.min.css" />
		<link rel="stylesheet" href="/css/glyphicons.css" />

		<!--
		    If using Google font api, uncomment below for IE 8 support
		    Be sure to point to the correct fonts
		-->
                <!--
                <xsl:comment>[if lte IE 8]&gt;

		    &lt;link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Droid+Sans:400" /&gt;
		    &lt;link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Droid+Sans:700" /&gt;

		&lt;![endif]</xsl:comment>
		-->

		<link rel='stylesheet' href='http://fonts.googleapis.com/css?family=Open+Sans:400,600,700,800|Oswald:400,300,700&amp;subset=latin,latin-ext' type='text/css' />
		<link rel="stylesheet" href="/css/app.css" />
		<link rel="stylesheet" href="/css/customer.css" />


		<!-- ie 8 css overrides -->

		<xsl:comment>[if lte IE 8]&gt;
		    &lt;link rel="stylesheet" href="/css/ie.css" /&gt;
		&lt;![endif]</xsl:comment>

		<!-- ie 8 CSS & HTML hackery -->

		<xsl:comment>[if lt IE 9]&gt;
		  &lt;script src="/js/ie/html5shiv-3.7.0.min.js"&gt;&lt;/script&gt;
		  &lt;script src="/js/ie/nwmatcher-1.3.1.min.js"&gt;&lt;/script&gt;
		  &lt;script src="/js/ie/selectivizr-1.0.2.min.js"&gt;&lt;/script&gt;
		  &lt;script src="/js/ie/respond-1.4.2.min.js"&gt;&lt;/script&gt;
		&lt;![endif]</xsl:comment>


                <xsl:copy-of select="exsl:node-set($headers)"/>
            </head>
            <body>
                <div class="wrapper">
                		<div class="fixed">
				    <nav class="top-bar" data-topbar="topbar">
					<ul class="title-area">
					    <li class="name"><h1>Cinci.pm Log History</h1></li>
					    <li class="toggle-topbar menu-icon"><a href="#">Menu</a></li>
					</ul>
				    </nav>
				</div>
				<br/>

		                <xsl:call-template name="chameleon-message"/>

		                <div class="row">
				    <div class="large-12 columns">

					<xsl:copy-of select="exsl:node-set($content_nodeset)"/>

					<xsl:call-template name="footer-links"/>

				    </div>
		                </div>
                </div>

                <script src="/js/jquery-1.10.2.min.js"/>
		<script src="/js/jquery-ui-1.10.4.custom.min.js"/>

	        <!-- uncomment for development debugging as needed -->
		<!-- <script src="/js/foundation-5.3.1.hacked.js"/> -->

		<script src="/js/foundation-5.3.1.hacked.min.js"/>
		<script src="/js/modernizr.js"/>

		<script>
		    $(document).foundation();
		    $(document).ready(function(){
		    // Fallback for no HTML5 type="date" support

		    if (!Modernizr.inputtypes.date) {
			    $('[data-widget="date"]').attr('readonly', 'readonly').datepicker({ dateFormat: 'yy-mm-dd' });
		    }

		    // disable any submit buttons after the first click
		    $("form").submit(function() {
			$('input[type=submit]', this).attr('disabled', 'disabled');
		    });
		    });
		</script>
                <xsl:copy-of select="exsl:node-set($footers)"/>
		<xsl:comment>[if IE 8]&gt;
		  &lt;script src="/js/ie/rem-1.1.0.min.js"&gt;&lt;/script&gt;
		&lt;![endif]</xsl:comment>
            </body>
        </html>
    </xsl:template>


    <xsl:template name="chameleon-message">

	<xsl:if test="//chameleon_message">
		<div class="row">
		<div class="large-12 columns">
		    <xsl:for-each select="//chameleon_message">
			<xsl:variable name="class">
				<xsl:choose>
				<xsl:when test="@level = 'success'">success</xsl:when>
				<xsl:when test="@level = 'error'">alert</xsl:when>
				<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			    <div data-alert="" class="alert-box {$class}">
			    <xsl:value-of select="@text"/>
			    <a href="#" class="close">&#215;</a>
			</div>
			</xsl:for-each>
		</div>
	    </div>
	</xsl:if>

    </xsl:template>


    <xsl:template name="footer-links">

	<hr/>
	<p class="text-center">
		<a href="{cham:uri('home')}">Home</a> &#8226;
	    <br/><br/>
	</p>

    </xsl:template>

</xsl:stylesheet>
