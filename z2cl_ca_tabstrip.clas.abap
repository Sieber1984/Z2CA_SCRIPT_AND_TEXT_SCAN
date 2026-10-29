"! <p class="shorttext synchronized" lang="en">Tabstrip</p>
CLASS z2cl_ca_tabstrip DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    CONSTANTS co_max_tab_count TYPE i VALUE 20.

    CLASS-METHODS:
      "! <p class="shorttext synchronized" lang="en">Get instance of this class</p>
      "! When calling the method for first time, <strong>all parameter</strong> are required.
      "! Parameter <strong>IV_TABSTRIPNAME</strong> is always required to get the correct instance.
      "! @parameter iv_tabstrip_control_name | <p class="shorttext synchronized" lang="en">Controlname of Tabstrip</p>
      "! @parameter iv_repid | <p class="shorttext synchronized" lang="en">Reportname of Screen which contains Tabstrip</p>
      "! @parameter iv_dynnr | <p class="shorttext synchronized" lang="en">Sreennumber which contains the Tabstrip</p>
      "! @parameter iv_structname | <p class="shorttext synchronized" lang="en">Structurename which is used for the Tabs on the Screen</p>
      "! @parameter iv_max_tab_count | <p class="shorttext synchronized" lang="en">Maximal count of tabs</p>
      "! @parameter is_tab_titles | <p class="shorttext synchronized" lang="en">Structure with all tab titles</p>
      "! @parameter ro_instance | <p class="shorttext synchronized" lang="en">Self Instance</p>
      "! @raising zcx_ca_tabstrip_missing_param | <p class="shorttext synchronized" lang="en">Invalid parameter usage</p>
      "! @raising zcx_ca_tabstrip_wrong_par_typ | <p class="shorttext synchronized" lang="en">Wrong type for parameter</p>
      "! @raising zcx_ca_tab_wrong_fieldname | <p class="shorttext synchronized" lang="en">Wrong fieldname for tab</p>
      get_instance
        IMPORTING
          iv_tabstrip_control_name TYPE z2ca_tabstrip_control_name
          iv_repid                 TYPE syrepid OPTIONAL
          iv_dynnr                 TYPE sydynnr OPTIONAL
          iv_structname            TYPE tabname OPTIONAL
          iv_max_tab_count         TYPE i DEFAULT co_max_tab_count
          is_tab_titles            TYPE any OPTIONAL
        RETURNING
          VALUE(ro_instance)       TYPE REF TO z2cl_ca_tabstrip
        RAISING
          zcx_ca_tabstrip_missing_param
          zcx_ca_tabstrip_wrong_par_typ
          zcx_ca_tab_wrong_fieldname
          zcx_ca_wrong_data_type.

    METHODS:
      "! <p class="shorttext synchronized" lang="en"></p>
      "!
      "! @parameter io_tab | <p class="shorttext synchronized" lang="en"></p>
      "! @parameter iv_handle_on_first_visible_tab | <p class="shorttext synchronized" lang="en"></p>
      "! @parameter iv_handle_on_tab_changed | <p class="shorttext synchronized" lang="en"></p>
      "! @parameter iv_handle_on_title_changed | <p class="shorttext synchronized" lang="en"></p>
      "! @parameter iv_handle_on_invisible_changed | <p class="shorttext synchronized" lang="en"></p>
      "! @parameter iv_handle_on_tab_removed | <p class="shorttext synchronized" lang="en"></p>
      set_handler_from_outside
        IMPORTING
          io_tab                         TYPE REF TO z2cl_ca_tab
          iv_handle_on_first_visible_tab TYPE abap_bool DEFAULT abap_true
          iv_handle_on_tab_changed       TYPE abap_bool DEFAULT abap_true
          iv_handle_on_title_changed     TYPE abap_bool DEFAULT abap_true
          iv_handle_on_invisible_changed TYPE abap_bool DEFAULT abap_true
          iv_handle_on_tab_removed       TYPE abap_bool DEFAULT abap_true,

      "! <p class="shorttext synchronized" lang="en">Handle PAI (Function Code) of Tab</p>
      "!
      "! @parameter iv_ucomm | <p class="shorttext synchronized" lang="en">Function Code</p>
      pai_tab
        IMPORTING
          iv_ucomm TYPE syucomm,

      "! <p class="shorttext synchronized" lang="en">Add new Tab to the Tabstrip</p>
      "!
      "! @parameter iv_repid | <p class="shorttext synchronized" lang="en">Reportname of the subscreen</p>
      "! @parameter iv_dynnr | <p class="shorttext synchronized" lang="en">Sreennumber of the subscreen</p>
      "! @parameter iv_ucomm | <p class="shorttext synchronized" lang="en">Function Code assigned to the Tab</p>
      "! @parameter iv_title | <p class="shorttext synchronized" lang="en">Title for the Tab</p>
      "! @parameter iv_icon | <p class="shorttext synchronized" lang="en">Icon placed in the Tab</p>
      "! @parameter iv_counter | <p class="shorttext synchronized" lang="en">Counter to show the amount of data in the Tab</p>
      "! @raising zcx_ca_tab_missing_param | <p class="shorttext synchronized" lang="en">Missing parameter for tab</p>
      add_tab
        IMPORTING
          iv_repid   TYPE syrepid
          iv_dynnr   TYPE sy-dynnr
          iv_ucomm   TYPE syucomm
          iv_title   TYPE z2ca_tab_title
          iv_icon    TYPE icon_4     OPTIONAL
          iv_counter TYPE i          OPTIONAL
        RAISING
          zcx_ca_tab_missing_param,

      "! <p class="shorttext synchronized" lang="en">Add new Tab to the Tabstrip</p>
      "!
      "! @parameter iv_repid | <p class="shorttext synchronized" lang="en">Reportname of the subscreen</p>
      "! @parameter iv_dynnr | <p class="shorttext synchronized" lang="en">Sreennumber of the subscreen</p>
      "! @parameter iv_ucomm | <p class="shorttext synchronized" lang="en">Function Code assigned to the Tab</p>
      remove_tab
        IMPORTING
          iv_repid TYPE syrepid
          iv_dynnr TYPE sy-dynnr
          iv_ucomm TYPE syucomm,

      "! <p class="shorttext synchronized" lang="en">Get data for the active Tab</p>
      "!
      "! @parameter rs_subscreen_data | <p class="shorttext synchronized" lang="en">Data for the active Tab</p>
      get_subscreen_data
        RETURNING
          VALUE(rs_subscreen_data) TYPE z2ca_subscreen_s,

      "! <p class="shorttext synchronized" lang="en">Get all Tab Titles</p>
      "!
      "! @parameter rr_tab_titles | <p class="shorttext synchronized" lang="en">Tab Titles</p>
      get_titles
        RETURNING
          VALUE(rr_tab_titles) TYPE REF TO data,

      "! <p class="shorttext synchronized" lang="en">Handle PBO (Screen Attributes) of Tabstrip</p>
      "!
      "! @parameter iv_repid | <p class="shorttext synchronized" lang="en">Reportname of Screen which contains Tabstrip</p>
      "! @parameter iv_dynnr | <p class="shorttext synchronized" lang="en">Sreennumber which contains the Tabstrip</p>
      pbo
        IMPORTING
          iv_repid TYPE syrepid DEFAULT sy-repid
          iv_dynnr TYPE sydynnr DEFAULT sy-dynnr,

      "! <p class="shorttext synchronized" lang="en">Check if the Tabstrip is still initial</p>
      "!
      "! @parameter rv_is_initial | <p class="shorttext synchronized" lang="en">"X" initial, " " Tab(s) already added</p>
      is_initial
        RETURNING
          VALUE(rv_is_initial) TYPE abap_bool,

      "! <p class="shorttext synchronized" lang="en">Handle if (in)visible state of Tab got changed</p>
      "!
      "! @parameter iv_tabname | <p class="shorttext synchronized" lang="en">Fieldname of the Structure used on the Screen</p>
      "! @parameter iv_invisible | <p class="shorttext synchronized" lang="en">(In)Visible State of the Tab</p>
      "! @parameter iv_ucomm | <p class="shorttext synchronized" lang="en">Function Code</p>
      handle_on_invisible_changed FOR EVENT on_invisible_changed OF z2cl_ca_tab
        IMPORTING
          iv_tabname
          iv_invisible
          iv_ucomm
          sender,

      "! <p class="shorttext synchronized" lang="en">Handle if (in)visible state of Tab got changed</p>
      "!
      "! @parameter iv_tabname | <p class="shorttext synchronized" lang="en">Fieldname of the Structure used on the Screen</p>
      "! @parameter iv_ucomm | <p class="shorttext synchronized" lang="en">Function Code</p>
      "! @parameter sender | <p class="shorttext synchronized" lang="en">sender instance</p>
      handle_on_tab_removed FOR EVENT on_tab_removed OF z2cl_ca_tab
        IMPORTING
          iv_tabname
          iv_ucomm
          sender,

      "! <p class="shorttext synchronized" lang="en">Handle if Title got changed</p>
      "!
      "! @parameter iv_tabname | <p class="shorttext synchronized" lang="en">Fieldname of the Structure used on the Screen</p>
      "! @parameter iv_title | <p class="shorttext synchronized" lang="en">Tab Title</p>
      handle_on_title_changed FOR EVENT on_title_changed OF z2cl_ca_tab
        IMPORTING
          iv_tabname
          iv_title
          sender,

      "! <p class="shorttext synchronized" lang="en">Handle to get the first visible Tab</p>
      "!
      "! @parameter is_subscreen_data | <p class="shorttext synchronized" lang="en">Data for the active Tab</p>
      handle_on_first_visible_tab FOR EVENT on_first_visible_tab OF z2cl_ca_tab
        IMPORTING
          is_subscreen_data
          sender,

      "! <p class="shorttext synchronized" lang="en">Handle the data of the Tab which got activated</p>
      "!
      "! @parameter is_subscreen_data | <p class="shorttext synchronized" lang="en">Data for the active Tab</p>
      handle_on_tab_changed FOR EVENT on_tab_changed OF z2cl_ca_tab
        IMPORTING
          is_subscreen_data
          sender.

    EVENTS:
      "! <p class="shorttext synchronized" lang="en">Let Tab object handle the Function Code</p>
      "!
      "! @parameter iv_ucomm | <p class="shorttext synchronized" lang="en">Function Code</p>
      check_for_tab_change
        EXPORTING
          VALUE(iv_ucomm) TYPE syucomm,

      "! <p class="shorttext synchronized" lang="en">Ask for the first visible Tab</p>
      "!
      check_for_visible_tab.

    EVENTS:
      "! <p class="shorttext synchronized" lang="en">Let Tab object handle the Function Code</p>
      "!
      "! @parameter iv_repid |<p class="shorttext synchronized" lang="en">ABAP Program: Current Master Program</p>
      "! @parameter iv_dynnr |<p class="shorttext synchronized" lang="en">Dynpro Number</p>
      on_remove_tab
        EXPORTING
          VALUE(iv_repid) TYPE syrepid
          VALUE(iv_dynnr) TYPE sydynnr.

  PROTECTED SECTION.
  PRIVATE SECTION.

    "! <p class="shorttext synchronized" lang="en">Alle erstellten Instanzen holen</p>
    "!
    CLASS-DATA gt_instances TYPE z2ca_tabstrip_instances_t.

    CLASS-METHODS:
      "! <p class="shorttext synchronized" lang="en"></p>
      "!
      "! @parameter is_tab_titles | <p class="shorttext synchronized" lang="en"></p>
      "! @parameter rv_structure_meets_requirement | <p class="shorttext synchronized" lang="en"></p>
      "! @raising zcx_ca_tabstrip_wrong_par_typ | <p class="shorttext synchronized" lang="en"></p>
      "! @raising zcx_ca_tab_wrong_fieldname | <p class="shorttext synchronized" lang="en"></p>
      _check_struc_meets_requirement
        IMPORTING
          is_tab_titles                         TYPE any
        RETURNING
          VALUE(rv_structure_meets_requirement) TYPE abap_bool
        RAISING
          zcx_ca_tabstrip_wrong_par_typ
          zcx_ca_tab_wrong_fieldname
          zcx_ca_wrong_data_type.

    "! <p class="shorttext synchronized" lang="en">Anzahl der hinzugefügten Tabs</p>
    DATA mv_tab_count TYPE i.
    "! <p class="shorttext synchronized" lang="en">Daten für den aktiven Tab</p>
    DATA ms_subscreen_data TYPE z2ca_subscreen_s.
