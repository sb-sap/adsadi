*
* Copyright (c) 2013-2015 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://www.ukw.de
*
*
* Copyright (c) 2011-2012 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/6sH2p
*

*
* Copyright (c) 2011-2012 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/6sH2p
*



class /UKW/ADSADI_DIALOG definition
  public
  create public .

public section.
  type-pools ABAP .
  type-pools CNHT .

  interfaces /UKW/IF_ADSADI_CALLBACK .

  aliases DLG_CANCEL
    for /UKW/IF_ADSADI_CALLBACK~DLG_CANCEL .
  aliases DLG_NO_CANCEL
    for /UKW/IF_ADSADI_CALLBACK~DLG_NO_CANCEL .
  aliases ACTION_LOOKUP
    for /UKW/IF_ADSADI_CALLBACK~ACTION_LOOKUP .
  aliases ADSADI_TITLE
    for /UKW/IF_ADSADI_CALLBACK~TITLE .
  aliases CLOSE
    for /UKW/IF_ADSADI_CALLBACK~CLOSE .
  aliases EXECUTE_ACTION
    for /UKW/IF_ADSADI_CALLBACK~EXECUTE_ACTION .
  aliases EXECUTE_RESULT
    for /UKW/IF_ADSADI_CALLBACK~EXECUTE_RESULT .
  aliases LAST_COMMAND
    for /UKW/IF_ADSADI_CALLBACK~LAST_COMMAND .

  methods ON_SAPEVENT
    for event SAPEVENT of CL_GUI_HTML_VIEWER
    importing
      !ACTION
      !FRAME
      !GETDATA
      !POSTDATA
      !QUERY_TABLE .
  methods CANCELED
    importing
      value(CANCELED) type I optional
    returning
      value(R) type I .
  methods DISPLAY_RESULT
    importing
      value(ACTION) type ref to /UKW/ADSADI_ACTIONSUPPORT
      value(RESULT) type STRING .
  methods REGISTER_ACTION
    importing
      value(NAME) type STRING
      value(ACTION) type ref to /UKW/ADSADI_ACTIONSUPPORT .
  methods XSLT_PARAMS
    importing
      value(I_XSLT_PARAMS) type ABAP_TRANS_PARMBIND_TAB optional
    returning
      value(R) type ABAP_TRANS_PARMBIND_TAB .
  methods SET_PARAMS
    importing
      value(I_PARAMS) type ABAP_TRANS_PARMBIND_TAB .
  methods CONSTRUCTOR
    importing
      value(I_XSLT) type CSEQUENCE optional
      value(I_XML) type CSEQUENCE optional
      value(I_XML_DOC) type ref to IF_IXML_NODE optional
      value(I_PARAMS) type ABAP_TRANS_PARMBIND_TAB optional
      value(I_SIZE) type CSEQUENCE default ''
      value(I_TOP_LEFT_Y) type I default 3
      value(I_TOP_LEFT_X) type I default 40
      value(I_WIDTH) type I default 100
      value(I_HEIGHT) type I default 25
      value(I_TITLE) type STRING default ''
      value(I_JQUERY_VERSION) type /UKW/JQUERY_VERSION optional .
  methods GET_VALUE
    importing
      value(N) type CSEQUENCE
    returning
      value(R) type STRING .
  methods RENDER
    returning
      value(CANCELED) type I .
  class-methods GET_SAPGUI_BGCOLOR
    returning
      value(E_COLOR) type N2_CHAR10 .
  class-methods GET_SAPGUI_FGCOLOR
    returning
      value(E_COLOR) type N2_CHAR10 .

protected section.

  types:
    begin of action_registry_type,
          name type string,
          action type ref to /ukw/adsadi_actionsupport,
      end of action_registry_type .

  data M_LAST_COMMAND type STRING .
  data XML type STRING .
  data XML_DOC type ref to IF_IXML_NODE .
  data XSLT type STRING .
  data QUERY_TABLE type CNHT_QUERY_TABLE .
  data SIZE type STRING .
  data TOP_LEFT_Y type I .
  data TOP_LEFT_X type I .
  data WIDTH type I .
  data HEIGHT type I .
  data:
    action_registry type hashed table of action_registry_type with unique key name .
  data M_CANCELED type I .
  data M_XSLT_PARAMS type ABAP_TRANS_PARMBIND_TAB .

