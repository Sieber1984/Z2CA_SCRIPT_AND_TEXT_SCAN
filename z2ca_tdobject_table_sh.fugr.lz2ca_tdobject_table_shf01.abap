FORM fill_language_range.
  DATA:
    lv_system_language TYPE c LENGTH 128,
    lv_second_language TYPE c LENGTH 128.

  CALL FUNCTION 'RSAN_SYSTEM_PARAMETER_READ'
    EXPORTING
      i_name     = 'zcsa/system_language'
    IMPORTING
      e_value    = lv_system_language
    EXCEPTIONS
      read_error = 1
      OTHERS     = 2.

  CALL FUNCTION 'RSAN_SYSTEM_PARAMETER_READ'
    EXPORTING
      i_name     = 'zcsa/second_language'
    IMPORTING
      e_value    = lv_second_language
    EXCEPTIONS
      read_error = 1
      OTHERS     = 2.

  gt_spras_range = VALUE #( sign = 'I'
                            option = 'EQ'
                            ( low = sy-langu )
                            ( low = COND #( WHEN sy-langu NE lv_system_language
                                            THEN lv_system_language
                                            WHEN sy-langu NE lv_second_language
                                            THEN lv_second_language
                                            WHEN sy-langu NE 'E'
                                            THEN 'E'
                                            ELSE 'D' ) ) ).
ENDFORM.
