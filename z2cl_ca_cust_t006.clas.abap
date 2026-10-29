CLASS z2cl_ca_cust_t006 DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    "! <p class="shorttext synchronized">Get unit of measurement instance</p>
    "!
    "! @parameter iv_unit_of_measurement | <p class="shorttext synchronized">Unit of measurement</p>
    "! @parameter ro_instance | <p class="shorttext synchronized">Unit of measurement instance</p>
    CLASS-METHODS get_insatnce
      IMPORTING
        iv_unit_of_measurement TYPE msehi
      RETURNING
        VALUE(ro_instance)     TYPE REF TO z2cl_ca_cust_t006.

    "! <p class="shorttext synchronized">Get ISO Code for Unit of Measurement</p>
    "!
    "! @parameter rv_iso_code | <p class="shorttext synchronized">ISO Code for Unit of Measurement</p>
    METHODS get_iso_code
      RETURNING
        VALUE(rv_iso_code) TYPE isocd_unit.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      "! <p class="shorttext synchronized">Instance</p>
      BEGIN OF ty_instance,
        unit_of_measurement TYPE msehi,
        instance            TYPE REF TO z2cl_ca_cust_t006,
      END OF ty_instance.
    "! <p class="shorttext synchronized">Instances</p>
    TYPES tty_instances TYPE STANDARD TABLE OF ty_instance.

    "! <p class="shorttext synchronized">Table with instances</p>
    CLASS-DATA gt_instances TYPE tty_instances.
    "! <p class="shorttext synchronized">Unit of measurement</p>
    DATA mv_unit_of_measurement TYPE msehi.
    "! <p class="shorttext synchronized">Unit of measurement data</p>
    DATA ms_unit_of_measurement_data TYPE t006.

    "! <p class="shorttext synchronized">Constructor</p>
    "!
    "! @parameter iv_unit_of_measurement | <p class="shorttext synchronized">Unit of measurement</p>
    METHODS constructor
      IMPORTING
        iv_unit_of_measurement TYPE msehi.

    "! <p class="shorttext synchronized">Determine unit of measurement data</p>
    "!
    METHODS _determine_unit_data.

ENDCLASS.



CLASS z2cl_ca_cust_t006 IMPLEMENTATION.
  METHOD constructor.
    mv_unit_of_measurement = iv_unit_of_measurement.
    _determine_unit_data( ).
    APPEND VALUE #( unit_of_measurement = iv_unit_of_measurement
                    instance = me )
           TO gt_instances.
  ENDMETHOD.

  METHOD get_insatnce.
    ro_instance = COND #( WHEN line_exists( gt_instances[ unit_of_measurement = iv_unit_of_measurement ] )
                          THEN gt_instances[ unit_of_measurement = iv_unit_of_measurement ]-instance
                          ELSE NEW #( iv_unit_of_measurement ) ).
  ENDMETHOD.

  METHOD get_iso_code.
    rv_iso_code = ms_unit_of_measurement_data-isocode.
  ENDMETHOD.

  METHOD _determine_unit_data.
    SELECT SINGLE FROM t006
           FIELDS *
           WHERE msehi EQ @mv_unit_of_measurement
           INTO @ms_unit_of_measurement_data.
  ENDMETHOD.
ENDCLASS.
