CLASS z2cl_ca_excel_import_tools DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        iv_filename               TYPE text1024
        iv_header_row_count       TYPE n DEFAULT 1
        iv_types                  TYPE z2ca_worksheet_title OPTIONAL
        iv_types_header_row_count TYPE n OPTIONAL
      RAISING
        zcx_excel
        zcx_ca_sheet_cannot_imported
        zcx_ca_sheet_unknown_type
        zcx_ca_types_sheet_not_exists
        cx_sy_table_creation
        cx_sy_struct_creation
        cx_sy_conversion_exact_not_sup
        zcx_ca_wrong_data_type.

    METHODS memorize_sheets
      IMPORTING
        iv_date_conv_raise_exception TYPE abap_bool DEFAULT abap_false
        iv_use_types_of_sheet        TYPE abap_bool
        iv_ignore_missing_type       TYPE abap_bool
        iv_use_conversion_exit       TYPE abap_bool DEFAULT abap_false
      RAISING
        zcx_excel
        zcx_ca_sheet_cannot_imported
        zcx_ca_sheet_unknown_type
        zcx_ca_sheet_not_exists
        zcx_ca_types_sheet_not_exists
        cx_sy_table_creation
        cx_sy_struct_creation
        cx_sy_conversion_exact_not_sup
        zcx_ca_wrong_data_type
        cx_sy_conversion_no_date.

    METHODS memorize_sheet
      IMPORTING
        iv_worksheet_title           TYPE z2ca_worksheet_title
        iv_header_row_count          TYPE n OPTIONAL
        iv_date_conv_raise_exception TYPE abap_bool DEFAULT abap_false
        iv_use_types_of_sheet        TYPE abap_bool DEFAULT abap_false
        iv_ignore_missing_type       TYPE abap_bool
        iv_use_conversion_exit       TYPE abap_bool DEFAULT abap_false
      RAISING
        zcx_ca_sheet_cannot_imported
        zcx_ca_sheet_not_exists
        zcx_ca_sheet_unknown_type
        zcx_ca_types_sheet_not_exists
        zcx_excel
        cx_sy_table_creation
        cx_sy_struct_creation
        cx_sy_conversion_exact_not_sup
        zcx_ca_wrong_data_type
        cx_sy_conversion_no_date.

    METHODS memorize_types
      IMPORTING
        iv_worksheet_title      TYPE z2ca_worksheet_title DEFAULT '_____________TYPES_____________'
        it_types_4_excel_sheets TYPE z2ca_types_4_excel_sheets_t.

    METHODS save_excel_file
      IMPORTING
        iv_filename TYPE string
        io_excel    TYPE REF TO zcl_excel
      RAISING
        zcx_ca_canceled_by_user
        zcx_ca_file_not_saved.

    METHODS get_filename
      RETURNING
        VALUE(rv_filename) TYPE text1024.

    METHODS get_excel_with_header_by_title
      IMPORTING
        iv_worksheet_title TYPE z2ca_worksheet_title
      RETURNING
        VALUE(ro_excel)    TYPE REF TO zcl_excel
      RAISING
        zcx_excel.

    METHODS get_excel_with_header_by_index
      IMPORTING
        iv_worksheet_index TYPE i
      RETURNING
        VALUE(ro_excel)    TYPE REF TO zcl_excel
      RAISING
        zcx_excel.

    METHODS convert_date_time_in_table
      IMPORTING
        it_table_data_source         TYPE any
        iv_date_conv_raise_exception TYPE abap_bool
      CHANGING
        ct_table_data_target         TYPE any
      RAISING
        zcx_ca_wrong_data_type
        cx_sy_conversion_no_date.

    METHODS get_sheet_content_by_index
      IMPORTING
        iv_worksheet_index      TYPE i
      RETURNING
        VALUE(rr_sheet_content) TYPE REF TO data
      RAISING
        zcx_ca_sheet_cannot_imported
        zcx_ca_sheet_not_exists
        zcx_ca_sheet_index_not_exists.

    METHODS get_sheet_content_by_title
      IMPORTING
        iv_worksheet_title      TYPE z2ca_worksheet_title
      RETURNING
        VALUE(rr_sheet_content) TYPE REF TO data
      RAISING
        zcx_ca_sheet_cannot_imported
        zcx_ca_sheet_not_exists.

    METHODS get_new_table_by_index
      IMPORTING
        iv_worksheet_index           TYPE i
        it_excel_insert_fields_begin TYPE z2ca_excel_additional_fields_t OPTIONAL
        it_excel_additional_fields   TYPE z2ca_excel_additional_fields_t OPTIONAL
      RETURNING
        VALUE(rr_sheet_content)      TYPE REF TO data
      RAISING
        zcx_ca_sheet_cannot_imported
        zcx_ca_sheet_not_exists
        zcx_ca_sheet_index_not_exists.

    METHODS get_new_table_by_title
      IMPORTING
        iv_worksheet_title           TYPE z2ca_worksheet_title
        it_excel_insert_fields_begin TYPE z2ca_excel_additional_fields_t OPTIONAL
        it_excel_additional_fields   TYPE z2ca_excel_additional_fields_t OPTIONAL
      RETURNING
        VALUE(rr_sheet_content)      TYPE REF TO data
      RAISING
        zcx_ca_sheet_cannot_imported
        zcx_ca_sheet_not_exists.

    METHODS get_new_table_by_reference
      IMPORTING
        ir_data                      TYPE REF TO data
        it_excel_insert_fields_begin TYPE z2ca_excel_additional_fields_t OPTIONAL
        it_excel_additional_fields   TYPE z2ca_excel_additional_fields_t OPTIONAL
      RETURNING
        VALUE(rr_sheet_content)      TYPE REF TO data
      RAISING
        zcx_ca_wrong_data_type.

    METHODS get_sap_column_name
      IMPORTING
        iv_worksheet_title        TYPE z2ca_worksheet_title
        iv_excel_column_name      TYPE text1024
      RETURNING
        VALUE(rv_sap_column_name) TYPE fieldname.

    METHODS get_header_count_by_index
      IMPORTING
        iv_worksheet_index         TYPE i
      RETURNING
        VALUE(rv_header_row_count) TYPE i
      RAISING
        zcx_ca_sheet_index_not_exists.

    METHODS get_header_count_by_title
      IMPORTING
        iv_worksheet_title         TYPE z2ca_worksheet_title
      RETURNING
        VALUE(rv_header_row_count) TYPE i
      RAISING
        zcx_ca_sheet_not_exists.

    METHODS get_column_count
      IMPORTING
        iv_worksheet_title     TYPE z2ca_worksheet_title
      RETURNING
        VALUE(rv_column_count) TYPE i.

    METHODS get_sheetcomponents_by_name
      IMPORTING
        iv_worksheet_title   TYPE z2ca_worksheet_title
      RETURNING
        VALUE(rt_components) TYPE abap_component_tab.

    METHODS get_sheetcomponents_by_index
      IMPORTING
        iv_worksheet_index   TYPE i
      RETURNING
        VALUE(rt_components) TYPE abap_component_tab.

    METHODS sheet_exists
      IMPORTING
        iv_worksheet_title     TYPE z2ca_worksheet_title
      RETURNING
        VALUE(rv_sheet_exists) TYPE abap_bool.

    METHODS get_worksheet_title
      IMPORTING
        iv_worksheet_index        TYPE i
      RETURNING
        VALUE(rv_worksheet_title) TYPE z2ca_worksheet_title.

    METHODS check_columns_exists
      IMPORTING
        iv_worksheet_index  TYPE i
        it_columns_to_check TYPE z2ca_fieldname_t
      RAISING
        zcx_ca_sheet_index_not_exists
        zcx_ca_missing_column.

