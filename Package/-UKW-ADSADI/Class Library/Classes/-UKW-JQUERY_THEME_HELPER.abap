*
* Copyright (c) 2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://www.smi.uk-wuerzburg.de
*
class /UKW/JQUERY_THEME_HELPER definition
  public
  create public .

public section.

  class-methods THEME_4_USER
    importing
      value(I_THEME) type STRING optional
    returning
      value(R) type STRING .

protected section.

  constants C_JQUERY_PARAM_ID type USR05-PARID value '/UKW/JQUERY_THEME'. "#EC NOTEXT

private section.
endclass. "/UKW/JQUERY_THEME_HELPER definition

*"* local class implementation

method theme_4_user.
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
  data: theme_parva type usr05-parva.
  data: theme type string.
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
    else.
      theme = 'cupertino'. " default
    endif.
  else.
    " Schreiben
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
