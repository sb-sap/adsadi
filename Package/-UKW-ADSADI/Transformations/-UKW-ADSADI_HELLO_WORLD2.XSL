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

<xsl:param name="SAP_BACKGROUNDCOLOR1" />
<xsl:param name="SAP_BACKGROUNDCOLOR2" />

<xsl:template match="/">
<html>
  <head>
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
        <input id="your_name" type="text" size="20" name="your_name" value="Your Name!" />
        <br />
        <input id="fertig" type="submit" value="Done" />
      </form>
    </div>
  </body>
</html>
</xsl:template>

</xsl:transform>
