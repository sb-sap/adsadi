*
* Copyright (c) 2013-2016 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://www.ukw.de
*
interface /UKW/IF_ADSADI_CALLBACK
  public .


  constants DLG_CANCEL type I value 1. "#EC NOTEXT
  constants DLG_NO_CANCEL type I value -1. "#EC NOTEXT

  type-pools CNHT .
  methods EXECUTE_ACTION
    importing
      value(ACTION) type STRING
      value(GETDATA) type C optional
      value(POSTDATA) type CNHT_POST_DATA_TAB optional
      value(QUERY_TABLE) type CNHT_QUERY_TABLE optional
    returning
      value(R) type STRING .
  methods LAST_COMMAND
    importing
      value(I_COMMAND) type STRING optional
    returning
      value(R) type STRING .
  methods EXECUTE_RESULT
    importing
      value(RESULT) type STRING
    returning
      value(R) type /UKW/ADSADI_T_ML .
  methods ACTION_LOOKUP
    importing
      value(NAME) type STRING
    returning
      value(ACTION) type ref to /UKW/ADSADI_ACTIONSUPPORT .
  methods DISPLAY .
  methods CLOSE
    importing
      value(I_COMMAND) type STRING optional .
  methods TITLE
    returning
      value(R) type STRING .
endinterface.
