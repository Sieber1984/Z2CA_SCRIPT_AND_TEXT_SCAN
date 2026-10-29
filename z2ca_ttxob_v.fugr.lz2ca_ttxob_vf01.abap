FORM zzfield_obligatory.
  IF <vim_tctrl> IS ASSIGNED.
    LOOP AT <vim_tctrl>-cols ASSIGNING FIELD-SYMBOL(<ls_col>).
      IF line_exists( x_namtab[ viewfield = substring_after( val = <ls_col>-screen-name
                                                             sub = '-'
                                                             occ = -1 )
                                keyflag   = abap_true ] ).
        <ls_col>-screen-required = 1.
      ENDIF.
      IF substring_after( val = <ls_col>-screen-name
                          sub = '-'
                          occ = -1 ) EQ 'TDSPRAS'.
        <ls_col>-screen-active = 0.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDFORM.
