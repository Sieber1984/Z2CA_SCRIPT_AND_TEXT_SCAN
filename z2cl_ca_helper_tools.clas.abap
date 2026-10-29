CLASS z2cl_ca_helper_tools DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS get_filename
      IMPORTING
        iv_filename        TYPE z2ca_filename
        iv_file_filter     TYPE string DEFAULT cl_gui_frontend_services=>filetype_excel
      RETURNING
        VALUE(rv_filename) TYPE text1024
      RAISING
        zcx_ca_canceled_by_user .

    CLASS-METHODS get_folder
      CHANGING
        cv_folder TYPE text1024
      RAISING
        zcx_ca_canceled_by_user .

    CLASS-METHODS calculate_string_number
      IMPORTING
        iv_number_string                     TYPE string
        iv_add                               TYPE string OPTIONAL
        iv_substract                         TYPE string OPTIONAL
        iv_multiply                          TYPE string OPTIONAL
        iv_divide                            TYPE string OPTIONAL
      RETURNING
        VALUE(rv_converted_calculated_value) TYPE string .

    CLASS-METHODS get_field_with_header
      IMPORTING
        is_fields           TYPE any
        iv_header           TYPE string
      RETURNING
        VALUE(rv_fieldname) TYPE fieldname .

    CLASS-METHODS convert_date_excel_ext_to_int
      IMPORTING
        iv_date_extern        TYPE string
      RETURNING
        VALUE(rv_date_intern) TYPE date
      RAISING
        cx_sy_conversion_no_date .

    CLASS-METHODS round_string_num_by_dest_type
      IMPORTING
        iv_value_string  TYPE string
      CHANGING
        cv_value_numeric TYPE any .

    CLASS-METHODS get_components_by_data
      IMPORTING
        is_data_it_data      TYPE any
      RETURNING
        VALUE(rt_components) TYPE abap_component_tab
      RAISING
        zcx_ca_wrong_data_type .

    CLASS-METHODS get_components_by_data_ref
      IMPORTING
        ir_data              TYPE REF TO data
      RETURNING
        VALUE(rt_components) TYPE abap_component_tab
      RAISING
        zcx_ca_wrong_data_type .
  PRIVATE SECTION.
    CLASS-METHODS _conv_string_number_ex_to_in
      IMPORTING
        iv_number_string        TYPE string
      RETURNING
        VALUE(rv_number_string) TYPE string.

    CLASS-METHODS _get_components_by_datadescr
      IMPORTING
        io_abap_datadescr    TYPE REF TO cl_abap_datadescr
      RETURNING
        VALUE(rt_components) TYPE abap_component_tab
      RAISING
        zcx_ca_wrong_data_type.

ENDCLASS.



