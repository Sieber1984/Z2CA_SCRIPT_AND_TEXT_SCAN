"! <p class="shorttext synchronized">Application database Z2CA_DHL_ORTDB</p>
CLASS z2cl_ca_appl_z2ca_dhl_ortdb DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    "! <p class="shorttext synchronized">Get instance by key</p>
    "!
    "! @parameter iv_alort | <p class="shorttext synchronized">DHL location number</p>
    "! @parameter ro_instance         | <p class="shorttext synchronized">Instance</p>
    CLASS-METHODS get_instance
      IMPORTING
        iv_alort           TYPE z2ca_dhl_alort
      RETURNING
        VALUE(ro_instance) TYPE REF TO z2cl_ca_appl_z2ca_dhl_ortdb.

    "! <p class="shorttext synchronized">Has instance</p>
    "!
    "! @parameter iv_alort | <p class="shorttext synchronized">DHL location number</p>
    CLASS-METHODS has_instance
      IMPORTING
        iv_alort               TYPE z2ca_dhl_alort
      RETURNING
        VALUE(rv_has_instance) TYPE abap_bool.

    "! <p class="shorttext synchronized">Has instances</p>
    "!
    CLASS-METHODS has_instances
      RETURNING
        VALUE(rv_has_instances) TYPE abap_bool.

    "! <p class="shorttext synchronized">Free instance by material number</p>
    "!
    "! @parameter iv_alort | <p class="shorttext synchronized">DHL location number</p>
    CLASS-METHODS free_instance
      IMPORTING
        iv_alort TYPE z2ca_dhl_alort.

    "! <p class="shorttext synchronized">Free all instances</p>
    "!
    CLASS-METHODS free_instances.

    "! <p class="shorttext synchronized">Free all instance data</p>
    "!
    METHODS free.

    "! <p class="shorttext synchronized">Get location name</p>
    "!
    "! @parameter rv_location_name | <p class="shorttext synchronized">Location name</p>
    METHODS get_location_name
      RETURNING
        VALUE(rv_location_name) TYPE z2ca_dhl_oname.

    "! <p class="shorttext synchronized">Get location name full</p>
    "!
    "! @parameter rv_location_name_full | <p class="shorttext synchronized">Location name full</p>
    METHODS get_location_name_full
      RETURNING
        VALUE(rv_location_name_full) TYPE z2ca_dhl_oname_full.

    CLASS-METHODS class_constructor.
    "! <p class="shorttext synchronized">Insert import data into database</p>
    "!
    "! @parameter it_dhl_import_file_data | <p class="shorttext synchronized">DHL Import file data </p>
    "! @parameter iv_display_progress | <p class="shorttext synchronized">Display progress</p>
    "! @parameter iv_test | <p class="shorttext synchronized">Test</p>
    "! @parameter rt_return | <p class="shorttext synchronized">Error Messages</p>
    CLASS-METHODS insert_entries_into_db
      IMPORTING
        it_dhl_import_file_data TYPE z2ca_dhl_import_file_data_t
        iv_display_progress     TYPE z2ca_display_progress DEFAULT abap_true
        iv_test                 TYPE z2ca_test DEFAULT abap_false
      RETURNING
        VALUE(rt_return)        TYPE bapiret2_tab.

  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      "! <p class="shorttext synchronized">Instance</p>
      BEGIN OF ty_instances,
        alort    TYPE z2ca_dhl_alort,
        instance TYPE REF TO z2cl_ca_appl_z2ca_dhl_ortdb,
      END OF ty_instances.

    "! <p class="shorttext synchronized">Instances</p>
    TYPES  tty_instances TYPE STANDARD TABLE OF ty_instances.

    "! <p class="shorttext synchronized">Database to process</p>
    CONSTANTS co_database_name TYPE tablename VALUE 'Z2CA_DHL_ORTDB'.

    "! <p class="shorttext synchronized">DHL master file record type to process</p>
    CONSTANTS co_satzart TYPE z2ca_dhl_satzart VALUE 'OR'.

    CONSTANTS:
      "! <p class="shorttext synchronized">Valid status to process</p>
      BEGIN OF co_valid_status,
        valid_location_record  TYPE z2ca_dhl_ort_status VALUE 'G',
        valid_archive_one      TYPE z2ca_dhl_ort_status VALUE 'S',
        valid_archive_multiple TYPE z2ca_dhl_ort_status VALUE 'W',
      END OF co_valid_status.

    "! <p class="shorttext synchronized">Maximal version in database</p>
    CLASS-DATA gv_max_version TYPE z2ca_dhl_version.

    "! <p class="shorttext synchronized">Location number</p>
    DATA mv_alort TYPE z2ca_dhl_alort.

    "! <p class="shorttext synchronized">Collection of instances</p>
    CLASS-DATA gt_instances TYPE tty_instances.

    "! <p class="shorttext synchronized">Database entries of instance key</p>
    DATA ms_instance_database_entry TYPE z2ca_dhl_ortdb.

    "! <p class="shorttext synchronized">Determine max version</p>
    "!
    CLASS-METHODS _determine_max_version.

    "! <p class="shorttext synchronized">Constructor</p>
    "!
    "! @parameter iv_alort | <p class="shorttext synchronized">DHL location number</p>
    METHODS constructor
      IMPORTING
        iv_alort TYPE z2ca_dhl_alort.

    "! <p class="shorttext synchronized">Determine database entry of instance</p>
    "!
    "! @parameter iv_alort | <p class="shorttext synchronized">DHL location number</p>
    METHODS _determine_database_entry
      IMPORTING
        iv_alort TYPE z2ca_dhl_alort.

    "! <p class="shorttext synchronized">Free instance by material number</p>
    "!
    "! @parameter iv_alort | <p class="shorttext synchronized">DHL location number</p>
    CLASS-METHODS _free_instance
      IMPORTING
        iv_alort TYPE z2ca_dhl_alort.

