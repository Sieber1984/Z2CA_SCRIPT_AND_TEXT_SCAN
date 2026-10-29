"! <p class="shorttext synchronized">Check Switch-Framework</p>
CLASS z2cl_ca_check_sfw DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    "! <p class="shorttext synchronized">Development Key</p>
    DATA mv_devkey TYPE ybc_sfw_id_mod READ-ONLY.
    "! <p class="shorttext synchronized">Parameter for Organisational Units</p>
    DATA mv_param TYPE ybc_sfw_param READ-ONLY.

    "! <p class="shorttext synchronized">Get instance</p>
    "!
    "! @parameter iv_devkey   | <p class="shorttext synchronized">Development Key</p>
    "! @parameter iv_param    | <p class="shorttext synchronized">Parameter for Organisational Units</p>
    "! @parameter ro_instance | <p class="shorttext synchronized">Instance</p>
    CLASS-METHODS get_instance
      IMPORTING
        iv_devkey          TYPE ybc_sfw_id_mod
        iv_param           TYPE ybc_sfw_param OPTIONAL
      RETURNING
        VALUE(ro_instance) TYPE REF TO z2cl_ca_check_sfw.

    "! <p class="shorttext synchronized">Is Switch-Framework active</p>
    "!
    "! @parameter rv_sfw_active | <p class="shorttext synchronized">Switch-Framework is active</p>
    METHODS is_sfw_active
      RETURNING
        VALUE(rv_sfw_active) TYPE ybc_sfw_aktiv_cs.

  PRIVATE SECTION.
    "! <p class="shorttext synchronized">Instances</p>
    CLASS-DATA gt_instances TYPE TABLE OF REF TO z2cl_ca_check_sfw.

    "! <p class="shorttext synchronized">Switch-Framework is active</p>
    DATA mv_sfw_active TYPE ybc_sfw_aktiv_cs.

    "! <p class="shorttext synchronized">Constructor</p>
    "!
    "! @parameter iv_devkey | <p class="shorttext synchronized">Development Key</p>
    "! @parameter iv_param  | <p class="shorttext synchronized">Parameter for Organisational Units</p>
    METHODS constructor
      IMPORTING
        iv_devkey TYPE ybc_sfw_id_mod
        iv_param  TYPE ybc_sfw_param.

    "! <p class="shorttext synchronized">Check development key</p>
    "!
    METHODS _check_devkey.

ENDCLASS.



CLASS Z2CL_CA_CHECK_SFW IMPLEMENTATION.


  METHOD constructor.
    mv_devkey = iv_devkey.
    mv_param = iv_param.
    _check_devkey( ).
    APPEND me TO gt_instances.
  ENDMETHOD.


  METHOD get_instance.
    ro_instance = COND #( WHEN line_exists( gt_instances[
                                                table_line->mv_devkey = iv_devkey
                                                table_line->mv_param  = iv_param ] )
                          THEN gt_instances[ table_line->mv_devkey = iv_devkey
                                             table_line->mv_param  = iv_param ]
                          ELSE NEW #( iv_devkey = iv_devkey
                                      iv_param  = iv_param ) ). "#EC CI_STDSEQ
  ENDMETHOD.


  METHOD _check_devkey.
    mv_sfw_active = ybc_sfw_devcheck=>ybc_sfw_check_devkey(
                        iv_devkey = mv_devkey
                        iv_param  = mv_param ).
  ENDMETHOD.


  METHOD is_sfw_active.
    rv_sfw_active = mv_sfw_active.
  ENDMETHOD.
ENDCLASS.
