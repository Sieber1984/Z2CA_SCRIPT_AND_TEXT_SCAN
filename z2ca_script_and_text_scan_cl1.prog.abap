CLASS lcl_dynamic_screen DEFINITION CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS get_instance
      RETURNING
        VALUE(ro_dynamic_screen) TYPE REF TO lcl_dynamic_screen.

    METHODS fill_dynamic_selections
      IMPORTING
        ir_tdobject_range TYPE REF TO data.

    METHODS get_dynamic_selection_data
      IMPORTING
        ir_tdobject_range TYPE REF TO data.

    METHODS has_ranges
      RETURNING
        VALUE(rv_has_ranges) TYPE abap_bool.

    METHODS get_range
      IMPORTING
        iv_tablename           TYPE tabname
      RETURNING
        VALUE(rs_field_ranges) TYPE rsds_range.

    METHODS get_tablenames_of_ranges
      RETURNING
        VALUE(rt_tablename_of_ranges) TYPE tttabname.

    METHODS get_tablenames
      RETURNING
        VALUE(rt_tablenames) TYPE tttabname.

    METHODS is_valid_table
      IMPORTING
        iv_tabname               TYPE tabname
      RETURNING
        VALUE(rv_is_valid_table) TYPE abap_bool.

    METHODS has_valid_tables
      RETURNING
        VALUE(rv_has_valid_tables) TYPE abap_bool.

    METHODS delete_range.

  PRIVATE SECTION.
    CONSTANTS:
      BEGIN OF gc_range_fields,
        sign   TYPE fieldname VALUE 'SIGN',
        option TYPE fieldname VALUE 'OPTION',
        low    TYPE fieldname VALUE 'LOW',
        high   TYPE fieldname VALUE 'HIGH',
      END OF gc_range_fields.
    CLASS-DATA go_dynamic_screen TYPE REF TO lcl_dynamic_screen.
    DATA mv_selection_id TYPE dynselid.
    DATA mt_field_ranges TYPE rsds_trange.
    DATA mt_fields_tab TYPE rsdsfields_t.
    DATA mt_fields_not_selected TYPE rsdsfields_t.
    DATA mt_tables_tab TYPE rsdstabs_t.
    DATA mt_tabfields_not_display TYPE rsdsfields_t.

    METHODS constructor.

    METHODS _is_correct_rollname_used
      IMPORTING
        ir_tdobject_range                  TYPE REF TO data
        iv_expected_rollname               TYPE rollname
      RETURNING
        VALUE(rv_is_correct_rollname_used) TYPE abap_bool.

    METHODS _is_range_table
      IMPORTING
        it_components            TYPE abap_component_tab
      RETURNING
        VALUE(rv_is_range_table) TYPE abap_bool.

    METHODS _deteremine_fields_tab
      IMPORTING
        ir_tdobject_range TYPE REF TO data.

    METHODS _deteremine_tables.

    METHODS _deteremine_tablefields_no_dis.

    METHODS _reduce_field_ranges
      IMPORTING
        ir_tdobject_range TYPE REF TO data.

    METHODS _free_selections_init.

    METHODS _free_selections_dialog.
ENDCLASS.

