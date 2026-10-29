"! <p class="shorttext synchronized" lang="en">Wrong fieldname for tab</p>
CLASS zcx_ca_tab_wrong_fieldname DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES if_t100_dyn_msg.
    INTERFACES if_t100_message.

    ALIASES ms_t100key FOR if_t100_message~t100key.

    CONSTANTS:
      BEGIN OF zcx_ca_tabstrip_wrong_fielnam,
        msgid TYPE symsgid VALUE 'Z2CA_TABSTRIP_TAB',
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE 'MV_FIELDNAME',
        attr2 TYPE scx_attrname VALUE 'MV_FIELDPATTERN',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF zcx_ca_tabstrip_wrong_fielnam.

    DATA:
      mv_fieldname    TYPE fieldname,
      mv_fieldpattern TYPE fieldname.

    METHODS constructor
      IMPORTING
        textid          TYPE scx_t100key OPTIONAL
        previous        TYPE REF TO cx_root OPTIONAL
        iv_fieldname    TYPE fieldname
        iv_fieldpattern TYPE fieldname.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCX_CA_TAB_WRONG_FIELDNAME IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.


    mv_fieldname    = iv_fieldname.
    mv_fieldpattern = iv_fieldpattern.

    CLEAR me->textid.
    IF textid IS INITIAL.
      ms_t100key = zcx_ca_tabstrip_wrong_fielnam.
    ELSE.
      ms_t100key = textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
