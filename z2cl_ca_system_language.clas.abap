CLASS z2cl_ca_system_language DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    "! <p class="shorttext synchronized" lang="en">Installed languages as table</p>
    "!
    TYPES tty_installed_languages TYPE STANDARD TABLE OF sbiwa_s_langu
                                  WITH EMPTY KEY.
    "! <p class="shorttext synchronized" lang="en">Languages as range</p>
    "!
    TYPES tty_spras_range TYPE RANGE OF syst_langu.

    "! <p class="shorttext synchronized" lang="en">Get instance</p>
    "!
    "! @parameter ro_instance | <p class="shorttext synchronized" lang="en">Instance</p>
    CLASS-METHODS get_instance
      RETURNING
        VALUE(ro_instance) TYPE REF TO z2cl_ca_system_language.

    "! <p class="shorttext synchronized" lang="en">Get installed languages as string</p>
    "!
    "! @parameter rv_installed_languages | <p class="shorttext synchronized" lang="en">Installed languages as string</p>
    METHODS get_installed_languages
      RETURNING
        VALUE(rv_installed_languages) TYPE pfepvalue.

    "! <p class="shorttext synchronized" lang="en">Get installed languages as table</p>
    "!
    "! @parameter rt_installed_languages | <p class="shorttext synchronized" lang="en">Installed languages as table</p>
    METHODS get_installed_languages_table
      RETURNING
        VALUE(rt_installed_languages) TYPE tty_installed_languages.

    "! <p class="shorttext synchronized" lang="en">Get system language</p>
    "!
    "! @parameter rv_system_language | <p class="shorttext synchronized" lang="en">System language</p>
    METHODS get_system_language
      RETURNING
        VALUE(rv_system_language) TYPE syst_langu.

    "! <p class="shorttext synchronized" lang="en">Get second system language</p>
    "!
    "! @parameter rv_second_language | <p class="shorttext synchronized" lang="en">Second system language</p>
    METHODS get_second_language
      RETURNING
        VALUE(rv_second_language) TYPE syst_langu.

    "! <p class="shorttext synchronized" lang="en">Get languages as range</p>
    "!
    "! @parameter iv_primary_language | <p class="shorttext synchronized" lang="en">Primary language</p>
    "! @parameter rt_language_range | <p class="shorttext synchronized" lang="en">Languages as range</p>
    METHODS get_language_range
      IMPORTING
        iv_primary_language TYPE syst_langu DEFAULT sy-langu
      RETURNING
        VALUE(rt_language_range) TYPE z2cl_ca_system_language=>tty_spras_range.

  PROTECTED SECTION.
  PRIVATE SECTION.
    "! <p class="shorttext synchronized" lang="en">Instance</p>
    "!
    CLASS-DATA go_instance TYPE REF TO z2cl_ca_system_language.

    "! <p class="shorttext synchronized" lang="en">System language</p>
    "!
    DATA mv_system_language TYPE syst_langu.
    "! <p class="shorttext synchronized" lang="en">Second system language</p>
    "!
    DATA mv_second_language TYPE pfepvalue.
    "! <p class="shorttext synchronized" lang="en">Installed languages as string</p>
    "!
    DATA mv_installed_languages TYPE pfepvalue.
    "! <p class="shorttext synchronized" lang="en">Installed languages as table</p>
    "!
    DATA mt_installed_languages TYPE STANDARD TABLE OF sbiwa_s_langu.


    "! <p class="shorttext synchronized" lang="en">Constructor</p>
    "!
    METHODS constructor.

    "! <p class="shorttext synchronized" lang="en">Determine system and installed languages</p>
    "!
    METHODS _determine_languages.
ENDCLASS.



CLASS Z2CL_CA_SYSTEM_LANGUAGE IMPLEMENTATION.


  METHOD constructor.
    _determine_languages( ).
    go_instance = me.
  ENDMETHOD.


  METHOD get_instance.
    ro_instance = COND #( WHEN go_instance IS BOUND
                          THEN go_instance
                          ELSE NEW #( ) ).
  ENDMETHOD.


  METHOD get_installed_languages.
    rv_installed_languages = mv_installed_languages.
  ENDMETHOD.


  METHOD get_language_range.
    rt_language_range = VALUE #( sign = 'I'
                                 option = 'EQ'
                                 ( low = iv_primary_language )
                                 ( low = COND #( WHEN iv_primary_language NE mv_system_language
                                                 THEN mv_system_language
                                                 WHEN iv_primary_language NE mv_second_language
                                                 THEN mv_second_language
                                                 WHEN iv_primary_language NE 'E'
                                                 THEN 'E'
                                                 ELSE 'D' ) ) ).
  ENDMETHOD.


  METHOD get_system_language.
    rv_system_language = mv_system_language.
  ENDMETHOD.


  METHOD get_second_language.
    rv_second_language = mv_second_language.
  ENDMETHOD.


  METHOD _determine_languages.
    CALL FUNCTION 'RSAN_SYSTEM_PARAMETERS_GET'
      IMPORTING
        e_zcsa_installed_languages   = mv_installed_languages
        e_zcsa_system_language       = mv_system_language
      TABLES
        e_t_zcsa_installed_languages = mt_installed_languages
      EXCEPTIONS
        read_error                   = 0
        OTHERS                       = 0.

    CALL FUNCTION 'RSAN_SYSTEM_PARAMETER_READ'
      EXPORTING
        i_name     = 'zcsa/second_language'
      IMPORTING
        e_value    = mv_second_language
      EXCEPTIONS
        read_error = 0
        OTHERS     = 0.
  ENDMETHOD.


  METHOD get_installed_languages_table.
    rt_installed_languages = mt_installed_languages.
  ENDMETHOD.
ENDCLASS.