private section.

  aliases DISPLAY
    for /UKW/IF_ADSADI_CALLBACK~DISPLAY .

  data TITLE type STRING .
  data HTML_VIEWER type ref to CL_GUI_HTML_VIEWER .
  data HTML_CONTAINER type ref to CL_GUI_CUSTOM_CONTAINER .
endclass. "/UKW/ADSADI_DIALOG definition

*"* local class implementation

method /ukw/if_adsadi_callback~action_lookup.
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
  data: action_registry_item type action_registry_type.
  read table action_registry into action_registry_item with table key name = name.

  "if sy-subrc eq 0.
  action = action_registry_item-action.
  "endif.
endmethod.

method /ukw/if_adsadi_callback~close.
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
  if not me->html_viewer is initial.
    call method me->html_viewer->free.
    free me->html_viewer.
    call method me->html_container->free.
    free me->html_container.
  endif.

  me->last_command( i_command ).
  if i_command eq 'SAVE'.
    me->canceled( /ukw/if_adsadi_callback=>dlg_no_cancel ).
  endif.

  leave to screen 0.
endmethod.

method /ukw/if_adsadi_callback~display.
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
  " Display only at the first time. Further display is done within display_result.
  if me->html_viewer is initial.
    create object html_container
      exporting
        container_name = 'CONTAINER'.

    create object me->html_viewer
      exporting
        parent = html_container.

*   register event
    data: myevent_tab type cntl_simple_events.
    data: myevent type cntl_simple_event.

    myevent-eventid = me->html_viewer->m_id_sapevent.
    myevent-appl_event = 'x'.
    append myevent to myevent_tab.

    me->html_viewer->set_registered_events( myevent_tab ).
*      create object evt_receiver
*        exporting
*          callback = me.
*      set handler evt_receiver->on_sapevent for me->html_viewer.
    set handler me->on_sapevent for me->html_viewer.

    data: doc_url(80).
    data: html_tab type /ukw/adsadi_t_ml.
    data: html_l type line of /ukw/adsadi_t_ml.

    refresh html_tab.

    data: post_action type ref to /ukw/adsadi_actionsupport.
    post_action = me->action_lookup( 'ACTION_POST' ).

    if post_action is bound.
      html_tab = post_action->execute_result( /ukw/if_adsadi_action=>input ).

      me->xslt_params( post_action->xslt_params( ) ).

      if html_tab is not initial.

        call method me->html_viewer->load_data
          exporting
            url          = doc_url
            size         = 0
            type         = 'text'
            subtype      = 'html'
          importing
            assigned_url = doc_url
          changing
            data_table   = html_tab
          exceptions
            others       = 1.

        if sy-subrc eq 0.
          call method me->html_viewer->show_url
            exporting
              url = doc_url.
        endif.
      endif.
    endif.
  else.
    if me->last_command( ) eq 'SAVE'.
      " The save occurs outside of the HTML viewer. Is there a way to force
      " the viewer from outside to fire on_sapevent? If this would be possible,
      " the outside SAVE event could trigger a generic SAVE action, as one would
      " click a SAVE button in the HTML form.
      "
      " Call to me->html_viewer->dispatch fails if it is triggered this way the first time.
      " If the me->html_viewer->dispatch occurs the first time from the control itself, the
      " subsequenct trigger here doesn't fail anymore. Why?
      " Anyway, the manually triggered me->html_viewer->dispatch yields no query_table parameters.
      " THEREFORE: Save should only happen from inside the HTML form!
      " Finally: It never could work this way, because which form inside the HTML form should be
      " posted if there are more than one? There is no complete 'state' of the HTML that could be
      " queried from outside.
*        me->html_viewer->dispatch(
*          eventid = me->html_viewer->m_id_sapevent
*          cargo = ''
*          is_shellevent = ''
*        ).
      me->last_command( '-' ).
    endif.
  endif.

  "r = me->html_viewer.
endmethod.

method /ukw/if_adsadi_callback~execute_action.
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

  case action.
    when 'ACTION_HELLO'.
      data: your_name type string.
      your_name = me->get_value( 'your_name' ).
      concatenate
        '<?xml version="1.0" encoding="utf-8" ?>'
        `<my-dialog your_name="` your_name `">`
        `</my-dialog>`
      into me->xml.
  endcase.

  r = 'SUCCESS'.
endmethod.

method /ukw/if_adsadi_callback~execute_result.
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


  try.
      if me->xml_doc is bound.
        call transformation (result)
                 parameters (me->m_xslt_params)
                 source xml me->xml_doc
                 result xml r.
      else.
        call transformation (result)
                 parameters (me->m_xslt_params)
                 source xml me->xml
                 result xml r.
      endif.
    catch: cx_xslt_runtime_error into ex.
    catch: cx_invalid_transformation into ex2.
  endtry.
