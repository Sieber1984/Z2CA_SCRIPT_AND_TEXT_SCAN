CLASS z2cl_ca_excel_column_mapping DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS:
      get_instance
        RETURNING
          VALUE(ro_instance) TYPE REF TO z2cl_ca_excel_column_mapping.

    METHODS:
      add_mapping
        IMPORTING
          iv_filename          TYPE text1024
          iv_worksheet_title   TYPE z2ca_worksheet_title
          iv_column_text_excel TYPE text1024
          iv_column_name_sap   TYPE fieldname
          iv_column_type_sap   TYPE rollname
        RAISING
          zcx_ca_sheet_unknown_type,

      get_sap_column_name
        IMPORTING
          iv_filename               TYPE text1024
          iv_worksheet_title        TYPE z2ca_worksheet_title
          iv_excel_column_name      TYPE text1024
        RETURNING
          VALUE(rv_sap_column_name) TYPE fieldname,

      get_sheet_column_mapping
        IMPORTING
          iv_filename                    TYPE text1024
          iv_worksheet_title             TYPE z2ca_worksheet_title
        RETURNING
          VALUE(rt_sheet_column_mapping) TYPE z2ca_column_mapping_t.

  PRIVATE SECTION.
    CLASS-DATA go_instance TYPE REF TO z2cl_ca_excel_column_mapping.

    DATA mt_column_mapping TYPE z2ca_column_mapping_t.

    METHODS:
      constructor.

ENDCLASS.



CLASS Z2CL_CA_EXCEL_COLUMN_MAPPING IMPLEMENTATION.


  METHOD constructor.
    go_instance = me.
  ENDMETHOD.


  METHOD get_instance.
    ro_instance = COND #( WHEN go_instance IS BOUND
                          THEN go_instance
                          ELSE NEW #( ) ).
  ENDMETHOD.


  METHOD add_mapping.
    IF NOT line_exists( mt_column_mapping[ filename = iv_filename
                                           worksheet_title = iv_worksheet_title
                                           column_text_excel = iv_column_text_excel ] ). "#EC CI_STDSEQ
      cl_abap_elemdescr=>describe_by_name(
        EXPORTING
          p_name = iv_column_type_sap
        RECEIVING
          p_descr_ref = DATA(lo_abap_typedexr)
        EXCEPTIONS
          type_not_found = 1
          OTHERS         = 2 ).

      IF sy-subrc NE 0 OR lo_abap_typedexr IS NOT INSTANCE OF cl_abap_elemdescr.
        RAISE EXCEPTION NEW zcx_ca_sheet_unknown_type(
            iv_worksheet = iv_worksheet_title
            iv_type      = |{ iv_column_type_sap } ({ iv_column_text_excel })| ).
      ENDIF.
      APPEND VALUE #( filename = iv_filename
                      worksheet_title = iv_worksheet_title
                      column_text_excel = iv_column_text_excel
                      column_name_sap = iv_column_name_sap
                      column_datatype = COND #( WHEN lo_abap_typedexr IS INSTANCE OF cl_abap_elemdescr
                                                THEN CAST cl_abap_elemdescr( lo_abap_typedexr )->get_ddic_field( )-datatype )
                      column_type_sap = CAST #( lo_abap_typedexr )
                      column_type_string = cl_abap_elemdescr=>get_string( ) )
             TO mt_column_mapping.
    ENDIF.
  ENDMETHOD.


  METHOD get_sap_column_name.
    rv_sap_column_name = VALUE #( mt_column_mapping[ filename = iv_filename
                                                     worksheet_title = iv_worksheet_title
                                                     column_text_excel = iv_excel_column_name ]-column_name_sap OPTIONAL ). "#EC CI_STDSEQ
  ENDMETHOD.


  METHOD get_sheet_column_mapping.
    rt_sheet_column_mapping = VALUE #( FOR ls_column_mapping IN mt_column_mapping
                                       WHERE ( filename = iv_filename AND
                                               worksheet_title = iv_worksheet_title )
                                       ( ls_column_mapping ) ). "#EC CI_STDSEQ
  ENDMETHOD.
ENDCLASS.
