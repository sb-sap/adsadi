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
report  /ukw/adsadi_xml_demo_2.

data: dlg type ref to /ukw/adsadi_dialog.

* XML Demo 1 created the xml inline via concatenate, which is error-prone due to the
* lack of syntax checking at compile time.
*
* XML Demo 2 here uses the iXML library to create an XML tree,
* which appears more verbose, but is more flexible and enables compile time error checking.

data: the_ixml type ref to if_ixml.
data: xml_doc type ref to if_ixml_document.

the_ixml = cl_ixml=>create( ).
xml_doc  = the_ixml->create_document( ).

data: root type ref to if_ixml_element.
root = xml_doc->create_element( name = 'my-dialog' ).
root->set_attribute( name = 'title' value = 'Risk factor analysis' ).
xml_doc->append_child( root ).

data: elm type ref to if_ixml_element.
elm = xml_doc->create_element( name = 'field' ).
elm->set_attribute( name = 'type' value = 'select' ).
elm->set_attribute( name = 'text' value = 'Emergency admission' ).
elm->set_attribute( name = 'name' value = 'emergency' ).
elm->set_attribute( name = 'value' value = '' ).
root->append_child( elm ).

data: elm2 type ref to if_ixml_element.
elm2 = xml_doc->create_element( name = 'option' ).
elm2->set_attribute( name = 'text' value = 'Outpatient' ).
elm2->set_attribute( name = 'value' value = 'outpatient' ).
elm->append_child( elm2 ).

elm2 = xml_doc->create_element( name = 'option' ).
elm2->set_attribute( name = 'text' value = 'Inpatient' ).
elm2->set_attribute( name = 'value' value = 'inpatient' ).
elm2->set_attribute( name = 'selected' value = 'yes' ).
elm->append_child( elm2 ).

elm2 = xml_doc->create_element( name = 'option' ).
elm2->set_attribute( name = 'text' value = 'Day-Unit' ).
elm2->set_attribute( name = 'value' value = 'day-unit' ).
elm->append_child( elm2 ).

elm = xml_doc->create_element( name = 'field' ).
elm->set_attribute( name = 'type' value = 'radio' ).
elm->set_attribute( name = 'text' value = 'Level of care III' ).
elm->set_attribute( name = 'name' value = 'care_level3' ).
elm->set_attribute( name = 'value' value = '' ).
root->append_child( elm ).

elm = xml_doc->create_element( name = 'field' ).
elm->set_attribute( name = 'type' value = 'radio' ).
elm->set_attribute( name = 'text' value = 'Stay in hospital last 12 month' ).
elm->set_attribute( name = 'name' value = 'stay_12month' ).
elm->set_attribute( name = 'value' value = '' ).
root->append_child( elm ).

elm = xml_doc->create_element( name = 'field' ).
elm->set_attribute( name = 'type' value = 'input' ).
elm->set_attribute( name = 'text' value = 'Comment' ).
elm->set_attribute( name = 'name' value = 'comment' ).
elm->set_attribute( name = 'value' value = '' ).
root->append_child( elm ).

create object dlg
  exporting    " Use same XSL stylesheet as XML Demo 1 because html layout doesn't has changed
    i_xslt       = '/UKW/ADSADI_XML_DEMO_1.XSL'
    i_xml_doc    = xml_doc
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
