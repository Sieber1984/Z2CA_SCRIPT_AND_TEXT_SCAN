*"* use this source file for your ABAP unit test classes
CLASS lcl_text_class DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS t000_street_conversion FOR TESTING RAISING cx_static_check.
    METHODS t001_street_conversion FOR TESTING RAISING cx_static_check.
    METHODS t002_street_conversion FOR TESTING RAISING cx_static_check.
    METHODS t003_street_conversion FOR TESTING RAISING cx_static_check.
    METHODS t004_street_conversion FOR TESTING RAISING cx_static_check.
    METHODS t005_street_conversion FOR TESTING RAISING cx_static_check.
    METHODS t006_street_conversion FOR TESTING RAISING cx_static_check.
    METHODS t007_street_conversion FOR TESTING RAISING cx_static_check.
    METHODS t008_street_conversion FOR TESTING RAISING cx_static_check.
    METHODS t009_street_conversion FOR TESTING RAISING cx_static_check.
    METHODS t010_street_conversion FOR TESTING RAISING cx_static_check.

    METHODS t050_instance_get FOR TESTING RAISING cx_static_check.
    METHODS t051_instance_get FOR TESTING RAISING cx_static_check.
    METHODS t052_instance_free FOR TESTING RAISING cx_static_check.
    METHODS t053_instances_free FOR TESTING RAISING cx_static_check.

    METHODS t100_get_street_code FOR TESTING RAISING cx_static_check.
    METHODS t101_get_street_code FOR TESTING RAISING cx_static_check.
    METHODS t102_get_street_code FOR TESTING RAISING cx_static_check.
    METHODS t103_get_street_code FOR TESTING RAISING cx_static_check.
    METHODS t104_get_street_code FOR TESTING RAISING cx_static_check.
    METHODS t105_get_street_code FOR TESTING RAISING cx_static_check.
    METHODS t106_get_street_code FOR TESTING RAISING cx_static_check.
    METHODS t107_get_street_code FOR TESTING RAISING cx_static_check.
    METHODS t108_get_street_code FOR TESTING RAISING cx_static_check.
    METHODS t109_get_street_code FOR TESTING RAISING cx_static_check.
    METHODS t110_get_street_code FOR TESTING RAISING cx_static_check.

    METHODS t150_db_insert FOR TESTING RAISING cx_static_check.
    METHODS t151_db_insert FOR TESTING RAISING cx_static_check.
    METHODS t152_db_insert FOR TESTING RAISING cx_static_check.
    METHODS t153_db_insert FOR TESTING RAISING cx_static_check.
    METHODS t154_db_insert FOR TESTING RAISING cx_static_check.
    METHODS t155_db_insert FOR TESTING RAISING cx_static_check.
    METHODS t156_db_insert FOR TESTING RAISING cx_static_check.
    METHODS t157_db_insert FOR TESTING RAISING cx_static_check.
    METHODS t158_db_insert FOR TESTING RAISING cx_static_check.
    METHODS t159_db_insert FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS lcl_text_class IMPLEMENTATION.
  METHOD t000_street_conversion.
    TEST-INJECTION determine_max_version.
      gv_max_version = '2303061'.
    END-TEST-INJECTION.
    DATA(lv_name_short) = z2cl_ca_appl_z2ca_dhl_stradb=>convert_street_to_name_short( 'Mühlenstrasse' ).
    cl_abap_unit_assert=>assert_equals( act = lv_name_short
                                        exp = 'MUEHLENSTR'
                                        msg = 'Erwarteter NAME_SHORT MUEHLENSTR nicht erhalten' ).
  ENDMETHOD.

  METHOD t001_street_conversion.
    DATA(lv_name_short) = z2cl_ca_appl_z2ca_dhl_stradb=>convert_street_to_name_short( 'König-Rudolf-Str.' ).
    cl_abap_unit_assert=>assert_equals( act = lv_name_short
                                        exp = 'KOENIGRUDOLFSTR'
                                        msg = 'Erwarteter NAME_SHORT KOENIGRUDOLFSTR nicht erhalten' ).
  ENDMETHOD.

  METHOD t002_street_conversion.
    DATA(lv_name_short) = z2cl_ca_appl_z2ca_dhl_stradb=>convert_street_to_name_short( 'Längenbergstr.' ).
    cl_abap_unit_assert=>assert_equals( act = lv_name_short
                                        exp = 'LAENGENBERGSTR'
                                        msg = 'Erwarteter NAME_SHORT LAENGENBERGSTR nicht erhalten' ).
  ENDMETHOD.

  METHOD t003_street_conversion.
    DATA(lv_name_short) = z2cl_ca_appl_z2ca_dhl_stradb=>convert_street_to_name_short( 'Auf dem Ösch' ).
    cl_abap_unit_assert=>assert_equals( act = lv_name_short
                                        exp = 'AUFDEMOESCH'
                                        msg = 'Erwarteter NAME_SHORT AUFDEMOESCH nicht erhalten' ).
  ENDMETHOD.

  METHOD t004_street_conversion.
    DATA(lv_name_short) = z2cl_ca_appl_z2ca_dhl_stradb=>convert_street_to_name_short( 'Gräfin-Helene-Strasse' ).
    cl_abap_unit_assert=>assert_equals( act = lv_name_short
                                        exp = 'GRAEFINHELENESTR'
                                        msg = 'Erwarteter NAME_SHORT GRAEFINHELENESTR nicht erhalten' ).
  ENDMETHOD.

  METHOD t005_street_conversion.
    DATA(lv_name_short) = z2cl_ca_appl_z2ca_dhl_stradb=>convert_street_to_name_short( 'Im Wölfertsbühl' ).
    cl_abap_unit_assert=>assert_equals( act = lv_name_short
                                        exp = 'IMWOELFERTSBUEHL'
                                        msg = 'Erwarteter NAME_SHORT IMWOELFERTSBUEHL nicht erhalten' ).
  ENDMETHOD.

  METHOD t006_street_conversion.
    DATA(lv_name_short) = z2cl_ca_appl_z2ca_dhl_stradb=>convert_street_to_name_short( 'Maria-Theresia-Str.' ).
    cl_abap_unit_assert=>assert_equals( act = lv_name_short
                                        exp = 'MARIATHERESIASTR'
                                        msg = 'Erwarteter NAME_SHORT MARIATHERESIASTR nicht erhalten' ).
  ENDMETHOD.

  METHOD t007_street_conversion.
    DATA(lv_name_short) = z2cl_ca_appl_z2ca_dhl_stradb=>convert_street_to_name_short( 'Paul-Röntgen-Str.' ).
    cl_abap_unit_assert=>assert_equals( act = lv_name_short
                                        exp = 'PAULROENTGENSTR'
                                        msg = 'Erwarteter NAME_SHORT PAULROENTGENSTR nicht erhalten' ).
  ENDMETHOD.

  METHOD t008_street_conversion.
    DATA(lv_name_short) = z2cl_ca_appl_z2ca_dhl_stradb=>convert_street_to_name_short( 'Alte Würselener Str.' ).
    cl_abap_unit_assert=>assert_equals( act = lv_name_short
                                        exp = 'ALTEWUERSELENERSTR'
                                        msg = 'Erwarteter NAME_SHORT ALTEWUERSELENERSTR nicht erhalten' ).
  ENDMETHOD.

  METHOD t009_street_conversion.
    DATA(lv_name_short) = z2cl_ca_appl_z2ca_dhl_stradb=>convert_street_to_name_short( 'Am Adamshäuschen' ).
    cl_abap_unit_assert=>assert_equals( act = lv_name_short
                                        exp = 'AMADAMSHAEUSCHEN'
                                        msg = 'Erwarteter NAME_SHORT AMADAMSHAEUSCHEN nicht erhalten' ).
  ENDMETHOD.

  METHOD t010_street_conversion.
    DATA(lv_name_short) = z2cl_ca_appl_z2ca_dhl_stradb=>convert_street_to_name_short( 'Am Büschchen' ).
    cl_abap_unit_assert=>assert_equals( act = lv_name_short
                                        exp = 'AMBUESCHCHEN'
                                        msg = 'Erwarteter NAME_SHORT AMBUESCHCHEN nicht erhalten' ).
  ENDMETHOD.

  METHOD t050_instance_get.
    TEST-INJECTION determine_database_entries.
      mt_instance_database_entries = VALUE #( ( plz = '78315'
                                                name_sort = 'Güttinger Strasse'
                                                code = '000' ) ).
    END-TEST-INJECTION.
    DATA(lo_appl_z2ca_dhl_stradb) = z2cl_ca_appl_z2ca_dhl_stradb=>get_instance(
                                        VALUE #( country = 'DE'
                                                 post_code1 = '78315'
                                                 street = 'Güttinger Strasse'
                                                 house_num1   = '24'
                                                 city1     = 'Radolfzel' ) ).
    lo_appl_z2ca_dhl_stradb = z2cl_ca_appl_z2ca_dhl_stradb=>get_instance(
                                  VALUE #( country = 'DE'
                                           post_code1 = '78315'
                                           street = 'Güttinger Strasse'
                                           house_num1   = '23'
                                           city1     = 'Radolfzell' ) ).
    cl_abap_unit_assert=>assert_bound( act = lo_appl_z2ca_dhl_stradb
                                       msg = 'Keine Instanz erzeugt' ).
  ENDMETHOD.

  METHOD t051_instance_get.
    TRY.
        DATA(lo_appl_z2ca_dhl_stradb) = z2cl_ca_appl_z2ca_dhl_stradb=>get_instance(
                                            VALUE #( country = 'ZZ'
                                                     post_code1 = '78315'
                                                     street = 'Güttinger Strasse'
                                                     house_num1   = '24'
                                                     city1     = 'Radolfzel' ) ).
      CATCH zcx_ca_dhl_country_not_in_use ##NO_HANDLER.
    ENDTRY.
    cl_abap_unit_assert=>assert_not_bound( act = lo_appl_z2ca_dhl_stradb
                                           msg = 'Keine Instanz erwartet' ).
  ENDMETHOD.

  METHOD t052_instance_free.
    DATA(lv_has_instance_before) = z2cl_ca_appl_z2ca_dhl_stradb=>has_instance(
                                       VALUE #( country = 'DE'
                                                post_code1 = '78315'
                                                street = 'Güttinger Strasse'
                                                house_num1   = '23'
                                                city1     = 'Radolfzell' ) ).

    z2cl_ca_appl_z2ca_dhl_stradb=>free_instance(
        VALUE #( country = 'DE'
                 post_code1 = '78315'
                 street = 'Güttinger Strasse'
                 house_num1   = '23'
                 city1     = 'Radolfzell' ) ).

    DATA(lv_has_instance_after) = z2cl_ca_appl_z2ca_dhl_stradb=>has_instance(
                                      VALUE #( country = 'DE'
                                               post_code1 = '78315'
                                               street = 'Güttinger Strasse'
                                               house_num1   = '23'
                                               city1     = 'Radolfzell' ) ).

    cl_abap_unit_assert=>assert_differs( act = lv_has_instance_after
                                         exp = lv_has_instance_before
                                         msg = 'Instanz wurde nicht wie erwartet gelöscht' ).

    TEST-INJECTION determine_database_entries.
      mt_instance_database_entries = VALUE #( ( plz = '78315'
                                                name_sort = 'Güttinger Strasse'
                                                code = '000' ) ).
    END-TEST-INJECTION.
  ENDMETHOD.

  METHOD t053_instances_free.
    TRY.
        z2cl_ca_appl_z2ca_dhl_stradb=>get_instance(
            VALUE #( country = 'DE'
                     post_code1 = '78315'
                     street = 'Güttinger Strasse'
                     house_num1   = '23'
                     city1     = 'Radolfzell' ) ).
      CATCH zcx_ca_dhl_country_not_in_use ##NO_HANDLER.
    ENDTRY.

    DATA(lv_has_instances_before) = z2cl_ca_appl_z2ca_dhl_stradb=>has_instances( ).

    z2cl_ca_appl_z2ca_dhl_stradb=>free_instances( ).

    DATA(lv_has_instances_after) = z2cl_ca_appl_z2ca_dhl_stradb=>has_instances( ).

    cl_abap_unit_assert=>assert_differs( act = lv_has_instances_after
                                         exp = lv_has_instances_before
                                         msg = 'Instanzen wurde nicht wie erwartet gelöscht' ).

    TEST-INJECTION determine_database_entries.
      mt_instance_database_entries = VALUE #( ( plz = '78315'
                                                name_sort = 'Güttinger Strasse'
                                                code = '000' ) ).
