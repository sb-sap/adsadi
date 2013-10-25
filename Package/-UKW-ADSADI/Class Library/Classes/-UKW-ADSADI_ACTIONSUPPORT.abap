*
* Copyright (c) 2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://www.smi.uk-wuerzburg.de
*
class /UKW/ADSADI_ACTIONSUPPORT definition
  public
  create public .

public section.

  interfaces /UKW/IF_ADSADI_ACTION .

  aliases CANCEL
    for /UKW/IF_ADSADI_ACTION~CANCEL .
  aliases ERROR
    for /UKW/IF_ADSADI_ACTION~ERROR .
  aliases INPUT
    for /UKW/IF_ADSADI_ACTION~INPUT .
  aliases SUCCESS
    for /UKW/IF_ADSADI_ACTION~SUCCESS .
  aliases ADD_RESULT_CONFIG
    for /UKW/IF_ADSADI_ACTION~ADD_RESULT_CONFIG .
  aliases EXECUTE_ACTION
    for /UKW/IF_ADSADI_ACTION~EXECUTE_ACTION .
  aliases EXECUTE_RESULT
    for /UKW/IF_ADSADI_ACTION~EXECUTE_RESULT .
  aliases GET_OWNER
    for /UKW/IF_ADSADI_ACTION~GET_OWNER .
  aliases GET_VALUE
    for /UKW/IF_ADSADI_ACTION~GET_VALUE .
  aliases NAME
    for /UKW/IF_ADSADI_ACTION~NAME .
  aliases PREPARE
    for /UKW/IF_ADSADI_ACTION~PREPARE .
  aliases SET_OWNER
    for /UKW/IF_ADSADI_ACTION~SET_OWNER .

  methods CONSTRUCTOR
    importing
      value(NAME) type STRING optional .
  methods XML
    importing
      value(I_XML) type STRING optional
    returning
      value(R) type STRING .
  methods XML_DOC
    importing
      value(I_XML_DOC) type ref to IF_IXML_NODE optional
    returning
      value(R) type ref to IF_IXML_NODE .
  type-pools ABAP .
  methods XSLT_PARAMS
    importing
      value(I_XSLT_PARAMS) type ABAP_TRANS_PARMBIND_TAB optional
    returning
      value(R) type ABAP_TRANS_PARMBIND_TAB .

protected section.

  types:
    begin of result_config_type,
          result type string,
          view   type string,
        end of result_config_type .

  data M_NAME type STRING value 'ACTION'. "#EC NOTEXT . " .
  data M_XML type STRING .
  data M_XML_DOC type ref to IF_IXML_NODE .
  type-pools CNHT .
  data QUERY_TABLE type CNHT_QUERY_TABLE .
  data:
    result_configs type hashed table of result_config_type with unique key result .
  type-pools ABAP .
  data M_XSLT_PARAMS type ABAP_TRANS_PARMBIND_TAB .
  data M_OWNER type ref to /UKW/ADSADI_DIALOG .

  methods UPDATE_PARAMS .
  methods RESULT_VIEW_LOOKUP
    importing
      value(RESULT) type STRING
    returning
      value(R) type STRING .

  private section.
endclass. "/UKW/ADSADI_ACTIONSUPPORT definition

*"* local class implementation

method /ukw/if_adsadi_action~add_result_config.
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
  data: result_config_item type result_config_type.
  read table result_configs into result_config_item with table key result = result.

  if sy-subrc ne 0 and result is not initial.
    result_config_item-result = result.
    result_config_item-view   = view.

    insert result_config_item into table result_configs.
  endif.
endmethod.

method /ukw/if_adsadi_action~execute_action.
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
  result = /ukw/if_adsadi_action=>success.
endmethod.

method /UKW/IF_ADSADI_ACTION~EXECUTE_RESULT.
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
    data: ex type ref to  cx_xslt_runtime_error.
    data: ex2 type ref to cx_transformation_error.

    data: param type abap_trans_parmbind.

    data: begin of bgr,
          h1 type c length 2,
          h2 type c length 2,
          h3 type c length 2,
        end of bgr.

    data: hex type x length 3.
    data: buf type c length 10.
    data: color type i.

*   Background-Color1
    delete me->m_xslt_params where name eq 'SAP_BACKGROUNDCOLOR1'.
    param-name = 'SAP_BACKGROUNDCOLOR1'.
    param-value = '#FFFFFF'.

    " Overwrite default with system value
    call method cl_gui_resources=>get_background_color
      exporting
        id     = cl_gui_resources=>col_background_level1
        state  = 0
      importing
        color  = color
      exceptions
        others = 1.
    if sy-subrc = 0.
      bgr = buf = hex = color.
      concatenate `#` bgr-h3 bgr-h2 bgr-h1 into param-value.
    endif.
    append param to me->m_xslt_params.