**    "! <p class="shorttext synchronized" lang="en">Tabüberschriften</p>
**    DATA ms_tab_titles TYPE z2ca_tab_title_s.
    "! <p class="shorttext synchronized" lang="en">Name der Struktur, wie sie auf dem Dynpro benutzt wird</p>
    DATA mv_structname TYPE tabname.
    "! <p class="shorttext synchronized" lang="en">Reportname des Dynpro, welcher den Tabstrip beinhaltet</p>
    DATA mv_repid TYPE syrepid.
    "! <p class="shorttext synchronized" lang="en">Dynppr-Nummer, welche den Tabstrip beinhaltet</p>
    DATA mv_dynnr TYPE sydynnr.
    "! <p class="shorttext synchronized" lang="en">Anzahl der maximal möglichen Tabs</p>
    DATA mv_max_tab_count TYPE i.
    "! <p class="shorttext synchronized" lang="en">Welche Tabs sind (un)sichtbar</p>
    DATA mr_tab_invisible TYPE REF TO data.
    "! <p class="shorttext synchronized" lang="en">Tabbeschriftungen</p>
    DATA mr_tab_titles TYPE REF TO data.

    METHODS:
      "! <p class="shorttext synchronized" lang="en">Konstruktor Methode</p>
      "!
      "! @parameter iv_repid | <p class="shorttext synchronized" lang="en">Reportname of Screen which contains Tabstrip</p>
      "! @parameter iv_dynnr | <p class="shorttext synchronized" lang="en">Sreennumber which contains the Tabstrip</p>
      "! @parameter iv_structname | <p class="shorttext synchronized" lang="en">Structurename which is used for the Tabs on the Screen</p>
      "! @parameter iv_max_tab_count | <p class="shorttext synchronized" lang="en">Maximal count of tabs</p>
      "! @parameter is_tab_titles | <p class="shorttext synchronized" lang="en">Structure with all tab titles</p>
      constructor
        IMPORTING
          iv_repid         TYPE syrepid
          iv_dynnr         TYPE sydynnr
          iv_structname    TYPE tabname
          iv_max_tab_count TYPE i
          is_tab_titles    TYPE any
        RAISING
          zcx_ca_tabstrip_wrong_par_typ,

      "! <p class="shorttext synchronized" lang="en"></p>
      "!
      "! @parameter io_tab | <p class="shorttext synchronized" lang="en"></p>
      "! @parameter iv_handle_on_first_visible_tab | <p class="shorttext synchronized" lang="en"></p>
      "! @parameter iv_handle_on_tab_changed | <p class="shorttext synchronized" lang="en"></p>
      "! @parameter iv_handle_on_title_changed | <p class="shorttext synchronized" lang="en"></p>
      "! @parameter iv_handle_on_invisible_changed | <p class="shorttext synchronized" lang="en"></p>
      "! @parameter iv_handle_on_tab_removed | <p class="shorttext synchronized" lang="en"></p>
      _reset_handler
        IMPORTING
          io_tab                         TYPE REF TO z2cl_ca_tab
          iv_handle_on_first_visible_tab TYPE abap_bool DEFAULT abap_true
          iv_handle_on_tab_changed       TYPE abap_bool DEFAULT abap_true
          iv_handle_on_title_changed     TYPE abap_bool DEFAULT abap_true
          iv_handle_on_invisible_changed TYPE abap_bool DEFAULT abap_true
          iv_handle_on_tab_removed       TYPE abap_bool DEFAULT abap_true,

      "! <p class="shorttext synchronized" lang="en"></p>
      "!
      "! @parameter io_tab | <p class="shorttext synchronized" lang="en"></p>
      "! @parameter iv_handle_on_first_visible_tab | <p class="shorttext synchronized" lang="en"></p>
      "! @parameter iv_handle_on_tab_changed | <p class="shorttext synchronized" lang="en"></p>
      "! @parameter iv_handle_on_title_changed | <p class="shorttext synchronized" lang="en"></p>
      "! @parameter iv_handle_on_invisible_changed | <p class="shorttext synchronized" lang="en"></p>
      "! @parameter iv_handle_on_tab_removed | <p class="shorttext synchronized" lang="en"></p>
      _set_handler
        IMPORTING
          io_tab                         TYPE REF TO z2cl_ca_tab
          iv_handle_on_first_visible_tab TYPE abap_bool DEFAULT abap_true
          iv_handle_on_tab_changed       TYPE abap_bool DEFAULT abap_true
          iv_handle_on_title_changed     TYPE abap_bool DEFAULT abap_true
          iv_handle_on_invisible_changed TYPE abap_bool DEFAULT abap_true
          iv_handle_on_tab_removed       TYPE abap_bool DEFAULT abap_true,
      _create_tab_invisible_structur
        IMPORTING
          is_tab_titles TYPE any
        RAISING
          zcx_ca_tabstrip_wrong_par_typ.
