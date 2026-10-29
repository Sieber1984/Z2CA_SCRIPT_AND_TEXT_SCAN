CLASS zcx_ca_sheet_unknown_type DEFINITION
  PUBLIC
  INHERITING FROM zcx_ca_static_check
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES if_t100_dyn_msg.
    INTERFACES if_t100_message.

    ALIASES ms_t100key FOR if_t100_message~t100key.

    CONSTANTS:
      BEGIN OF zcx_ca_sheet_unknown_type,
        msgid TYPE symsgid VALUE 'Z2CA_EXCEL_IMP_TOOLS',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE 'MV_WORKSHEET',
        attr2 TYPE scx_attrname VALUE 'MV_TYPE',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF zcx_ca_sheet_unknown_type.

    METHODS constructor
      IMPORTING
        textid       TYPE scx_t100key OPTIONAL
        previous     TYPE REF TO cx_root OPTIONAL
        iv_worksheet TYPE z2ca_worksheet_title
        iv_type      TYPE rollname.

    DATA:
      mv_worksheet TYPE z2ca_worksheet_title,
      mv_type      TYPE rollname.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCX_CA_SHEET_UNKNOWN_TYPE IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.

    mv_worksheet = iv_worksheet.
    mv_type = iv_type.

    CLEAR me->textid.
    IF textid IS INITIAL.
      ms_t100key = zcx_ca_sheet_unknown_type.
    ELSE.
      ms_t100key = textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
