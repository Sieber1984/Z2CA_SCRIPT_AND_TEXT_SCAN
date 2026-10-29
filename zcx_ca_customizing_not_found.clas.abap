CLASS zcx_ca_customizing_not_found DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES if_t100_dyn_msg.
    INTERFACES if_t100_message.

    ALIASES ms_t100key FOR if_t100_message~t100key.

    DATA mv_tabname TYPE tabname.
    DATA mv_key     TYPE string.

    CONSTANTS:
      BEGIN OF zcx_ca_customizing_not_found,
        msgid TYPE symsgid VALUE 'Z2CA_CUSTOMIZING',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'MV_KEY',
        attr2 TYPE scx_attrname VALUE 'MV_TABNAME',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF zcx_ca_customizing_not_found.

    METHODS constructor
      IMPORTING
        textid     TYPE scx_t100key OPTIONAL
        previous   TYPE REF TO cx_root OPTIONAL
        iv_tabname TYPE tabname
        iv_key     TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCX_CA_CUSTOMIZING_NOT_FOUND IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.

    mv_tabname = iv_tabname.
    mv_key = iv_key.

    CLEAR me->textid.
    IF textid IS INITIAL.
      ms_t100key = zcx_ca_customizing_not_found.
    ELSE.
      ms_t100key = textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
