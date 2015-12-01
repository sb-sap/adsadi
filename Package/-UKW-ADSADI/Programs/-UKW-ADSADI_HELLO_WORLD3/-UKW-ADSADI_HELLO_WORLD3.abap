*
* Copyright (c) 2013-2015 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://www.ukw.de
*
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
report  /ukw/adsadi_hello_world3.

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