CLASS lcl_dynamic_screen IMPLEMENTATION.


  METHOD constructor.
    _deteremine_tables( ).
    _deteremine_tablefields_no_dis( ).
    _free_selections_init( ).
    go_dynamic_screen = me.
  ENDMETHOD.


  METHOD get_instance.
    ro_dynamic_screen = COND #( WHEN go_dynamic_screen IS BOUND
                                THEN go_dynamic_screen
                                ELSE NEW #( ) ).
  ENDMETHOD.


  METHOD fill_dynamic_selections.
    IF _is_correct_rollname_used( ir_tdobject_range = ir_tdobject_range
                                  iv_expected_rollname = 'TDOBJECT' ).
      _deteremine_fields_tab( ir_tdobject_range ).
      _reduce_field_ranges( ir_tdobject_range ).
    ENDIF.
  ENDMETHOD.


  METHOD get_dynamic_selection_data.
    fill_dynamic_selections( ir_tdobject_range ).
    _free_selections_init( ).
    _free_selections_dialog( ).
  ENDMETHOD.


  METHOD has_ranges.
    rv_has_ranges = xsdbool( mt_field_ranges IS NOT INITIAL ).
  ENDMETHOD.


  METHOD get_range.
    rs_field_ranges = VALUE #( mt_field_ranges[ tablename = iv_tablename ] OPTIONAL ).
  ENDMETHOD.


  METHOD get_tablenames_of_ranges.
    rt_tablename_of_ranges = VALUE #( FOR ls_field_range IN mt_field_ranges
                                      ( ls_field_range-tablename ) ).
  ENDMETHOD.


  METHOD get_tablenames.
    rt_tablenames = VALUE #( FOR ls_table IN mt_tables_tab
                             ( ls_table-prim_tab ) ).
  ENDMETHOD.


  METHOD _deteremine_tables.
    SELECT FROM ttxob AS t
           INNER JOIN dd02l AS d2
             ON d2~tabname EQ t~tdobject
           LEFT OUTER JOIN dd02t AS dt
             ON dt~tabname EQ d2~tabname AND
                dt~as4local EQ d2~as4local AND
                dt~ddlanguage EQ @sy-langu
           INNER JOIN z2ca_ttxob AS z
             ON z~tdobject EQ t~tdobject
           FIELDS DISTINCT ( d2~tabname ) AS prim_tab, dt~ddtext
           WHERE t~tdobject LIKE '%'
             AND d2~as4local EQ 'A'
             AND d2~tabclass EQ 'TRANSP'
           ORDER BY dt~ddtext
           INTO TABLE @DATA(lt_tables).              "#EC CI_SEL_NESTED

    mt_tables_tab = CORRESPONDING #( lt_tables ).
  ENDMETHOD.


  METHOD _deteremine_tablefields_no_dis.
    DATA lt_tablename_range TYPE RANGE OF tabname.

    IF mt_tables_tab IS NOT INITIAL.
      lt_tablename_range = VALUE #( FOR ls_tablename IN mt_tables_tab
                                    sign = 'I' option = 'EQ'
                                    ( low = ls_tablename-prim_tab ) ).
      SELECT FROM dd02l AS d2
             INNER JOIN dd03l AS d3
               ON d3~tabname EQ d2~tabname
             FIELDS d2~tabname AS tablename, d3~fieldname AS fieldname, 'S' AS type
             WHERE d2~tabname   IN @lt_tablename_range
               AND d3~fieldname NOT LIKE  '.%'
               AND d2~as4local  EQ 'A'
               AND d2~tabclass  EQ 'TRANSP'
               AND d3~keyflag   EQ @abap_false
               AND d3~datatype  NE 'CLNT'
             INTO TABLE @mt_tabfields_not_display.   "#EC CI_SEL_NESTED
    ENDIF.
  ENDMETHOD.


  METHOD _deteremine_fields_tab.
    FIELD-SYMBOLS <lt_tdobject_range> TYPE STANDARD TABLE.
    ASSIGN ir_tdobject_range->* TO <lt_tdobject_range>.

    IF <lt_tdobject_range> IS NOT INITIAL.
      SELECT FROM ttxob AS t
             INNER JOIN dd02l AS d2
               ON d2~tabname EQ t~tdobject
             INNER JOIN dd03l AS d3
               ON d3~tabname EQ d2~tabname
             INNER JOIN z2ca_ttxob AS z
               ON z~tdobject EQ t~tdobject
             FIELDS d2~tabname AS tablename, d3~fieldname AS fieldname, 'S' AS type
             WHERE t~tdobject IN @<lt_tdobject_range>
               AND d2~as4local EQ 'A'
               AND d3~fieldname NOT LIKE  '.%'
               AND d2~tabclass EQ 'TRANSP'
               AND d3~keyflag EQ @abap_true
               AND d3~datatype NE 'CLNT'
             INTO TABLE @mt_fields_tab.              "#EC CI_SEL_NESTED
    ENDIF.
  ENDMETHOD.


  METHOD _reduce_field_ranges.
    FIELD-SYMBOLS <lt_tdobject_range> TYPE STANDARD TABLE.
    ASSIGN ir_tdobject_range->* TO <lt_tdobject_range>.

    IF <lt_tdobject_range> IS NOT INITIAL.
      DELETE mt_field_ranges WHERE tablename NOT IN <lt_tdobject_range>.
    ENDIF.
  ENDMETHOD.


  METHOD _is_correct_rollname_used.
    CASE TYPE OF cl_abap_typedescr=>describe_by_data_ref( ir_tdobject_range ).
      WHEN TYPE cl_abap_structdescr INTO DATA(lo_abap_structdescr).
      WHEN TYPE cl_abap_tabledescr INTO DATA(lo_abap_tabledescr).
        IF lo_abap_tabledescr->get_table_line_type( ) IS INSTANCE OF cl_abap_structdescr..
          lo_abap_structdescr = CAST #( lo_abap_tabledescr->get_table_line_type( ) ).
        ELSE.
          RETURN.
        ENDIF.
      WHEN OTHERS.
        RETURN.
    ENDCASE.
    DATA(lt_components) = lo_abap_structdescr->get_components( ).
    IF _is_range_table( it_components = lt_components ).
      rv_is_correct_rollname_used = xsdbool( CAST cl_abap_elemdescr( VALUE #( lt_components[ name = 'LOW' ]-type ) )->get_relative_name( ) EQ iv_expected_rollname ).
    ENDIF.
  ENDMETHOD.


  METHOD _is_range_table.
    IF lines( it_components ) EQ 4.
      rv_is_range_table = abap_true.
      LOOP AT it_components REFERENCE INTO DATA(lr_component).
        IF lr_component->name NE SWITCH #( sy-tabix
                                           WHEN 1 THEN gc_range_fields-sign
                                           WHEN 2 THEN gc_range_fields-option
                                           WHEN 3 THEN gc_range_fields-low
                                           WHEN 4 THEN gc_range_fields-high ).
          CLEAR rv_is_range_table.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD _free_selections_init.
    CALL FUNCTION 'FREE_SELECTIONS_INIT'
      EXPORTING
        kind                     = 'T'              " Type of field list
      IMPORTING
        selection_id             = mv_selection_id
      TABLES
        tables_tab               = mt_tables_tab
        tabfields_not_display    = mt_tabfields_not_display
        fields_tab               = mt_fields_tab
        fields_not_selected      = mt_fields_not_selected
      EXCEPTIONS
        fields_incomplete        = 1                " Only PRIM_FNAME filled
        fields_no_join           = 2                " Field assignment without join
        field_not_found          = 3                " Dictionary field not found
        no_tables                = 4                " Table P_TABLES is empty
        table_not_found          = 5                " A table from P_TABLES was not found
        expression_not_supported = 6                " Expression not (yet) supported
        incorrect_expression     = 7                " Incorrect logical expression
        illegal_kind             = 8                " KIND not equal to T,G,F or: G without P_RSDSQCAT
        area_not_found           = 9                " Invalid key FIELD_GROUPS_KEY
        inconsistent_area        = 10               " Inconsistent selection view
        kind_f_no_fields_left    = 11               " KIND = F, but no field left after cleanup
        kind_f_no_fields         = 12               " KIND = F, but no field passed
        too_many_fields          = 13               " Too many entries in FIELDS_TAB
        dup_field                = 14               " Field doubles in FIELDS_TAB
        field_no_type            = 15               " No field type in the field description
        field_ill_type           = 16               " Non-allowed field type
        dup_event_field          = 17               " Field doubled in EVENT_FIELDS
        node_not_in_ldb          = 18               " Node not part of logical database
        area_no_field            = 19               " Selection view has no fields
        OTHERS                   = 20.

    IF sy-subrc <> 0.
*     MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDMETHOD.


  METHOD _free_selections_dialog.
    CALL FUNCTION 'FREE_SELECTIONS_DIALOG'
      EXPORTING
        selection_id        = mv_selection_id
*       title               = space            " Selection screen title
*       frame_text          = space            " Frame text on selection screen
*       status              =                  " Status number (see long text)
*       as_window           = space            " X: Selection screen as dialog box
*       start_row           =                  " Dialog box: Initial row
*       start_col           =                  " Dialog box: Initial column
*       no_intervals        = space            " Thin selection screen (no HIGH field)
*       just_display        = space            " X: Display Mode
*       pfkey               =                  " Individual GUI status (status + program).
*       alv                 = space            " Internal use
*       tree_visible        = 'X'              " Do you want to display the field selection tree?
*       diag_text_1         =                  " Replacement text:"Deleting dynamic selections"
*       diag_text_2         =                  " Replacement text:"Changing dynamic selections"
*       warning_title       =                  " Warning dialob box title
*       as_subscreen        = space            " (For internal use only) Integrate Dynamic Selections as Subs
*       no_frame            =
      IMPORTING
*       where_clauses       =                  " Selections in form of WHERE clauses
*       expressions         =                  " Selections in form of logical expressions
        field_ranges        = mt_field_ranges
*       number_of_active_fields =                  " Number of fields with selections
      TABLES
        fields_tab          = mt_fields_tab
*       fcode_tab           =                  " Internal use
        fields_not_selected = mt_fields_not_selected
      EXCEPTIONS
        internal_error      = 1                " Internal error
        no_action           = 2                " Canceled by user
        selid_not_found     = 3                " Transfer non-existent selection ID
        illegal_status      = 4                " Invalid status number
        OTHERS              = 5.
    IF sy-subrc <> 0.
*     MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDMETHOD.


  METHOD is_valid_table.
    rv_is_valid_table = xsdbool( line_exists( mt_tables_tab[ prim_tab = iv_tabname ] ) ).
  ENDMETHOD.


  METHOD has_valid_tables.
    rv_has_valid_tables = xsdbool( mt_tables_tab IS NOT INITIAL ).
  ENDMETHOD.


  METHOD delete_range.
    CLEAR mt_field_ranges.
  ENDMETHOD.


ENDCLASS.
