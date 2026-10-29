CLASS z2cl_ca_plant_data DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS get_instance
      IMPORTING
        iv_plant           TYPE werks_d
      RETURNING
        VALUE(ro_instance) TYPE REF TO z2cl_ca_plant_data.

    METHODS get_country
      RETURNING
        VALUE(rv_country) TYPE land1.

  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_instance,
             plant    TYPE werks_d,
             instance TYPE REF TO z2cl_ca_plant_data,
           END OF ty_instance.

    TYPES tty_instances TYPE STANDARD TABLE OF ty_instance.

    CLASS-DATA gt_instances TYPE tty_instances.

    DATA mv_plant TYPE werks_d.
    DATA ms_plant_data TYPE t001w.

    METHODS constructor
      IMPORTING
        iv_plant TYPE werks_d.

    METHODS _determine_plant_data.

ENDCLASS.



CLASS z2cl_ca_plant_data IMPLEMENTATION.
  METHOD constructor.
    mv_plant = iv_plant.
    _determine_plant_data( ).

    APPEND VALUE #( plant = iv_plant
                    instance = me )
           TO gt_instances.
  ENDMETHOD.

  METHOD get_instance.
    ro_instance = COND #( WHEN line_exists( gt_instances[ plant = iv_plant ] )
                          THEN gt_instances[ plant = iv_plant ]-instance
                          ELSE NEW #( iv_plant ) ).
  ENDMETHOD.

  METHOD get_country.
    rv_country = ms_plant_data-land1.
  ENDMETHOD.

  METHOD _determine_plant_data.
    SELECT SINGLE FROM t001w
           FIELDS *
           WHERE werks EQ @mv_plant
           INTO @ms_plant_data.
  ENDMETHOD.
ENDCLASS.
