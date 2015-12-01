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
report  /ukw/adsadi_hello_world.

data: dlg type ref to /ukw/adsadi_dialog.

create object dlg
  exporting
    i_xslt = '/UKW/ADSADI_HELLO_WORLD.XSL'.

if dlg->render( ) ne /ukw/if_adsadi_callback=>dlg_cancel.
  write: / `success...`.
else.
  write: / `cancel...`.
endif.
