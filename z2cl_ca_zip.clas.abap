CLASS z2cl_ca_zip DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    "! <p class="shorttext synchronized">Get instance by key</p>
    "!
    "! @parameter iv_filename | <p class="shorttext synchronized">Filename</p>
    "! @parameter ro_instance         | <p class="shorttext synchronized">Instance</p>
    CLASS-METHODS get_instance
      IMPORTING
        iv_filename        TYPE z2ca_filename
      RETURNING
        VALUE(ro_instance) TYPE REF TO z2cl_ca_zip
      RAISING
        cx_sy_file_open
        zcx_ca_file_not_exists
        zcx_ca_zip_file_error.

    "! <p class="shorttext synchronized">Free instance by material number</p>
    "!
    "! @parameter iv_filename | <p class="shorttext synchronized">Filename</p>
    CLASS-METHODS free_instance
      IMPORTING
        iv_filename TYPE z2ca_filename.

    "! <p class="shorttext synchronized">Free all instances</p>
    "!
    CLASS-METHODS free_instances.

    "! <p class="shorttext synchronized">Has instance</p>
    "!
    "! @parameter iv_filename | <p class="shorttext synchronized">Filename</p>
    CLASS-METHODS has_instance
      IMPORTING
        iv_filename            TYPE z2ca_filename
      RETURNING
        VALUE(rv_has_instance) TYPE abap_bool.

    "! <p class="shorttext synchronized">Has instances</p>
    "!
    CLASS-METHODS has_instances
      RETURNING
        VALUE(rv_has_instances) TYPE abap_bool.

    "! <p class="shorttext synchronized">Free all instance data</p>
    "!
    METHODS free.

    METHODS get_file_content_by_index
      IMPORTING
        iv_index               TYPE i
      RETURNING
        VALUE(rv_file_content) TYPE xstring
      RAISING
        zcx_ca_zip_index_error
        zcx_ca_zip_decompression_error.

  PROTECTED SECTION.

  PRIVATE SECTION.
    TYPES:
      "! <p class="shorttext synchronized">Instance</p>
      BEGIN OF ty_instances,
        filename TYPE z2ca_filename,
        instance TYPE REF TO z2cl_ca_zip,
      END OF ty_instances.

    "! <p class="shorttext synchronized">Instances</p>
    TYPES  tty_instances TYPE STANDARD TABLE OF ty_instances.

    "! <p class="shorttext synchronized">Collection of instances</p>
    CLASS-DATA gt_instances TYPE tty_instances.

    DATA mo_abap_zip TYPE REF TO cl_abap_zip.

    DATA mv_filename type z2ca_filename.

    "! <p class="shorttext synchronized">Constructor</p>
    "!
    "! @parameter iv_filename | <p class="shorttext synchronized">Filename</p>
    METHODS constructor
      IMPORTING
        iv_filename TYPE z2ca_filename
      RAISING
        cx_sy_file_open
        zcx_ca_file_not_exists
        zcx_ca_zip_file_error.

    "! <p class="shorttext synchronized">Free instance by material number</p>
    "!
    "! @parameter iv_filename | <p class="shorttext synchronized">Filename</p>
    CLASS-METHODS _free_instance
      IMPORTING
        iv_filename TYPE z2ca_filename.

    METHODS _determine_zip_file_content
      IMPORTING
        iv_filename TYPE z2ca_filename
      RAISING
        cx_sy_file_open
        zcx_ca_file_not_exists
        zcx_ca_zip_file_error.

ENDCLASS.