ENDCLASS.



CLASS Z2CL_CA_TABSTRIP IMPLEMENTATION.


  METHOD add_tab.
    IF mv_tab_count + 1 LE mv_max_tab_count.
      z2cl_ca_tab=>get_instance( io_tabstrip = me
                                iv_repid = iv_repid
                                iv_dynnr = iv_dynnr
                                iv_ucomm = iv_ucomm
                                iv_title = iv_title
                                iv_icon = iv_icon
                                iv_counter = iv_counter ).
      mv_tab_count = mv_tab_count + 1.
    ENDIF.
  ENDMETHOD.


  METHOD constructor.
    mv_repid      = iv_repid.
    mv_dynnr      = iv_dynnr.
    mv_structname = iv_structname.
    mv_max_tab_count = iv_max_tab_count.
    CREATE DATA mr_tab_titles LIKE is_tab_titles.
    _create_tab_invisible_structur( is_tab_titles ).
  ENDMETHOD.


  METHOD get_instance.
    ASSIGN gt_instances[ tabstrip_control_name = iv_tabstrip_control_name ] TO FIELD-SYMBOL(<ls_instance>). "#EC CI_STDSEQ
    IF sy-subrc NE 0.
      IF iv_repid IS INITIAL OR iv_dynnr IS INITIAL OR iv_structname IS INITIAL OR is_tab_titles IS NOT SUPPLIED.
        DATA(lt_seosconame) = VALUE z2ca_parameter_list_t( ).
        IF iv_repid IS INITIAL.
          APPEND 'IV_REPID' TO lt_seosconame.
        ENDIF.
        IF iv_dynnr IS INITIAL.
          APPEND 'IV_DYNNR' TO lt_seosconame.
        ENDIF.
        IF iv_structname IS INITIAL.
          APPEND 'IV_STRUCTNAME' TO lt_seosconame.
        ENDIF.
        IF is_tab_titles IS INITIAL.
          APPEND 'IS_TAB_TITLES' TO lt_seosconame.
        ENDIF.
        RAISE EXCEPTION NEW zcx_ca_tabstrip_missing_param( iv_parameter1 = VALUE #( lt_seosconame[ 1 ] OPTIONAL )
                                                           iv_parameter2 = VALUE #( lt_seosconame[ 2 ] OPTIONAL )
                                                           iv_parameter3 = VALUE #( lt_seosconame[ 3 ] OPTIONAL )
                                                           iv_parameter4 = VALUE #( lt_seosconame[ 4 ] OPTIONAL ) ).
      ELSEIF cl_abap_typedescr=>describe_by_data( is_tab_titles ) IS NOT INSTANCE OF cl_abap_structdescr.
        RAISE EXCEPTION NEW zcx_ca_tabstrip_wrong_par_typ( iv_parameter = 'IS_TAB_TITLES'
                                                           iv_type      = 'CL_ABAP_STRUCTDESCR' ).
      ENDIF.
      _check_struc_meets_requirement( is_tab_titles ).
      APPEND VALUE #( tabstrip_control_name = iv_tabstrip_control_name
                      instance = NEW #( iv_repid = iv_repid
                                        iv_dynnr = iv_dynnr
                                        iv_structname  = iv_structname
                                        iv_max_tab_count = iv_max_tab_count
                                        is_tab_titles = is_tab_titles ) )
             TO gt_instances
             ASSIGNING <ls_instance>.
    ENDIF.
    ro_instance = <ls_instance>-instance.
  ENDMETHOD.


  METHOD get_subscreen_data.
    IF ms_subscreen_data-pressed_tab IS INITIAL.
      RAISE EVENT check_for_visible_tab.
    ENDIF.
    rs_subscreen_data = ms_subscreen_data.
  ENDMETHOD.


  METHOD get_titles.
    rr_tab_titles = mr_tab_titles.
  ENDMETHOD.


  METHOD handle_on_first_visible_tab.
    IF ms_subscreen_data-pressed_tab IS INITIAL.
      ms_subscreen_data = is_subscreen_data.
    ENDIF.
  ENDMETHOD.


  METHOD handle_on_invisible_changed.
    IF mr_tab_invisible IS BOUND.
      ASSIGN mr_tab_invisible->* TO FIELD-SYMBOL(<ls_tab_invisible>).
      ASSIGN COMPONENT iv_tabname OF STRUCTURE <ls_tab_invisible> TO FIELD-SYMBOL(<lv_invisible>).
      IF sy-subrc EQ 0.
        <lv_invisible> = iv_invisible.
      ENDIF.
      IF iv_invisible EQ abap_true AND ms_subscreen_data-pressed_tab EQ iv_ucomm.
        CLEAR: ms_subscreen_data-pressed_tab.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD handle_on_tab_changed.
    ms_subscreen_data = is_subscreen_data.
  ENDMETHOD.


  METHOD handle_on_tab_removed.
    IF mr_tab_invisible IS BOUND.
      ASSIGN mr_tab_invisible->* TO FIELD-SYMBOL(<ls_tab_invisible>).
      ASSIGN COMPONENT iv_tabname OF STRUCTURE <ls_tab_invisible> TO FIELD-SYMBOL(<lv_invisible>).
      IF sy-subrc EQ 0.
        CLEAR: <lv_invisible>.
      ENDIF.
    ENDIF.
    IF mr_tab_titles IS BOUND.
      ASSIGN mr_tab_titles->* TO FIELD-SYMBOL(<ls_tab_titles>).
      ASSIGN COMPONENT iv_tabname OF STRUCTURE <ls_tab_titles> TO FIELD-SYMBOL(<lv_tab_title>).
      IF sy-subrc EQ 0.
        CLEAR: <lv_tab_title>.
      ENDIF.
    ENDIF.
    IF ms_subscreen_data-pressed_tab EQ iv_ucomm.
      CLEAR: ms_subscreen_data-pressed_tab.
    ENDIF.
    _reset_handler( sender ).
  ENDMETHOD.


  METHOD handle_on_title_changed.
    IF mr_tab_titles IS BOUND.
      ASSIGN mr_tab_titles->* TO FIELD-SYMBOL(<ls_tab_titles>).
      ASSIGN COMPONENT iv_tabname OF STRUCTURE <ls_tab_titles> TO FIELD-SYMBOL(<lv_description>).
      IF sy-subrc EQ 0.
        <lv_description> = iv_title.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD is_initial.
    rv_is_initial = xsdbool( mv_tab_count EQ 0 ).
  ENDMETHOD.


  METHOD pai_tab.
    RAISE EVENT check_for_tab_change
      EXPORTING
        iv_ucomm = iv_ucomm.
  ENDMETHOD.


  METHOD pbo.
    IF iv_repid = mv_repid AND iv_dynnr = mv_dynnr.
      IF mr_tab_titles IS BOUND.
        ASSIGN mr_tab_titles->* TO FIELD-SYMBOL(<ls_tab_titles>).
        IF mr_tab_invisible IS BOUND.
          ASSIGN mr_tab_invisible->* TO FIELD-SYMBOL(<ls_tab_invisible>).
          LOOP AT SCREEN.
            IF strlen( screen-name ) EQ strlen( mv_structname ) + 6 AND substring_before( val = screen-name sub = '-' occ = 1 ) EQ mv_structname.
              DATA(lv_fieldname) = substring_after( val = screen-name sub = '-' occ = -1 ).
              ASSIGN COMPONENT lv_fieldname OF STRUCTURE <ls_tab_titles> TO FIELD-SYMBOL(<lv_tab_description>).
              ASSIGN COMPONENT lv_fieldname OF STRUCTURE <ls_tab_invisible> TO FIELD-SYMBOL(<lv_invisible>).
              IF ( <lv_tab_description> IS ASSIGNED AND <lv_tab_description> IS INITIAL ) OR
                 ( <lv_invisible> IS ASSIGNED AND <lv_invisible> EQ abap_true ).
                screen-output = 0.
                screen-active = 0.
              ENDIF.
            ENDIF.
            MODIFY SCREEN.
          ENDLOOP.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD remove_tab.
    RAISE EVENT on_remove_tab
      EXPORTING
        iv_repid = iv_repid
        iv_dynnr = iv_dynnr.
    cl_abap_memory_utilities=>do_garbage_collection( ).
  ENDMETHOD.


  METHOD set_handler_from_outside.
    _set_handler( io_tab                      = io_tab
                  iv_handle_on_first_visible_tab = iv_handle_on_first_visible_tab
                  iv_handle_on_tab_changed       = iv_handle_on_tab_changed
                  iv_handle_on_title_changed     = iv_handle_on_tab_changed
                  iv_handle_on_invisible_changed = iv_handle_on_invisible_changed
                  iv_handle_on_tab_removed       = iv_handle_on_tab_removed ).
  ENDMETHOD.


  METHOD _check_struc_meets_requirement.
    IF cl_abap_typedescr=>describe_by_data( is_tab_titles ) IS NOT INSTANCE OF cl_abap_structdescr.
      RAISE EXCEPTION NEW zcx_ca_tabstrip_wrong_par_typ( iv_parameter = 'IS_TAB_TITLES'
                                                         iv_type      = 'CL_ABAP_STRUCTDESCR' ).
    ENDIF.
    rv_structure_meets_requirement = abap_true.
    DATA(lt_components) = z2cl_ca_helper_tools=>get_components_by_data( is_tab_titles ).
    LOOP AT lt_components REFERENCE INTO DATA(lr_component).
      IF find( val = lr_component->name regex = `^TAB\d{2}$` ) NE 0.
        RAISE EXCEPTION NEW zcx_ca_tab_wrong_fieldname( iv_fieldname    = CONV #( lr_component->name )
                                                        iv_fieldpattern = 'TAB##' ).

      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD _create_tab_invisible_structur.
    IF cl_abap_typedescr=>describe_by_data( is_tab_titles ) IS NOT INSTANCE OF cl_abap_structdescr.
      RAISE EXCEPTION NEW zcx_ca_tabstrip_wrong_par_typ( iv_parameter = 'IS_TAB_TITLES'
                                                         iv_type      = 'CL_ABAP_STRUCTDESCR' ).
    ENDIF.
    TRY.
        DATA(lo_abap_elemdescr_char1) = cl_abap_elemdescr=>get_c( 1 ).
        DATA(lt_components) = CAST cl_abap_structdescr(  cl_abap_typedescr=>describe_by_data( is_tab_titles ) )->get_components( ).
        MODIFY lt_components FROM VALUE #( type = lo_abap_elemdescr_char1 )
                             TRANSPORTING type
                             WHERE name IS NOT INITIAL.  "#EC CI_STDSEQ
        DATA(lo_abap_structdescr) = cl_abap_structdescr=>create( lt_components ).
        CREATE DATA mr_tab_invisible TYPE HANDLE lo_abap_structdescr.
      CATCH cx_sy_struct_creation ##NO_HANDLER.
      CATCH cx_parameter_invalid_range ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.


  METHOD _reset_handler.
    IF iv_handle_on_first_visible_tab EQ abap_true.
      SET HANDLER handle_on_first_visible_tab FOR io_tab ACTIVATION space.
    ENDIF.
    IF iv_handle_on_tab_changed EQ abap_true.
      SET HANDLER handle_on_tab_changed FOR io_tab ACTIVATION space.
    ENDIF.
    IF iv_handle_on_title_changed EQ abap_true.
      SET HANDLER handle_on_title_changed FOR io_tab ACTIVATION space.
    ENDIF.
    IF iv_handle_on_invisible_changed EQ abap_true.
      SET HANDLER handle_on_invisible_changed FOR io_tab ACTIVATION space.
    ENDIF.
    IF iv_handle_on_tab_removed EQ abap_true.
      SET HANDLER handle_on_tab_removed FOR io_tab ACTIVATION space.
    ENDIF.
  ENDMETHOD.


  METHOD _set_handler.
    IF iv_handle_on_first_visible_tab EQ abap_true.
      SET HANDLER handle_on_first_visible_tab FOR io_tab.
    ENDIF.
    IF iv_handle_on_tab_changed EQ abap_true.
      SET HANDLER handle_on_tab_changed FOR io_tab.
    ENDIF.
    IF iv_handle_on_title_changed EQ abap_true.
      SET HANDLER handle_on_title_changed FOR io_tab.
    ENDIF.
    IF iv_handle_on_invisible_changed EQ abap_true.
      SET HANDLER handle_on_invisible_changed FOR io_tab.
    ENDIF.
    IF iv_handle_on_tab_removed EQ abap_true.
      SET HANDLER handle_on_tab_removed FOR io_tab.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
