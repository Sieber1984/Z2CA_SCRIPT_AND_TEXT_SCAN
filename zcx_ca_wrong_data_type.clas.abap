CLASS zcx_ca_wrong_data_type DEFINITION
  PUBLIC
  INHERITING FROM zcx_ca_static_check
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES if_t100_dyn_msg.
    INTERFACES if_t100_message.

    ALIASES ms_t100key FOR if_t100_message~t100key.

    CONSTANTS:
      BEGIN OF zcx_ca_wrong_data_type,
        msgid TYPE symsgid VALUE 'ZCC_HELPER_TOOLS',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF zcx_ca_wrong_data_type.

    METHODS constructor
      IMPORTING
        textid      TYPE scx_t100key DEFAULT zcx_ca_wrong_data_type=>zcx_ca_wrong_data_type
        previous    TYPE REF TO cx_root OPTIONAL.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCX_CA_WRONG_DATA_TYPE IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.

    CLEAR me->textid.
    ms_t100key = textid.
  ENDMETHOD.
ENDCLASS.
