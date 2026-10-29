CLASS zcx_ca_missing_column DEFINITION
  PUBLIC
  INHERITING FROM zcx_ca_static_check
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES if_t100_dyn_msg.
    INTERFACES if_t100_message.

    ALIASES ms_t100key FOR if_t100_message~t100key.

    CONSTANTS:
      BEGIN OF zcx_ca_missing_column,
        msgid TYPE symsgid VALUE 'ZSTKOES_EXCEL_TOOLS',
        msgno TYPE symsgno VALUE '006',
        attr1 TYPE scx_attrname VALUE 'MV_WORKSHEET',
        attr2 TYPE scx_attrname VALUE 'MV_MISSING_COLUMN_COUNT',
        attr3 TYPE scx_attrname VALUE 'MV_TOTAL_COLUMN_COUNT',
        attr4 TYPE scx_attrname VALUE '',
      END OF zcx_ca_missing_column.

    CONSTANTS:
      BEGIN OF zcx_ca_missing_columns,
        msgid TYPE symsgid VALUE 'ZSTKOES_EXCEL_TOOLS',
        msgno TYPE symsgno VALUE '007',
        attr1 TYPE scx_attrname VALUE 'MV_WORKSHEET',
        attr2 TYPE scx_attrname VALUE 'MV_MISSING_COLUMN_COUNT',
        attr3 TYPE scx_attrname VALUE 'MV_TOTAL_COLUMN_COUNT',
        attr4 TYPE scx_attrname VALUE '',
      END OF zcx_ca_missing_columns.

    METHODS constructor
      IMPORTING
        textid                 TYPE scx_t100key
        previous               TYPE REF TO cx_root OPTIONAL
        iv_worksheet           TYPE z2ca_worksheet_title
        iv_missing_colum_count TYPE i
        iv_total_colum_count   TYPE i.

    DATA mv_worksheet TYPE z2ca_worksheet_title.
    DATA mv_missing_column_count TYPE i.
    DATA mv_total_column_count   TYPE i.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCX_CA_MISSING_COLUMN IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.

    mv_worksheet = iv_worksheet.
    mv_missing_column_count = iv_missing_colum_count.
    mv_total_column_count = iv_total_colum_count.

    CLEAR me->textid.
    IF textid IS INITIAL.
      ms_t100key = zcx_ca_missing_column.
    ELSE.
      ms_t100key = textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
