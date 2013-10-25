*
* Copyright (c) 2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://www.smi.uk-wuerzburg.de
*
class /UKW/ADSADI_ROUND_TRIP_1_ACT definition
  public
  inheriting from /UKW/ADSADI_ACTIONSUPPORT
  create public .

public section.

  methods /UKW/IF_ADSADI_ACTION~EXECUTE_ACTION
    redefinition .

protected section.

  private section.
endclass. "/UKW/ADSADI_ROUND_TRIP_1_ACT definition

*"* local class implementation

method /ukw/if_adsadi_action~execute_action.
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
  result = super->/ukw/if_adsadi_action~execute_action( ).

  data: cancel type string.
  cancel = me->get_value( 'cancel' ).
  if cancel eq 'X'.
    result = /ukw/if_adsadi_action=>cancel.
    return.
  endif.

  data: your_name type string.
  your_name = me->get_value( 'your_name' ).
  concatenate
    '<?xml version="1.0" encoding="utf-8" ?>'
    `<my-dialog your_name="` your_name `">`
    `</my-dialog>`
  into me->m_xml.
endmethod.
endclass. "/UKW/ADSADI_ROUND_TRIP_1_ACT implementation
