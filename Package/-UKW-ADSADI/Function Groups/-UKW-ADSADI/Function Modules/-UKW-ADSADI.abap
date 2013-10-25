function /ukw/adsadi.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(I_CALLBACK) TYPE REF TO  /UKW/IF_ADSADI_CALLBACK
*"     VALUE(I_SIZE) TYPE  STRING OPTIONAL
*"     VALUE(I_TOP_LEFT_Y) TYPE  I DEFAULT 3
*"     VALUE(I_TOP_LEFT_X) TYPE  I DEFAULT 40
*"     VALUE(I_WIDTH) TYPE  I DEFAULT 100
*"     VALUE(I_HEIGHT) TYPE  I DEFAULT 25
*"----------------------------------------------------------------------
*
* Copyright (c) 2011-2013 Servicecenter for Medical Informatics,
* Wuerzburg University Hospital, Germany. All rights reserved.
* Use is subject to license terms.
* http://goo.gl/dTqqQM
*

  g_callback = i_callback.
  if i_callback is bound.
    g_title = i_callback->title( ).
  endif.

  if i_size eq 'NORMAL'.
    call screen 100
      starting at 40  3
      ending   at 140 30.
  elseif i_size eq 'FULL'.
    call screen 100.
  else.
    data: bottom_right_x type i.
    data: bottom_right_y type i.

    bottom_right_x = i_top_left_x + i_width.
    bottom_right_y = i_top_left_y + i_height.
    call screen 100
      starting at i_top_left_x   i_top_left_y
      ending   at bottom_right_x bottom_right_y.
  endif.

endfunction.
