AdSaDi
------

AdSaDi - Advanced SAP Dialog is a smal ABAP package to make the SAP HTML Viewer (CL_GUI_HTML_VIEWER) 
ready to use along with dynamically created HTML content an runtime by using XSL transformations.

Copyright (c) 2011-2013 Servicecenter for Medical Informatics (http://www.smi.ukw.de)
Wuerzburg University Hospital, Germany
All rights reserved. Use is subject to license terms.


Install and Update
------------------

Please follow the installation process (manually) described in the tutorials for an initial setup. 
To update to the current version, copy&paste the respective *.abap files using transaction SE80.


How to use
----------

A simple Hello, World! example with one dialog parameter in two steps:

**Create an XSL stylesheet ZADSADI_HELLO_WORLD.XSL**

        <xsl:transform version="1.0"
          xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
          xmlns:sap="http://www.sap.com/sapxsl"
        >

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
        
**Create an ABAP program**

        data: dlg type ref to /ukw/adsadi_dialog.
        
        create object dlg
          exporting
            i_xslt = 'ZADSADI_HELLO_WORLD2.XSL'
            i_size = 'FULL'.

        if dlg->render( ) ne /ukw/adsadi_dialog=>dlg_cancel.
          data: your_name type string.
          your_name = dlg->get_value( 'your_name' ).
          write: / `success... your_name = ` no-gap, your_name.
        else.
          write: / `cancel...`.
        endif.
