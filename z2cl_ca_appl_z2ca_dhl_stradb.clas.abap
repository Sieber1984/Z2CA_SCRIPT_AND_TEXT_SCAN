"! <p class="shorttext synchronized">Application database Z2CA_DHL_STRADB</p>
CLASS z2cl_ca_appl_z2ca_dhl_stradb DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES:
      "! <p class="shorttext synchronized">Instance key</p>
      BEGIN OF ty_get_instance_key,
        country    TYPE land1,
        post_code1 TYPE ad_pstcd1,
        street     TYPE ad_street,
        house_num1 TYPE ad_hsnm1,
        city1      TYPE ad_city1,
      END OF ty_get_instance_key.

    TYPES:
      "! <p class="shorttext synchro nized">Instance key</p>
      BEGIN OF ty_instance_key,
        country       TYPE land1,
        dhl_plz       TYPE z2ca_dhl_plz,
        dhl_name_sort TYPE z2ca_dhl_name_sort,
      END OF ty_instance_key.

    "! <p class="shorttext synchronized">Class constructor</p>
    "!
    CLASS-METHODS class_constructor.

    "! <p class="shorttext synchronized">Get instance by key</p>
    "!
    "! @parameter is_get_instance_key | <p class="shorttext synchronized">Instance get key</p>
    "! @parameter ro_instance         | <p class="shorttext synchronized">Instance</p>
    CLASS-METHODS get_instance
      IMPORTING
        is_get_instance_key TYPE ty_get_instance_key
      RETURNING
        VALUE(ro_instance)  TYPE REF TO z2cl_ca_appl_z2ca_dhl_stradb
      RAISING
        zcx_ca_dhl_country_not_in_use.

    "! <p class="shorttext synchronized">Has instance</p>
    "!
    "! @parameter is_get_instance_key | <p class="shorttext synchronized">Instance get key</p>
    CLASS-METHODS has_instance
      IMPORTING
        is_get_instance_key    TYPE ty_get_instance_key
      RETURNING
        VALUE(rv_has_instance) TYPE abap_bool.

    "! <p class="shorttext synchronized">Has instances</p>
    "!
    CLASS-METHODS has_instances
      RETURNING
        VALUE(rv_has_instances) TYPE abap_bool.

    "! <p class="shorttext synchronized">Free instance by material number</p>
    "!
    "! @parameter is_get_instance_key | <p class="shorttext synchronized">Instance get key</p>
    CLASS-METHODS free_instance
      IMPORTING
        is_get_instance_key TYPE ty_get_instance_key.

    "! <p class="shorttext synchronized">Free all instances</p>
    "!
    CLASS-METHODS free_instances.

    "! <p class="shorttext synchronized">Free all instance data</p>
    "!
    METHODS free.

    "! <p class="shorttext synchronized">Get street code</p>
    "!
    "! @parameter rv_street_code | <p class="shorttext synchronized">Street code</p>
    METHODS get_street_code
      RETURNING
        VALUE(rv_street_code) TYPE z2ca_dhl_code_char.

    "! <p class="shorttext synchronized">Is post code and street valid</p>
    "!
    "! @parameter rv_is_valid | <p class="shorttext synchronized">Post code and street valid</p>
    METHODS is_valid
      RETURNING
        VALUE(rv_is_valid) TYPE abap_bool.

    "! <p class="shorttext synchronized">Set house number</p>
    "!
    "! @parameter iv_house_number | <p class="shorttext synchronized">House number</p>
    METHODS set_house_number
      IMPORTING
        iv_house_number TYPE ad_hsnm1.

    "! <p class="shorttext synchronized">Get house number</p>
    "!
    "! @parameter rv_house_number | <p class="shorttext synchronized">House number</p>
    METHODS get_house_number
      RETURNING
        VALUE(rv_house_number) TYPE ad_hsnm1.

    "! <p class="shorttext synchronized">Set city</p>
    "!
    "! @parameter iv_city | <p class="shorttext synchronized">City</p>
    METHODS set_city
      IMPORTING
        iv_city TYPE ad_city1.

    "! <p class="shorttext synchronized">Get city</p>
    "!
    "! @parameter rv_city | <p class="shorttext synchronized">City</p>
    METHODS get_city
      RETURNING
        VALUE(rv_city) TYPE ad_city1.

    "! <p class="shorttext synchronized">Convert street name to name short</p>
    "! <h1>Convert street name to </h1>
    "! <ol>
    "!   <li>The street name needs to be converted to capital letters.</li>
    "!   <li>All occurrences of the following characters will be replaced as followed</li>
    "!   <ul>
    "!     <li> ß by SS</li>
    "!     <li> Ä by AE</li>
    "!     <li> Ö by OE</li>
    "!     <li> Ü by UE</li>
    "!   </ul>
    "!   <li>All occurrences of the following characters will be deleted</li>
    "!   <ul>
    "!     <li>>space<</li>
    "!     <li>-</li>
    "!     <li>.</li>
    "!     <li>,</li>
    "!     <li>/</li>
    "!     <li>'</li>
    "!     <li>(</li>
    "!     <li>)</li>
    "!   </ul>
    "!   <li>STRASSE at the end of the street name needs to be replaced by STR</li>
    "! </ol>
    "!
    "! @parameter rv_name_short | <p class="shorttext synchronized"></p>
    "! @parameter iv_street     | <p class="shorttext synchronized"></p>
    CLASS-METHODS convert_street_to_name_short
      IMPORTING
        iv_street            TYPE ad_street
      RETURNING
        VALUE(rv_name_short) TYPE z2ca_dhl_name_sort.

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
      BEGIN OF ty_instances.
        INCLUDE TYPE ty_instance_key AS instance_key.
    TYPES:
        instance TYPE REF TO z2cl_ca_appl_z2ca_dhl_stradb,
      END OF ty_instances.

    "! <p class="shorttext synchronized">Instances</p>
    TYPES  tty_instances TYPE STANDARD TABLE OF ty_instances.

    "! <p class="shorttext synchronized">Database to process</p>
    CONSTANTS co_database_name TYPE tablename VALUE 'Z2CA_DHL_STRADB'.

    CONSTANTS:
      "! <p class="shorttext synchronized">Types of house number</p>
      BEGIN OF co_house_number_types,
        even TYPE z2ca_dhl_hnr_typ VALUE 'G',
        odd  TYPE z2ca_dhl_hnr_typ VALUE 'U',
      END OF co_house_number_types.

    "! <p class="shorttext synchronized">Default street code</p>
    CONSTANTS co_default_street_code TYPE z2ca_dhl_code_char VALUE '000'.


    "! <p class="shorttext synchronized">DHL master file record type to process</p>
    CONSTANTS co_satzart TYPE z2ca_dhl_satzart VALUE 'SB'.

    CONSTANTS:
      "! <p class="shorttext synchronized">Valid countries for street code determination</p>
      BEGIN OF co_valid_countries,
        germany TYPE land1 VALUE 'DE',
      END OF co_valid_countries.

    "! <p class="shorttext synchronized">Collection of instances</p>
    CLASS-DATA gt_instances TYPE tty_instances.

    "! <p class="shorttext synchronized">Maximal version in database</p>
    CLASS-DATA gv_max_version TYPE z2ca_dhl_version.

    "! <p class="shorttext synchronized">Instance get key</p>
    DATA ms_get_instance_key TYPE ty_get_instance_key.

    "! <p class="shorttext synchronized">Instance key</p>
    DATA ms_instance_key TYPE ty_instance_key.

    "! <p class="shorttext synchronized">Database entries of instance key</p>
    DATA mt_instance_database_entries TYPE z2ca_dhl_stradb_t.

    "! <p class="shorttext synchronized">Determine max version</p>
    "!
    CLASS-METHODS _determine_max_version.

    "! <p class="shorttext synchronized">Constructor</p>
    "!
    "! @parameter is_get_instance_key | <p class="shorttext synchronized">Instance get key</p>
    METHODS constructor
      IMPORTING
        is_instance_key     TYPE ty_instance_key
        is_get_instance_key TYPE ty_get_instance_key.

    "! <p class="shorttext synchronized">Determine database entries of instance</p>
    "!
    "! @parameter is_instance_key | <p class="shorttext synchronized">Instance key</p>
    METHODS _determine_database_entries
      IMPORTING
        is_instance_key TYPE ty_instance_key.

    "! <p class="shorttext synchronized">Free instance by material number</p>
    "!
    "! @parameter is_instance_key | <p class="shorttext synchronized">Instance key</p>
    CLASS-METHODS _free_instance
      IMPORTING
        is_instance_key TYPE ty_instance_key.
    CLASS-METHODS _conv_instance_get_to_instance
      IMPORTING
        is_get_instance_key    TYPE z2cl_ca_appl_z2ca_dhl_stradb=>ty_get_instance_key
      RETURNING
        VALUE(rs_instance_key) TYPE z2cl_ca_appl_z2ca_dhl_stradb=>ty_instance_key.

    "! <p class="shorttext synchronized">Get street code by house number</p>
    "!
    "! @parameter rv_street_code | <p class="shorttext synchronized">Street code</p>
    METHODS _get_street_code_by_house_no
      RETURNING
        VALUE(rv_street_code) TYPE z2ca_dhl_code_char.

    "! <p class="shorttext synchronized">Get street code by location</p>
    "!
    "! @parameter rv_street_code | <p class="shorttext synchronized">Street code</p>
    METHODS _get_street_code_by_location
      RETURNING
        VALUE(rv_street_code) TYPE z2ca_dhl_code_char.

