*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*
*----------------------------------------------------------------------*
***INCLUDE LZADSADIO01 .
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module status_0100 output.
  set pf-status '/UKW/ADSADI'.
  set titlebar '/UKW/ADSADI' with g_title.
  g_callback->display( ).
endmodule.                 " STATUS_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module user_command_0100 input.
  data: last_command type string.
  last_command = sy-ucomm.

  case sy-ucomm.
    when 'BACK'.
      g_callback->close( last_command ).
    when others.
      " CAVE: crashes if the length of the value of a post/get parameter exceeds 512 characters.
      " The caused query_error/cntl_error can't be catched here.
      " Look at CL_GUI_HTML_VIEWER, APPEND_QUERY_PARAMETER for details.
      " To prevent this, use html client side Javascript to chop such long parameter values
      " into pieces not more than 512 characters long before the html form is submitted.
      g_callback->last_command( last_command ).
      call method cl_gui_cfw=>dispatch.
  endcase.
endmodule.                 " USER_COMMAND_0100  INPUT
