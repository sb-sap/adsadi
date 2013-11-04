Demo 1 - Hello World!
---------------------

**Demo 1 - ABAP**

        data: dlg type ref to /ukw/adsadi_dialog.
        
        create object dlg
          exporting
            i_xslt = '/UKW/ADSADI_HELLO_WORLD.XSL'.
        
        if dlg->render( ) ne /ukw/if_adsadi_callback=>dlg_cancel.
          write: / `success...`.
        else.
          write: / `cancel...`.
        endif.

**Demo 1 - XSLT /UKW/ADSADI_HELLO_WORLD1.XSL**

        <xsl:transform version="1.0"
          xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
          xmlns:sap="http://www.sap.com/sapxsl"
        >
        
        <xsl:template match="/">
          <html>
            <head></head>
            <body>
              <div>Hello, <b>World</b>!</div>
            </body>
          </html>
        </xsl:template>
        
        </xsl:transform>

![Hello World Example](https://raw.github.com/RubyNunatak/adsadi/master/img/adsadi_40.png)

Demo 2 - Hello World with input field
-------------------------------------

**Demo 2 - ABAP**

        data: dlg type ref to /ukw/adsadi_dialog.
        
        create object dlg
          exporting
            i_xslt       = '/UKW/ADSADI_HELLO_WORLD2.XSL'
            i_top_left_y = 1
            i_top_left_x = 10
            i_width      = 50
            i_height     = 5.
        
        if dlg->render( ) ne /ukw/if_adsadi_callback=>dlg_cancel.
        
          data: your_name type string.
          your_name = dlg->get_value( 'your_name' ).
        
          data: len type i.
          len = strlen( your_name ).
        
          write: / `success... your_name = ` no-gap.
        
          if len ge 250.
            " To illustrate the loss of information beyond 250 characters
            " split input if the length is 250 (longer is not possible anyway).
            " To prevent this loss look at Hello World program 3.
            len = len / 2.
            write: your_name(len).
            your_name = your_name+len(*).
            write: your_name.
          else.
            write: your_name.
          endif.
        else.
          write: / `cancel...`.
        endif.

**Demo 2 - XSLT /UKW/ADSADI_HELLO_WORLD2.XSL**

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

![Demo 2](https://raw.github.com/RubyNunatak/adsadi/master/img/adsadi_45.png)


Demo 3 - Text input of any length
---------------------------------

**Demo 3 - ABAP**

        data: dlg type ref to /ukw/adsadi_dialog.
        data: dlg type ref to /ukw/adsadi_dialog.
        
        create object dlg
          exporting
            i_xslt = '/UKW/ADSADI_HELLO_WORLD3.XSL'
            i_size = 'FULL'.
        
        if dlg->render( ) ne /ukw/if_adsadi_callback=>dlg_cancel.
        
          data: long_text type string.
          data: line_len type i value 72.
          data: len type i.
        
          long_text = dlg->get_value( 'long_text' ).
          len = strlen( long_text ).
        
          write: / `long_text:` no-gap, len.
        
          while len > line_len.
            write: / long_text(line_len).
            long_text = long_text+line_len(*).
            len = strlen( long_text ).
          endwhile.
          write: / long_text(len).
        
        endif.

**Demo 2 - XSLT /UKW/ADSADI_HELLO_WORLD3.XSL**

        <xsl:transform version="1.0"
          xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
          xmlns:sap="http://www.sap.com/sapxsl"
        >
        
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

![Demo 3](https://raw.github.com/RubyNunatak/adsadi/master/img/adsadi_03.png)