CLASS zcx_ca_dhl_country_not_in_use DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES if_t100_dyn_msg.
    INTERFACES if_t100_message.

    ALIASES ms_t100key FOR if_t100_message~t100key.

    DATA mv_country TYPE land1.

    CONSTANTS:
      BEGIN OF zcx_ca_dhl_country_not_in_use,
        msgid TYPE symsgid VALUE 'Z2CA_DHL',
        msgno TYPE symsgno VALUE '011',
        attr1 TYPE scx_attrname VALUE 'MV_COUNTRY',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF zcx_ca_dhl_country_not_in_use.

    METHODS constructor
      IMPORTING
        textid     TYPE scx_t100key OPTIONAL
        previous   TYPE REF TO cx_root OPTIONAL
        iv_country TYPE land1.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcx_ca_dhl_country_not_in_use IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.

    mv_country = iv_country.
    CLEAR me->textid.
    IF textid IS INITIAL.
      ms_t100key = zcx_ca_dhl_country_not_in_use.
    ELSE.
      ms_t100key = textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
