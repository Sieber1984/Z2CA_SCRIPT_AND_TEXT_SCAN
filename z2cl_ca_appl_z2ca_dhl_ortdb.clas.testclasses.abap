*"* use this source file for your ABAP unit test classes
CLASS lcl_text_class DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS t000_instance_get FOR TESTING RAISING cx_static_check.
    METHODS t001_instance_free FOR TESTING RAISING cx_static_check.
    METHODS t002_instances_free FOR TESTING RAISING cx_static_check.

    METHODS t050_get_location_name FOR TESTING RAISING cx_static_check.
    METHODS t051_get_location_name_full FOR TESTING RAISING cx_static_check.

    METHODS t100_db_insert FOR TESTING RAISING cx_static_check.
    METHODS t101_db_insert FOR TESTING RAISING cx_static_check.
    METHODS t102_db_insert FOR TESTING RAISING cx_static_check.
    METHODS t103_db_insert FOR TESTING RAISING cx_static_check.
    METHODS t104_db_insert FOR TESTING RAISING cx_static_check.
    METHODS t105_db_insert FOR TESTING RAISING cx_static_check.
    METHODS t106_db_insert FOR TESTING RAISING cx_static_check.
    METHODS t107_db_insert FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS lcl_text_class IMPLEMENTATION.
  METHOD t000_instance_get.
    TEST-INJECTION determine_max_version.
      gv_max_version = '2303061'.
    END-TEST-INJECTION.
    DATA(lv_alort) = CONV z2ca_dhl_alort( '12345678' ).
    TEST-INJECTION determine_database_entries.
      ms_instance_database_entry = VALUE z2ca_dhl_ortdb( alort   = '12345678'
                                                         oname   = 'Test'
                                                         ozusatz = 'am Rhein' ).
    END-TEST-INJECTION.
    DATA(lo_appl_z2ca_dhl_ortdb) = z2cl_ca_appl_z2ca_dhl_ortdb=>get_instance( '12345678' ).
    cl_abap_unit_assert=>assert_bound( act = lo_appl_z2ca_dhl_ortdb
                                       msg = 'No instance not created' ).
  ENDMETHOD.

  METHOD t001_instance_free.
    TEST-INJECTION determine_max_version.
      gv_max_version = '2303061'.
    END-TEST-INJECTION.
    TEST-INJECTION determine_database_entries.
      ms_instance_database_entry = VALUE z2ca_dhl_ortdb( alort   = '12345678'
                                                         oname   = 'Test'
                                                         ozusatz = 'am Rhein' ).
    END-TEST-INJECTION.
    DATA(lo_appl_z2ca_dhl_ortdb) = z2cl_ca_appl_z2ca_dhl_ortdb=>get_instance( '12345678' ).

    DATA(lv_has_instance_before) = z2cl_ca_appl_z2ca_dhl_ortdb=>has_instance( '12345678' ).

    z2cl_ca_appl_z2ca_dhl_ortdb=>free_instance( '12345678' ).

    DATA(lv_has_instance_after) = z2cl_ca_appl_z2ca_dhl_ortdb=>has_instance( '12345678' ).

    cl_abap_unit_assert=>assert_differs( act = lv_has_instance_after
                                         exp = lv_has_instance_before
                                         msg = 'Instance not deleted as expected' ).
  ENDMETHOD.

  METHOD t002_instances_free.
    TEST-INJECTION determine_max_version.
      gv_max_version = '2303061'.
    END-TEST-INJECTION.
    TEST-INJECTION determine_database_entries.
      ms_instance_database_entry = VALUE z2ca_dhl_ortdb( alort   = '12345678'
                                                         oname   = 'Test'
                                                         ozusatz = 'am Rhein' ).
    END-TEST-INJECTION.
    DATA(lo_appl_z2ca_dhl_ortdb) = z2cl_ca_appl_z2ca_dhl_ortdb=>get_instance( '12345678' ).

    DATA(lv_has_instances_before) = z2cl_ca_appl_z2ca_dhl_ortdb=>has_instances( ).

    z2cl_ca_appl_z2ca_dhl_ortdb=>free_instances( ).

    DATA(lv_has_instances_after) = z2cl_ca_appl_z2ca_dhl_ortdb=>has_instances( ).

    cl_abap_unit_assert=>assert_differs( act = lv_has_instances_after
                                         exp = lv_has_instances_before
                                         msg = 'Instances not deleted as expected' ).
  ENDMETHOD.

  METHOD t050_get_location_name.
    TEST-INJECTION determine_max_version.
      gv_max_version = '2303061'.
    END-TEST-INJECTION.
    DATA(lv_location_name_expected) = CONV z2ca_dhl_oname( 'Test' ).
    TEST-INJECTION determine_database_entries.
      ms_instance_database_entry = VALUE z2ca_dhl_ortdb( alort   = '12345678'
                                                         oname   = 'Test'
                                                         ozusatz = 'am Rhein' ).
    END-TEST-INJECTION.
    DATA(lv_location_name_actual) = z2cl_ca_appl_z2ca_dhl_ortdb=>get_instance( '12345678' )->get_location_name( ).

    cl_abap_unit_assert=>assert_equals( act = lv_location_name_actual
                                        exp = lv_location_name_expected
                                        msg = |Expected location name { lv_location_name_expected } not received| ).
  ENDMETHOD.

  METHOD t051_get_location_name_full.
    TEST-INJECTION determine_max_version.
      gv_max_version = '2303061'.
    END-TEST-INJECTION.
    DATA(lv_location_name_expected) = CONV z2ca_dhl_oname( 'Test am Rhein' ).
    TEST-INJECTION determine_database_entries.
      ms_instance_database_entry = VALUE z2ca_dhl_ortdb( alort   = '12345678'
                                                         oname   = 'Test'
                                                         ozusatz = 'am Rhein' ).
    END-TEST-INJECTION.
    DATA(lv_location_name_actual) = z2cl_ca_appl_z2ca_dhl_ortdb=>get_instance( '12345678' )->get_location_name_full( ).

    cl_abap_unit_assert=>assert_equals( act = lv_location_name_actual
                                        exp = lv_location_name_expected
                                        msg = |Expected location name { lv_location_name_expected } not received| ).
  ENDMETHOD.

  METHOD t100_db_insert.
    TEST-INJECTION determine_max_version.
      gv_max_version = '2303061'.
    END-TEST-INJECTION.
    DATA lt_return_expected TYPE bapiret2_tab.
    DATA(lt_dhl_import_file_data) = VALUE z2ca_dhl_import_file_data_t(
      ( |OR       1978010100000400SAa                                      H| &&
        |opsten                                                                A| &&
        |a                              26631500$| ) ).

    DATA(lt_return) = z2cl_ca_appl_z2ca_dhl_ortdb=>insert_entries_into_db(
                          it_dhl_import_file_data = lt_dhl_import_file_data
                          iv_display_progress     = abap_true
                          iv_test                 = abap_true ).
    MESSAGE e002 WITH 'VERSION'
                      '00000400'
                      'Aa'
                 INTO DATA(lv_message).
    APPEND VALUE #( BASE ycl_abap_services=>get_bapiret2_from_sy( )
                    row = lines( lt_return_expected ) + 1 )
           TO lt_return_expected.
    cl_abap_unit_assert=>assert_equals( act = lt_return
                                        exp = lt_return_expected
                                        msg = 'Erwartete Fehlertablle ungleich erhalten' ).

  ENDMETHOD.

  METHOD t101_db_insert.
    TEST-INJECTION determine_max_version.
      gv_max_version = '2303061'.
    END-TEST-INJECTION.
    DATA lt_return_expected TYPE bapiret2_tab.
    DATA(lt_dhl_import_file_data) = VALUE z2ca_dhl_import_file_data_t(
      ( |OR240306119780101        SAa-Bauerschaft                          H| &&
        |opsten                                                                A| &&
        |a-Bauerschaft                  26631500$| ) ).

    DATA(lt_return) = z2cl_ca_appl_z2ca_dhl_ortdb=>insert_entries_into_db(
                          it_dhl_import_file_data = lt_dhl_import_file_data
                          iv_display_progress     = abap_true
                          iv_test                 = abap_true ).
    MESSAGE e002 WITH 'ALORT'
                      ''
                      'Aa-Bauerschaft'
                 INTO DATA(lv_message).
    APPEND VALUE #( BASE ycl_abap_services=>get_bapiret2_from_sy( )
                    row = lines( lt_return_expected ) + 1 )
           TO lt_return_expected.
  ENDMETHOD.

  METHOD t102_db_insert.
    TEST-INJECTION determine_max_version.
      gv_max_version = '2303061'.
    END-TEST-INJECTION.
    DATA lt_return_expected TYPE bapiret2_tab.
    DATA(lt_dhl_import_file_data) = VALUE z2ca_dhl_import_file_data_t(
      ( |ORA4030611973080100001500SAach                                    O| &&
        |berstaufen                             i Allgäu                      0A| &&
        |ach                            44326500$| ) ).

    DATA(lt_return) = z2cl_ca_appl_z2ca_dhl_ortdb=>insert_entries_into_db(
                          it_dhl_import_file_data = lt_dhl_import_file_data
                          iv_display_progress     = abap_true
                          iv_test                 = abap_true ).

    TRY.
        RAISE EXCEPTION NEW cx_sy_conversion_no_number( value = 'A403061' ).
      CATCH cx_sy_conversion_no_number INTO DATA(lx_sy_conversion_no_number).
        APPEND VALUE #( BASE ycl_abap_services=>get_bapiret2_from_cx( lx_sy_conversion_no_number )
                        row = lines( lt_return_expected ) + 1 )
               TO lt_return_expected.
    ENDTRY.
  ENDMETHOD.

  METHOD t103_db_insert.
    TEST-INJECTION determine_max_version.
      gv_max_version = '2303061'.
    END-TEST-INJECTION.
    DATA lt_return_expected TYPE bapiret2_tab.
    DATA(lt_dhl_import_file_data) = VALUE z2ca_dhl_import_file_data_t(
      ( |OR24030611975090100002000S| &&
        |                                                                                , K| &&
        |r Freudenstadt             0Aach                            10859600$| ) ).

    DATA(lt_return) = z2cl_ca_appl_z2ca_dhl_ortdb=>insert_entries_into_db(
                          it_dhl_import_file_data = lt_dhl_import_file_data
                          iv_display_progress     = abap_true
                          iv_test                 = abap_true ).
    MESSAGE e002 WITH 'ONAME'
                      '00002000'
                 INTO DATA(lv_message).
    APPEND VALUE #( BASE ycl_abap_services=>get_bapiret2_from_sy( )
                    row = lines( lt_return_expected ) + 1 )
           TO lt_return_expected.

    cl_abap_unit_assert=>assert_equals( act = lt_return
                                        exp = lt_return_expected
                                        msg = 'Erwartete Fehlertablle ungleich erhalten' ).

  ENDMETHOD.

  METHOD t104_db_insert.
    TEST-INJECTION determine_max_version.
      gv_max_version = '2303061'.
    END-TEST-INJECTION.
    DATA lt_return_expected TYPE bapiret2_tab.
    DATA(lt_dhl_import_file_data) = VALUE z2ca_dhl_import_file_data_t(
      ( |OR240306119991027000021001A| &&
        |ach                                                                            , H| &&
        |egau                       0Aach                    08335001        $| ) ).

    DATA(lt_return) = z2cl_ca_appl_z2ca_dhl_ortdb=>insert_entries_into_db(
                          it_dhl_import_file_data = lt_dhl_import_file_data
                          iv_display_progress     = abap_true
                          iv_test                 = abap_true ).

    cl_abap_unit_assert=>assert_equals( act = lt_return
                                        exp = lt_return_expected
                                        msg = 'Erwartete Fehlertablle ungleich erhalten' ).

  ENDMETHOD.

  METHOD t105_db_insert.
    TEST-INJECTION determine_max_version.
      gv_max_version = '2303061'.
    END-TEST-INJECTION.
    DATA lt_return_expected TYPE bapiret2_tab.
    DATA(lt_dhl_import_file_data) = VALUE z2ca_dhl_import_file_data_t(
      ( |OR24030611996031900003500GA| &&
        |ach                                                                            b T| &&
        |rier                       0Aach                    07235001        $| ) ).

    DATA(lt_return) = z2cl_ca_appl_z2ca_dhl_ortdb=>insert_entries_into_db(
                          it_dhl_import_file_data = lt_dhl_import_file_data
                          iv_display_progress     = abap_true
                          iv_test                 = abap_true ).

    MESSAGE s009 WITH 'Z2CA_DHL_ORTDB' INTO DATA(lv_message).
    APPEND VALUE #( BASE ycl_abap_services=>get_bapiret2_from_sy( )
                    row = lines( lt_return_expected ) + 1 ) TO lt_return_expected.

    cl_abap_unit_assert=>assert_equals( act = lt_return
                                        exp = lt_return_expected
                                        msg = 'Erwartete Fehlertablle ungleich erhalten' ).

  ENDMETHOD.

  METHOD t106_db_insert.
    TEST-INJECTION determine_max_version.
      gv_max_version = '2303061'.
    END-TEST-INJECTION.
    DATA lt_return_expected TYPE bapiret2_tab.
    DATA(lt_dhl_import_file_data) = VALUE z2ca_dhl_import_file_data_t(
      ( |OR23030611996031900003500GA| &&
        |ach                                                                            b T| &&
        |rier                       0Aach                    07235001        $| ) ).

    DATA(lt_return) = z2cl_ca_appl_z2ca_dhl_ortdb=>insert_entries_into_db(
                          it_dhl_import_file_data = lt_dhl_import_file_data
                          iv_display_progress     = abap_true
                          iv_test                 = abap_true ).

    MESSAGE e008 WITH '2303061'
                      'Z2CA_DHL_ORTDB'
                 INTO DATA(lv_message).
    APPEND VALUE #( BASE ycl_abap_services=>get_bapiret2_from_sy( )
                    row = lines( lt_return_expected ) + 1 ) TO lt_return_expected.

    cl_abap_unit_assert=>assert_equals( act = lt_return
                                        exp = lt_return_expected
                                        msg = 'Erwartete Fehlertablle ungleich erhalten' ).

  ENDMETHOD.

  METHOD t107_db_insert.
    TEST-INJECTION determine_max_version.
      gv_max_version = '2303061'.
    END-TEST-INJECTION.
    DATA lt_return_expected TYPE bapiret2_tab.
    DATA(lt_dhl_import_file_data) = VALUE z2ca_dhl_import_file_data_t(
      ( |OR23030601996031900003500GA| &&
        |ach                                                                            b T| &&
        |rier                       0Aach                    07235001        $| ) ).

    DATA(lt_return) = z2cl_ca_appl_z2ca_dhl_ortdb=>insert_entries_into_db(
                          it_dhl_import_file_data = lt_dhl_import_file_data
                          iv_display_progress     = abap_true
                          iv_test                 = abap_true ).

    MESSAGE e010 WITH '2303060'
                      '2303061'
                      'Z2CA_DHL_ORTDB'
                 INTO DATA(lv_message).
    APPEND VALUE #( BASE ycl_abap_services=>get_bapiret2_from_sy( )
                    row = lines( lt_return_expected ) + 1 ) TO lt_return_expected.

    cl_abap_unit_assert=>assert_equals( act = lt_return
                                        exp = lt_return_expected
                                        msg = 'Erwartete Fehlertablle ungleich erhalten' ).
  ENDMETHOD.
ENDCLASS.