CLASS z2cl_ca_zip IMPLEMENTATION.
  METHOD constructor.
    _determine_zip_file_content( iv_filename = iv_filename ).
    mv_filename = iv_filename.
  ENDMETHOD.

  METHOD  get_instance.
    ro_instance = COND #( WHEN line_exists( gt_instances[ filename = iv_filename ] ) "#EC CI_STDSEQ
                          THEN gt_instances[ filename = iv_filename ]-instance "#EC CI_STDSEQ
                          ELSE NEW #( iv_filename ) ).
  ENDMETHOD.

  METHOD free_instance.
    _free_instance( iv_filename ).
  ENDMETHOD.

  METHOD free_instances.
    LOOP AT gt_instances REFERENCE INTO DATA(lr_instance).
      _free_instance( lr_instance->filename ).
    ENDLOOP.
    FREE gt_instances.
  ENDMETHOD.

  METHOD has_instance.
    rv_has_instance = xsdbool( line_exists( gt_instances[ filename = iv_filename ] ) ).
  ENDMETHOD.

  METHOD has_instances.
    rv_has_instances = xsdbool( gt_instances IS NOT INITIAL ).
  ENDMETHOD.

  METHOD free.
    CLEAR mv_filename.
  ENDMETHOD.

  METHOD get_file_content_by_index.
    mo_abap_zip->get(
      EXPORTING
        index                   = iv_index
      IMPORTING
        content                 = rv_file_content
      EXCEPTIONS
        zip_index_error         = 1
        zip_decompression_error = 2
        OTHERS                  = 3 ).
    CASE sy-subrc.
      WHEN 1.
        RAISE EXCEPTION NEW zcx_ca_zip_index_error( mv_filename ).
      WHEN 2.
        RAISE EXCEPTION NEW zcx_ca_zip_decompression_error( mv_filename ).
    ENDCASE.
  ENDMETHOD.

  METHOD _free_instance.
    DATA(lo_instance) = VALUE #( gt_instances[ filename = iv_filename ]-instance OPTIONAL ).
    IF lo_instance IS BOUND.
      lo_instance->free( ).
      DELETE gt_instances WHERE filename EQ iv_filename.
    ENDIF.
  ENDMETHOD.

  METHOD _determine_zip_file_content.
    DATA xtab TYPE TABLE OF x255.
    DATA lv_zip_content TYPE xstring.

    cl_gui_frontend_services=>file_exist(
      EXPORTING
        file                 = iv_filename
      RECEIVING
        result               = DATA(lv_file_exists)
      EXCEPTIONS
        cntl_error           = 1
        error_no_gui         = 2
        wrong_parameter      = 3
        not_supported_by_gui = 4
        OTHERS               = 5 ).
    IF sy-subrc NE 0.
      RAISE EXCEPTION NEW cx_sy_file_open( textid   = cx_sy_file_open=>cx_sy_file_access_error
                                           filename = iv_filename ).
    ELSEIF lv_file_exists EQ abap_false.
      RAISE EXCEPTION NEW zcx_ca_file_not_exists( iv_filename ).
    ENDIF.
    cl_gui_frontend_services=>gui_upload(
      EXPORTING
        filename                = iv_filename
        filetype                = 'BIN'
      IMPORTING
        filelength                = DATA(lv_file_length)
      CHANGING
        data_tab                  = xtab
        EXCEPTIONS
          file_open_error         = 1
          file_read_error         = 2
          no_batch                = 3
          gui_refuse_filetransfer = 4
          invalid_type            = 5
          no_authority            = 6
          unknown_error           = 7
          bad_data_format         = 8
          header_not_allowed      = 9
          separator_not_allowed   = 10
          header_too_long         = 11
          unknown_dp_error        = 12
          access_denied           = 13
          dp_out_of_memory        = 14
          disk_full               = 15
          dp_timeout              = 16
          not_supported_by_gui    = 17
          error_no_gui            = 18
          OTHERS                  = 19 ).
    IF sy-subrc NE 0.
      CASE sy-subrc.
        WHEN 1 OR 2.
          RAISE EXCEPTION NEW cx_sy_file_open( textid   = cx_sy_file_open=>cx_sy_file_open
                                               filename = iv_filename ).
        WHEN OTHERS.
          RAISE EXCEPTION NEW cx_sy_file_open( textid   = cx_sy_file_open=>cx_sy_file_access_error
                                               filename = iv_filename ).
      ENDCASE.
    ENDIF.

    CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
      EXPORTING
        input_length = lv_file_length
      IMPORTING
        buffer       = lv_zip_content
      TABLES
        binary_tab   = xtab
      EXCEPTIONS
        failed       = 1
        OTHERS       = 2.

    mo_abap_zip = NEW #( ).
    mo_abap_zip->load(
      EXPORTING
        zip             = lv_zip_content
      EXCEPTIONS
        zip_parse_error = 1
        OTHERS          = 2 ).
    IF sy-subrc NE 0.
      RAISE EXCEPTION NEW zcx_ca_zip_file_error( iv_filename ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
