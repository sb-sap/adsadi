*
* Copyright (c) 2013-2016 Servicecenter for Medical Informatics,
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
report  /ukw/adsadi_xml_demo_1.

data: dlg type ref to /ukw/adsadi_dialog.
data: xml type string.

concatenate
  '<?xml version="1.0" encoding="utf-8" ?>'
  `<my-dialog title="Risk factor analysis">`
  ` <field type="select" text="Emergency admission" name="emergency" value="">`
  `   <option text="Outpatient" value="outpatient" />`
  `   <option text="Inpatient" value="inpatient" selected="yes" />`
  `   <option text="Day-Unit" value="day-unit" />`
  ` </field>`
  ` <field type="radio"  text="Level of care III" name="care_level3" value="" />`
  ` <field type="radio"  text="Stay in hospital last 12 month" name="stay_12month" value="" />`
  ` <field type="input"  text="Comment" name="comment" value="" />`
  `</my-dialog>`
  into xml.

create object dlg
  exporting
    i_xslt       = '/UKW/ADSADI_XML_DEMO_1.XSL'
    i_xml        = xml
    i_top_left_y = 1
    i_top_left_x = 1
    i_width      = 50
    i_height     = 10.

if dlg->render( ) ne /ukw/if_adsadi_callback=>dlg_cancel.

  data: param type string.

  param = dlg->get_value( 'emergency' ).
  write: / `emergency: ` no-gap, param.

  param = dlg->get_value( 'care_level3' ).
  write: / `care_level3: ` no-gap, param.

  param = dlg->get_value( 'stay_12month' ).
  write: / `stay_12month: ` no-gap, param.

  param = dlg->get_value( 'comment' ).
  write: / `comment: ` no-gap, param.

endif.