CLASS z2cl_ca_helper_tools IMPLEMENTATION.
  METHOD calculate_string_number.
    TRY.
        DATA(lv_number_string) = _conv_string_number_ex_to_in( iv_number_string ).

        IF iv_add IS NOT INITIAL.
          DATA(lv_add) = _conv_string_number_ex_to_in( iv_add ).
          rv_converted_calculated_value = lv_number_string + lv_add. "#EC CI_CONV_OK
        ELSEIF iv_substract IS NOT INITIAL.
          DATA(lv_substract) = _conv_string_number_ex_to_in( iv_substract ).
          rv_converted_calculated_value = lv_number_string - lv_substract. "#EC CI_CONV_OK
        ELSEIF iv_multiply IS NOT INITIAL.
          DATA(lv_multiply) = _conv_string_number_ex_to_in( iv_multiply ).
          rv_converted_calculated_value = lv_number_string * lv_multiply. "#EC CI_CONV_OK
        ELSEIF iv_divide IS NOT INITIAL.
          DATA(lv_divide) = _conv_string_number_ex_to_in( iv_divide ).
          TRY.
              rv_converted_calculated_value = lv_number_string / lv_divide. "#EC CI_CONV_OK
            CATCH cx_sy_zerodivide ##NO_HANDLER.
          ENDTRY.
        ELSE.
          rv_converted_calculated_value = lv_number_string.
        ENDIF.
      CATCH cx_sy_conversion_no_number.
        rv_converted_calculated_value = lv_number_string.
    ENDTRY.
  ENDMETHOD.

  METHOD convert_date_excel_ext_to_int.
    DATA lv_date_d TYPE d.

    rv_date_intern = '00000000'.
    IF strlen( iv_date_extern ) EQ 10.
      IF find( val = iv_date_extern regex = '\d{1,2}\.\d{1,2}\.\d{4}' ) EQ 0.
        rv_date_intern = |{ substring_after( val = iv_date_extern sub = '.' occ = -1 ) }{
                            substring_after( val = iv_date_extern sub = '.' occ = 1 len = 2 ) }{
                            substring( val = iv_date_extern len = 2 ) }|.
      ENDIF.
    ELSEIF strlen( iv_date_extern ) EQ 8 AND iv_date_extern CO ' 0123456789'.
      rv_date_intern = iv_date_extern.
    ELSEIF iv_date_extern CO ' 0123456789.'.
      TRY.
          rv_date_intern = zcl_excel_common=>excel_string_to_date( iv_date_extern ).
        CATCH zcx_excel ##NO_HANDLER.
      ENDTRY.
    ENDIF.

    lv_date_d = CONV dats( rv_date_intern ) + 0.
    IF lv_date_d NE rv_date_intern.
      RAISE EXCEPTION NEW cx_sy_conversion_no_date( value = iv_date_extern ).
    ENDIF.
  ENDMETHOD.

  METHOD get_components_by_data.
    CASE TYPE OF cl_abap_typedescr=>describe_by_data( is_data_it_data ).
      WHEN TYPE cl_abap_structdescr INTO DATA(lo_abap_structdescr).
        rt_components = _get_components_by_datadescr( lo_abap_structdescr ).
      WHEN TYPE cl_abap_tabledescr INTO DATA(lo_abap_tabledescr).
        rt_components = _get_components_by_datadescr( lo_abap_tabledescr ).
      WHEN OTHERS.
        RAISE EXCEPTION NEW zcx_ca_wrong_data_type( ).
    ENDCASE.
  ENDMETHOD.

  METHOD get_components_by_data_ref.
    IF ir_data IS BOUND.
      CASE TYPE OF cl_abap_typedescr=>describe_by_data_ref( ir_data ).
        WHEN TYPE cl_abap_structdescr INTO DATA(lo_abap_structdescr).
          rt_components = _get_components_by_datadescr( lo_abap_structdescr ).
        WHEN TYPE cl_abap_tabledescr INTO DATA(lo_abap_tabledescr).
          rt_components = _get_components_by_datadescr( lo_abap_tabledescr ).
        WHEN OTHERS.
          RAISE EXCEPTION NEW zcx_ca_wrong_data_type( ).
      ENDCASE.
    ENDIF.
  ENDMETHOD.

  METHOD get_field_with_header.
    DATA(lt_components) = CAST cl_abap_structdescr( cl_abap_structdescr=>describe_by_data( is_fields ) )->get_components( ).
    LOOP AT lt_components REFERENCE INTO DATA(lr_component).
      ASSIGN COMPONENT lr_component->name
             OF STRUCTURE is_fields
             TO FIELD-SYMBOL(<lv_header>).
      IF <lv_header> EQ iv_header.
        rv_fieldname = lr_component->name.
        EXIT.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_filename.
    DATA lv_rc TYPE i.
    DATA lv_action TYPE i.

    DATA lt_files TYPE filetable.

    cl_gui_frontend_services=>file_open_dialog(
      EXPORTING
        default_filename = |{ iv_filename }|
        file_filter = iv_file_filter
      CHANGING
        file_table  = lt_files
        rc          = lv_rc
        user_action = lv_action ).

    IF lv_action = cl_gui_frontend_services=>action_ok.
      IF lines( lt_files ) > 0.
        rv_filename = lt_files[ 1 ]-filename.
      ENDIF.
    ELSE.
      RAISE EXCEPTION NEW zcx_ca_canceled_by_user( ).
    ENDIF.
  ENDMETHOD.

  METHOD get_folder.
    DATA(lv_folder) = |{ cv_folder }|.

    cl_gui_frontend_services=>directory_browse(
      EXPORTING
        initial_folder       = CONV #( cv_folder )
      CHANGING
        selected_folder      = lv_folder
      EXCEPTIONS
        cntl_error           = 1
        error_no_gui         = 2
        not_supported_by_gui = 3
        OTHERS               = 4 ).
    IF sy-subrc EQ 0 AND lv_folder IS NOT INITIAL.
      cv_folder = lv_folder.
    ELSE.
      RAISE EXCEPTION NEW zcx_ca_canceled_by_user( ).
    ENDIF.

  ENDMETHOD.

  METHOD round_string_num_by_dest_type.
    CASE cl_abap_elemdescr=>get_data_type_kind( cv_value_numeric ).
      WHEN cl_abap_elemdescr=>typekind_int OR cl_abap_elemdescr=>typekind_int1 OR
           cl_abap_elemdescr=>typekind_int2 OR cl_abap_elemdescr=>typekind_int8 OR
           cl_abap_elemdescr=>typekind_num OR cl_abap_elemdescr=>typekind_packed OR
           cl_abap_elemdescr=>typekind_numeric.
        DATA(lv_decimals) = CAST cl_abap_elemdescr( cl_abap_typedescr=>describe_by_data( cv_value_numeric ) )->decimals.
        cv_value_numeric = round( val = iv_value_string dec = lv_decimals mode = cl_abap_math=>round_half_even ). "#EC CI_CONV_OK
    ENDCASE.
  ENDMETHOD.

  METHOD _conv_string_number_ex_to_in.
    DATA:
      lv_fltp               TYPE f,
      lv_quantity_pro_value TYPE p LENGTH 16 DECIMALS 10.

    IF iv_number_string CA `,`.
      rv_number_string = replace(  val = replace( val = iv_number_string
                                                  sub = `.`
                                                  with = ``
                                                  occ = 0 )
                                   sub = `,`
                                   with = `.` ).
    ELSE.
      rv_number_string = iv_number_string.
    ENDIF.

    IF rv_number_string CA 'E'.
      lv_fltp = rv_number_string.                       "#EC CI_CONV_OK
      lv_quantity_pro_value = lv_fltp.
      rv_number_string = lv_quantity_pro_value.
    ENDIF.
  ENDMETHOD.

  METHOD _get_components_by_datadescr.
    CASE TYPE OF io_abap_datadescr.
      WHEN TYPE cl_abap_structdescr INTO DATA(lo_abap_structdescr).
      WHEN TYPE cl_abap_tabledescr INTO DATA(lo_abap_tabledescr).
        DATA(lo_abap_datadescr) = lo_abap_tabledescr->get_table_line_type( ).
        IF lo_abap_datadescr IS INSTANCE OF cl_abap_structdescr.
          lo_abap_structdescr = CAST #( lo_abap_datadescr ).
        ELSE.
          RAISE EXCEPTION NEW zcx_ca_wrong_data_type( ).
        ENDIF.
      WHEN OTHERS.
        RAISE EXCEPTION NEW zcx_ca_wrong_data_type( ).
    ENDCASE.
    rt_components = lo_abap_structdescr->get_components( ).

    LOOP AT rt_components REFERENCE INTO DATA(lr_component).
      IF lr_component->as_include EQ abap_true.
        DATA(lv_insert_components) = sy-tabix + 1.
        INSERT LINES OF _get_components_by_datadescr( lr_component->type )
               INTO rt_components
               INDEX lv_insert_components.
      ENDIF.
    ENDLOOP.

    DELETE rt_components WHERE as_include EQ abap_true.  "#EC CI_STDSEQ
  ENDMETHOD.
ENDCLASS.
