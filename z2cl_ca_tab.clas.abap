"! <p class="shorttext synchronized" lang="en">Tab</p>
CLASS z2cl_ca_tab DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.

    EVENTS:
    "! <p class="shorttext synchronized" lang="en">Return the first visible Tab</p>
    "! @parameter is_subscreen_data | Data for the active tab
     on_first_visible_tab
      EXPORTING
        VALUE(is_subscreen_data) TYPE z2ca_subscreen_s,

    "! <p class="shorttext synchronized" lang="en">Tab changed</p>
    "! @parameter is_subscreen_data | Data for the active tab
      on_tab_changed
        EXPORTING
          VALUE(is_subscreen_data) TYPE z2ca_subscreen_s,

    "! <p class="shorttext synchronized" lang="en">Title changed</p>
    "! @parameter iv_tabname | Fieldname of the structure used on the screen
    "! @parameter iv_title | Tab Title
      on_title_changed
        EXPORTING
          VALUE(iv_tabname) TYPE fieldname
          VALUE(iv_title) TYPE z2ca_tab_title,

    "! <p class="shorttext synchronized" lang="en">(In)Visible State changed</p>
    "! @parameter iv_tabname | Fieldname of the structure used on the screen
    "! @parameter iv_invisible | (In)Visble State
    "! @parameter iv_ucomm | <p class="shorttext synchronized" lang="en"></p>
      on_invisible_changed
        EXPORTING
          VALUE(iv_tabname) TYPE fieldname
          VALUE(iv_invisible) TYPE abap_bool
          VALUE(iv_ucomm) TYPE syucomm,

    "! <p class="shorttext synchronized" lang="en">(In)Visible State changed</p>
    "! @parameter iv_tabname | Fieldname of the structure used on the screen
    "! @parameter iv_ucomm | <p class="shorttext synchronized" lang="en"></p>
      on_tab_removed
        EXPORTING
          VALUE(iv_tabname) TYPE fieldname
          VALUE(iv_ucomm) TYPE syucomm.

    CLASS-METHODS:
      "! <p class="shorttext synchronized" lang="en">Get instance of this class</p>
      "! When calling the method for first time, fields <strong>io_tabstrip</strong>
      "! <strong>IV_REPID</strong> <strong>IV_DYNNR</strong> <strong>IV_UCOMM</strong> are required.
      "! Parameter <strong>IV_REPID</strong> <strong>IV_DYNNR</strong> are always required to get the correct instance.
      "! @parameter io_tabstrip | <p class="shorttext synchronized" lang="en">Instance of Tabstrip Object</p>
      "! @parameter iv_repid | <p class="shorttext synchronized" lang="en">Reportname of screen which contains tabstrip</p>
      "! @parameter iv_dynnr | <p class="shorttext synchronized" lang="en">Sreennumber which contains the tabstrip</p>
      "! @parameter iv_ucomm | <p class="shorttext synchronized" lang="en">Function Code of the Tab</p>
      "! @parameter iv_title | <p class="shorttext synchronized" lang="en">Tab Title</p>
      "! @parameter iv_icon | <p class="shorttext synchronized" lang="en">Tab Icon</p>
      "! @parameter iv_counter | <p class="shorttext synchronized" lang="en">Counter to show the amount of data in the tab</p>
      "! @parameter iv_set_foreign_handler |<p class="shorttext synchronized" lang="en">Set Handler for tabstrip instance</p>
      "! @parameter ro_instance | <p class="shorttext synchronized" lang="en">Self Instance</p>
      "! @raising zcx_ca_tab_missing_param | <p class="shorttext synchronized" lang="en">Missing parameter for tab</p>
      get_instance
        IMPORTING
          io_tabstrip            TYPE REF TO z2cl_ca_tabstrip OPTIONAL
          iv_repid               TYPE syrepid
          iv_dynnr               TYPE sydynnr
          iv_ucomm               TYPE syucomm OPTIONAL
          iv_title               TYPE z2ca_tab_title OPTIONAL
          iv_icon                TYPE icon_4 OPTIONAL
          iv_counter             TYPE i OPTIONAL
          iv_set_foreign_handler TYPE abap_bool DEFAULT abap_true
        RETURNING
          VALUE(ro_instance)     TYPE REF TO z2cl_ca_tab
        RAISING
          zcx_ca_tab_missing_param.

    METHODS:
      "! <p class="shorttext synchronized" lang="en">Set Tab Title</p>
      "! @parameter iv_title | <p class="shorttext synchronized" lang="en">Tab Title</p>
      set_title
        IMPORTING
          iv_title TYPE z2ca_tab_title,

      "! <p class="shorttext synchronized" lang="en">Get Title of this Tab</p>
      "! @parameter rv_title | <p class="shorttext synchronized" lang="en">Tab Title</p>
      get_title
        RETURNING
          VALUE(rv_title) TYPE z2ca_tab_title,

      "! <p class="shorttext synchronized" lang="en">Set Tab Icon</p>
      "! @parameter iv_icon | <p class="shorttext synchronized" lang="en">Tab Icon</p>
      set_icon
        IMPORTING
          iv_icon TYPE icon_4,

      "! <p class="shorttext synchronized" lang="en">Get Icon of this Tab</p>
      "! @parameter rv_icon | <p class="shorttext synchronized" lang="en">Tab Icon</p>
      get_icon
        RETURNING
          VALUE(rv_icon) TYPE icon_4,

      "! <p class="shorttext synchronized" lang="en">Set Tab Counter</p>
      "! @parameter iv_counter | <p class="shorttext synchronized" lang="en">Tab Counter</p>
      set_counter
        IMPORTING
          iv_counter TYPE i,

      "! <p class="shorttext synchronized" lang="en">Add Tab Counter</p>
      "! @parameter iv_counter | <p class="shorttext synchronized" lang="en">Count to add to Tab Counter</p>
      add_counter
        IMPORTING
          iv_counter TYPE i,


      "! <p class="shorttext synchronized" lang="en">Substract Tab Counter</p>
      "! @parameter iv_counter | <p class="shorttext synchronized" lang="en">Count to substract from Tab Counter</p>
      substract_counter
        IMPORTING
          iv_counter TYPE i,

      "! <p class="shorttext synchronized" lang="en">Get Counter of this Tab</p>
      "! @parameter rv_counter | <p class="shorttext synchronized" lang="en">Tab Counter</p>
      get_counter
        RETURNING
          VALUE(rv_counter) TYPE i,

      "! <p class="shorttext synchronized" lang="en">Set (in)visible State of this Tab</p>
      "! @parameter iv_invisible | <p class="shorttext synchronized" lang="en">(In)Visible State</p>
      set_invisible
        IMPORTING
          iv_invisible TYPE abap_bool,

      "! <p class="shorttext synchronized" lang="en">Toggle (in)visible State of this tab</p>
      toggle_invisible,

      "! <p class="shorttext synchronized" lang="en">Checks if the Tab is visible</p>
      handle_check_for_visible_tab FOR EVENT check_for_visible_tab OF z2cl_ca_tabstrip
        IMPORTING
          sender,

      "! <p class="shorttext synchronized" lang="en">Handle Function Code of Tab change</p>
      "! @parameter iv_ucomm | <p class="shorttext synchronized" lang="en"></p>
      handle_check_for_tab_change FOR EVENT check_for_tab_change OF z2cl_ca_tabstrip
        IMPORTING
          iv_ucomm
          sender,

      "! <p class="shorttext synchronized" lang="en">Handle Function Code of Tab change</p>
      "! @parameter iv_repid |<p class="shorttext synchronized" lang="en">ABAP Program: Current Master Program</p>
      "! @parameter iv_dynnr |<p class="shorttext synchronized" lang="en">Dynpro Number</p>
      "! @parameter sender | <p class="shorttext synchronized" lang="en">sender instance</p>
      handle_remove_tab FOR EVENT on_remove_tab OF z2cl_ca_tabstrip
        IMPORTING
          iv_repid
          iv_dynnr
          sender.

  PROTECTED SECTION.
  PRIVATE SECTION.

    "! <p class="shorttext synchronized" lang="en">All created instances</p>
    CLASS-DATA gt_instances TYPE z2ca_tab_instances_t.
    "! <p class="shorttext synchronized" lang="en">Fieldname of the structure used on the screen</p>
    DATA mv_tabname TYPE fieldname.
    "! <p class="shorttext synchronized" lang="en">(In)Visible State of the Tab</p>
    DATA mv_invisible TYPE abap_bool.
    "! <p class="shorttext synchronized" lang="en">Reportname of screen which contains tabstrip</p>
    DATA mv_repid TYPE syrepid.
    "! <p class="shorttext synchronized" lang="en">Sreennumber which contains the tabstrip</p>
    DATA mv_dynnr TYPE sydynnr.
    "! <p class="shorttext synchronized" lang="en">Function Code of the Tab</p>
    DATA mv_ucomm TYPE syucomm.
    "! <p class="shorttext synchronized" lang="en">Tab Title</p>
    DATA mv_title TYPE z2ca_tab_title.
    "! <p class="shorttext synchronized" lang="en">Tab Icon</p>
    DATA mv_icon TYPE icon_4.
    "! <p class="shorttext synchronized" lang="en">Counter to show the amount of data in the tab</p>
    DATA mv_counter TYPE i.

    "! <p class="shorttext synchronized" lang="en">Constructor Method</p>
    "! @parameter io_tabstrip | <p class="shorttext synchronized" lang="en">Instance of Tabstrip Object</p>
    "! @parameter iv_repid | <p class="shorttext synchronized" lang="en">Reportname of screen which contains tabstrip</p>
    "! @parameter iv_dynnr | <p class="shorttext synchronized" lang="en">Sreennumber which contains the tabstrip</p>
    "! @parameter iv_ucomm | <p class="shorttext synchronized" lang="en">Function Code of the Tab</p>
    "! @parameter iv_title | <p class="shorttext synchronized" lang="en">Tab Title</p>
    "! @parameter iv_icon | <p class="shorttext synchronized" lang="en">Tab Icon</p>
    "! @parameter iv_counter | <p class="shorttext synchronized" lang="en">Counter to show the amount of data in the tab</p>
    "! @parameter iv_set_foreign_handler | <p class="shorttext synchronized" lang="en">Set Handler for tabstrip instance</p>
    METHODS constructor
      IMPORTING
        io_tabstrip            TYPE REF TO z2cl_ca_tabstrip
        iv_repid               TYPE syrepid
        iv_dynnr               TYPE sydynnr
        iv_ucomm               TYPE syucomm
        iv_title               TYPE z2ca_tab_title
        iv_icon                TYPE icon_4
        iv_counter             TYPE i
        iv_set_foreign_handler TYPE abap_bool.

    "! <p class="shorttext synchronized" lang="en">Get the Icon for the Title</p>
    "! @parameter rv_title | <p class="shorttext synchronized" lang="en">Icon for the Title</p>
    METHODS _get_icon_title
      RETURNING
        VALUE(rv_title) TYPE z2ca_tab_title.
