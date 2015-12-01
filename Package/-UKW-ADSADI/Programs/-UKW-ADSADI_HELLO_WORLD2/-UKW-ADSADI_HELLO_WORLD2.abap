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
report  /ukw/adsadi_hello_world2.

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
