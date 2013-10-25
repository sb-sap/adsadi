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
report  /ukw/adsadi_round_trip_2.

data: dlg type ref to /ukw/adsadi_dialog.

* An AdSaDi dialog always has a default action with the name "ACTION_POST".
* At creation of the dialog object, specify the XSL template that generates
* the first view to start with. This can be any view, but in this example
* we reuse the view from the PING-action.
create object dlg
  exporting
    i_xslt       = '/UKW/ADSADI_ROUNDTRIP2PING.XSL'
    i_top_left_y = 3
    i_top_left_x = 40
    i_width	     = 100
    i_height     = 10.

* Define first action named "ACTION_PING".
* Use this name everywhere in HTML forms for the action parameter like
* <form id="myform" method="post" action="SAPEVENT:ACTION_PING"> in order to
* post the form data to this action.
data: ping_action type ref to /ukw/adsadi_round_trip_2_ping.
create object ping_action
  exporting
    name = 'ACTION_PING'.

ping_action->add_result_config(
  result = /ukw/if_adsadi_action=>success
  view   = 'ZADSADI_ROUND_TRIP_2_PING.XSL'
).

dlg->register_action(
  name = 'ACTION_PING'
  action = ping_action
).

* Define second action named "ACTION_PONG".
* Use this name everywhere in HTML forms for the action parameter like
* <form id="myform" method="post" action="SAPEVENT:ACTION_PONG"> in order to
* post the form data to this action.
data: pong_action type ref to /ukw/adsadi_round_trip_2_pong.
create object pong_action
  exporting
    name = 'ACTION_PONG'.

pong_action->add_result_config(
  result = /ukw/if_adsadi_action=>success
  view   = 'ZADSADI_ROUND_TRIP_2_PONG.XSL'
).

dlg->register_action(
  name = 'ACTION_PONG'
  action = pong_action
).

if dlg->render( ) ne /ukw/if_adsadi_callback=>dlg_cancel.
  write: / `success...`.
  data: name type string.
  name = ping_action->get_value( 'your_name' ).
  write: / `success... your_name = ` no-gap, name.
else.
  write: / `cancel...`.
endif.
