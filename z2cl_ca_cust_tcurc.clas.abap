CLASS z2cl_ca_cust_tcurc DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    "! <p class="shorttext synchronized">Get currency_code instance</p>
    "!
    "! @parameter iv_currency_code | <p class="shorttext synchronized">Currency_code</p>
    "! @parameter ro_instance | <p class="shorttext synchronized">Currency_code instance</p>
    CLASS-METHODS get_insatnce
      IMPORTING
        iv_currency_code   TYPE waers_curc
      RETURNING
        VALUE(ro_instance) TYPE REF TO z2cl_ca_cust_tcurc.

    "! <p class="shorttext synchronized">Get ISO currency_code</p>
    "!
    "! @parameter rv_iso_code | <p class="shorttext synchronized">ISO currency_code</p>
    METHODS get_iso_code
      RETURNING
        VALUE(rv_iso_code) TYPE isocd.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      "! <p class="shorttext synchronized">Instance</p>
      BEGIN OF ty_instance,
        currency_code TYPE waers_curc,
        instance      TYPE REF TO z2cl_ca_cust_tcurc,
      END OF ty_instance.
    "! <p class="shorttext synchronized">Instances</p>
    TYPES tty_instances TYPE STANDARD TABLE OF ty_instance.

    "! <p class="shorttext synchronized">Table with instances</p>
    CLASS-DATA gt_instances TYPE tty_instances.
    "! <p class="shorttext synchronized">Currency_code</p>
    DATA mv_currency_code TYPE waers_curc.
    "! <p class="shorttext synchronized">Currency_code data</p>
    DATA ms_currency_code_data TYPE tcurc.

    "! <p class="shorttext synchronized">Constructor</p>
    "!
    "! @parameter iv_currency_code | <p class="shorttext synchronized">Currency_code</p>
    METHODS constructor
      IMPORTING
        iv_currency_code TYPE waers_curc.

    "! <p class="shorttext synchronized">Determine currency_code data</p>
    "!
    METHODS _determine_unit_data.

ENDCLASS.



CLASS z2cl_ca_cust_tcurc IMPLEMENTATION.
  METHOD constructor.
    mv_currency_code = iv_currency_code.
    _determine_unit_data( ).
    APPEND VALUE #( currency_code = iv_currency_code
                    instance = me )
           TO gt_instances.
  ENDMETHOD.

  METHOD get_insatnce.
    ro_instance = COND #( WHEN line_exists( gt_instances[ currency_code = iv_currency_code ] )
                          THEN gt_instances[ currency_code = iv_currency_code ]-instance
                          ELSE NEW #( iv_currency_code ) ).
  ENDMETHOD.

  METHOD get_iso_code.
    rv_iso_code = ms_currency_code_data-isocd.
  ENDMETHOD.

  METHOD _determine_unit_data.
    SELECT SINGLE FROM tcurc
           FIELDS *
           WHERE waers EQ @mv_currency_code
           INTO @ms_currency_code_data.
  ENDMETHOD.
ENDCLASS.