endmethod.

method /ukw/if_adsadi_callback~last_command.
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
  if i_command is not initial.
    me->m_last_command = i_command.
  else.
    r = m_last_command.
  endif.
endmethod.

method /ukw/if_adsadi_callback~title.
  r = me->title.
endmethod.

  method CANCELED.
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
    if canceled is not initial.
      r = me->m_canceled = canceled.
    else.
      r = me->m_canceled.
    endif.
  endmethod.                    "canceled

  method constructor.
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
    data: param type line of abap_trans_parmbind_tab.
    me->m_xslt_params  = i_params.
    delete  me->m_xslt_params where name eq 'SAP_BACKGROUNDCOLOR'.
    param-name = 'SAP_BACKGROUNDCOLOR'.
    param-value = /ukw/adsadi_dialog=>get_sapgui_bgcolor( ).
    append param to  me->m_xslt_params.

    delete  me->m_xslt_params where name eq 'SAP_FOREGROUNDCOLOR'.
    param-name = 'SAP_FOREGROUNDCOLOR'.
    param-value = /ukw/adsadi_dialog=>get_sapgui_fgcolor( ).
    append param to  me->m_xslt_params.

    if i_jquery_version is not initial.
      delete me->m_xslt_params where name eq 'THEME'.
      param-name = 'THEME'.
      param-value = /ukw/jquery_theme_helper=>theme_4_user( i_jquery_version = i_jquery_version ).
      append param to me->m_xslt_params.
    endif.

    me->xslt         = i_xslt.
    me->size         = i_size.
    me->top_left_y   = i_top_left_y.
    me->top_left_x   = i_top_left_x.
    me->width        = i_width.
    me->height       = i_height.
    me->title        = i_title.
    if i_xml is not initial.
      me->xml = i_xml.
    elseif i_xml_doc is bound.
      me->xml_doc = i_xml_doc.
    else.
      concatenate
        `<?xml version="1.0" encoding="utf-8" ?>`
        `<dialog />`
        into me->xml.
    endif.

* To be backward compatible with single page dialog, generate the default
* action with name "ACTION_POST".
    data: post_action type ref to /ukw/adsadi_actionsupport.
    create object post_action
      exporting
        name = 'ACTION_POST'.

    post_action->add_result_config(
      result = /ukw/if_adsadi_action=>input
      view   = me->xslt
    ).
    post_action->xml( me->xml ).
    post_action->xml_doc( me->xml_doc ).
    post_action->xslt_params( me->xslt_params( ) ).

    me->register_action(
      name = 'ACTION_POST'
      action = post_action
    ).
  endmethod.                    "CONSTRUCTOR

  method DISPLAY_RESULT.
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
    data: doc_url(80).
    data: html_tab type zadsadi_t_ml.
    data: html_l type line of zadsadi_t_ml.

    me->last_command( '-' ).

    refresh html_tab.

    html_tab = action->execute_result( result ).

    if html_tab is not initial and me->html_viewer is bound.

      call method me->html_viewer->load_data
        exporting
          url          = doc_url
          size         = 0
          type         = 'text'
          subtype      = 'html'
        importing
          assigned_url = doc_url
        changing
          data_table   = html_tab
        exceptions
          others       = 1.

      if sy-subrc eq 0.
        call method me->html_viewer->show_url
          exporting
            url = doc_url.
      endif.
    else.
      me->close( ).
    endif.
  endmethod.                    "display_result

method GET_SAPGUI_BGCOLOR .
  " Aus Defaultcode übernommen
  DATA: BEGIN OF ls_buf,
          h1 TYPE c LENGTH 2,
          h2 TYPE c LENGTH 2,
          h3 TYPE c LENGTH 2,
        END OF ls_buf.

  DATA l_hex TYPE x LENGTH 3.
  DATA l_buf TYPE c LENGTH 10.
  DATA color TYPE i.

* get Font/Color-Infos from GUI
  CALL METHOD cl_gui_resources=>get_background_color
    EXPORTING
      id                     = cl_gui_resources=>col_background_level1 "col_background_level2
      state                  = 0
    IMPORTING
      color                  = color
    EXCEPTIONS
      get_std_resource_error = 1
      OTHERS                 = 2.
  IF sy-subrc = 0.
    ls_buf = l_buf = l_hex = color.
    e_color = ls_buf-h3.
    CONCATENATE e_color ls_buf-h2 INTO e_color.
    CONCATENATE e_color ls_buf-h1 INTO e_color.
    CONCATENATE '#' e_color INTO e_color.
  ENDIF.