*      APPEND VALUE #( plz = '78315'
*                      name_sort = 'Güttinger Strasse'
*                      code = '000' ) TO mt_instance_database_entries.
    END-TEST-INJECTION.
  ENDMETHOD.

  METHOD t100_get_street_code.
    TEST-INJECTION determine_database_entries.
      mt_instance_database_entries = VALUE #( ( plz = '78315'
                                                name_sort = 'Güttinger Strasse'
                                                code = '000' ) ).
    END-TEST-INJECTION.

    DATA(lv_street_code_expected) = CONV z2ca_dhl_code( '000' ).
    TRY.
        DATA(lv_street_code) = z2cl_ca_appl_z2ca_dhl_stradb=>get_instance(
                                   VALUE #( country = 'DE'
                                            post_code1 = '78315'
                                            street = 'Güttinger Strasse'
                                            house_num1   = '23'
                                            city1     = 'Radolfzell' ) )->get_street_code( ).
      CATCH zcx_ca_dhl_country_not_in_use ##NO_HANDLER.
    ENDTRY.

    cl_abap_unit_assert=>assert_equals( act = lv_street_code
                                        exp = lv_street_code_expected
                                        msg = |Erwarteter Strassencode { lv_street_code_expected } nicht erhalten| ).

  ENDMETHOD.

  METHOD t101_get_street_code.
    TEST-INJECTION determine_database_entries.
      mt_instance_database_entries = VALUE #( ( plz = '78267'
                                                name_sort = 'MUEHLENSTR'
                                                code = '013' ) ).
    END-TEST-INJECTION.

    DATA(lv_street_code_expected) = CONV z2ca_dhl_code( '013' ).
    TRY.
        DATA(lv_street_code) = z2cl_ca_appl_z2ca_dhl_stradb=>get_instance(
                                   VALUE #( country = 'DE'
                                            post_code1 = '78267'
                                            street = 'Mühlenstrasse' ) )->get_street_code( ).
      CATCH zcx_ca_dhl_country_not_in_use ##NO_HANDLER.
    ENDTRY.

    cl_abap_unit_assert=>assert_equals( act = lv_street_code
                                        exp = lv_street_code_expected
                                        msg = |Erwarteter Strassencode { lv_street_code_expected } nicht erhalten| ).

  ENDMETHOD.

  METHOD t102_get_street_code.
    TEST-INJECTION determine_database_entries.
      mt_instance_database_entries = VALUE #( ( plz = '78267'
                                                name_sort = 'KOENIGRUDOLFSTR'
                                                code = '044' ) ).
    END-TEST-INJECTION.

    DATA(lv_street_code_expected) = CONV z2ca_dhl_code( '044' ).
    TRY.
        DATA(lv_street_code) = z2cl_ca_appl_z2ca_dhl_stradb=>get_instance(
                                   VALUE #( country = 'DE'
                                            post_code1 = '78267'
                                            street = 'König-Rudolf-Str.' ) )->get_street_code( ).
      CATCH zcx_ca_dhl_country_not_in_use ##NO_HANDLER.
    ENDTRY.

    cl_abap_unit_assert=>assert_equals( act = lv_street_code
                                        exp = lv_street_code_expected
                                        msg = |Erwarteter Strassencode { lv_street_code_expected } nicht erhalten| ).
  ENDMETHOD.

  METHOD t103_get_street_code.
    TEST-INJECTION determine_database_entries.
      mt_instance_database_entries = VALUE #( ( plz = '78267'
                                                name_sort = 'LAENGENBERGSTR'
                                                code = '031' ) ).
    END-TEST-INJECTION.

    DATA(lv_street_code_expected) = CONV z2ca_dhl_code( '031' ).
    TRY.
        DATA(lv_street_code) = z2cl_ca_appl_z2ca_dhl_stradb=>get_instance(
                                   VALUE #( country = 'DE'
                                            post_code1 = '78267'
                                            street = 'Längenbergstr.' ) )->get_street_code( ).
      CATCH zcx_ca_dhl_country_not_in_use ##NO_HANDLER.
    ENDTRY.

    cl_abap_unit_assert=>assert_equals( act = lv_street_code
                                        exp = lv_street_code_expected
                                        msg = |Erwarteter Strassencode { lv_street_code_expected } nicht erhalten| ).
  ENDMETHOD.

  METHOD t104_get_street_code.
    TEST-INJECTION determine_database_entries.
      mt_instance_database_entries = VALUE #( ( plz = '78267'
                                                name_sort = 'AUFDEMOESCH'
                                                code = '040' ) ).
    END-TEST-INJECTION.

    DATA(lv_street_code_expected) = CONV z2ca_dhl_code( '040' ).
    TRY.
        DATA(lv_street_code) = z2cl_ca_appl_z2ca_dhl_stradb=>get_instance(
                                   VALUE #( country = 'DE'
                                            post_code1 = '78267'
                                            street = 'Auf dem Ösch' ) )->get_street_code( ).
      CATCH zcx_ca_dhl_country_not_in_use ##NO_HANDLER.
    ENDTRY.

    cl_abap_unit_assert=>assert_equals( act = lv_street_code
                                        exp = lv_street_code_expected
                                        msg = |Erwarteter Strassencode { lv_street_code_expected } nicht erhalten| ).
  ENDMETHOD.

  METHOD t105_get_street_code.
    TEST-INJECTION determine_database_entries.
      mt_instance_database_entries = VALUE #( ( plz = '78267'
                                                name_sort = 'GRAEFINHELENESTR'
                                                code = '048' ) ).
    END-TEST-INJECTION.

    DATA(lv_street_code_expected) = CONV z2ca_dhl_code( '048' ).
    TRY.
        DATA(lv_street_code) = z2cl_ca_appl_z2ca_dhl_stradb=>get_instance(
                                   VALUE #( country = 'DE'
                                            post_code1 = '78267'
                                            street = 'Gräfin-Helene-Strasse' ) )->get_street_code( ).
      CATCH zcx_ca_dhl_country_not_in_use ##NO_HANDLER.
    ENDTRY.

    cl_abap_unit_assert=>assert_equals( act = lv_street_code
                                        exp = lv_street_code_expected
                                        msg = |Erwarteter Strassencode { lv_street_code_expected } nicht erhalten| ).
  ENDMETHOD.

  METHOD t106_get_street_code.
    TEST-INJECTION determine_database_entries.
      mt_instance_database_entries = VALUE z2ca_dhl_stradb_t(
                                       ( plz = '12345'
                                         name_sort = 'GRAEFINHELENESTR'
                                         alort = ''
                                         hnr_typ = 'G'
                                         hnr_von = '2'
                                         hnr_bis = '30'
                                         code = '048' )
                                       ( plz = '12345'
                                         name_sort = 'GRAEFINHELENESTR'
                                         alort = ''
                                         hnr_typ = 'U'
                                         hnr_von = '1'
                                         hnr_bis = '31'
                                         code = '049' ) ).
    END-TEST-INJECTION.

    DATA(lv_street_code_expected) = CONV z2ca_dhl_code( '049' ).
    TRY.
        DATA(lv_street_code) = z2cl_ca_appl_z2ca_dhl_stradb=>get_instance(
                                   VALUE #( country = 'DE'
                                            post_code1 = '12345'
                                            street = 'Gräfin-Helene-Strasse'
                                            house_num1 = '27' ) )->get_street_code( ).
      CATCH zcx_ca_dhl_country_not_in_use ##NO_HANDLER.
    ENDTRY.

    cl_abap_unit_assert=>assert_equals( act = lv_street_code
                                        exp = lv_street_code_expected
                                        msg = |Erwarteter Strassencode { lv_street_code_expected } nicht erhalten| ).
  ENDMETHOD.

  METHOD t107_get_street_code.
    TEST-INJECTION determine_database_entries.
      mt_instance_database_entries = VALUE z2ca_dhl_stradb_t(
                                       ( plz = '12345'
                                         name_sort = 'GRAEFINHELENESTR'
                                         alort = ''
                                         hnr_typ = 'G'
                                         hnr_von = '2'
                                         hnr_bis = '30'
                                         code = '048' )
                                       ( plz = '12345'
                                         name_sort = 'GRAEFINHELENESTR'
                                         alort = ''
                                         hnr_typ = 'U'
                                         hnr_von = '1'
                                         hnr_bis = '31'
                                         code = '049' ) ).
    END-TEST-INJECTION.

    DATA(lv_street_code_expected) = CONV z2ca_dhl_code( '048' ).
    TRY.
        DATA(lo_stradb) = z2cl_ca_appl_z2ca_dhl_stradb=>get_instance(
                              VALUE #( country = 'DE'
                                       post_code1 = '12345'
                                       street = 'Gräfin-Helene-Strasse'
                                       house_num1 = '18' ) ).

        IF lo_stradb->is_valid( ).
          DATA(lv_street_code) = lo_stradb->get_street_code( ).
        ENDIF.
      CATCH zcx_ca_dhl_country_not_in_use ##NO_HANDLER.
    ENDTRY.

    cl_abap_unit_assert=>assert_equals( act = lv_street_code
                                        exp = lv_street_code_expected
                                        msg = |Erwarteter Strassencode { lv_street_code_expected } nicht erhalten| ).
  ENDMETHOD.

  METHOD t108_get_street_code.
    TEST-INJECTION determine_database_entries.
      mt_instance_database_entries = VALUE z2ca_dhl_stradb_t(
                                       ( plz = '54321'
                                         name_sort = 'HAUPTSTR'
                                         alort = '12345678'
                                         hnr_typ = 'G'
                                         hnr_von = '2'
                                         hnr_bis = '30'
                                         code = '048' )
                                       ( plz = '5321'
                                         name_sort = 'HAUPTSTR'
                                         alort = '23456789'
                                         hnr_typ = 'U'
                                         hnr_von = '1'
                                         hnr_bis = '31'
                                         code = '049' ) ).
    END-TEST-INJECTION.
    TEST-INJECTION get_location_name.
      CASE lr_instance_database_entry->alort.
        WHEN '12345678'.
          IF ms_get_instance_key-city1 EQ 'Singen'.
            rv_street_code = '048'.
            EXIT.
          ENDIF.
        WHEN '23456789'.
          IF ms_get_instance_key-city1 EQ 'Radolfzell'.
            rv_street_code = '049'.
            EXIT.
          ENDIF.
      ENDCASE.
    END-TEST-INJECTION.

    DATA(lv_street_code_expected) = CONV z2ca_dhl_code( '049' ).
    TRY.
      CATCH zcx_ca_dhl_country_not_in_use ##NO_HANDLER.
    ENDTRY.
    DATA(lv_street_code) = z2cl_ca_appl_z2ca_dhl_stradb=>get_instance(
                               VALUE #( country = 'DE'
                                        post_code1 = '12345'
                                        street = 'Hauptstraße'
                                        house_num1 = 'A18'
                                        city1 = 'Radolfzell' ) )->get_street_code( ).

    cl_abap_unit_assert=>assert_equals( act = lv_street_code
                                        exp = lv_street_code_expected
                                        msg = |Erwarteter Strassencode { lv_street_code_expected } nicht erhalten| ).
  ENDMETHOD.

  METHOD t109_get_street_code.
    TEST-INJECTION determine_database_entries.
    END-TEST-INJECTION.

    DATA(lv_street_code_expected) = CONV z2ca_dhl_code( '000' ).

    TRY.
      CATCH zcx_ca_dhl_country_not_in_use ##NO_HANDLER.
    ENDTRY.
    DATA(lo_stradb) = z2cl_ca_appl_z2ca_dhl_stradb=>get_instance(
                          VALUE #( country = 'DE'
                                   post_code1 = '23456'
                                   street = 'Gräfin-Helene-Strasse'
                                   house_num1 = '18' ) ).

    DATA(lv_street_code) = lo_stradb->get_street_code( ).

    cl_abap_unit_assert=>assert_equals( act = lv_street_code
                                        exp = lv_street_code_expected
                                        msg = |Erwarteter Strassencode { lv_street_code_expected } nicht erhalten| ).
  ENDMETHOD.

  METHOD t110_get_street_code.
    TEST-INJECTION determine_database_entries.
      mt_instance_database_entries = VALUE z2ca_dhl_stradb_t(
                                       ( plz = '39343'
                                         name_sort = 'DORFSTR'
                                         alort = '00155000'
                                         hnr_typ = 'G'
                                         str_nam_schl = '027695'
                                         str_bu_lfdnr = '00121'
                                         hnr_von = ''
                                         hnr_bis = ''
                                         code = '030' )
                                       ( plz = '39343'
                                         name_sort = 'DORFSTR'
                                         alort = '00155000'
                                         hnr_typ = 'G'
                                         str_nam_schl = '027695'
                                         str_bu_lfdnr = '00122'
                                         hnr_von = ''
                                         hnr_bis = ''
                                         code = '031' ) ).
    END-TEST-INJECTION.
    TEST-INJECTION get_location_name.
      IF ms_get_instance_key-city1 EQ 'Ackendorf'.
        rv_street_code = '000'.
        EXIT.
      ENDIF.
    END-TEST-INJECTION.

    DATA(lv_street_code_expected) = CONV z2ca_dhl_code( '000' ).
    TRY.
      CATCH zcx_ca_dhl_country_not_in_use ##NO_HANDLER.
    ENDTRY.
    DATA(lv_street_code) = z2cl_ca_appl_z2ca_dhl_stradb=>get_instance(
                               VALUE #( country = 'DE'
                                        post_code1 = '39343'
                                        street = 'Dorfstrasse'
                                        house_num1 = '1'
                                        city1 = 'Ackendorf' ) )->get_street_code( ).

    cl_abap_unit_assert=>assert_equals( act = lv_street_code
                                        exp = lv_street_code_expected
                                        msg = |Erwarteter Strassencode { lv_street_code_expected } nicht erhalten| ).
  ENDMETHOD.

  METHOD t150_db_insert.
    DATA lt_return_expected TYPE bapiret2_tab.

    DATA(lt_dhl_import_file_data) = VALUE z2ca_dhl_import_file_data_t(
      ( |SBA403061202307210000210062659300001                G01| &&
        |IMWOELFERTSBUEHL                              I| &&
        |m Wölfertsbühl                               Im Wölfertsbühl        N| &&
        |78267052   1318807008335001                                   $| ) ).
    DATA(lt_return) = z2cl_ca_appl_z2ca_dhl_stradb=>insert_entries_into_db(
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

    cl_abap_unit_assert=>assert_equals( act = lt_return
                                        exp = lt_return_expected
                                        msg = 'Erwartete Fehlertablle ungleich erhalten' ).
  ENDMETHOD.

  METHOD t151_db_insert.
    DATA lt_return_expected TYPE bapiret2_tab.

    DATA(lt_dhl_import_file_data) = VALUE z2ca_dhl_import_file_data_t(
      ( |SB       199910270000210007655300119                G01| &&
        |MUEHLENSTR                                    M| &&
        |ühlenstr.                                    Mühlenstr.             N| &&
        |78267013   1318807008335001                                   $| ) ).
    DATA(lt_return) = z2cl_ca_appl_z2ca_dhl_stradb=>insert_entries_into_db(
                          it_dhl_import_file_data = lt_dhl_import_file_data
                          iv_display_progress     = abap_true
                          iv_test                 = abap_true ).

    MESSAGE e001 WITH 'VERSION'
                      '78267'
                      '00002100'
                      'MUEHLENSTR'
                 INTO DATA(lv_message).
    APPEND VALUE #( BASE ycl_abap_services=>get_bapiret2_from_sy( )
                    row = lines( lt_return_expected ) + 1 )
           TO lt_return_expected.

    cl_abap_unit_assert=>assert_equals( act = lt_return
                                        exp = lt_return_expected
                                        msg = 'Erwartete Fehlertablle ungleich erhalten' ).
  ENDMETHOD.

  METHOD t152_db_insert.
    DATA lt_return_expected TYPE bapiret2_tab.

    DATA(lt_dhl_import_file_data) = VALUE z2ca_dhl_import_file_data_t(
      ( |SB2403061200903040000210024793100003                G01| &&
        |                                              K| &&
        |önig-Rudolf-Str.                             König-Rudolf-Str.      N| &&
        |78267044   1318807008335001                                   $| ) ).
    DATA(lt_return) = z2cl_ca_appl_z2ca_dhl_stradb=>insert_entries_into_db(
                          it_dhl_import_file_data = lt_dhl_import_file_data
                          iv_display_progress     = abap_true
                          iv_test                 = abap_true ).

    MESSAGE e001 WITH 'NAME_SORT'
                      '78267'
                      '00002100'
                      ''
                 INTO DATA(lv_message).
    APPEND VALUE #( BASE ycl_abap_services=>get_bapiret2_from_sy( )
                    row = lines( lt_return_expected ) + 1 )
           TO lt_return_expected.

    cl_abap_unit_assert=>assert_equals( act = lt_return
                                        exp = lt_return_expected
                                        msg = 'Erwartete Fehlertablle ungleich erhalten' ).
  ENDMETHOD.

  METHOD t153_db_insert.
    DATA lt_return_expected TYPE bapiret2_tab.

    DATA(lt_dhl_import_file_data) = VALUE z2ca_dhl_import_file_data_t(
      ( |SB240306119991027        27188900001                G01| &&
        |LAENGENBERGSTR                                L| &&
        |ängenbergstr.                                Längenbergstr.         N| &&
        |78267031   1318807008335001                                   $| ) ).
    DATA(lt_return) = z2cl_ca_appl_z2ca_dhl_stradb=>insert_entries_into_db(
                          it_dhl_import_file_data = lt_dhl_import_file_data
                          iv_display_progress     = abap_true
                          iv_test                 = abap_true ).

    MESSAGE e001 WITH 'ALORT'
                      '78267'
                      '00000000'
                      'LAENGENBERGSTR'
                 INTO DATA(lv_message).
    APPEND VALUE #( BASE ycl_abap_services=>get_bapiret2_from_sy( )
                    row = lines( lt_return_expected ) + 1 )
           TO lt_return_expected.

    cl_abap_unit_assert=>assert_equals( act = lt_return
                                        exp = lt_return_expected
                                        msg = 'Erwartete Fehlertablle ungleich erhalten' ).
  ENDMETHOD.

  METHOD t154_db_insert.
    DATA lt_return_expected TYPE bapiret2_tab.

    DATA(lt_dhl_import_file_data) = VALUE z2ca_dhl_import_file_data_t(
      ( |SB2403061200011070000210039405100002                G01| &&
        |AUFDEMOESCH                                   A| &&
        |uf dem Ösch                                  Auf dem Ösch           N| &&
        |     040   1318807008335001                                   $| ) ).
    DATA(lt_return) = z2cl_ca_appl_z2ca_dhl_stradb=>insert_entries_into_db(
                          it_dhl_import_file_data = lt_dhl_import_file_data
                          iv_display_progress     = abap_true
                          iv_test                 = abap_true ).

    MESSAGE e001 WITH 'PLZ'
                      '00000'
                      '00002100'
                      'AUFDEMOESCH'
                 INTO DATA(lv_message).
    APPEND VALUE #( BASE ycl_abap_services=>get_bapiret2_from_sy( )
                    row = lines( lt_return_expected ) + 1 )
           TO lt_return_expected.

    cl_abap_unit_assert=>assert_equals( act = lt_return
                                        exp = lt_return_expected
                                        msg = 'Erwartete Fehlertablle ungleich erhalten' ).
  ENDMETHOD.

  METHOD t155_db_insert.
    DATA lt_return_expected TYPE bapiret2_tab.

    DATA(lt_dhl_import_file_data) = VALUE z2ca_dhl_import_file_data_t(
      ( |SB2403061201404300000210058983600001                G01| &&
        |GRAEFINHELENESTR                              G| &&
        |räfin-Helene-Str.                            Gräfin-Helene-Str.      | &&
        |78267048   1318807008335001                                   $| ) ).
    DATA(lt_return) = z2cl_ca_appl_z2ca_dhl_stradb=>insert_entries_into_db(
                          it_dhl_import_file_data = lt_dhl_import_file_data
                          iv_display_progress     = abap_true
                          iv_test                 = abap_true ).

    MESSAGE e001 WITH 'HNR_TYP'
                      '78267'
                      '00002100'
                      'GRAEFINHELENESTR'
                 INTO DATA(lv_message).
    APPEND VALUE #( BASE ycl_abap_services=>get_bapiret2_from_sy( )
                    row = lines( lt_return_expected ) + 1 )
           TO lt_return_expected.

    cl_abap_unit_assert=>assert_equals( act = lt_return
                                        exp = lt_return_expected
                                        msg = 'Erwartete Fehlertablle ungleich erhalten' ).
  ENDMETHOD.

  METHOD t156_db_insert.
    DATA lt_return_expected TYPE bapiret2_tab.

    DATA(lt_dhl_import_file_data) = VALUE z2ca_dhl_import_file_data_t(
      ( |SB2403061202307210000210062659300001                G01| &&
        |IMWOELFERTSBUEHL                              I| &&
        |m Wölfertsbühl                               Im Wölfertsbühl        N| &&
        |78267000   1318807008335001                                   $| ) ).
    DATA(lt_return) = z2cl_ca_appl_z2ca_dhl_stradb=>insert_entries_into_db(
                          it_dhl_import_file_data = lt_dhl_import_file_data
                          iv_display_progress     = abap_true
                          iv_test                 = abap_true ).

    cl_abap_unit_assert=>assert_equals( act = lt_return
                                        exp = lt_return_expected
                                        msg = 'Erwartete Fehlertablle ungleich erhalten' ).
  ENDMETHOD.

  METHOD t157_db_insert.
    DATA lt_return_expected TYPE bapiret2_tab.

    DATA(lt_dhl_import_file_data) = VALUE z2ca_dhl_import_file_data_t(
      ( |SB2403061202307210000210062659300001                G01| &&
        |IMWOELFERTSBUEHL                              I| &&
        |m Wölfertsbühl                               Im Wölfertsbühl        N| &&
        |78267052   1318807008335001                                   $| ) ).
    DATA(lt_return) = z2cl_ca_appl_z2ca_dhl_stradb=>insert_entries_into_db(
                          it_dhl_import_file_data = lt_dhl_import_file_data
                          iv_display_progress     = abap_true
                          iv_test                 = abap_true ).

    MESSAGE s009 WITH 'Z2CA_DHL_STRADB'
                 INTO DATA(lv_message).
    APPEND VALUE #( BASE ycl_abap_services=>get_bapiret2_from_sy( )
                    row = lines( lt_return_expected ) + 1 )
           TO lt_return_expected.

    cl_abap_unit_assert=>assert_equals( act = lt_return
                                        exp = lt_return_expected
                                        msg = 'Erwartete Fehlertablle ungleich erhalten' ).
  ENDMETHOD.

  METHOD t158_db_insert.
    DATA lt_return_expected TYPE bapiret2_tab.

    DATA(lt_dhl_import_file_data) = VALUE z2ca_dhl_import_file_data_t(
      ( |SB2303061202307210000210062659300001                G01| &&
        |IMWOELFERTSBUEHL                              I| &&
        |m Wölfertsbühl                               Im Wölfertsbühl        N| &&
        |78267052   1318807008335001                                   $| ) ).
    DATA(lt_return) = z2cl_ca_appl_z2ca_dhl_stradb=>insert_entries_into_db(
                          it_dhl_import_file_data = lt_dhl_import_file_data
                          iv_display_progress     = abap_true
                          iv_test                 = abap_true ).

    MESSAGE e008 WITH '2303061'
                      'Z2CA_DHL_STRADB'
                 INTO DATA(lv_message).
    APPEND VALUE #( BASE ycl_abap_services=>get_bapiret2_from_sy( )
                    row = lines( lt_return_expected ) + 1 )
           TO lt_return_expected.

    cl_abap_unit_assert=>assert_equals( act = lt_return
                                        exp = lt_return_expected
                                        msg = 'Erwartete Fehlertablle ungleich erhalten' ).
  ENDMETHOD.

  METHOD t159_db_insert.
    DATA lt_return_expected TYPE bapiret2_tab.

    DATA(lt_dhl_import_file_data) = VALUE z2ca_dhl_import_file_data_t(
      ( |SB2303060202307210000210062659300001                G01| &&
        |IMWOELFERTSBUEHL                              I| &&
        |m Wölfertsbühl                               Im Wölfertsbühl        N| &&
        |78267052   1318807008335001                                   $| ) ).
    DATA(lt_return) = z2cl_ca_appl_z2ca_dhl_stradb=>insert_entries_into_db(
                          it_dhl_import_file_data = lt_dhl_import_file_data
                          iv_display_progress     = abap_true
                          iv_test                 = abap_true ).

    MESSAGE e010 WITH '2303060'
                      '2303061'
                      'Z2CA_DHL_STRADB'
                 INTO DATA(lv_message).
    APPEND VALUE #( BASE ycl_abap_services=>get_bapiret2_from_sy( )
                    row = lines( lt_return_expected ) + 1 )
           TO lt_return_expected.

    cl_abap_unit_assert=>assert_equals( act = lt_return
                                        exp = lt_return_expected
                                        msg = 'Erwartete Fehlertablle ungleich erhalten' ).
  ENDMETHOD.
ENDCLASS.
