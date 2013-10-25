<xsl:transform version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sap="http://www.sap.com/sapxsl"
>
<!--
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
-->

<!-- Include template for JQuery (not part of this distribution, download from http://jquery.com), e.g.:
 <xsl:template name="jquery">
   <link rel="stylesheet" href="[add-jquery-root-here]/jquery/css/ui-lightness/jquery-ui-1.8.16.custom.css" type="text/css" media="all" />
   <script src="[add-jquery-root-here]/jquery/js/jquery-1.6.2.min.js" type="text/javascript"></script>
   <script src="[add-jquery-root-here]/jquery/js/jquery-ui-1.8.16.custom.min.js" type="text/javascript"></script>
  </xsl:template>
-->

<xsl:include sap:name="ZJQUERY.XSL" />

<xsl:param name="SAP_BACKGROUNDCOLOR1" />
<xsl:param name="SAP_BACKGROUNDCOLOR2" />

<xsl:template match="/">
<html>
  <head>
    <xsl:call-template name="jquery" />

    <script type="text/javascript">
      jQuery.noConflict();
      jQuery(document).ready(function($){
        $("#next_button").button().click(function(){
          $("#myform").submit();
        });

        $("#cancel_button").button().click(function(){
          $("#myform input[name=cancel]").val('X');
          $("#myform").submit();
        });
      });
    </script>
    <style type="text/css">
      body, table {
        font-family: Tahoma, Arial, sans-serif;
        font-size:75%;
        background-color:<xsl:value-of select="$SAP_BACKGROUNDCOLOR1" />;
      }
      #hello {
        background-color:<xsl:value-of select="$SAP_BACKGROUNDCOLOR2" />;
        padding:5px;
        text-align:center;
      }
      #myform {
        text-align:center;
      }

    </style>
  </head>
  <body>
    <xsl:variable name="YOUR_NAME">
      <xsl:choose>
        <xsl:when test="/my-dialog/@your_name"><xsl:value-of select="/my-dialog/@your_name" /></xsl:when>
        <xsl:otherwise>Your Name!</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <div id="hello">Hello,
      <xsl:choose>
        <xsl:when test="/my-dialog/@your_name">
          <xsl:value-of select="/my-dialog/@your_name" />
        </xsl:when>
        <xsl:otherwise>
          <b>World</b>!
        </xsl:otherwise>
      </xsl:choose>
    </div>
    <div id="form">
      <form id="myform" method="post" action="SAPEVENT:ACTION_HELLO">
        <input id="your_name" type="text" size="20" name="your_name" value="{$YOUR_NAME}" />
        <input id="cancel" type="hidden" name="cancel" value="" />
        <div>
          <a href="#" id="next_button">Weiter</a>
          <a href="#" id="cancel_button">Abbrechen</a>
        </div>
      </form>

    </div>
  </body>
</html>
</xsl:template>

</xsl:transform>
