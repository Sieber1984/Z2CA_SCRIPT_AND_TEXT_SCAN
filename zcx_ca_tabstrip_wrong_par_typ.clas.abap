"! <p class="shorttext synchronized" lang="en">Wrong type for parameter</p>
CLASS zcx_ca_tabstrip_wrong_par_typ DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES if_t100_dyn_msg.
    INTERFACES if_t100_message.

    ALIASES ms_t100key FOR if_t100_message~t100key.

    CONSTANTS:
      BEGIN OF zcx_ca_tabstrip_wrong_par_typ,
        msgid TYPE symsgid VALUE 'Z2CA_TABSTRIP_TAB',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE 'MV_PARAMETER',
        attr2 TYPE scx_attrname VALUE 'MV_TYPE',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF zcx_ca_tabstrip_wrong_par_typ.

    DATA:
      mv_parameter TYPE seosconame,
      mv_type      TYPE seosconame.

    METHODS constructor
      IMPORTING
        textid       TYPE scx_t100key OPTIONAL
        previous     TYPE REF TO cx_root OPTIONAL
        iv_parameter TYPE seosconame
        iv_type      TYPE seosconame.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCX_CA_TABSTRIP_WRONG_PAR_TYP IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.

    mv_parameter = iv_parameter.
    mv_type = iv_type.

    CLEAR me->textid.
    IF textid IS INITIAL.
      ms_t100key = zcx_ca_tabstrip_wrong_par_typ.
    ELSE.
      ms_t100key = textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
