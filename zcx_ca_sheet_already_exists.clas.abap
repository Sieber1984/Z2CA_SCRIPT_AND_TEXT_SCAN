CLASS zcx_ca_sheet_already_exists DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES if_t100_dyn_msg.
    INTERFACES if_t100_message.

    ALIASES ms_t100key FOR if_t100_message~t100key.

    CONSTANTS:
      BEGIN OF zcx_ca_sheet_already_exists,
        msgid TYPE symsgid VALUE 'Z2CA_EXCEL_IMP_TOOLS',
        msgno TYPE symsgno VALUE '005',
        attr1 TYPE scx_attrname VALUE 'MV_WORKSHEET',
        attr2 TYPE scx_attrname VALUE 'MV_PROCESS',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF zcx_ca_sheet_already_exists.

    METHODS constructor
      IMPORTING
        textid       TYPE scx_t100key DEFAULT zcx_ca_sheet_already_exists=>zcx_ca_sheet_already_exists
        previous     TYPE REF TO cx_root OPTIONAL
        iv_worksheet TYPE z2ca_worksheet_title
        iv_process   TYPE text50.

    DATA mv_worksheet TYPE z2ca_worksheet_title.
    DATA mv_process TYPE text50.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCX_CA_SHEET_ALREADY_EXISTS IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.

    mv_worksheet = iv_worksheet.
    mv_process = iv_process.

    CLEAR me->textid.
    ms_t100key = textid.
  ENDMETHOD.
ENDCLASS.