private section.

  constants CO_SAP_COLUMN_NAME type FIELDNAME value 'COLUMN_' ##NO_TEXT.
  constants CO_DEFAULT_EXCEL_COLUMN_TYPE type ROLLNAME value 'Z2CA_DEFAULT_EXCEL_COLUMN_TYPE' ##NO_TEXT.
  data MV_HEADER_ROW_COUNT type N .
  data MV_TYPES type Z2CA_WORKSHEET_TITLE .
  data MV_TYPES_HEADER_ROW_COUNT type N .
  data MT_EXCEL_CONTENT type Z2CA_EXCEL_CONTENT_T .
  data MV_FILENAME type TEXT1024 .
  data MO_EXCEL type ref to ZCL_EXCEL .

  methods _GET_TABLE_CONTENT
    importing
      !IO_WORKSHEET type ref to ZCL_EXCEL_WORKSHEET
      !IO_ABAP_TABLEDESCR type ref to CL_ABAP_TABLEDESCR
      !IV_HEADER_ROW_COUNT type N
    returning
      value(RR_TABLE_CONTENT) type ref to DATA
    raising
      ZCX_EXCEL .
  methods _GET_TABLEDESCR_FOR_HEADER
    importing
      !IO_WORKSHEET type ref to ZCL_EXCEL_WORKSHEET
    returning
      value(RO_CONTENT_TABLE) type ref to CL_ABAP_TABLEDESCR
    raising
      ZCX_EXCEL
      CX_SY_TABLE_CREATION
      CX_SY_STRUCT_CREATION .
  methods _DETERMINE_MAPPING
    importing
      !IO_WORKSHEET type ref to ZCL_EXCEL_WORKSHEET
      !IV_HEADER_ROW_COUNT type N
      !IV_USE_TYPES_OF_SHEET type ABAP_BOOL
      !IV_IGNORE_MISSING_TYPE type ABAP_BOOL
    raising
      ZCX_CA_SHEET_UNKNOWN_TYPE
      ZCX_CA_SHEET_CANNOT_IMPORTED
      ZCX_CA_TYPES_SHEET_NOT_EXISTS
      ZCX_EXCEL
      CX_SY_TABLE_CREATION
      CX_SY_STRUCT_CREATION
      CX_SY_CONVERSION_EXACT_NOT_SUP
      CX_SY_ITAB_DYN_LOOP
      ZCX_CA_WRONG_DATA_TYPE .
  methods _FILL_MAPPING_TABLE
    importing
      !IR_COLUMN_NAMES type ref to DATA
      !IR_COLUMN_TEXTS type ref to DATA
      !IR_COLUMN_TYPES type ref to DATA
      !IV_WORKSHEET_TITLE type Z2CA_WORKSHEET_TITLE
      !IV_USE_TYPES_OF_SHEET type ABAP_BOOL
      !IV_IGNORE_MISSING_TYPE type ABAP_BOOL
    raising
      ZCX_CA_SHEET_UNKNOWN_TYPE
      ZCX_CA_SHEET_CANNOT_IMPORTED
      ZCX_CA_TYPES_SHEET_NOT_EXISTS
      ZCX_EXCEL
      CX_SY_TABLE_CREATION
      CX_SY_STRUCT_CREATION
      CX_SY_CONVERSION_EXACT_NOT_SUP
      CX_SY_ITAB_DYN_LOOP
      ZCX_CA_WRONG_DATA_TYPE .
  methods _FILL_EXCEL_CONTENT
    importing
      !IV_WORKSHEET_INDEX type I
      !IO_WORKSHEET type ref to ZCL_EXCEL_WORKSHEET
      !IV_HEADER_ROW_COUNT type N
      !IV_DATE_CONV_RAISE_EXCEPTION type ABAP_BOOL
      !IV_USE_TYPES_OF_SHEET type ABAP_BOOL
      !IV_IGNORE_MISSING_TYPE type ABAP_BOOL
      !IV_USE_CONVERSION_EXIT type ABAP_BOOL
    raising
      ZCX_CA_SHEET_UNKNOWN_TYPE
      ZCX_CA_SHEET_CANNOT_IMPORTED
      ZCX_CA_TYPES_SHEET_NOT_EXISTS
      ZCX_EXCEL
      CX_SY_TABLE_CREATION
      CX_SY_STRUCT_CREATION
      CX_SY_CONVERSION_EXACT_NOT_SUP
      ZCX_CA_WRONG_DATA_TYPE
      CX_SY_CONVERSION_NO_DATE .
  methods _GET_SAP_COLUMN_NAME
    importing
      !IV_COLUMN_INDEX type I
    returning
      value(RV_SAP_COLUMN_NAME) type FIELDNAME .
  methods _CREATE_CONTENT_TABLE
    importing
      !IO_WORKSHEET type ref to ZCL_EXCEL_WORKSHEET
      !IV_STRING_ONLY type ABAP_BOOL
    returning
      value(RO_CONTENT_TABLE) type ref to CL_ABAP_TABLEDESCR
    raising
      ZCX_EXCEL
      CX_SY_TABLE_CREATION
      CX_SY_STRUCT_CREATION .
  methods _MEMORIZE_TYPES
    raising
      ZCX_CA_SHEET_CANNOT_IMPORTED
      ZCX_CA_SHEET_UNKNOWN_TYPE
      ZCX_CA_TYPES_SHEET_NOT_EXISTS
      ZCX_EXCEL
      CX_SY_TABLE_CREATION
      CX_SY_STRUCT_CREATION
      CX_SY_CONVERSION_EXACT_NOT_SUP
      ZCX_CA_WRONG_DATA_TYPE .
  methods _GET_FIELDNAME
    importing
      !IV_COLUMN_TEXT type STRING
    returning
      value(RV_FIELDNAME) type FIELDNAME
    raising
      ZCX_CA_SHEET_CANNOT_IMPORTED
      ZCX_CA_SHEET_UNKNOWN_TYPE
      ZCX_CA_TYPES_SHEET_NOT_EXISTS
      ZCX_EXCEL
      CX_SY_TABLE_CREATION
      CX_SY_STRUCT_CREATION
      CX_SY_ITAB_DYN_LOOP
      CX_SY_CONVERSION_EXACT_NOT_SUP
      ZCX_CA_WRONG_DATA_TYPE .
  methods _GET_ROLLNAME
    importing
      !IV_COLUMN_TEXT type STRING
    returning
      value(RV_ROLLNAME) type ROLLNAME
    raising
      ZCX_CA_SHEET_CANNOT_IMPORTED
      ZCX_CA_SHEET_UNKNOWN_TYPE
      ZCX_CA_TYPES_SHEET_NOT_EXISTS
      ZCX_EXCEL
      CX_SY_TABLE_CREATION
      CX_SY_STRUCT_CREATION
      CX_SY_ITAB_DYN_LOOP
      CX_SY_CONVERSION_EXACT_NOT_SUP
      ZCX_CA_WRONG_DATA_TYPE .
  methods _CONVERT_VALUES_WITH_CONVEXIT
    changing
      !CT_TABLE_DATA type ANY
    raising
      ZCX_CA_WRONG_DATA_TYPE .
  methods _ENABLE_MULTI_LANG
    changing
      !CT_TABLE type STANDARD TABLE .
