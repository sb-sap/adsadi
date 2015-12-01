*
* Copyright (c) 2013-2015 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://www.ukw.de
*
class /UKW/ADSADI_ACTION_THEME definition
  public
  inheriting from /UKW/ADSADI_ACTIONSUPPORT
  create public .

public section.

  methods CONSTRUCTOR
    importing
      value(NAME) type STRING optional
      value(JQUERY_VERSION) type /UKW/JQUERY_VERSION optional .

  methods /UKW/IF_ADSADI_ACTION~EXECUTE_ACTION
    redefinition .

protected section.

  data JQUERY_VERSION type /UKW/JQUERY_VERSION .

private section.
endclass. "/UKW/ADSADI_ACTION_THEME definition

*"* local class implementation

method /ukw/if_adsadi_action~execute_action.
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
  result = super->/ukw/if_adsadi_action~execute_action( ).

  data: param type abap_trans_parmbind.
  data: theme type string.
  theme = me->get_value( 'theme' ).

  " Theme speichern im Userparamter
  /ukw/jquery_theme_helper=>theme_4_user(
    i_theme = theme
    i_jquery_version = me->jquery_version
  ).

  me->update_params( ).
endmethod.

method constructor.
  super->constructor( name = name ).
  me->jquery_version = jquery_version.
endmethod.
endclass. "/UKW/ADSADI_ACTION_THEME implementation