ENDCLASS.



CLASS Z2CL_CA_TAB IMPLEMENTATION.


  METHOD get_instance.
    ASSIGN gt_instances[ repid = iv_repid dynnr = iv_dynnr ] TO FIELD-SYMBOL(<ls_instance>). "#EC CI_STDSEQ
    IF sy-subrc NE 0.
      IF iv_repid IS INITIAL OR iv_dynnr IS INITIAL OR io_tabstrip IS INITIAL OR iv_ucomm IS INITIAL.
        DATA(lt_seosconame) = VALUE z2ca_parameter_list_t( ).
        IF iv_repid IS INITIAL.
          APPEND 'IV_REPID' TO lt_seosconame ##NO_TEXT.
        ENDIF.
        IF iv_dynnr IS INITIAL.
          APPEND 'IV_DYNNR' TO lt_seosconame ##NO_TEXT.
        ENDIF.
        IF io_tabstrip IS INITIAL.
          APPEND 'IO_TABSTRIP' TO lt_seosconame ##NO_TEXT.
        ENDIF.
        IF iv_ucomm IS INITIAL.
          APPEND 'IV_UCOMM' TO lt_seosconame ##NO_TEXT.
        ENDIF.
        RAISE EXCEPTION NEW zcx_ca_tab_missing_param( iv_parameter1 = VALUE #( lt_seosconame[ 1 ] OPTIONAL )
                                                      iv_parameter2 = VALUE #( lt_seosconame[ 2 ] OPTIONAL )
                                                      iv_parameter3 = VALUE #( lt_seosconame[ 3 ] OPTIONAL )
                                                      iv_parameter4 = VALUE #( lt_seosconame[ 4 ] OPTIONAL ) ).
      ENDIF.

      APPEND VALUE #( repid = iv_repid
                      dynnr = iv_dynnr
                      instance = NEW #( io_tabstrip = io_tabstrip
                                        iv_repid = iv_repid
                                        iv_dynnr = iv_dynnr
                                        iv_ucomm = iv_ucomm
                                        iv_title = iv_title
                                        iv_icon = iv_icon
                                        iv_counter = iv_counter
                                        iv_set_foreign_handler = iv_set_foreign_handler ) )
             TO gt_instances
             ASSIGNING <ls_instance>.
    ENDIF.
    ro_instance = <ls_instance>-instance.
  ENDMETHOD.


  METHOD constructor.
    SET HANDLER handle_check_for_tab_change FOR io_tabstrip.
    SET HANDLER handle_check_for_visible_tab FOR io_tabstrip.
    SET HANDLER handle_remove_tab FOR io_tabstrip.

    IF iv_set_foreign_handler EQ abap_true.
      io_tabstrip->set_handler_from_outside( me ).
    ENDIF.

    mv_repid        = iv_repid.
    mv_dynnr        = iv_dynnr.
    mv_ucomm        = iv_ucomm.
    mv_tabname      = |TAB{ substring( val = mv_ucomm off = strlen( mv_ucomm ) - 2 ) }|.

    set_title( iv_title ).
    set_icon( iv_icon ).
    set_counter( iv_counter ).
  ENDMETHOD.


  METHOD handle_remove_tab.

    IF mv_repid EQ iv_repid AND mv_dynnr EQ iv_dynnr.
      SET HANDLER handle_check_for_tab_change FOR sender ACTIVATION space.
      SET HANDLER handle_check_for_visible_tab FOR sender ACTIVATION space.
      SET HANDLER handle_remove_tab FOR sender ACTIVATION space.


      RAISE EVENT on_tab_removed
        EXPORTING
          iv_tabname = mv_tabname
          iv_ucomm   = mv_ucomm.

      DATA(lo_tab) = VALUE #( gt_instances[ repid = mv_repid dynnr = mv_dynnr ]-instance OPTIONAL ). "#EC CI_STDSEQ
      IF lo_tab IS BOUND.
        CLEAR: lo_tab.
      ENDIF.
      DELETE gt_instances WHERE repid EQ mv_repid
                            AND dynnr EQ mv_dynnr.       "#EC CI_STDSEQ
    ENDIF.
  ENDMETHOD.


  METHOD get_title.
    rv_title = |{ _get_icon_title( ) }{ COND #( WHEN mv_counter IS NOT INITIAL THEN | ({ mv_counter NUMBER = USER })| ) }|.
  ENDMETHOD.


  METHOD handle_check_for_tab_change.
    IF mv_ucomm EQ iv_ucomm.
      RAISE EVENT on_tab_changed
        EXPORTING
          is_subscreen_data = VALUE #( subscreen = mv_dynnr program = mv_repid pressed_tab = mv_ucomm ).
    ENDIF.
  ENDMETHOD.


  METHOD handle_check_for_visible_tab.
    IF mv_invisible EQ abap_false.
      RAISE EVENT on_first_visible_tab
        EXPORTING
          is_subscreen_data = VALUE #( subscreen = mv_dynnr program = mv_repid pressed_tab = mv_ucomm ).
    ENDIF.
  ENDMETHOD.


  METHOD set_title.
    IF iv_title NE mv_title.
      mv_title = iv_title.
      RAISE EVENT on_title_changed
        EXPORTING
          iv_tabname = mv_tabname
          iv_title   = get_title( ).
    ENDIF.
  ENDMETHOD.


  METHOD _get_icon_title.
    IF mv_icon IS NOT INITIAL.
      CALL FUNCTION 'ICON_CREATE'
        EXPORTING
          name                  = mv_icon
          text                  = mv_title
          add_stdinf            = ' '
        IMPORTING
          result                = rv_title
        EXCEPTIONS
          icon_not_found        = 1                " Ikonenname dem System unbekannt
          outputfield_too_short = 2                " Länge des Feld 'RESULT' ist zu klein
          OTHERS                = 3.
      IF sy-subrc NE 0.
        rv_title = mv_title.
      ENDIF.
    ELSE.
      rv_title = mv_title.
    ENDIF.
  ENDMETHOD.


  METHOD substract_counter.
    IF mv_counter - iv_counter GE 0.
      mv_counter = mv_counter - iv_counter.
      RAISE EVENT on_title_changed
        EXPORTING
          iv_tabname = mv_tabname
          iv_title   = get_title( ).
    ENDIF.
  ENDMETHOD.


  METHOD get_icon.
    rv_icon = mv_icon.
  ENDMETHOD.


  METHOD set_invisible.
    IF iv_invisible NE mv_invisible.
      mv_invisible = iv_invisible.
      RAISE EVENT on_invisible_changed
        EXPORTING
          iv_tabname   = mv_tabname
          iv_invisible = mv_invisible
          iv_ucomm     = mv_ucomm.
    ENDIF.
  ENDMETHOD.


  METHOD get_counter.
    rv_counter = mv_counter.
  ENDMETHOD.


  METHOD set_icon.
    IF iv_icon NE mv_icon.
      mv_icon = iv_icon.
      RAISE EVENT on_title_changed
        EXPORTING
          iv_tabname = mv_tabname
          iv_title   = get_title( ).
    ENDIF.
  ENDMETHOD.


  METHOD add_counter.
    mv_counter = mv_counter + iv_counter.
    RAISE EVENT on_title_changed
      EXPORTING
        iv_tabname = mv_tabname
        iv_title   = get_title( ).
  ENDMETHOD.


  METHOD toggle_invisible.
    mv_invisible = boolc( mv_invisible EQ abap_false ).
    RAISE EVENT on_invisible_changed
      EXPORTING
        iv_tabname   = mv_tabname
        iv_invisible = mv_invisible
        iv_ucomm     = mv_ucomm.
  ENDMETHOD.


  METHOD set_counter.
    IF iv_counter NE mv_counter.
      mv_counter = iv_counter.
      RAISE EVENT on_title_changed
        EXPORTING
          iv_tabname = mv_tabname
          iv_title   = get_title( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