ENDCLASS.



CLASS Z2CL_CA_EXCEL_IMPORT_TOOLS IMPLEMENTATION.


  METHOD constructor.
    mo_excel = NEW ycl_excel_reader_huge_file( )->zif_excel_reader~load_file( iv_filename ).
    mv_header_row_count = iv_header_row_count.
    mv_filename = iv_filename.
    mv_types = iv_types.
    mv_types_header_row_count = iv_types_header_row_count.
    _memorize_types( ).
  ENDMETHOD.


  METHOD convert_date_time_in_table.
    DATA lt_date_fieldnames TYPE TABLE OF fieldname.
    DATA lt_time_fieldnames TYPE TABLE OF fieldname.

    FIELD-SYMBOLS <lt_table_data_source> TYPE ANY TABLE.
    FIELD-SYMBOLS <lt_table_data_target> TYPE STANDARD TABLE.

    DATA(lt_components) = z2cl_ca_helper_tools=>get_components_by_data( ct_table_data_target ).

    LOOP AT lt_components REFERENCE INTO DATA(lr_component).
      CASE CAST cl_abap_elemdescr( lr_component->type )->type_kind.
        WHEN  cl_abap_typedescr=>typekind_date.
          APPEND lr_component->name TO lt_date_fieldnames.
        WHEN  cl_abap_typedescr=>typekind_time.
          APPEND lr_component->name TO lt_time_fieldnames.
      ENDCASE.
    ENDLOOP.

    IF lt_date_fieldnames IS NOT INITIAL OR lt_time_fieldnames IS NOT INITIAL.
      ASSIGN it_table_data_source TO <lt_table_data_source>.
      ASSIGN ct_table_data_target TO <lt_table_data_target>.

      LOOP AT <lt_table_data_source> ASSIGNING FIELD-SYMBOL(<ls_table_data_source>).
        APPEND INITIAL LINE TO <lt_table_data_target> ASSIGNING FIELD-SYMBOL(<ls_table_data_target>).
        <ls_table_data_target> = CORRESPONDING #( <ls_table_data_source> ).
        LOOP AT lt_date_fieldnames REFERENCE INTO DATA(lr_date_fieldname). "#EC CI_NESTED
          ASSIGN COMPONENT lr_date_fieldname->* OF STRUCTURE <ls_table_data_source> TO FIELD-SYMBOL(<lv_date_value_source>).
          IF <lv_date_value_source> IS NOT INITIAL.
            ASSIGN COMPONENT lr_date_fieldname->* OF STRUCTURE <ls_table_data_target> TO FIELD-SYMBOL(<lv_date_value_target>).
            TRY.
                <lv_date_value_target> = z2cl_ca_helper_tools=>convert_date_excel_ext_to_int( CONV #( <lv_date_value_source> ) ).
              CATCH cx_sy_conversion_no_date INTO DATA(lx_sy_conversion_no_date).
                IF iv_date_conv_raise_exception EQ abap_true.
                  RAISE EXCEPTION lx_sy_conversion_no_date.
                ENDIF.
            ENDTRY.
          ENDIF.
        ENDLOOP.

        LOOP AT lt_time_fieldnames REFERENCE INTO DATA(lr_time_fieldname). "#EC CI_NESTED
          ASSIGN COMPONENT lr_time_fieldname->* OF STRUCTURE <ls_table_data_source> TO FIELD-SYMBOL(<lv_time_value_source>).
          IF <lv_time_value_source> IS NOT INITIAL.
            ASSIGN COMPONENT lr_time_fieldname->* OF STRUCTURE <ls_table_data_target> TO FIELD-SYMBOL(<lv_time_value_target>).
            TRY.
                <lv_time_value_target> = zcl_excel_common=>excel_string_to_time( <lv_time_value_source> ).
              CATCH zcx_excel ##NO_HANDLER.
            ENDTRY.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ELSE.
      ct_table_data_target = CORRESPONDING #( it_table_data_source ).
    ENDIF.
  ENDMETHOD.


  METHOD get_column_count.
    DATA(lo_abap_tabledescr) = VALUE #( mt_excel_content[ worksheet_title = iv_worksheet_title ]-string_tabledescr OPTIONAL ). "#EC CI_STDSEQ
    IF lo_abap_tabledescr IS BOUND.
      rv_column_count = lines( CAST cl_abap_structdescr( lo_abap_tabledescr->get_table_line_type( ) )->get_components( ) ).
    ENDIF.
  ENDMETHOD.


  METHOD get_excel_with_header_by_index.
    DATA lr_table_content TYPE REF TO data.

    FIELD-SYMBOLS <lt_table_content> TYPE STANDARD TABLE.

    DATA(lo_abap_tabledescr) = VALUE #( mt_excel_content[ worksheet_index = iv_worksheet_index ]-string_tabledescr OPTIONAL ). "#EC CI_STDSEQ

    IF lo_abap_tabledescr IS BOUND.
      CREATE DATA lr_table_content TYPE HANDLE lo_abap_tabledescr.
      ASSIGN lr_table_content->* TO <lt_table_content>.

      DATA(lo_worksheet_source) = mo_excel->get_worksheet_by_index( iv_worksheet_index ).

      lo_worksheet_source->get_table(
        EXPORTING
          iv_max_row      = CONV #( mv_header_row_count )
        IMPORTING
          et_table        = <lt_table_content> ).
      DELETE <lt_table_content> FROM mv_header_row_count + 1.

      ro_excel = NEW #( ).
      DATA(lo_worksheet) = ro_excel->get_active_worksheet( ).

      lo_worksheet->set_table(
        EXPORTING
          ip_table           = <lt_table_content>
          ip_table_title     = lo_worksheet->get_title( )
          ip_top_left_column = 'A'
          ip_top_left_row    = 1 ).
    ENDIF.
  ENDMETHOD.


  METHOD get_excel_with_header_by_title.
    DATA(lo_worksheet_source) = mo_excel->get_worksheet_by_name( iv_worksheet_title ).

    ro_excel = NEW #( ).
    DATA(lo_worksheet) = ro_excel->get_active_worksheet( ).
    lo_worksheet->set_title( iv_worksheet_title ).
    LOOP AT lo_worksheet_source->sheet_content REFERENCE INTO DATA(lr_sheet_content)
         WHERE cell_row LE mv_header_row_count.         "#EC CI_SORTSEQ
      APPEND lr_sheet_content->* TO lo_worksheet->sheet_content. "#EC CI_APPEND_OK
      TRY.
          ro_excel->get_style_index_in_styles( lr_sheet_content->cell_style ).
        CATCH zcx_excel.
          DATA(lo_styles_iterator_source) = mo_excel->get_styles_iterator( ).
          WHILE lo_styles_iterator_source->has_next( ).  "#EC CI_NESTED
            DATA(lo_style_source) = CAST zcl_excel_style( lo_styles_iterator_source->get_next( ) ).
            IF lo_style_source->get_guid( ) EQ lr_sheet_content->cell_style.
              DATA(lo_style) = ro_excel->add_new_style( lr_sheet_content->cell_style ).
              lo_style->alignment = lo_style_source->alignment.
              lo_style->borders = lo_style_source->borders.
              lo_style->fill = lo_style_source->fill.
              lo_style->font = lo_style_source->font.
              lo_style->number_format = lo_style_source->number_format.
              lo_style->protection = lo_style_source->protection.
              EXIT.
            ENDIF.
          ENDWHILE.
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.


  METHOD get_filename.
    rv_filename = mv_filename.
  ENDMETHOD.


  METHOD check_columns_exists.
    DATA lv_field_count TYPE i.

    DATA(lo_tabledescr) = VALUE #( mt_excel_content[ worksheet_index = iv_worksheet_index ]-content_tabledescr OPTIONAL ).
    IF lo_tabledescr IS NOT BOUND.
      RAISE EXCEPTION NEW zcx_ca_sheet_index_not_exists( iv_worksheet_index ).
    ENDIF.
    DATA(lt_components) = get_sheetcomponents_by_index( iv_worksheet_index ).
    LOOP AT it_columns_to_check REFERENCE INTO DATA(lr_fieldname_to_check).
      IF line_exists( lt_components[ name = lr_fieldname_to_check->* ] ).
        lv_field_count += 1.
      ENDIF.
    ENDLOOP.
    DATA(lv_total_columns_to_check) = lines( it_columns_to_check ).
    IF lv_field_count LT lv_total_columns_to_check.
      RAISE EXCEPTION NEW zcx_ca_missing_column(
        textid                 = COND #( WHEN lv_total_columns_to_check - lv_field_count EQ 1
                                         THEN zcx_ca_missing_column=>zcx_ca_missing_column
                                         ELSE zcx_ca_missing_column=>zcx_ca_missing_columns )
        iv_worksheet           = VALUE #( mt_excel_content[ worksheet_index = iv_worksheet_index ]-worksheet_title OPTIONAL )
        iv_missing_colum_count = lv_total_columns_to_check - lv_field_count
        iv_total_colum_count   = lv_total_columns_to_check ).
    ENDIF.
  ENDMETHOD.


  METHOD memorize_types.
    IF NOT line_exists( mt_excel_content[ worksheet_title = iv_worksheet_title ] ). "#EC CI_STDSEQ
      mv_types = iv_worksheet_title.
      APPEND VALUE #( worksheet_title = iv_worksheet_title
                      worksheet_content = NEW z2ca_types_4_excel_sheets_t( it_types_4_excel_sheets ) )
             TO mt_excel_content.
    ENDIF.
  ENDMETHOD.


  METHOD get_new_table_by_title.
    IF line_exists( mt_excel_content[ worksheet_title = iv_worksheet_title ] ). "#EC CI_STDSEQ
      DATA(lo_abap_tabledescr) = mt_excel_content[ worksheet_title = iv_worksheet_title ]-content_tabledescr. "#EC CI_STDSEQ
      IF lo_abap_tabledescr IS NOT BOUND.
        RAISE EXCEPTION NEW zcx_ca_sheet_cannot_imported( iv_worksheet_title ).
      ENDIF.
      DATA(lt_components) = CAST cl_abap_structdescr( lo_abap_tabledescr->get_table_line_type( ) )->get_components( ).
      LOOP AT it_excel_insert_fields_begin REFERENCE INTO DATA(lr_excel_insert_fields_begin).
        DATA(lv_index_for_insert) = sy-tabix.
        INSERT VALUE #( name = lr_excel_insert_fields_begin->fieldname
                        type = CAST #( cl_abap_elemdescr=>describe_by_name( lr_excel_insert_fields_begin->rollname ) ) )
               INTO lt_components
               INDEX lv_index_for_insert.
      ENDLOOP.
      LOOP AT it_excel_additional_fields REFERENCE INTO DATA(lr_excel_additional_fields).
        APPEND VALUE #( name = lr_excel_additional_fields->fieldname
                        type = CAST #( cl_abap_elemdescr=>describe_by_name( lr_excel_additional_fields->rollname ) ) ) TO lt_components.
      ENDLOOP.
      DATA(lo_abap_structdescr) = cl_abap_structdescr=>create( lt_components ).
      IF lo_abap_structdescr IS BOUND.
        lo_abap_tabledescr = cl_abap_tabledescr=>create( lo_abap_structdescr ).
      ENDIF.
      IF lo_abap_tabledescr IS BOUND.
        CREATE DATA rr_sheet_content TYPE HANDLE lo_abap_tabledescr.
      ENDIF.
    ELSE.
      RAISE EXCEPTION NEW zcx_ca_sheet_not_exists( iv_worksheet_title ).
    ENDIF.
  ENDMETHOD.


  METHOD get_header_count_by_index.
    IF line_exists( mt_excel_content[ worksheet_index = iv_worksheet_index ] ). "#EC CI_STDSEQ
      rv_header_row_count = mt_excel_content[ worksheet_index = iv_worksheet_index ]-header_row_count. "#EC CI_STDSEQ
    ELSE.
      RAISE EXCEPTION NEW zcx_ca_sheet_index_not_exists( iv_worksheet_index ).
    ENDIF.
  ENDMETHOD.


  METHOD get_sap_column_name.
    rv_sap_column_name = z2cl_ca_excel_column_mapping=>get_instance( )->get_sap_column_name(
                           iv_filename = mv_filename
                           iv_worksheet_title = iv_worksheet_title
                           iv_excel_column_name = iv_excel_column_name ).
  ENDMETHOD.


  METHOD get_sheetcomponents_by_index.
    DATA(lo_abap_tabledescr) = VALUE #( mt_excel_content[ worksheet_index = iv_worksheet_index ]-string_tabledescr OPTIONAL ). "#EC CI_STDSEQ
    IF lo_abap_tabledescr IS BOUND.
      rt_components = CAST cl_abap_structdescr( lo_abap_tabledescr->get_table_line_type( ) )->get_components( ).
    ENDIF.
  ENDMETHOD.


  METHOD get_sheetcomponents_by_name.
    DATA(lo_abap_tabledescr) = VALUE #( mt_excel_content[ worksheet_title = iv_worksheet_title ]-string_tabledescr OPTIONAL ). "#EC CI_STDSEQ
    IF lo_abap_tabledescr IS BOUND.
      rt_components = CAST cl_abap_structdescr( lo_abap_tabledescr->get_table_line_type( ) )->get_components( ).
    ENDIF.
  ENDMETHOD.


  METHOD get_sheet_content_by_index.
    IF line_exists( mt_excel_content[ worksheet_index = iv_worksheet_index ] ). "#EC CI_STDSEQ
      rr_sheet_content = mt_excel_content[ worksheet_index = iv_worksheet_index ]-worksheet_content. "#EC CI_STDSEQ
      IF rr_sheet_content IS NOT BOUND.
        RAISE EXCEPTION NEW zcx_ca_sheet_cannot_imported( mt_excel_content[ worksheet_index = iv_worksheet_index ]-worksheet_title ). "#EC CI_STDSEQ
      ENDIF.
    ELSE.
      RAISE EXCEPTION NEW zcx_ca_sheet_index_not_exists( iv_worksheet_index ).
    ENDIF.
  ENDMETHOD.


  METHOD get_sheet_content_by_title.
    IF line_exists( mt_excel_content[ worksheet_title = iv_worksheet_title ] ). "#EC CI_STDSEQ
      rr_sheet_content = mt_excel_content[ worksheet_title = iv_worksheet_title ]-worksheet_content. "#EC CI_STDSEQ
      IF rr_sheet_content IS NOT BOUND.
        RAISE EXCEPTION NEW zcx_ca_sheet_cannot_imported( iv_worksheet_title ).
      ENDIF.
    ELSE.
      RAISE EXCEPTION NEW zcx_ca_sheet_not_exists( iv_worksheet_title ).
    ENDIF.
  ENDMETHOD.


  METHOD memorize_sheet.
    _memorize_types( ).

    IF NOT line_exists( mt_excel_content[ worksheet_title = iv_worksheet_title ] ). "#EC CI_STDSEQ
      DATA(lo_worksheet_iterator) = mo_excel->get_worksheets_iterator( ).
      WHILE lo_worksheet_iterator->has_next( ) EQ abap_true.
        DATA(lv_sheet_index) = sy-index.
        DATA(lo_worksheet) = CAST zcl_excel_worksheet( lo_worksheet_iterator->get_next( ) ).
        IF lo_worksheet->get_title( ) EQ iv_worksheet_title.
          _fill_excel_content( iv_worksheet_index           = lv_sheet_index
                               io_worksheet                 = lo_worksheet
                               iv_header_row_count          = COND #( WHEN iv_header_row_count IS NOT SUPPLIED
                                                                      THEN mv_header_row_count
                                                                      ELSE iv_header_row_count )
                               iv_date_conv_raise_exception = iv_date_conv_raise_exception
                               iv_use_types_of_sheet        = iv_use_types_of_sheet
                               iv_ignore_missing_type       = iv_ignore_missing_type
                               iv_use_conversion_exit       = iv_use_conversion_exit ).
          DATA(lv_worksheet_exists) = abap_true.
          EXIT.
        ENDIF.
      ENDWHILE.
      IF lv_worksheet_exists EQ abap_false.
        RAISE EXCEPTION NEW zcx_ca_sheet_not_exists( iv_worksheet_title ).
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD memorize_sheets.
    DATA(lo_worksheet_iterator) = mo_excel->get_worksheets_iterator( ).
    WHILE lo_worksheet_iterator->has_next( ) EQ abap_true.
      DATA(lv_sheet_index) = sy-index.
      DATA(lo_worksheet) = CAST zcl_excel_worksheet( lo_worksheet_iterator->get_next( ) ).
      _fill_excel_content( iv_worksheet_index           = lv_sheet_index
                           io_worksheet                 = lo_worksheet
                           iv_header_row_count          = mv_header_row_count
                           iv_date_conv_raise_exception = iv_date_conv_raise_exception
                           iv_use_types_of_sheet        = iv_use_types_of_sheet
                           iv_ignore_missing_type       = iv_ignore_missing_type
                           iv_use_conversion_exit       = iv_use_conversion_exit ).
    ENDWHILE.
  ENDMETHOD.


  METHOD get_worksheet_title.
    rv_worksheet_title = mo_excel->get_worksheet_by_index( iv_worksheet_index )->get_title( ).
  ENDMETHOD.


  METHOD save_excel_file.
    CONSTANTS co_access_denied TYPE string VALUE 1.

    DATA lv_filename TYPE string.
    DATA lv_path TYPE string.
    DATA lv_fullpath TYPE string.
    DATA lv_answer TYPE char1.

    TRY.
        DATA(lo_excel_writer) = CAST zif_excel_writer( NEW zcl_excel_writer_2007( ) ).

        DATA(lv_xdata) = lo_excel_writer->write_file( io_excel ).
        DATA(lt_rawdata) = cl_bcs_convert=>xstring_to_solix( iv_xstring = lv_xdata ).
        DATA(lv_bytecount) = xstrlen( lv_xdata ).

        IF iv_filename IS NOT INITIAL.
          lv_filename = iv_filename.
        ELSE.
          cl_gui_frontend_services=>file_save_dialog(
            EXPORTING
              file_filter               = cl_gui_frontend_services=>filetype_excel
            CHANGING
              filename                  = lv_filename
              path                      = lv_path
              fullpath                  = lv_fullpath ).
        ENDIF.
        IF lv_filename IS NOT INITIAL.
          DO.
            cl_gui_frontend_services=>gui_download(
              EXPORTING
                bin_filesize  = lv_bytecount
                filename      = lv_filename
                filetype      ='BIN'
              CHANGING
                data_tab      = lt_rawdata
              EXCEPTIONS
                access_denied = co_access_denied
                OTHERS        = 2 ).
            IF sy-subrc EQ 0.
              EXIT.
            ELSEIF sy-subrc EQ co_access_denied.
              MESSAGE e100 WITH lv_filename INTO DATA(lv_message).
              CALL FUNCTION 'POPUP_TO_CONFIRM'
                EXPORTING
                  text_question = lv_message
                IMPORTING
                  answer        = lv_answer.
              IF lv_answer EQ '1'.
                CONTINUE.
              ELSE.
                EXIT.
              ENDIF.
            ELSE.
              RAISE EXCEPTION NEW zcx_ca_file_not_saved( lv_filename ).
            ENDIF.
          ENDDO.
        ENDIF.
      CATCH zcx_excel ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.


  METHOD sheet_exists.
    rv_sheet_exists = xsdbool( mo_excel->get_worksheet_by_name( iv_worksheet_title ) IS BOUND ).
  ENDMETHOD.


  METHOD _create_content_table.
    DATA(lt_mapping) = z2cl_ca_excel_column_mapping=>get_instance( )->get_sheet_column_mapping(
                         iv_filename    = mv_filename
                         iv_worksheet_title = CONV #( io_worksheet->get_title( ) ) ).
    IF iv_string_only EQ abap_true.
      DATA(lt_components) = CORRESPONDING abap_component_tab( lt_mapping MAPPING name = column_name_sap
                                                                                 type = column_type_string ).
    ELSE.
      lt_components = CORRESPONDING abap_component_tab( lt_mapping MAPPING name = column_name_sap
                                                                           type = column_type_sap ).
    ENDIF.
    DATA(lo_abap_structdescr) = cl_abap_structdescr=>create( lt_components ).
    ro_content_table = cl_abap_tabledescr=>create( lo_abap_structdescr ).
  ENDMETHOD.


  METHOD _determine_mapping.
    DATA lr_table_content TYPE REF TO data.

    FIELD-SYMBOLS <lt_sheet_content> TYPE STANDARD TABLE.

    DATA(lo_tabledescr_for_header) = _get_tabledescr_for_header( io_worksheet ).

    IF lo_tabledescr_for_header IS BOUND.
      CREATE DATA lr_table_content TYPE HANDLE lo_tabledescr_for_header.
      ASSIGN lr_table_content->* TO <lt_sheet_content>.
      IF <lt_sheet_content> IS ASSIGNED.
        io_worksheet->get_table(
          EXPORTING
            iv_max_row      = CONV #( iv_header_row_count )
          IMPORTING
            et_table        = <lt_sheet_content> ).
        IF <lt_sheet_content> IS NOT INITIAL.

          _enable_multi_lang( CHANGING ct_table = <lt_sheet_content> ).

          ASSIGN <lt_sheet_content>[ 1 ] TO FIELD-SYMBOL(<ls_column_texts>).
          ASSIGN <lt_sheet_content>[ 2 ] TO FIELD-SYMBOL(<ls_column_names>).
          ASSIGN <lt_sheet_content>[ 3 ] TO FIELD-SYMBOL(<ls_column_types>).
          _fill_mapping_table( ir_column_names = COND #( WHEN <ls_column_names> IS ASSIGNED
                                                         THEN REF #( <ls_column_names> ) )
                               ir_column_texts = COND #( WHEN <ls_column_texts> IS ASSIGNED
                                                         THEN REF #( <ls_column_texts> ) )
                               ir_column_types = COND #( WHEN <ls_column_types> IS ASSIGNED
                                                         THEN REF #( <ls_column_types> ) )
                               iv_worksheet_title = CONV #( io_worksheet->get_title( ) )
                               iv_use_types_of_sheet = iv_use_types_of_sheet
                               iv_ignore_missing_type = iv_ignore_missing_type ).
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD _fill_excel_content.
    FIELD-SYMBOLS <lt_table_content> TYPE STANDARD TABLE.
    FIELD-SYMBOLS <lt_table_content_string> TYPE STANDARD TABLE.

    _determine_mapping( io_worksheet = io_worksheet
                        iv_header_row_count = iv_header_row_count
                        iv_use_types_of_sheet = iv_use_types_of_sheet
                        iv_ignore_missing_type = iv_ignore_missing_type ).

    DATA(lo_content_tabledescr) = _create_content_table( io_worksheet = io_worksheet
                                                         iv_string_only = abap_false ).

    DATA(lo_content_string_tabledescr) = _create_content_table( io_worksheet = io_worksheet
                                                                iv_string_only = abap_true ).

    APPEND VALUE #( worksheet_index = iv_worksheet_index
                    worksheet_title = io_worksheet->get_title( )
                    header_row_count = iv_header_row_count
                    worksheet_content_string = _get_table_content( io_worksheet = io_worksheet
                                                                   io_abap_tabledescr = lo_content_string_tabledescr
                                                                   iv_header_row_count = iv_header_row_count )
                    content_tabledescr   = lo_content_tabledescr
                    string_tabledescr    = lo_content_string_tabledescr )
           TO mt_excel_content
           ASSIGNING FIELD-SYMBOL(<ls_excel_content>).
    IF lo_content_tabledescr IS BOUND.
      CREATE DATA <ls_excel_content>-worksheet_content TYPE HANDLE lo_content_tabledescr.
      ASSIGN <ls_excel_content>-worksheet_content->* TO <lt_table_content>.
      ASSIGN <ls_excel_content>-worksheet_content_string->* TO <lt_table_content_string>.
      IF <lt_table_content> IS ASSIGNED AND <lt_table_content_string> IS ASSIGNED.
        convert_date_time_in_table(
          EXPORTING
            it_table_data_source         = <lt_table_content_string>
            iv_date_conv_raise_exception = iv_date_conv_raise_exception
          CHANGING
            ct_table_data_target = <lt_table_content> ).
        IF iv_use_conversion_exit EQ abap_true.
          _convert_values_with_convexit(
            CHANGING
            ct_table_data = <lt_table_content> ).
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD _fill_mapping_table.
    DATA(lo_column_mapping) = z2cl_ca_excel_column_mapping=>get_instance( ).
    IF ir_column_texts IS BOUND.
      ASSIGN ir_column_texts->* TO FIELD-SYMBOL(<ls_column_texts>).
    ENDIF.
    IF iv_use_types_of_sheet EQ abap_true AND ir_column_names IS BOUND.
      ASSIGN ir_column_names->* TO FIELD-SYMBOL(<ls_column_names>).
    ENDIF.
    IF iv_use_types_of_sheet EQ abap_true AND ir_column_types IS BOUND.
      ASSIGN ir_column_types->* TO FIELD-SYMBOL(<ls_column_types>).
    ENDIF.
    IF <ls_column_texts> IS NOT ASSIGNED AND <ls_column_names> IS NOT ASSIGNED AND
        <ls_column_types> IS NOT ASSIGNED.
      RETURN.
    ENDIF.
    DO.
      DATA(lv_column_count) = sy-index.
      IF <ls_column_texts> IS ASSIGNED.
        ASSIGN COMPONENT sy-index OF STRUCTURE <ls_column_texts>
               TO FIELD-SYMBOL(<lv_column_text>)." CASTING TYPE string.
      ENDIF.
      IF sy-subrc NE 0.
        EXIT.
      ENDIF.

      IF iv_use_types_of_sheet EQ abap_true.
        IF <ls_column_names> IS ASSIGNED.
          ASSIGN COMPONENT sy-index OF STRUCTURE <ls_column_names>
                 TO FIELD-SYMBOL(<lv_column_name>)." CASTING TYPE string.
        ENDIF.
        IF <ls_column_types> IS ASSIGNED.
          ASSIGN COMPONENT sy-index OF STRUCTURE <ls_column_types>
                 TO FIELD-SYMBOL(<lv_column_type>)." CASTING TYPE string.
        ENDIF.
      ENDIF.

      DATA(lv_column_name_sap) = COND fieldname( WHEN <lv_column_name> IS ASSIGNED
                                                 THEN EXACT #( <lv_column_name> )
                                                 ELSE _get_fieldname( <lv_column_text> ) ).
      DATA(lv_column_type_sap) = COND rollname( WHEN <lv_column_type> IS ASSIGNED
                                                THEN EXACT #( <lv_column_type> )
                                                ELSE _get_rollname( <lv_column_text> ) ).
      IF lv_column_name_sap IS INITIAL OR lv_column_type_sap IS INITIAL.
        IF iv_ignore_missing_type EQ abap_true.
          lv_column_name_sap = _get_sap_column_name( lv_column_count ).
          lv_column_type_sap = co_default_excel_column_type.
        ELSE.
          RAISE EXCEPTION NEW zcx_ca_sheet_unknown_type(
              iv_worksheet = iv_worksheet_title
              iv_type      = |{ <lv_column_text> }| ).
        ENDIF.
      ENDIF.
      lo_column_mapping->add_mapping(
          iv_filename = mv_filename
          iv_worksheet_title = iv_worksheet_title
          iv_column_text_excel = COND #( WHEN <lv_column_text> IS ASSIGNED
                                         THEN <lv_column_text> )
          iv_column_name_sap = lv_column_name_sap
          iv_column_type_sap = lv_column_type_sap ).
    ENDDO.
  ENDMETHOD.


  METHOD _get_fieldname.
    FIELD-SYMBOLS <lt_types> TYPE STANDARD TABLE.

    _memorize_types( ).
    DATA(lr_types) = VALUE #( mt_excel_content[ worksheet_title = mv_types ]-worksheet_content OPTIONAL ). "#EC CI_STDSEQ
    IF lr_types IS BOUND.
      ASSIGN lr_types->* TO <lt_types>.
      DATA(lv_where) = |HEADER EQ '{ iv_column_text }'|.
      LOOP AT <lt_types> ASSIGNING FIELD-SYMBOL(<ls_type>) WHERE (lv_where).
        ASSIGN COMPONENT 'FIELDNAME' OF STRUCTURE <ls_type> TO FIELD-SYMBOL(<lv_fieldname>).
        IF sy-subrc EQ 0.
          rv_fieldname = EXACT #( <lv_fieldname> ).
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD _get_sap_column_name.
    rv_sap_column_name = |{ co_sap_column_name }{ CONV numc5( iv_column_index ) }|.
  ENDMETHOD.


  METHOD _get_tabledescr_for_header.
    DATA lt_components TYPE abap_component_tab.

    DATA(lo_abap_elemdescr_string) = cl_abap_elemdescr=>get_string( ).
    DO io_worksheet->get_highest_column( ) TIMES.
      APPEND VALUE #( name = _get_sap_column_name( iv_column_index = sy-index )
                      type = lo_abap_elemdescr_string ) TO lt_components.
    ENDDO.
    DATA(lo_abap_structdescr) = cl_abap_structdescr=>create( lt_components ).
    ro_content_table = cl_abap_tabledescr=>create( lo_abap_structdescr ).
  ENDMETHOD.


  METHOD _get_table_content.
    FIELD-SYMBOLS <lt_sheet_content> TYPE STANDARD TABLE.

    IF io_abap_tabledescr IS BOUND.
      CREATE DATA rr_table_content TYPE HANDLE io_abap_tabledescr.
      ASSIGN rr_table_content->* TO <lt_sheet_content>.
      IF <lt_sheet_content> IS ASSIGNED.
        io_worksheet->get_table(
          EXPORTING
            iv_skipped_rows = CONV #( iv_header_row_count )
          IMPORTING
            et_table        = <lt_sheet_content> ).
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD _memorize_types.
    IF mv_types IS NOT INITIAL AND
       NOT line_exists( mt_excel_content[ worksheet_title = mv_types ] ). "#EC CI_STDSEQ
      DATA(lo_worksheet_iterator) = mo_excel->get_worksheets_iterator( ).
      WHILE lo_worksheet_iterator->has_next( ) EQ abap_true.
        DATA(lv_sheet_index) = sy-index.
        DATA(lo_worksheet) = CAST zcl_excel_worksheet( lo_worksheet_iterator->get_next( ) ).
        IF lo_worksheet->get_title( ) EQ mv_types.
          _fill_excel_content( iv_worksheet_index           = lv_sheet_index
                               io_worksheet                 = lo_worksheet
                               iv_header_row_count          = mv_types_header_row_count
                               iv_date_conv_raise_exception = abap_false
                               iv_use_types_of_sheet        = abap_true
                               iv_ignore_missing_type       = abap_false
                               iv_use_conversion_exit       = abap_false ).
          DATA(lv_worksheet_exists) = abap_true.
          EXIT.
        ENDIF.
      ENDWHILE.
      IF lv_worksheet_exists EQ abap_false.
        RAISE EXCEPTION NEW zcx_ca_types_sheet_not_exists( mv_types ).
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD get_new_table_by_reference.
    IF ir_data IS BOUND.
      DATA(lt_components) = z2cl_ca_helper_tools=>get_components_by_data_ref( ir_data ).
      LOOP AT it_excel_insert_fields_begin REFERENCE INTO DATA(lr_excel_insert_fields_begin).
        DATA(lv_index_for_insert) = sy-tabix.
        INSERT VALUE #( name = lr_excel_insert_fields_begin->fieldname
                        type = CAST #( cl_abap_elemdescr=>describe_by_name( lr_excel_insert_fields_begin->rollname ) ) )
               INTO lt_components
               INDEX lv_index_for_insert.
      ENDLOOP.
      LOOP AT it_excel_additional_fields REFERENCE INTO DATA(lr_excel_additional_fields).
        APPEND VALUE #( name = lr_excel_additional_fields->fieldname
                        type = CAST #( cl_abap_elemdescr=>describe_by_name( lr_excel_additional_fields->rollname ) ) ) TO lt_components.
      ENDLOOP.
      DATA(lo_abap_structdescr) = cl_abap_structdescr=>create( lt_components ).
      IF lo_abap_structdescr IS BOUND.
        DATA(lo_abap_tabledescr) = cl_abap_tabledescr=>create( lo_abap_structdescr ).
      ENDIF.
      IF lo_abap_tabledescr IS BOUND.
        CREATE DATA rr_sheet_content TYPE HANDLE lo_abap_tabledescr.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD get_header_count_by_title.
    IF line_exists( mt_excel_content[ worksheet_title = iv_worksheet_title ] ). "#EC CI_STDSEQ
      rv_header_row_count = mt_excel_content[ worksheet_title = iv_worksheet_title ]-header_row_count. "#EC CI_STDSEQ
    ELSE.
      RAISE EXCEPTION NEW zcx_ca_sheet_not_exists( iv_worksheet_title ).
    ENDIF.
    rv_header_row_count = mv_header_row_count.
  ENDMETHOD.


  METHOD _convert_values_with_convexit.
    DATA lt_conversion_exit_fields TYPE ddfields.
    FIELD-SYMBOLS <lt_table_data> TYPE STANDARD TABLE.

    DATA(lt_components) = z2cl_ca_helper_tools=>get_components_by_data( ct_table_data ).

    LOOP AT lt_components REFERENCE INTO DATA(lr_component).
      IF CAST cl_abap_elemdescr( lr_component->type )->is_ddic_type( ) AND
         CAST cl_abap_elemdescr( lr_component->type )->get_ddic_field( )-convexit IS NOT INITIAL.
        APPEND VALUE #( BASE CORRESPONDING #( CAST cl_abap_elemdescr( lr_component->type )->get_ddic_field( ) )
                        fieldname = lr_component->name ) TO lt_conversion_exit_fields.
      ENDIF.
    ENDLOOP.

    IF lt_conversion_exit_fields IS NOT INITIAL.
      ASSIGN ct_table_data TO <lt_table_data>.
      LOOP AT <lt_table_data> ASSIGNING FIELD-SYMBOL(<ls_table_data>).
        LOOP AT lt_conversion_exit_fields REFERENCE INTO DATA(lr_date_fieldname). "#EC CI_NESTED
          ASSIGN COMPONENT lr_date_fieldname->fieldname OF STRUCTURE <ls_table_data> TO FIELD-SYMBOL(<lv_value>).
          IF sy-subrc EQ 0.
            DATA(lv_conversion_exit_function) = |CONVERSION_EXIT_{ lr_date_fieldname->convexit }_INPUT|.
            CALL FUNCTION lv_conversion_exit_function
              EXPORTING
                input  = <lv_value>
              IMPORTING
                output = <lv_value>.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD get_new_table_by_index.
    IF line_exists( mt_excel_content[ worksheet_index = iv_worksheet_index ] ). "#EC CI_STDSEQ
      DATA(lo_abap_tabledescr) = mt_excel_content[ worksheet_index = iv_worksheet_index ]-content_tabledescr. "#EC CI_STDSEQ
      IF lo_abap_tabledescr IS NOT BOUND.
        RAISE EXCEPTION NEW zcx_ca_sheet_cannot_imported( mt_excel_content[ worksheet_index = iv_worksheet_index ]-worksheet_title ). "#EC CI_STDSEQ
      ENDIF.
      DATA(lt_components) = CAST cl_abap_structdescr( lo_abap_tabledescr->get_table_line_type( ) )->get_components( ).
      LOOP AT it_excel_insert_fields_begin REFERENCE INTO DATA(lr_excel_insert_fields_begin).
        DATA(lv_index_for_insert) = sy-tabix.
        INSERT VALUE #( name = lr_excel_insert_fields_begin->fieldname
                        type = CAST #( cl_abap_elemdescr=>describe_by_name( lr_excel_insert_fields_begin->rollname ) ) )
               INTO lt_components
               INDEX lv_index_for_insert.
      ENDLOOP.
      LOOP AT it_excel_additional_fields REFERENCE INTO DATA(lr_excel_additional_fields).
        APPEND VALUE #( name = lr_excel_additional_fields->fieldname
                        type = CAST #( cl_abap_elemdescr=>describe_by_name( lr_excel_additional_fields->rollname ) ) ) TO lt_components.
      ENDLOOP.
      DATA(lo_abap_structdescr) = cl_abap_structdescr=>create( lt_components ).
      IF lo_abap_structdescr IS BOUND.
        lo_abap_tabledescr = cl_abap_tabledescr=>create( lo_abap_structdescr ).
      ENDIF.
      IF lo_abap_tabledescr IS BOUND.
        CREATE DATA rr_sheet_content TYPE HANDLE lo_abap_tabledescr.
      ENDIF.
    ELSE.
      RAISE EXCEPTION NEW zcx_ca_sheet_index_not_exists( iv_worksheet_index ).
    ENDIF.
  ENDMETHOD.


  METHOD _get_rollname.
    FIELD-SYMBOLS:
      <lt_types> TYPE STANDARD TABLE.

    _memorize_types( ).
    DATA(lr_types) = VALUE #( mt_excel_content[ worksheet_title = mv_types ]-worksheet_content OPTIONAL ). "#EC CI_STDSEQ
    IF lr_types IS BOUND.
      ASSIGN lr_types->* TO <lt_types>.
      DATA(lv_where) = |HEADER EQ '{ iv_column_text }'|.
      LOOP AT <lt_types> ASSIGNING FIELD-SYMBOL(<ls_type>) WHERE (lv_where).
        ASSIGN COMPONENT 'ROLLNAME' OF STRUCTURE <ls_type> TO FIELD-SYMBOL(<lv_rollname>).
        IF sy-subrc EQ 0.
          rv_rollname = EXACT #( <lv_rollname> ).
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD _enable_multi_lang.
    ASSIGN ct_table[ 1 ] TO FIELD-SYMBOL(<ls_column_texts>).

    LOOP AT ct_table ASSIGNING FIELD-SYMBOL(<ls_table>).
      DO.
        DATA(lv_column_count) = sy-index.
        IF <ls_column_texts> IS ASSIGNED.
          ASSIGN COMPONENT sy-index OF STRUCTURE <ls_column_texts>
                 TO FIELD-SYMBOL(<lv_column_text>).
        ENDIF.
        IF sy-subrc NE 0.
          EXIT.
        ENDIF.


        CASE sy-cprog.
          WHEN 'Z2SD_PRICE_IMPORT_NEW'.
            <lv_column_text> = COND #( WHEN <lv_column_text> = 'Condition Type'        THEN 'Konditionsart'
                                       WHEN <lv_column_text> = 'Sales Organization'    THEN 'Verkaufsorganisation'
                                       WHEN <lv_column_text> = 'Distribution Channel'  THEN 'Vertriebsweg'
                                       WHEN <lv_column_text> = 'Division'              THEN 'Sparte'
                                       WHEN <lv_column_text> = 'Alpha Cust.'           THEN 'Alpha Kd.'
                                       WHEN <lv_column_text> = 'SAP Cust.'             THEN 'SAP Kd.'
                                       WHEN <lv_column_text> = 'Material (Alpha)'      THEN 'Material (Alpha)'
                                       WHEN <lv_column_text> = 'Material (SAP)'        THEN 'Material (SAP)'
                                       WHEN <lv_column_text> = 'Valid From'            THEN 'Gültig-Von'
                                       WHEN <lv_column_text> = 'Valid To'              THEN 'Gültig-Bis'
                                       WHEN <lv_column_text> = 'Amount'                THEN 'Betrag'
                                       WHEN <lv_column_text> = 'Condition Currency'    THEN 'Währung'
                                       WHEN <lv_column_text> = 'Pricing Unit'          THEN 'pro'
                                       WHEN <lv_column_text> = 'Unit of Measure'       THEN 'Einheit'
                                       ELSE <lv_column_text> ).
          WHEN 'Z2SD_DELETE_CONDITION'.
            <lv_column_text> = COND #( WHEN <lv_column_text> = 'Condition Type'        THEN 'Konditionsart'
                                       WHEN <lv_column_text> = 'Sales organization'    THEN 'Verkaufsorg.'
                                       WHEN <lv_column_text> = 'Sales Organization'    THEN 'Verkaufsorg.'
                                       WHEN <lv_column_text> = 'Distribution Channel'  THEN 'Vertriebsweg'
                                       WHEN <lv_column_text> = 'Division'              THEN 'Sparte'
                                       WHEN <lv_column_text> = 'Alpha Cust.'           THEN 'Alpha Kd.'
                                       WHEN <lv_column_text> = 'Customer'              THEN 'Kunde'
                                       WHEN <lv_column_text> = 'Material (Alpha)'      THEN 'Material (Alpha)'
                                       WHEN <lv_column_text> = 'Material (SAP)'        THEN 'Material'
                                       WHEN <lv_column_text> = 'Material'              THEN 'Material'
                                       WHEN <lv_column_text> = 'Valid From'            THEN 'Gültig-Von'
                                       WHEN <lv_column_text> = 'Valid To'              THEN 'Gültig-Bis'
                                       WHEN <lv_column_text> = 'Amount'                THEN 'Betrag'
                                       WHEN <lv_column_text> = 'Condition Currency'    THEN 'Währung'
                                       WHEN <lv_column_text> = 'Pricing Unit'          THEN 'pro'
                                       WHEN <lv_column_text> = 'Unit of Measure'       THEN 'Einheit'
                                       ELSE <lv_column_text> ).
        ENDCASE.
      ENDDO.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
