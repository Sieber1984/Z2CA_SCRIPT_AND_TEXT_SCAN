CLASS zcx_ca_canceled_by_user DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES if_t100_dyn_msg.
    INTERFACES if_t100_message.

    ALIASES ms_t100key FOR if_t100_message~t100key.

    CONSTANTS:
      BEGIN OF zcx_ca_canceled_by_user,
        msgid TYPE symsgid VALUE 'Z2CA_HELPER_TOOLS',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF zcx_ca_canceled_by_user.

    METHODS constructor
      IMPORTING
        textid   TYPE scx_t100key OPTIONAL
        previous TYPE REF TO cx_root OPTIONAL.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCX_CA_CANCELED_BY_USER IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.

    CLEAR me->textid.
    IF textid IS INITIAL.
      ms_t100key = zcx_ca_canceled_by_user.
    ELSE.
      ms_t100key = textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
