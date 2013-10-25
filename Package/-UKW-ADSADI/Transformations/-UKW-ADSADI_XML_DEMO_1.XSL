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
        $('#myform').submit( function(e){
          $('#error').html('');

          var isOkay = true;
          var fieldIsOkay = false;

          <xsl:for-each select="/my-dialog/field[@type='radio']">
            fieldIsOkay = false;
            $("input:radio[name='<xsl:value-of select="@name" />']").each(function(){
              if(this.checked) {fieldIsOkay = true;}
            });
            if(fieldIsOkay==false){
              isOkay = false;
              $('<div />')
               .html("<xsl:value-of select="@text" /> missing!")
               .appendTo('#error');
            }
          </xsl:for-each>

          if(isOkay==false) {
            $('#error').effect("pulsate", { mode:'show', times:3 }, 2000)
          }

          return isOkay;
        });
      });
    </script>

    <style type="text/css">
      body, table {
        font-family: Tahoma, Arial, sans-serif;
        font-size:11pt;
        background-color:<xsl:value-of select="$SAP_BACKGROUNDCOLOR1" />;
      }
      #header {
        background-color:<xsl:value-of select="$SAP_BACKGROUNDCOLOR2" />;
        padding:5px;
        text-align:center;
      }
      #myform {
        text-align:center;
      }
      #error {
        display:none;
        border: solid 1px #f03;
        background: #fcc;
        margin: 4px 0 4px 0;
        padding: 4px;
      }

    </style>
  </head>
  <body>
    <div id="header"><xsl:value-of select="/my-dialog/@title" /></div>
    <div id="error">

    </div>
    <div id="form">
      <form id="myform" method="post" action="SAPEVENT:ACTION_POST">
        <xsl:for-each select="/my-dialog/field">
          <label for="{@name}"><xsl:value-of select="@text" />: </label>

          <xsl:choose>
            <xsl:when test="@type='select'">
              <select id="{@name}" name="{@name}">
                <xsl:attribute name="size">1</xsl:attribute>

                <xsl:for-each select="option">
                  <option value="{@value}">
                    <xsl:if test="@selected = 'yes'">
                      <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="@text" />
                  </option>
                </xsl:for-each>
              </select>
            </xsl:when>

            <xsl:when test="@type='radio'">
              <input id="{@name}" type="radio" name="{@name}" value="yes">
                <xsl:if test="@value = 'yes'">
                  <xsl:attribute name="checked">1</xsl:attribute>
                </xsl:if>
                Yes
              </input>
              <input id="{@name}" type="radio" name="{@name}" value="no">
                <xsl:if test="@value = 'no'">
                  <xsl:attribute name="checked">1</xsl:attribute>
                </xsl:if>
                No
              </input>
            </xsl:when>

            <xsl:when test="@type='input'">
              <input id="{@name}" type="text" size="15" name="{@name}" value="{@value}" />
            </xsl:when>

            <xsl:otherwise>
              <xsl:value-of select="@value" />
            </xsl:otherwise>
          </xsl:choose>

          <br />
        </xsl:for-each>

        <input id="fertig" type="submit" value="Done" />
      </form>
    </div>
  </body>
</html>
</xsl:template>

</xsl:transform>