ENDCLASS.



CLASS z2cl_ca_appl_z2ca_dhl_stradb IMPLEMENTATION.
  METHOD class_constructor.
    _determine_max_version( ).
  ENDMETHOD.

  METHOD get_instance.
    DO.
      ASSIGN COMPONENT sy-index OF STRUCTURE co_valid_countries
             TO FIELD-SYMBOL(<lv_valid_country>).
      IF sy-subrc NE 0.
        EXIT.
      ENDIF.
      IF is_get_instance_key-country EQ <lv_valid_country>.
        DATA(lv_country_valid) = abap_true.
        EXIT.
      ENDIF.
    ENDDO.

    IF lv_country_valid EQ abap_false.
      RAISE EXCEPTION NEW zcx_ca_dhl_country_not_in_use( is_get_instance_key-country ).
    ENDIF.

    DATA(ls_instance_key) = _conv_instance_get_to_instance( is_get_instance_key ).

    ro_instance = COND #( WHEN line_exists( gt_instances[ instance_key = ls_instance_key ] ) "#EC CI_STDSEQ
                          THEN gt_instances[ instance_key = ls_instance_key ]-instance "#EC CI_STDSEQ
                          ELSE NEW #( is_instance_key = ls_instance_key
                                      is_get_instance_key = is_get_instance_key ) ).
    IF is_get_instance_key-house_num1 NE ro_instance->get_house_number( ).
      ro_instance->set_house_number( iv_house_number = is_get_instance_key-house_num1 ).
    ENDIF.

    IF is_get_instance_key-city1 NE ro_instance->get_city( ).
      ro_instance->set_city( is_get_instance_key-city1 ).
    ENDIF.
  ENDMETHOD.

  METHOD has_instance.
    DATA(ls_instance_key) = _conv_instance_get_to_instance( is_get_instance_key ).
    rv_has_instance = xsdbool( line_exists( gt_instances[ instance_key = ls_instance_key ] ) ).
  ENDMETHOD.

  METHOD has_instances.
    rv_has_instances = xsdbool( gt_instances IS NOT INITIAL ).
  ENDMETHOD.

  METHOD free_instance.
    DATA(ls_instance_key) = _conv_instance_get_to_instance( is_get_instance_key ).
    _free_instance( ls_instance_key ).
  ENDMETHOD.

  METHOD free_instances.
    LOOP AT gt_instances REFERENCE INTO DATA(lr_instance).
      _free_instance( lr_instance->instance_key ).
    ENDLOOP.
    FREE gt_instances.
  ENDMETHOD.

  METHOD free.
    CLEAR ms_instance_key.
    CLEAR ms_get_instance_key.
    FREE mt_instance_database_entries.
  ENDMETHOD.

  METHOD get_street_code.
    rv_street_code = co_default_street_code.

    IF mt_instance_database_entries IS INITIAL.
      RETURN.
    ENDIF.

    SELECT SINGLE FROM @mt_instance_database_entries AS db_entries  ##ITAB_DB_SELECT ##ITAB_KEY_IN_SELECT
           FIELDS COUNT( DISTINCT code )
           INTO @DATA(lv_code_count).

    IF lv_code_count EQ 1.
      rv_street_code = mt_instance_database_entries[ 1 ]-code.
      RETURN.
    ELSE.
      IF ms_get_instance_key-house_num1 IS NOT INITIAL.
        rv_street_code = _get_street_code_by_house_no( ).
      ENDIF.
    ENDIF.
    IF rv_street_code EQ co_default_street_code.
      rv_street_code =  _get_street_code_by_location( ).
    ENDIF.
  ENDMETHOD.

  METHOD is_valid.
    rv_is_valid = xsdbool( mt_instance_database_entries IS NOT INITIAL ).
  ENDMETHOD.

  METHOD set_house_number.
    ms_get_instance_key-house_num1 = iv_house_number.
  ENDMETHOD.

  METHOD get_house_number.
    rv_house_number = ms_get_instance_key-house_num1.
  ENDMETHOD.

  METHOD set_city.
    ms_get_instance_key-city1 = iv_city.
  ENDMETHOD.

  METHOD get_city.
    rv_city = ms_get_instance_key-city1.
  ENDMETHOD.

  METHOD convert_street_to_name_short.
    DATA(lv_street) = to_upper( iv_street ).
    lv_street = replace( val = lv_street
                         sub = `ß`
                         with = `SS`
                         occ = 0 ).
    lv_street = replace( val = lv_street
                         sub = `Ä`
                         with = `AE`
                         occ = 0 ).
    lv_street = replace( val = lv_street
                         sub = `Ö`
                         with = `OE`
                         occ = 0 ).
    lv_street = replace( val = lv_street
                         sub = `Ü`
                         with = `UE`
                         occ = 0 ).
    lv_street = replace( val = lv_street
                         pcre = `[\-/.,/'/(/)\s]`
                         with = ``
                         occ = 0 ).
    rv_name_short = replace( val = lv_street
                             pcre = `STRASSE$`
                             with = 'STR' ).
  ENDMETHOD.

  METHOD insert_entries_into_db.
    DATA ls_stradb TYPE z2ca_dhl_stradb.
    DATA lt_stradb TYPE z2ca_dhl_stradb_t.

    DATA(lo_stradb_descr) = cl_abap_structdescr=>describe_by_data( ls_stradb ).
    IF lo_stradb_descr IS INSTANCE OF cl_abap_structdescr AND
       lo_stradb_descr->is_ddic_type( ).
      DATA(lt_dhl_stradb_ddic_field_list) = CAST cl_abap_structdescr( lo_stradb_descr )->get_ddic_field_list(
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

        DATA(ls_stradb_import) = CONV z2ca_dhl_stradb_import_s( lr_import_file_data->* ) ##ENH_OK.
        TRY.
            ls_stradb-version = EXACT #( ls_stradb_import-version ).
            IF ls_stradb_import-code EQ co_default_street_code.
              CONTINUE.
            ELSEIF ls_stradb-version IS NOT INITIAL AND ls_stradb-version LT gv_max_version.
              MESSAGE e010 WITH ls_stradb-version
                                gv_max_version
                                co_database_name
                           INTO DATA(lv_message).
              APPEND VALUE #( BASE ycl_abap_services=>get_bapiret2_from_sy( )
                              row = lv_import_row ) TO rt_return.
              RETURN.
            ELSEIF ls_stradb-version IS NOT INITIAL AND ls_stradb-version EQ gv_max_version.
              MESSAGE e008 WITH ls_stradb-version
                                co_database_name
                           INTO lv_message.
              APPEND VALUE #( BASE ycl_abap_services=>get_bapiret2_from_sy( )
                              row = lv_import_row ) TO rt_return.
              RETURN.
            ENDIF.
          CATCH cx_sy_conversion_no_number ##NO_HANDLER.
        ENDTRY.
        LOOP AT lt_dhl_stradb_ddic_field_list REFERENCE INTO DATA(lr_stradb_ddic_field).
          TRY.
              ls_stradb-(lr_stradb_ddic_field->fieldname) = EXACT #( ls_stradb_import-(lr_stradb_ddic_field->fieldname) ).
            CATCH cx_sy_assign_illegal_component.
              CONTINUE.
            CATCH cx_sy_conversion_no_number INTO DATA(lx_sy_conversion_no_number).
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

        DATA(lo_stradb_oblig_fields_descr) = cl_abap_structdescr=>describe_by_data( ls_stradb-obligatory_fields ).
        DATA(lt_dhl_stradb_oblig_fields) = CAST cl_abap_structdescr( lo_stradb_oblig_fields_descr )->get_ddic_field_list(
                                            p_including_substructres = abap_true ).
        LOOP AT lt_dhl_stradb_oblig_fields REFERENCE INTO DATA(lr_stradb_oblig_ddic_field).
          IF ls_stradb-(lr_stradb_oblig_ddic_field->fieldname) IS INITIAL.
            MESSAGE e001 WITH lr_stradb_oblig_ddic_field->fieldname
                              ls_stradb-plz
                              ls_stradb-alort
                              ls_stradb-name_sort
                         INTO lv_message.
            APPEND VALUE #( BASE ycl_abap_services=>get_bapiret2_from_sy( )
                            row = lv_import_row ) TO rt_return.
            lv_error = abap_true.
            EXIT.
          ENDIF.
        ENDLOOP.
        IF lv_error EQ abap_false.
          APPEND ls_stradb TO lt_stradb.
          MESSAGE s009 WITH co_database_name INTO lv_message.
          APPEND VALUE #( BASE ycl_abap_services=>get_bapiret2_from_sy( )
                          row = lv_import_row ) TO rt_return.
        ELSE.
          CLEAR lv_error.
        ENDIF.
      ENDLOOP.
    ENDIF.

    IF iv_test EQ abap_false.
      INSERT z2ca_dhl_stradb FROM TABLE lt_stradb.
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
    SELECT FROM z2ca_dhl_stradb
           FIELDS MAX( version )
           WHERE version NE '0000000'
           INTO @gv_max_version.
    TEST-SEAM determine_max_version.
    END-TEST-SEAM.
  ENDMETHOD.

  METHOD constructor.
    _determine_database_entries( is_instance_key ).

    ms_get_instance_key = is_get_instance_key.

    APPEND VALUE #( instance_key = is_instance_key
                    instance = me ) TO gt_instances.
  ENDMETHOD.

  METHOD _determine_database_entries.
    SELECT FROM z2ca_dhl_stradb
           FIELDS *
           WHERE version   EQ  @gv_max_version
             AND plz       EQ @is_instance_key-dhl_plz
             AND name_sort EQ @is_instance_key-dhl_name_sort
           INTO TABLE @mt_instance_database_entries.
    TEST-SEAM determine_database_entries.
    END-TEST-SEAM.
  ENDMETHOD.

  METHOD _free_instance.
    DATA(lo_instance) = VALUE #( gt_instances[ instance_key = is_instance_key ]-instance OPTIONAL ).
    IF lo_instance IS BOUND.
      lo_instance->free( ).
      DELETE gt_instances WHERE instance_key EQ is_instance_key.
    ENDIF.
  ENDMETHOD.

  METHOD _conv_instance_get_to_instance.
    rs_instance_key = VALUE ty_instance_key(
                        country = is_get_instance_key-country
                        dhl_plz = is_get_instance_key-post_code1
                        dhl_name_sort = convert_street_to_name_short( is_get_instance_key-street ) ).
  ENDMETHOD.

  METHOD _get_street_code_by_house_no.
    rv_street_code = co_default_street_code.
    DATA(lv_house_number_first_part) = substring_to( val = condense( ms_get_instance_key-house_num1 )
                                               pcre = `^\d{1,10}` ).
    IF lv_house_number_first_part IS NOT INITIAL.
      CASE lv_house_number_first_part MOD 2.
        WHEN 1.
          DATA(lv_house_number_type) = co_house_number_types-odd.
        WHEN 0.
          lv_house_number_type = co_house_number_types-even.
      ENDCASE.
      SELECT FROM @mt_instance_database_entries AS db_entries  ##ITAB_DB_SELECT ##ITAB_KEY_IN_SELECT
             FIELDS alort, code
             WHERE hnr_typ EQ @lv_house_number_type
               AND hnr_von LE @lv_house_number_first_part
               AND hnr_bis GE @lv_house_number_first_part
             INTO TABLE @DATA(lt_alort_code).
      IF sy-subrc EQ 0 AND lines( lt_alort_code ) EQ 1.
        rv_street_code = lt_alort_code[ 1 ]-code.
        RETURN.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD _get_street_code_by_location.
    DATA lt_street_codes_found TYPE STANDARD TABLE OF z2ca_dhl_code.
    rv_street_code = co_default_street_code.
    LOOP AT mt_instance_database_entries REFERENCE INTO DATA(lr_instance_database_entry).
      DATA(lo_dhl_ortdb) = z2cl_ca_appl_z2ca_dhl_ortdb=>get_instance( lr_instance_database_entry->alort ).
      IF lo_dhl_ortdb->get_location_name( ) EQ ms_get_instance_key-city1 OR
         lo_dhl_ortdb->get_location_name_full( ) EQ ms_get_instance_key-city1.
        COLLECT lr_instance_database_entry->code INTO lt_street_codes_found.
      ENDIF.
    ENDLOOP.

    IF lines( lt_street_codes_found ) EQ 1.
      rv_street_code = lt_street_codes_found[ 1 ].
    ENDIF.
    TEST-SEAM get_location_name.
    END-TEST-SEAM.
  ENDMETHOD.
ENDCLASS.
