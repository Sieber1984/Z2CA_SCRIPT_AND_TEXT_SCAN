FORM selection_screen_value_request.
  DATA(lt_dynpfields) = VALUE dynpread_tabtype( ( fieldname  = 'P_FILE' ) ).

  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      dyname     = sy-repid
      dynumb     = sy-dynnr
    TABLES
      dynpfields = lt_dynpfields.
  TRY.
      DATA(gv_filename) = z2cl_ca_helper_tools=>get_filename(
                              iv_filename    = VALUE #( lt_dynpfields[ fieldname = 'P_FILE' ]-fieldvalue OPTIONAL )
                              iv_file_filter = 'ZIP (*.zip)\|*.zip' ).
      p_file = gv_filename.
    CATCH zcx_ca_canceled_by_user INTO DATA(lx_ca_canceled_by_user).
      MESSAGE lx_ca_canceled_by_user TYPE 'S'.
  ENDTRY.
ENDFORM.

FORM at_selection_screen.
  TRY.
      cl_progress_indicator=>progress_indicate( i_msgid              = 'Z2CA_DHL'
                                                i_msgno              = '005'
                                                i_msgv1              = |{ substring_after( val = p_file sub = '\' occ = -1 ) }|
                                                i_processed          = 25
                                                i_total              = 100
                                                i_output_immediately = abap_true ).
      go_zip = z2cl_ca_zip=>get_instance( p_file ).
    CATCH zcx_ca_file_not_exists INTO DATA(lx_ca_file_not_exists).
      MESSAGE lx_ca_file_not_exists TYPE 'E'.
    CATCH cx_sy_file_open INTO DATA(lx_sy_file_open).
      MESSAGE lx_sy_file_open TYPE 'E'.
    CATCH zcx_ca_zip_file_error INTO DATA(lx_ca_zip_file_error).
      MESSAGE lx_ca_zip_file_error TYPE 'E'.
  ENDTRY.
ENDFORM.

FORM start_of_selection.
  DATA t_out  TYPE z2ca_dhl_import_file_data_t.
  DATA olen TYPE i.
  DATA xtab TYPE TABLE OF x255.
  DATA ls   TYPE string.

  DO.
    DATA(lv_zipped_file_index) = sy-index.
    TRY.
        cl_progress_indicator=>progress_indicate( i_msgid              = 'Z2CA_DHL'
                                                  i_msgno              = '006'
                                                  i_msgv1              = lv_zipped_file_index
                                                  i_processed          = 50
                                                  i_total              = 100
                                                  i_output_immediately = abap_true ).

        DATA(lv_file_content) = go_zip->get_file_content_by_index( lv_zipped_file_index ).

        CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
          EXPORTING
            buffer        = lv_file_content
          IMPORTING
            output_length = olen
          TABLES
            binary_tab    = xtab.

        CALL FUNCTION 'SCMS_BINARY_TO_STRING'
          EXPORTING
            input_length = olen
            encoding     = '1103'
          IMPORTING
            text_buffer  = ls
          TABLES
            binary_tab   = xtab
          EXCEPTIONS
            failed       = 1
            OTHERS       = 2.

        SPLIT ls AT cl_abap_char_utilities=>cr_lf INTO TABLE t_out.

        DATA(lt_return) = z2cl_ca_appl_z2ca_dhl_stradb=>insert_entries_into_db(
                              it_dhl_import_file_data = t_out
                              iv_test                 = p_test ).
        APPEND LINES OF lt_return TO gt_return.

        lt_return = z2cl_ca_appl_z2ca_dhl_ortdb=>insert_entries_into_db(
                        it_dhl_import_file_data = t_out
                        iv_test                 = p_test ).
        APPEND LINES OF lt_return TO gt_return.
      CATCH zcx_ca_zip_index_error.
        EXIT.
      CATCH zcx_ca_zip_decompression_error.
        EXIT.
    ENDTRY.
  ENDDO.
ENDFORM.

FORM end_of_selection.
  TRY.
      cl_salv_table=>factory(
      IMPORTING
        r_salv_table = DATA(lo_salv_table_ret)
      CHANGING
        t_table = gt_return  ).

      lo_salv_table_ret->get_functions( )->set_all( abap_true ).
      lo_salv_table_ret->get_columns( )->set_optimize( ).
      lo_salv_table_ret->display( ).
    CATCH cx_salv_msg.
  ENDTRY.
ENDFORM.
