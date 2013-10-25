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
        var content = $('#editor').val();

        // Replace newline with html tag to prevent ABAP from adding dirty characters
        content = content.replace(/\n\r?/g, '<br />');

        // SAPHTMLP protocol processes only values that are no longer than 512 characters and
        // ABAP stores these values later in fields of size 250. In order to prevent
        // runtime errors and loss of content, slice the content in 250-1 long
        // chunks, add an end marking to prevent automatic right-sided whitespace
        // optimization of ABAPs string processing (right-hand whitespace is not always preserved).
        var len = 250-1, prev = 0;
        output = [];
        var cnt = 0;
        var cnt_str = "";

        while(content.charAt(prev)){
          cnt += 1;
          if (cnt &lt; 10) {
            cnt_str = "00" + cnt;
          } else if (cnt &lt; 100) {
            cnt_str = "0" + cnt;
          } else {
            cnt_str = cnt;
          }

          output.push({
            name:  $('#editor').attr("name") + "_chunk_" + cnt_str,
            value: content.substr(prev, len) + "|"
          });
          prev += len;
        };


         // Add chunks as hidden fields to the form
         $.each(output, function(i,param){
           $('<input />')
             .attr('type', 'hidden')
             .attr('name', param.name)
             .attr('value', param.value)
             .appendTo('#myform');
         });

         // Remove original field to prevent the oversized
         // value to be transferred to SAP on form submit.
         $('#editor').remove();

         return true;
       });
      });
    </script>

    <style type="text/css">
      body, table {
        font-family: Tahoma, Arial, sans-serif;
        font-size:11pt;
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
    <div id="hello">Hello, <b>World</b>!</div>
    <div id="form">
      <form id="myform" method="post" action="SAPEVENT:ACTION_POST">
        <label for="editor">A textarea with a text longer than the SAPHTMLP protocol is able to process</label>
        <br />
        <textarea id="editor" name="long_text" cols="68" rows="10" wrap="PHYSICAL"
        >Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no
sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores
et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</textarea>
        <br />
        <input id="fertig" type="submit" value="Done" />
      </form>
    </div>
  </body>
</html>
</xsl:template>

</xsl:transform>