ENDCLASS.



CLASS z2cl_ca_appl_z2ca_dhl_ortdb IMPLEMENTATION.
  METHOD class_constructor.
    _determine_max_version( ).
  ENDMETHOD.

  METHOD get_instance.
    ro_instance = COND #( WHEN line_exists( gt_instances[ alort = iv_alort ] ) "#EC CI_STDSEQ
                          THEN gt_instances[ alort = iv_alort ]-instance "#EC CI_STDSEQ
                          ELSE NEW #( iv_alort ) ).
  ENDMETHOD.

  METHOD has_instance.
    rv_has_instance = xsdbool( line_exists( gt_instances[ alort = iv_alort ] ) ).
  ENDMETHOD.

  METHOD has_instances.
    rv_has_instances = xsdbool( gt_instances IS NOT INITIAL ).
  ENDMETHOD.

  METHOD free_instance.
    _free_instance( iv_alort ).
  ENDMETHOD.

  METHOD free_instances.
    LOOP AT gt_instances REFERENCE INTO DATA(lr_instance).
      _free_instance( lr_instance->alort ).
    ENDLOOP.
    FREE gt_instances.
  ENDMETHOD.

  METHOD free.
    CLEAR ms_instance_database_entry.
    CLEAR mv_alort.
  ENDMETHOD.

  METHOD get_location_name.
    rv_location_name = ms_instance_database_entry-oname.
  ENDMETHOD.

  METHOD get_location_name_full.
    rv_location_name_full = |{ ms_instance_database_entry-oname } { ms_instance_database_entry-ozusatz }|.
  ENDMETHOD.

  METHOD insert_entries_into_db.
    DATA ls_ortdb TYPE z2ca_dhl_ortdb.
    DATA lt_ortdb TYPE z2ca_dhl_ortdb_t.

    DATA(lo_ortdb_descr) = cl_abap_structdescr=>describe_by_data( ls_ortdb ).
    IF lo_ortdb_descr IS INSTANCE OF cl_abap_structdescr AND
       lo_ortdb_descr->is_ddic_type( ).
      DATA(lt_dhl_ortdb_ddic_field_list) = CAST cl_abap_structdescr( lo_ortdb_descr )->get_ddic_field_list(
                                                p_including_substructres = abap_true ).

      DATA(lv_entries_to_process) = lines( it_dhl_import_file_data ).
      LOOP AT it_dhl_import_file_data REFERENCE INTO DATA(lr_import_file_data)
           WHERE table_line(2) EQ co_satzart.
        DATA(lv_import_row) = sy-tabix.

        IF iv_display_progress EQ abap_true.
          cl_progress_indicator=>progress_indicate( i_msgid              = 'Z2CA_DHL'
                                                    i_msgno              = '007'
                                                    i_msgv1              = |{ lv_import_row NUMBER = USER }|
                                                    i_msgv2              = |{ lv_entries_to_process NUMBER = USER }|
                                                    i_processed          = lv_import_row
                                                    i_total              = 100 ).
        ENDIF.

        DATA(ls_ortdb_import) = CONV z2ca_dhl_ortdb_import_s( lr_import_file_data->* ) ##ENH_OK.
        TRY.
            ls_ortdb-version = EXACT #( ls_ortdb_import-version ).
            IF ls_ortdb_import-status NA co_valid_status.
              CONTINUE.
            ELSEIF ls_ortdb-version IS NOT INITIAL AND ls_ortdb-version LT gv_max_version.
              MESSAGE e010 WITH ls_ortdb-version
                                gv_max_version
                                co_database_name
                           INTO DATA(lv_message).
              APPEND VALUE #( BASE ycl_abap_services=>get_bapiret2_from_sy( )
                              row = lv_import_row ) TO rt_return.
              RETURN.
            ELSEIF ls_ortdb-version IS NOT INITIAL AND ls_ortdb-version EQ gv_max_version.
              MESSAGE e008 WITH ls_ortdb-version
                                co_database_name
                           INTO lv_message.
              APPEND VALUE #( BASE ycl_abap_services=>get_bapiret2_from_sy( )
                              row = lv_import_row ) TO rt_return.
              RETURN.
            ENDIF.
          CATCH cx_sy_conversion_no_number INTO DATA(lx_sy_conversion_no_number).
            APPEND VALUE #( BASE ycl_abap_services=>get_bapiret2_from_cx( lx_sy_conversion_no_number )
                            row = lv_import_row ) TO rt_return.
        ENDTRY.
        LOOP AT lt_dhl_ortdb_ddic_field_list REFERENCE INTO DATA(lr_ortdb_ddic_field).
          TRY.
              ls_ortdb-(lr_ortdb_ddic_field->fieldname) = EXACT #( ls_ortdb_import-(lr_ortdb_ddic_field->fieldname) ).
            CATCH cx_sy_assign_illegal_component.
              CONTINUE.
            CATCH cx_sy_conversion_no_number INTO lx_sy_conversion_no_number.
              APPEND VALUE #( BASE ycl_abap_services=>get_bapiret2_from_cx( lx_sy_conversion_no_number )
                              row = lv_import_row ) TO rt_return.
              DATA(lv_error) = abap_true.
              CONTINUE.
            CATCH cx_sy_conversion_data_loss INTO DATA(lx_sy_conversion_data_loss).
              APPEND VALUE #( BASE ycl_abap_services=>get_bapiret2_from_cx( lx_sy_conversion_data_loss )
                              row = lv_import_row ) TO rt_return.
              lv_error = abap_true.
              CONTINUE.
            CATCH cx_sy_conversion_exact_not_sup INTO DATA(lx_sy_conversion_exact_not_sup).
              APPEND VALUE #( BASE ycl_abap_services=>get_bapiret2_from_cx( lx_sy_conversion_exact_not_sup )
                              row = lv_import_row ) TO rt_return.
              lv_error = abap_true.
              CONTINUE.
          ENDTRY.
        ENDLOOP.
        IF lv_error EQ abap_true.
          CLEAR lv_error.
          CONTINUE.
        ENDIF.

        IF ls_ortdb-version IS INITIAL.
          DATA(lv_fieldname) = CONV fieldname( 'VERSION' ).
        ELSEIF ls_ortdb-alort IS INITIAL.
          lv_fieldname = CONV fieldname( 'ALORT' ).
        ELSEIF ls_ortdb-oname IS INITIAL.
          lv_fieldname = CONV fieldname( 'ONAME' ).
        ELSE.
          APPEND ls_ortdb TO lt_ortdb.
          MESSAGE s009 WITH co_database_name INTO lv_message.
          APPEND VALUE #( BASE ycl_abap_services=>get_bapiret2_from_sy( )
                          row = lv_import_row ) TO rt_return.
        ENDIF.
        IF lv_fieldname IS NOT INITIAL.
          MESSAGE e002 WITH lv_fieldname
                            ls_ortdb-alort
                            ls_ortdb-oname
                       INTO lv_message.
          APPEND VALUE #( BASE ycl_abap_services=>get_bapiret2_from_sy( )
                          row = lv_import_row ) TO rt_return.
          CLEAR lv_fieldname.
        ENDIF.
      ENDLOOP.
    ENDIF.

    IF iv_test EQ abap_false.
      INSERT z2ca_dhl_ortdb FROM TABLE lt_ortdb.
      IF sy-subrc EQ 0.
        COMMIT WORK AND WAIT.
        MESSAGE s003 WITH co_database_name INTO lv_message.
        APPEND ycl_abap_services=>get_bapiret2_from_sy( ) TO rt_return.
      ELSE.
        MESSAGE e004 WITH co_database_name INTO lv_message.
        APPEND ycl_abap_services=>get_bapiret2_from_sy( ) TO rt_return.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD _determine_max_version.
    SELECT FROM z2ca_dhl_ortdb
           FIELDS MAX( version )
           WHERE version IS NOT INITIAL
           INTO @gv_max_version.
    TEST-SEAM determine_max_version.
    END-TEST-SEAM.
  ENDMETHOD.

  METHOD constructor.
    _determine_database_entry( iv_alort ) ##NEEDED.

    mv_alort = iv_alort.

    APPEND VALUE #( alort = iv_alort
                    instance = me ) TO gt_instances.
  ENDMETHOD.

  METHOD _determine_database_entry.
    SELECT SINGLE FROM z2ca_dhl_ortdb
           FIELDS *
           WHERE version EQ @gv_max_version
             AND alort EQ @iv_alort
           INTO @ms_instance_database_entry.
    TEST-SEAM determine_database_entries.
    END-TEST-SEAM.
  ENDMETHOD.

  METHOD _free_instance.
    DATA(lo_instance) = VALUE #( gt_instances[ alort = iv_alort ]-instance OPTIONAL ).
    IF lo_instance IS BOUND.
      lo_instance->free( ).
      DELETE gt_instances WHERE alort EQ iv_alort.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
