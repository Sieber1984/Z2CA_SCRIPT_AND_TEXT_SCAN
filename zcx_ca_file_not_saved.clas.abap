CLASS zcx_ca_file_not_saved DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES if_t100_dyn_msg.
    INTERFACES if_t100_message.

    ALIASES ms_t100key FOR if_t100_message~t100key.

    CONSTANTS:
      BEGIN OF zcx_ca_file_not_saved,
        msgid TYPE symsgid VALUE 'Z2CA_EXCEL_IMP_TOOLS',
        msgno TYPE symsgno VALUE '101',
        attr1 TYPE scx_attrname VALUE 'MV_FILENAME',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF zcx_ca_file_not_saved.

    METHODS constructor
      IMPORTING
        textid      TYPE scx_t100key OPTIONAL
        previous    TYPE REF TO cx_root OPTIONAL
        iv_filename TYPE string.

    DATA:
      mv_filename TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCX_CA_FILE_NOT_SAVED IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.

    mv_filename = iv_filename.

    CLEAR me->textid.
    IF textid IS INITIAL.
      ms_t100key = zcx_ca_file_not_saved.
    ELSE.
      ms_t100key = textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
