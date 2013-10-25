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

<xsl:include sap:name="/UKW/ADSADI_ROUND_TRIP_2.XSL" />

<xsl:template match="/">
  <xsl:call-template name="root">
    <xsl:with-param name="ACTION_NAME" select="'PING'" />
  </xsl:call-template>
</xsl:template>

</xsl:transform>
