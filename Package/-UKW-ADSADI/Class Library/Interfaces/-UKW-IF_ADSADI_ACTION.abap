*
* Copyright (c) 2013-2015 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://www.ukw.de
*
interface /UKW/IF_ADSADI_ACTION
  public .


  constants ERROR type STRING value 'ERROR'. "#EC NOTEXT
  constants SUCCESS type STRING value 'SUCCESS'. "#EC NOTEXT
  constants CANCEL type STRING value 'CANCEL'. "#EC NOTEXT
  constants INPUT type STRING value 'INPUT'. "#EC NOTEXT

  methods NAME
    importing
      value(NAME) type STRING optional
    returning
      value(R) type STRING .
  methods EXECUTE_ACTION
    returning
      value(RESULT) type STRING .
  methods EXECUTE_RESULT
    importing
      value(RESULT) type STRING default 'SUCCESS'
    returning
      value(R) type /UKW/ADSADI_T_ML .
  type-pools CNHT .
  methods PREPARE
    importing
      value(ACTION) type C optional
      value(GETDATA) type C optional
      value(POSTDATA) type CNHT_POST_DATA_TAB optional
      value(QUERY_TABLE) type CNHT_QUERY_TABLE optional .
  methods GET_VALUE
    importing
      value(N) type STRING
    returning
      value(R) type STRING .
  methods ADD_RESULT_CONFIG
    importing
      value(RESULT) type STRING
      value(VIEW) type STRING .
  methods SET_OWNER
    importing
      value(DIALOG) type ref to /UKW/ADSADI_DIALOG .
  methods GET_OWNER
    returning
      value(R) type ref to /UKW/ADSADI_DIALOG .
endinterface.
