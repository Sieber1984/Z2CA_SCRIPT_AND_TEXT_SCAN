"*********************************************************************
" Function:    Send materials via IDoc
"
" Description: This report displays every last unique message of selected
"              BIL-Tranaction
"
" created:     at 12.03.2024 by Stephan Köster
"
" Copyright:   consolut international ag
"              Ebnatstrasse 65c
"              CH-8200 Schaffhausen
"              Phone +41 52 533 8331
"              Fax   +41 52 533 8332
"              www.consolut.com
"
"------------|-------------|--------------------------------------------
" Date       | change user | modification
"------------|-------------|--------------------------------------------
" xx.xx.xxxx | xxx         | Kommentar
"------------|-------------|--------------------------------------------
REPORT z2ca_bil_status_display MESSAGE-ID z2ca_bil.

INCLUDE z2ca_bil_status_display_top. " Global data
INCLUDE z2ca_bil_status_display_c01. " Selection screen class
INCLUDE z2ca_bil_status_display_sel. " Selection screen

AT SELECTION-SCREEN OUTPUT.
  lcl_selection_screen=>get_instance( )->pbo( ).

AT SELECTION-SCREEN ON BLOCK b00.
  IF ( sscrfields-ucomm EQ 'ONLI' OR sscrfields-ucomm EQ 'SJOB' ) AND
     sy-ucomm EQ space.
    CLEAR: sscrfields-ucomm.
    RETURN.
  ELSEIF ( sscrfields-ucomm EQ 'ONLI' OR sscrfields-ucomm EQ 'SJOB' ).
    IF |{ p_mb01 }{ p_dlv51 }| CO abap_false.
      CLEAR sy-ucomm.
      MESSAGE e001.
    ENDIF.
  ENDIF.

AT SELECTION-SCREEN ON p_spras.
  lcl_selection_screen=>get_instance( )->pai_on_field(
    EXPORTING
      iv_fieldname    = 'P_SPRAS'
    CHANGING
      cv_syucomm      = sy-ucomm
      cv_screen_ucomm = sscrfields-ucomm ).

START-OF-SELECTION.
  IF p_mb01 EQ abap_true.
    APPEND VALUE #( sign   = 'I'
                    option = 'EQ'
                    low    = ytbil_busobj-mb01 )
           TO s_busobj.
  ENDIF.
  IF p_dlv51 EQ abap_true.
    APPEND VALUE #( sign   = 'I'
                    option = 'EQ'
                    low    = ytbil_busobj-dlv51 )
           TO s_busobj.
  ENDIF.
  IF NOT z2cl_ca_bil_tran_messages=>get_instance( )->set_selection_data(
             it_selection_screen = VALUE #( ( name = 'TRNUMB'
                                              data = REF #( s_trnumb[] ) )
                                            ( name = 'BUSOBJ'
                                              data = REF #( s_busobj[] ) )
                                            ( name = 'COSINS'
                                              data = REF #( s_cosins[] ) )
                                            ( name = 'CREDAT'
                                              data = REF #( s_credat[] ) )
                                            ( name = 'MSGTY'
                                              data = REF #( s_msgty[] ) ) )
             iv_language_for_messages = p_spras )->has_data( ).
    MESSAGE s022(ybil_base).
    RETURN.
  ENDIF.

END-OF-SELECTION.
  DATA(gt_output) = z2cl_ca_bil_tran_messages=>get_instance( )->get_selected_data( ).
  TRY.
      cl_salv_table=>factory(
        EXPORTING
          list_display = xsdbool( cl_gui_alv_grid=>offline( ) EQ 1 )
        IMPORTING
          r_salv_table = DATA(go_salv_table)
        CHANGING
          t_table      = gt_output ).

      go_salv_table->get_functions( )->set_all( ).
      go_salv_table->get_columns( )->set_optimize( ).
      IF p_mb01 EQ abap_false OR p_dlv51 EQ abap_false.
        DATA(lt_display_structures) = z2cl_ca_bil_tran_messages=>get_instance( )->get_display_structures( ).
        DATA(lt_components) = CAST cl_abap_structdescr(
                                CAST cl_abap_tabledescr(
                                  cl_abap_tabledescr=>describe_by_data( gt_output ) )->get_table_line_type( ) )->get_components( ).
        LOOP AT lt_components REFERENCE INTO DATA(lr_component)
             WHERE type IS INSTANCE OF cl_abap_structdescr.
          IF NOT line_exists( lt_display_structures[ structure = lr_component->name ] ).
            DATA(lt_components_to_hide) = CAST cl_abap_structdescr( lr_component->type )->get_components( ).
            LOOP AT lt_components_to_hide REFERENCE INTO DATA(lr_componetn_to_hide).
              TRY.
                  DATA(lo_column_to_hide) = go_salv_table->get_columns( )->get_column( |{ lr_componetn_to_hide->name }{ lr_component->suffix }| ).
                  lo_column_to_hide->set_technical( ).
                CATCH cx_salv_not_found.
              ENDTRY.
            ENDLOOP.
          ENDIF.
        ENDLOOP.
      ENDIF.
      go_salv_table->display( ).
    CATCH cx_salv_msg ##NO_HANDLER.
  ENDTRY.
