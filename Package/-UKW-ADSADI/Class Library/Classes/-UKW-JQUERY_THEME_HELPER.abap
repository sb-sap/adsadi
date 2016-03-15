*
* Copyright (c) 2013-2016 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://www.ukw.de
*
class /UKW/JQUERY_THEME_HELPER definition
  public
  create public .

public section.

  constants C_JQUERY_VERSION_1_8 type /UKW/JQUERY_VERSION value '1.8'. "#EC NOTEXT
  constants C_JQUERY_VERSION_1_11_0 type /UKW/JQUERY_VERSION value '1.11.0'. "#EC NOTEXT

  class-methods JQUERY_VERSION_LATEST
    returning
      value(R) type /UKW/JQUERY_VERSION .
  class-methods THEME_4_USER
    importing
      value(I_THEME) type STRING optional
      value(I_JQUERY_VERSION) type /UKW/JQUERY_VERSION optional
    preferred parameter I_THEME
    returning
      value(R) type STRING .

protected section.

  constants C_JQUERY_PARAM_ID type USR05-PARID value '/UKW/JQUERY_THEME'. "#EC NOTEXT

private section.
endclass. "/UKW/JQUERY_THEME_HELPER definition

*"* local class implementation

method jquery_version_latest.
  r = c_jquery_version_1_11_0.
endmethod.

method theme_4_user.
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
  data: theme_parva type usr05-parva.
  data: theme type string.
  data: old_theme type string.
  data: ver_theme type string.

  theme = i_theme.

  if theme is initial.
    " Lesen
    call function 'ISH_USR05_GET'
      exporting
        ss_bname         = sy-uname
        ss_parid         = c_jquery_param_id
      importing
        ss_value         = theme_parva
      exceptions
        parid_not_found  = 1
        bname_is_initial = 2
        parid_is_initial = 3
        others           = 4.
    if sy-subrc eq 0 and theme_parva is not initial.
      theme = theme_parva.
      " Versionen behandeln
      split theme at ';' into old_theme ver_theme.
      " theme=cupertiono;1.11.0:trontastik

      if i_jquery_version is initial.
        theme = old_theme.
      else.
        data: ver type string.
        split ver_theme at ':' into ver ver_theme.
        if ver eq i_jquery_version.
          theme = ver_theme.
        else.
          theme = old_theme.
        endif.
      endif.
    else.
      theme = 'cupertino'. " default
    endif.
  else.
    " Schreiben

    " Version berücksichtigen
    " Immer alten Wert lesen
    " theme=cupertiono;1.11.0:trontastik
    data: theme_db type string.
    data: parid_db type string.
    parid_db = c_jquery_param_id.

    theme_db = /ukw/userparam_helper=>read_userparam(
       i_param = parid_db
       i_default_empty_not_exists = ''
     ).

    split theme_db at ';' into old_theme ver_theme.

    if i_jquery_version is initial.
      " Vorne ersetzen
      old_theme = theme.
    else.
      ver_theme = i_jquery_version && `:` && theme.
    endif.

    theme = old_theme && `;` && ver_theme.

    theme_parva = theme.
    call function 'ISH_USR05_SET'
      exporting
        ss_bname         = sy-uname
        ss_parid         = c_jquery_param_id
        ss_value         = theme_parva
      exceptions
        bname_is_initial = 1
        parid_is_initial = 2
        others           = 3.
    if sy-subrc <> 0.
    endif.
  endif.

  r = theme.
endmethod.
endclass. "/UKW/JQUERY_THEME_HELPER implementation
