*
* Copyright (c) 2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://www.smi.uk-wuerzburg.de
*
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
report  /ukw/adsadi_round_trip_1.

data: dlg type ref to /ukw/adsadi_dialog.

create object dlg
  exporting
    i_xslt       = '/UKW/ADSADI_ROUND_TRIP_1.XSL'
    i_top_left_y = 3
    i_top_left_x = 40
    i_width	     = 100
    i_height     = 10.

data: hello_action type ref to /ukw/adsadi_round_trip_1_act.
create object hello_action
  exporting
    name = 'ACTION_HELLO'.

hello_action->add_result_config(
  result = /ukw/if_adsadi_action=>success
  view   = 'ZADSADI_ROUND_TRIP_1.XSL'
).

dlg->register_action(
  name = 'ACTION_HELLO'
  action = hello_action
).

if dlg->render( ) ne /ukw/if_adsadi_callback=>dlg_cancel.
  write: / `success...`.
  data: name type string.
  name = hello_action->get_value( 'your_name' ).
  write: / `success... your_name = ` no-gap, name.
else.
  write: / `cancel...`.
endif.
