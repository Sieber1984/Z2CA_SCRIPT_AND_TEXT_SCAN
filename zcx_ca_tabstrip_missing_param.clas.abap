"! <p class="shorttext synchronized" lang="en">Missing parameter for tabstrip</p>
CLASS zcx_ca_tabstrip_missing_param DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES if_t100_dyn_msg.
    INTERFACES if_t100_message.

    ALIASES ms_t100key FOR if_t100_message~t100key.

    CONSTANTS:
      BEGIN OF zcx_ca_tabstrip_missing_param,
        msgid TYPE symsgid VALUE 'Z2CA_TABSTRIP_TAB',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'MV_PARAMETER1',
        attr2 TYPE scx_attrname VALUE 'MV_PARAMETER2',
        attr3 TYPE scx_attrname VALUE 'MV_PARAMETER3',
        attr4 TYPE scx_attrname VALUE 'MV_PARAMETER4',
      END OF zcx_ca_tabstrip_missing_param.

    DATA:
      mv_parameter1 TYPE seosconame,
      mv_parameter2 TYPE seosconame,
      mv_parameter3 TYPE seosconame,
      mv_parameter4 TYPE seosconame.

    METHODS constructor
      IMPORTING
        textid        TYPE scx_t100key OPTIONAL
        previous      TYPE REF TO cx_root OPTIONAL
        iv_parameter1 TYPE seosconame OPTIONAL
        iv_parameter2 TYPE seosconame OPTIONAL
        iv_parameter3 TYPE seosconame OPTIONAL
        iv_parameter4 TYPE seosconame OPTIONAL.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCX_CA_TABSTRIP_MISSING_PARAM IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.

    mv_parameter1 = iv_parameter1.
    mv_parameter2 = iv_parameter2.
    mv_parameter3 = iv_parameter3.
    mv_parameter4 = iv_parameter4.

    CLEAR me->textid.
    IF textid IS INITIAL.
      ms_t100key = zcx_ca_tabstrip_missing_param.
    ELSE.
      ms_t100key = textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