*   Background-Color2
    delete me->m_xslt_params where name eq 'SAP_BACKGROUNDCOLOR2'.
    param-name = 'SAP_BACKGROUNDCOLOR2'.
    param-value = '#CCCCCC'.

    " Overwrite default with system value
    call method cl_gui_resources=>get_background_color
      exporting
        id     = cl_gui_resources=>col_background_level2
        state  = 0
      importing
        color  = color
      exceptions
        others = 1.
    if sy-subrc = 0.
      bgr = buf = hex = color.
      concatenate `#` bgr-h3 bgr-h2 bgr-h1 into param-value.
    endif.
    append param to me->m_xslt_params.

    data: result_view type string.
    result_view = me->result_view_lookup( result ).

    if result_view is not initial.
      try.
          if me->m_xml_doc is bound.
            call transformation (result_view)
                     parameters (me->m_xslt_params)
                     source xml me->m_xml_doc
                     result xml r.
          else.
            call transformation (result_view)
                     parameters (me->m_xslt_params)
                     source xml me->m_xml
                     result xml r.
          endif.
        catch: cx_xslt_runtime_error into ex.
        catch: cx_invalid_transformation into ex2.
      endtry.
    endif.
endmethod.

method /ukw/if_adsadi_action~get_owner.
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
  r = me->m_owner.
endmethod.

method /UKW/IF_ADSADI_ACTION~GET_VALUE.
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
    data: the_param type w3query.
    clear: r.

    loop at me->query_table into the_param where name eq n.
      r = the_param-value.
      exit.
    endloop.

    if r is initial.
      " No exact match found, look for sliced parameters due to the
      " 512/250-bottleneck of SAPHTMLP protocol.
      "
      " For a given field with name "fieldname" chunks are stored in a sequence of
      " parameters with name "fieldname_chunk_001, fieldname_chunk_002,...".
      data: chunk_param_name type string.
      data: cur_value type string.
      concatenate n `_chunk_*` into chunk_param_name.
      sort me->query_table by name ascending.

      loop at me->query_table into the_param where name cp chunk_param_name.
        cur_value = the_param-value.
        " Remove end marker '|'
        replace regex `\|$` in cur_value with ``.
        concatenate r cur_value into r.
      endloop.
    endif.
endmethod.

method /UKW/IF_ADSADI_ACTION~NAME.
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
    if name is not initial. me->m_name = name. endif.
    r = me->m_name.
endmethod.

method /UKW/IF_ADSADI_ACTION~PREPARE.
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
    data: the_param type w3query.
    clear: me->query_table.
    " Gather post and get data
    if getdata is not initial.
      the_param-name = action.
      the_param-value = getdata.
      append the_param to me->query_table.
    endif.
    loop at query_table into the_param.
      append the_param to me->query_table.
    endloop.
endmethod.

method /ukw/if_adsadi_action~set_owner.
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
  me->m_owner = dialog.
endmethod.

  method CONSTRUCTOR.
    me->name( name ).
  endmethod.

  method RESULT_VIEW_LOOKUP.
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
    data: result_config_item type result_config_type.
    read table result_configs into result_config_item with table key result = result.
    r = result_config_item-view.
  endmethod.                    "RESULT_VIEW_LOOKUP

method UPDATE_PARAMS.
  data: param type abap_trans_parmbind.

  " Tab und Scrollposition durchreichen
  delete me->m_xslt_params where name eq 'LAST_TAB_IDX'.
  param-name = 'LAST_TAB_IDX'.
  param-value = me->get_value( 'activeTabIdx' ).
  append param to me->m_xslt_params.

  delete me->m_xslt_params where name eq 'LAST_SCROLL_POS'.
  param-name = 'LAST_SCROLL_POS'.
  param-value = me->get_value( 'scrollPos' ).
  append param to me->m_xslt_params.

  " Theme
  delete me->m_xslt_params where name eq 'THEME'.
  param-name = 'THEME'.
  param-value = me->get_value( 'theme' ).
  append param to me->m_xslt_params.
endmethod.

  method XML.
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
    if i_xml is not initial. me->m_xml = i_xml. endif.
    r = me->m_xml.
  endmethod.                    "xml

  method XML_DOC.
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
    if i_xml_doc is bound. me->m_xml_doc = i_xml_doc. endif.
    r = me->m_xml_doc.
  endmethod.                    "xml_doc

  method XSLT_PARAMS.
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
    if i_xslt_params is not initial. me->m_xslt_params = i_xslt_params. endif.
    r = me->m_xslt_params.
  endmethod.                    "xslt_params
endclass. "/UKW/ADSADI_ACTIONSUPPORT implementation