endmethod.

method GET_SAPGUI_FGCOLOR .
  " Aus Defaultcode übernommen
  DATA: BEGIN OF ls_buf,
          h1 TYPE c LENGTH 2,
          h2 TYPE c LENGTH 2,
          h3 TYPE c LENGTH 2,
        END OF ls_buf.

  DATA l_hex TYPE x LENGTH 3.
  DATA l_buf TYPE c LENGTH 10.
  DATA color TYPE i.

* get Font/Color-Infos from GUI
  CALL METHOD cl_gui_resources=>get_background_color
    EXPORTING
      id                     = cl_gui_resources=>col_background_level2
      state                  = 0
    IMPORTING
      color                  = color
    EXCEPTIONS
      get_std_resource_error = 1
      OTHERS                 = 2.
  IF sy-subrc = 0.
    ls_buf = l_buf = l_hex = color.
    e_color = ls_buf-h3.
    CONCATENATE e_color ls_buf-h2 INTO e_color.
    CONCATENATE e_color ls_buf-h1 INTO e_color.
    CONCATENATE '#' e_color INTO e_color.
  ENDIF.
endmethod.

  method GET_VALUE.
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
*   Backward compatible to singel page dialog
    data: post_action type ref to /ukw/adsadi_actionsupport.
    post_action = me->/ukw/if_adsadi_callback~action_lookup( 'ACTION_POST' ).
    if post_action is bound.
      r = post_action->get_value( n ).
    endif.
  endmethod.                    "GET_VALUE

  method ON_SAPEVENT.
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
    data: action_name type string.
    action_name = action.

    data: result type string.
    data: result_view type string.

    if action_name is initial.
      me->canceled( /ukw/if_adsadi_callback=>dlg_cancel ).
      me->close( ).
      return.
    endif.

    if action is not initial.
      me->canceled( /ukw/if_adsadi_callback=>dlg_no_cancel ).

      data: adsadi_action type ref to /ukw/adsadi_actionsupport.
      adsadi_action = me->action_lookup( action_name ).

      if adsadi_action is bound.

        adsadi_action->prepare(
          getdata     = getdata
          postdata    = postdata
          query_table = query_table
        ).
        adsadi_action->xslt_params( me->xslt_params( ) ).

        result = adsadi_action->execute_action( ).

        if result = /ukw/if_adsadi_action=>success.
          me->xslt_params( adsadi_action->xslt_params( ) ).
          " Params weitergeben?

          me->display_result( action = adsadi_action result = result ).
        else.
          if result eq /ukw/if_adsadi_action=>cancel.
            me->canceled( /ukw/if_adsadi_callback=>dlg_cancel ).
          endif.
          me->close( ).
        endif.
      else.
        me->close( ).
      endif.
    endif.
  endmethod.                    "on_sapevent

  method REGISTER_ACTION.
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
    data: action_registry_item type action_registry_type.
    read table action_registry into action_registry_item with table key name = name.

    if sy-subrc ne 0 and action is not initial.
      action_registry_item-name = name.
      action_registry_item-action = action.

      insert action_registry_item into table action_registry.
      action->set_owner( me ).
    endif.
  endmethod.                    "register_action

  method RENDER.
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*

    me->canceled( /ukw/if_adsadi_callback=>dlg_cancel ).

    call function '/UKW/ADSADI'
      exporting
        i_callback   = me
        i_size       = me->size
        i_top_left_y = me->top_left_y
        i_top_left_x = me->top_left_x
        i_width      = me->width
        i_height     = me->height.

    canceled = me->canceled( ).
  endmethod.                    "RENDER

  method SET_PARAMS.
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
    me->m_xslt_params = i_params.

*   Backward compatible to singel page dialog
    data: post_action type ref to /ukw/adsadi_actionsupport.
    post_action = me->/ukw/if_adsadi_callback~action_lookup( 'ACTION_POST' ).
    if post_action is bound.
      post_action->xslt_params( me->m_xslt_params ).
    endif.
  endmethod.                    "set_params

  method XSLT_PARAMS.
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
    if i_xslt_params is not initial.
      me->set_params( i_xslt_params ).
    endif.
    r = me->m_xslt_params.
  endmethod.                    "xslt_params
endclass. "/UKW/ADSADI_DIALOG implementation
