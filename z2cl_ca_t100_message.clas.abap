CLASS z2cl_ca_t100_message DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES:
      "! <p class="shorttext synchronized">Message class key</p>
      BEGIN OF ty_message_class_key,
        message_id TYPE arbgb,
        language   TYPE spras,
      END OF ty_message_class_key.

    "! <p class="shorttext synchronized">Get instance</p>
    "!
    "! @parameter is_message_class_key | <p class="shorttext synchronized">Message class key</p>
    "! @parameter ro_instance          | <p class="shorttext synchronized">Instance</p>
    CLASS-METHODS get_instance
      IMPORTING
        is_message_class_key TYPE ty_message_class_key
      RETURNING
        VALUE(ro_instance)   TYPE REF TO z2cl_ca_t100_message.

    "! <p class="shorttext synchronized">Get message text</p>
    "!
    "! @parameter iv_message_number | <p class="shorttext synchronized">Message Number</p>
    "! @parameter iv_message_v1     | <p class="shorttext synchronized">Message Variable 1</p>
    "! @parameter iv_message_v2     | <p class="shorttext synchronized">Message Variable 2</p>
    "! @parameter iv_message_v3     | <p class="shorttext synchronized">Message Variable 3</p>
    "! @parameter iv_message_v4     | <p class="shorttext synchronized">Message Variable 4</p>
    "! @parameter rv_message_text   | <p class="shorttext synchronized">Message</p>
    METHODS get_message_text
      IMPORTING
        iv_message_number      TYPE syst_msgno
        iv_message_v1          TYPE syst_msgv OPTIONAL
        iv_message_v2          TYPE syst_msgv OPTIONAL
        iv_message_v3          TYPE syst_msgv OPTIONAL
        iv_message_v4          TYPE syst_msgv OPTIONAL
      RETURNING
        VALUE(rv_message_text) TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      "! <p class="shorttext synchronized">Message</p>
      BEGIN OF ty_message,
        msgnr TYPE msgnr,
        sprsl TYPE spras,
        text  TYPE natxt,
      END OF ty_message.
    "! <p class="shorttext synchronized">Messages</p>
    TYPES tty_messages TYPE STANDARD TABLE OF ty_message WITH DEFAULT KEY.

    "! <p class="shorttext synchronized">Message class key</p>
    DATA ms_message_class_key TYPE ty_message_class_key.
    "! <p class="shorttext synchronized">Message class master language</p>
    DATA mv_master_language TYPE spras.
    "! <p class="shorttext synchronized">Messages</p>
    DATA mt_messages TYPE tty_messages.
    "! <p class="shorttext synchronized">Instances</p>
    CLASS-DATA gt_instances TYPE STANDARD TABLE OF REF TO z2cl_ca_t100_message.

    "! <p class="shorttext synchronized">Constructor</p>
    "!
    "! @parameter is_message_class_key | <p class="shorttext synchronized">Message class key</p>
    METHODS constructor
      IMPORTING
        is_message_class_key TYPE ty_message_class_key.

    "! <p class="shorttext synchronized">Determine message class master language</p>
    "!
    METHODS _determine_master_language.

    "! <p class="shorttext synchronized">Determine messages</p>
    "!
    METHODS _determine_messages.

    "! <p class="shorttext synchronized">Replace numbered variable &1-&4</p>
    "!
    "! @parameter iv_message_text | <p class="shorttext synchronized">Message</p>
    "! @parameter iv_message_v1   | <p class="shorttext synchronized">Message Variable 1</p>
    "! @parameter iv_message_v2   | <p class="shorttext synchronized">Message Variable 2</p>
    "! @parameter iv_message_v3   | <p class="shorttext synchronized">Message Variable 3</p>
    "! @parameter iv_message_v4   | <p class="shorttext synchronized">Message Variable 4</p>
    "! @parameter rv_message_text | <p class="shorttext synchronized">Message</p>
    METHODS _replace_numbered_variables
      IMPORTING
        iv_message_text        TYPE string
        iv_message_v1          TYPE syst_msgv OPTIONAL
        iv_message_v2          TYPE syst_msgv OPTIONAL
        iv_message_v3          TYPE syst_msgv OPTIONAL
        iv_message_v4          TYPE syst_msgv OPTIONAL
      RETURNING
        VALUE(rv_message_text) TYPE string.

    "! <p class="shorttext synchronized">Replace unnumbered variables &</p>
    "!
    "! @parameter iv_message_text | <p class="shorttext synchronized">Message</p>
    "! @parameter iv_message_v1   | <p class="shorttext synchronized">Message Variable 1</p>
    "! @parameter iv_message_v2   | <p class="shorttext synchronized">Message Variable 2</p>
    "! @parameter iv_message_v3   | <p class="shorttext synchronized">Message Variable 3</p>
    "! @parameter iv_message_v4   | <p class="shorttext synchronized">Message Variable 4</p>
    "! @parameter rv_message_text | <p class="shorttext synchronized">Message</p>
    METHODS _replace_unnumbered_variables
      IMPORTING
        iv_message_text        TYPE string
        iv_message_v1          TYPE syst_msgv OPTIONAL
        iv_message_v2          TYPE syst_msgv OPTIONAL
        iv_message_v3          TYPE syst_msgv OPTIONAL
        iv_message_v4          TYPE syst_msgv OPTIONAL
      RETURNING
        VALUE(rv_message_text) TYPE string.

ENDCLASS.



