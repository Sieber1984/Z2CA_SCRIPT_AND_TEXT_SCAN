CLASS z2cl_ca_country_data DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS get_instance
      IMPORTING
        iv_country         TYPE land1
      RETURNING
        VALUE(ro_instance) TYPE REF TO z2cl_ca_country_data.

    METHODS is_country_in_eu
      RETURNING
        VALUE(rv_country_is_eu) TYPE land1.

  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_instance,
             country  TYPE land1,
             instance TYPE REF TO z2cl_ca_country_data,
           END OF ty_instance.

    TYPES tty_instances TYPE STANDARD TABLE OF ty_instance.

    CLASS-DATA gt_instances TYPE tty_instances.

    DATA mv_country TYPE land1.
    DATA ms_country_data TYPE t005.

    METHODS constructor
      IMPORTING
        iv_country TYPE land1.

    METHODS _determine_country_data.
ENDCLASS.



CLASS z2cl_ca_country_data IMPLEMENTATION.
  METHOD constructor.
    mv_country = iv_country.
    _determine_country_data( ).

    APPEND VALUE #( country = iv_country
                    instance = me )
           TO gt_instances.
  ENDMETHOD.

  METHOD get_instance.
    ro_instance = COND #( WHEN line_exists( gt_instances[ country = iv_country ] )
                          THEN gt_instances[ country = iv_country ]-instance
                          ELSE NEW #( iv_country ) ).
  ENDMETHOD.

  METHOD is_country_in_eu.
    rv_country_is_eu = ms_country_data-xegld.
  ENDMETHOD.

  METHOD _determine_country_data.
    SELECT SINGLE FROM t005
           FIELDS *
           WHERE land1 EQ @mv_country
           INTO @ms_country_data.
  ENDMETHOD.
ENDCLASS.