CLASS z2cl_ca_t100_message IMPLEMENTATION.
  METHOD constructor.
    ms_message_class_key = is_message_class_key.
    _determine_master_language( ).
    _determine_messages( ).
    APPEND me TO gt_instances.
  ENDMETHOD.

  METHOD get_instance.
    ro_instance = COND #( WHEN line_exists( gt_instances[ table_line->ms_message_class_key = is_message_class_key ] )
                          THEN gt_instances[ table_line->ms_message_class_key = is_message_class_key ]
                          ELSE NEW #( is_message_class_key ) ).
  ENDMETHOD.

  METHOD get_message_text.
    DATA(ls_message) = VALUE #( mt_messages[ msgnr = iv_message_number ] OPTIONAL ).
    IF ls_message IS INITIAL.
      rv_message_text = |E:{ ms_message_class_key-message_id }:{ iv_message_number } {
                             iv_message_v1 } { iv_message_v2 } {
                             iv_message_v3 } { iv_message_v4 }|.
      RETURN.
    ENDIF.
    IF ls_message-sprsl EQ sy-langu.
      MESSAGE ID ms_message_class_key-message_id TYPE 'S'
              NUMBER iv_message_number
              WITH iv_message_v1
                   iv_message_v2
                   iv_message_v3
                   iv_message_v4
              INTO rv_message_text.
      RETURN.
    ENDIF.
    IF iv_message_v1 IS SUPPLIED.
      rv_message_text = replace( val = ls_message-text sub = '&&' with = '##?##' occ = 0 ).
      rv_message_text = _replace_numbered_variables( iv_message_text = rv_message_text
                                                     iv_message_v1   = iv_message_v1
                                                     iv_message_v2   = iv_message_v2
                                                     iv_message_v3   = iv_message_v3
                                                     iv_message_v4   = iv_message_v4 ).
      rv_message_text = _replace_unnumbered_variables( iv_message_text = rv_message_text
                                                       iv_message_v1   = iv_message_v1
                                                       iv_message_v2   = iv_message_v2
                                                       iv_message_v3   = iv_message_v3
                                                       iv_message_v4   = iv_message_v4 ).
      rv_message_text = replace( val = rv_message_text sub = '##?##' with = '&' occ = 0 ).
    ENDIF.
  ENDMETHOD.

  METHOD _determine_master_language.
    SELECT SINGLE FROM tadir
           FIELDS masterlang
           WHERE pgmid EQ 'R3TR'
             AND object EQ 'MSAG'
             AND obj_name EQ @ms_message_class_key-message_id
           INTO @mv_master_language.
  ENDMETHOD.

  METHOD _determine_messages.
    DATA lt_language_range TYPE RANGE OF spras.

    IF mv_master_language IS NOT INITIAL.
      lt_language_range = VALUE #( ( sign   = 'I'
                                     option = 'EQ'
                                     low    = ms_message_class_key-language ) ).
      IF mv_master_language NE ms_message_class_key-language.
        lt_language_range = VALUE #( BASE lt_language_range
                                     ( sign   = 'I'
                                       option = 'EQ'
                                       low    = mv_master_language ) ).
        DATA(lv_order_by) = |MSGNR ASCENDING, SPRSL { COND #( WHEN mv_master_language GT ms_message_class_key-language
                                                              THEN |ASCENDING|
                                                              ELSE |DESCENDING| ) } |.
      ENDIF.
      SELECT FROM t100
             FIELDS DISTINCT ( msgnr ), sprsl, text
             WHERE arbgb EQ @ms_message_class_key-message_id
               AND sprsl IN @lt_language_range
             ORDER BY (lv_order_by)
             INTO TABLE @mt_messages.
      DELETE ADJACENT DUPLICATES FROM mt_messages COMPARING msgnr.
    ENDIF.
  ENDMETHOD.

  METHOD _replace_numbered_variables.
    rv_message_text = iv_message_text.
    DO 8 TIMES.
      DATA(lv_message_variable_fieldname) = |IV_MESSAGE_V{ sy-index }|.
      ASSIGN (lv_message_variable_fieldname) TO FIELD-SYMBOL(<lv_lv_message_variable_value>).
      rv_message_text = replace( val  = rv_message_text
                                 sub  = |&{ sy-index }|
                                 with = COND #( WHEN sy-subrc NE 0
                                                THEN ``
                                                WHEN <lv_lv_message_variable_value> IS INITIAL
                                                THEN ` `
                                                ELSE replace( val  = <lv_lv_message_variable_value>
                                                              sub  = '&'
                                                              with = '##?##'
                                                              occ  = 0 ) )
                                 occ  = 0 ).
    ENDDO.
  ENDMETHOD.

  METHOD _replace_unnumbered_variables.
    rv_message_text = iv_message_text.
    DO 4 TIMES.
      DATA(lv_message_variable_fieldname) = |IV_MESSAGE_V{ sy-index }|.
      ASSIGN (lv_message_variable_fieldname) TO FIELD-SYMBOL(<lv_lv_message_variable_value>).
      IF sy-subrc EQ 0.
        rv_message_text = replace( val  = rv_message_text
                                   sub  = '&'
                                   with = COND #( WHEN <lv_lv_message_variable_value> IS INITIAL
                                                  THEN ` `
                                                  ELSE replace( val  = <lv_lv_message_variable_value>
                                                                sub  = '&'
                                                                with = '##?##'
                                                                occ  = 0 ) ) ).
      ENDIF.
    ENDDO.
    rv_message_text = replace( val  = rv_message_text
                               sub  = '&'
                               with = ''
                               occ  = 0 ).
  ENDMETHOD.
ENDCLASS.
