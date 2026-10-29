*&---------------------------------------------------------------------*
*& Form  INITIALIZATION
*&---------------------------------------------------------------------*
FORM initialization.
  PERFORM determine_searchhelp_descr.
  PERFORM restrict_sel_opt.
  PERFORM fill_comments.
ENDFORM.                    " INITIALIZATION

FORM determine_searchhelp_descr.
  CALL FUNCTION 'F4IF_GET_SHLP_DESCR'
    EXPORTING
      shlpname = 'H_TTXID'
    IMPORTING
      shlp     = gs_searchhelp_descr.

  LOOP AT gs_searchhelp_descr-interface ASSIGNING FIELD-SYMBOL(<ls_interface>).
    CASE <ls_interface>-shlpfield.
      WHEN 'TDOBJECT'.
        <ls_interface>-valfield = 'S_OBJECT-LOW'.
      WHEN 'TDID'.
        <ls_interface>-valfield = 'S_TDID-LOW'.
    ENDCASE.
  ENDLOOP.
ENDFORM.                    " INITIALIZATION

*&---------------------------------------------------------------------*
*& Form  RESTRICT_SEL_OPT
*&---------------------------------------------------------------------*
*  Only included search help with equal and contain pattern is valid
*----------------------------------------------------------------------*
FORM restrict_sel_opt.

  CALL FUNCTION 'SELECT_OPTIONS_RESTRICT'
    EXPORTING
      restriction            = VALUE sscr_restrict( opt_list_tab = VALUE #( ( name       = 'EQ'
                                                                              options-eq = 'X' )      " Restrict to equal
                                                                            ( name       = 'EQ_NE'
                                                                              options-eq = 'X'        " Restrict to equal
                                                                              options-ne = 'X' )      " Restrict to not equal
                                                                            ( name       = 'EQ_CP'
                                                                              options-eq = 'X'        " Restrict to equal and Contains pattern
                                                                              options-cp = 'X' )
                                                                            ( name       = 'EQ_CP_NE'
                                                                              options-eq = 'X'
                                                                              options-ne = 'X'
                                                                              options-cp = 'X' ) )
                                                    ass_tab      = VALUE #( ( kind       = 'S'
                                                                              name       = 'S_FORM'
                                                                              sg_main    = 'I'        " Restrict to Included
                                                                              sg_addy    = ''
                                                                              op_main    = 'EQ_CP' )
                                                                            ( kind       = 'S'
                                                                              name       = 'S_NAME'
                                                                              sg_main    = 'I'        " Restrict to Included
                                                                              sg_addy    = ''
                                                                              op_main    = 'EQ_CP' )
                                                                            ( kind       = 'S'
                                                                              name       = 'S_OBJECT'
                                                                              sg_main    = 'I'        " Restrict to Included
                                                                              sg_addy    = ''
                                                                              op_main    = 'EQ_NE' )
                                                                            ( kind       = 'S'
                                                                              name       = 'S_TDID'
                                                                              sg_main    = 'I'        " Restrict to Included
                                                                              sg_addy    = ''
                                                                              op_main    = 'EQ_CP' ) ) )
    EXCEPTIONS
      too_late               = 1
      repeated               = 2
      selopt_without_options = 3
      selopt_without_signs   = 4
      invalid_sign           = 5
      empty_option_list      = 6
      invalid_kind           = 7
      repeated_kind_a        = 8
      OTHERS                 = 9.
ENDFORM.                    " RESTRICT_SEL_OPT

*&---------------------------------------------------------------------*
*& Form  FILL_COMMENTS
*&---------------------------------------------------------------------*
FORM fill_comments .
  c_mandt = 'Leer = Alle Mandanten'(cma).
  c_langu = 'Leer = Alle Sprachen'(cla).
  c_form = 'Leer = Alle Formulare'(cfo).
  c_name = 'Leer = Alle Textnamen'(cna).
  c_tdid = 'Leer = Alle Text-IDs'(ctd).
  b_dynsel = 'Dynamische Selektion'(bto).
  b_delran = '@11@ Dynamische Selektion'(btd).
ENDFORM.                    " FILL_COMMENTS

*&---------------------------------------------------------------------*
*&      Form  TDID_SEARCHHELP
*&---------------------------------------------------------------------*
*       Suchhilfe für Text-ID
*
*       Searchhelp for Text-ID
*----------------------------------------------------------------------*
FORM tdid_searchhelp.
  DATA lv_subrc TYPE i.
  DATA return_values TYPE STANDARD TABLE OF ddshretval.

  DATA(lt_dynpfields) = VALUE dynpread_tabtype( FOR ls_interface IN gs_searchhelp_descr-interface
                                                WHERE ( valfield IS NOT INITIAL )
                                                ( fieldname  = ls_interface-valfield ) ).

  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      dyname     = sy-repid
      dynumb     = sy-dynnr
    TABLES
      dynpfields = lt_dynpfields.

  LOOP AT gs_searchhelp_descr-interface ASSIGNING FIELD-SYMBOL(<ls_interface>).
    <ls_interface>-value = VALUE #( lt_dynpfields[ fieldname = <ls_interface>-valfield ]-fieldvalue OPTIONAL ).
  ENDLOOP.

  CALL FUNCTION 'F4IF_START_VALUE_REQUEST'
    EXPORTING
      shlp          = gs_searchhelp_descr
      disponly      = ' '
    IMPORTING
      rc            = lv_subrc
    TABLES
      return_values = return_values.
  IF sy-subrc <> 0.
    MESSAGE s805(dh).
*    Anzeige nicht möglich (Inkonsistenz der Eingabehilfe)
  ELSE.
    LOOP AT lt_dynpfields ASSIGNING FIELD-SYMBOL(<ls_dynpfields>).
      <ls_dynpfields>-fieldvalue = VALUE #( return_values[ retfield = <ls_dynpfields>-fieldname ]-fieldval OPTIONAL ).
    ENDLOOP.

    CALL FUNCTION 'DYNP_VALUES_UPDATE'
      EXPORTING
        dyname               = sy-repid
        dynumb               = sy-dynnr
      TABLES
        dynpfields           = lt_dynpfields
      EXCEPTIONS
        invalid_abapworkarea = 1                " Kein gültiger Arbeitsbereich
        invalid_dynprofield  = 2                " Kein gültiges Dynprofeld
        invalid_dynproname   = 3                " Kein gültiger Dynproname
        invalid_dynpronummer = 4                " Ungültige Dynpronummer
        invalid_request      = 5                " Allgemeiner Anforderungsfehler
        no_fielddescription  = 6                " Keine Feldbeschreibung vorhanden
        undefind_error       = 7                " Undefinierter Fehler
        OTHERS               = 8.
    IF sy-subrc <> 0.
*     MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.

ENDFORM.

FORM user_command_1000.
  CASE sscrfields-ucomm.
    WHEN 'START_DYN_SEL'.
      lcl_dynamic_screen=>get_instance( )->get_dynamic_selection_data( REF #( s_object[] ) ).
      DATA(lt_tabnames) = lcl_dynamic_screen=>get_instance( )->get_tablenames_of_ranges( ).
      LOOP AT lt_tabnames REFERENCE INTO DATA(lr_tabname).
        IF NOT line_exists( s_object[ low = lr_tabname->* ] ).
          APPEND VALUE #( sign = 'I'
                          option = 'EQ'
                          low = lr_tabname->* ) TO s_object.
        ENDIF.
      ENDLOOP.
    WHEN 'DELETE_RANGE'.
      lcl_dynamic_screen=>get_instance( )->delete_range( ).
    WHEN 'RAD'.
      CASE abap_true.
        WHEN pa_se71.
          CLEAR p_txtstr.
        WHEN pa_so10.
          p_txtstr = abap_true.
      ENDCASE.
  ENDCASE.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form  GET_AND_PREPARE_DATA
*&---------------------------------------------------------------------*
FORM get_and_prepare_data.

  DATA(lo_dynamic_screen) = lcl_dynamic_screen=>get_instance( ).

  lo_dynamic_screen->fill_dynamic_selections( REF #( s_object[] ) ).

  DATA lt_thead TYPE bbpt_thead.
  DO 2 TIMES.
    CASE sy-index.
      WHEN 1.
        CASE abap_true.
          WHEN pa_so10.
            PERFORM select_texts CHANGING lt_thead sy-subrc .
          WHEN pa_se71.
            PERFORM select_forms CHANGING lt_thead sy-subrc.
        ENDCASE.
      WHEN 2.
        CASE abap_true.
          WHEN pa_so10.
            PERFORM find_string_in_texts CHANGING lt_thead sy-subrc.
          WHEN pa_se71.
            PERFORM find_string_in_forms CHANGING lt_thead sy-subrc.
        ENDCASE.
    ENDCASE.
    CASE sy-subrc.
      WHEN 4.
        "SY-SUBRC 4: Keine Formulare zur Selektion
        "SY-SUBRC 4: No forms found for selection
        MESSAGE s003 DISPLAY LIKE 'E'.
        LEAVE LIST-PROCESSING.
      WHEN 5.
        "SY-SUBRC 5: Keine Texte zur Selektion
        "SY-SUBRC 5: No texts found for selection
        MESSAGE s004 DISPLAY LIKE 'E'.
        LEAVE LIST-PROCESSING.
      WHEN 8.
        "SY-SUBRC 8: Keine Übereinstimmung gefunden
        "SY-SUBRC 8: No matches found
        MESSAGE s005 DISPLAY LIKE 'E'.
        LEAVE LIST-PROCESSING.
    ENDCASE.
  ENDDO.

ENDFORM.                    " GET_AND_PREPARE_DATA

*&---------------------------------------------------------------------*
*& Form  SELECT_TEXTS
*&---------------------------------------------------------------------*
*  Texte zur Selektion des Benutzers selektieren
*
*  Select texts for selection of user
*----------------------------------------------------------------------*
*  <->CV_SUBRC  rerun code
*----------------------------------------------------------------------*
FORM select_texts CHANGING ct_thead TYPE bbpt_thead
                           cv_subrc TYPE sysubrc.
  PERFORM select_text CHANGING ct_thead.
  PERFORM reduce_texts_by_selection CHANGING ct_thead.
  cv_subrc = COND #( WHEN ct_thead IS INITIAL THEN 5 ELSE 0 ).

ENDFORM.                    " SELECT_TEXTS

*&---------------------------------------------------------------------*
*& Form  SELECT_FORMS
*&---------------------------------------------------------------------*
*  Formulare zur Selektion des Benutzers selektieren
*
*  Select forms for selection of user
*----------------------------------------------------------------------*
*  <->CV_SUBRC  rerun code
*----------------------------------------------------------------------*
FORM select_forms CHANGING ct_thead TYPE bbpt_thead
                           cv_subrc TYPE sysubrc.
  DATA:
    lt_thead TYPE bbpt_thead.

  LOOP AT s_form.
    CALL FUNCTION 'SELECT_FORM'
      EXPORTING
        client     = COND mandt( WHEN pa_mandt IS NOT INITIAL THEN pa_mandt ELSE '*' )
        form       = s_form-low
        language   = COND langu( WHEN pa_langu IS NOT INITIAL THEN pa_langu ELSE '*' )
      TABLES
        selections = lt_thead.
    APPEND LINES OF lt_thead TO ct_thead.
  ENDLOOP.
  IF sy-subrc NE 0.
    CALL FUNCTION 'SELECT_FORM'
      EXPORTING
        client     = COND mandt( WHEN pa_mandt IS NOT INITIAL THEN pa_mandt ELSE '*' )
        form       = '*'
        language   = COND langu( WHEN pa_langu IS NOT INITIAL THEN pa_langu ELSE '*' )
      TABLES
        selections = lt_thead.
    APPEND LINES OF lt_thead TO ct_thead.
  ENDIF.
  cv_subrc = COND #( WHEN ct_thead IS INITIAL THEN 4 ELSE 0 ).

  DATA(lv_has_ranges) = lcl_dynamic_screen=>get_instance( )->has_ranges( ).
  PERFORM create_table USING ct_thead.
ENDFORM.                    " SELECT_FORMS

*&---------------------------------------------------------------------*
*& Form  FIND_STRING_IN_FORMS
*&---------------------------------------------------------------------*
*  Suchbegriff in selektierten Formularen suchen
*
*  Search search term in selected forms
*----------------------------------------------------------------------*
*  <->CV_SUBRC  rerun code
*----------------------------------------------------------------------*
FORM find_string_in_forms CHANGING ct_thead TYPE bbpt_thead
                                   cv_subrc TYPE sysubrc.
  DATA:
    form_lines          TYPE TABLE OF tline.

  FIELD-SYMBOLS <lt_output> TYPE STANDARD TABLE.

  ASSIGN gr_output->* TO <lt_output>.

  DATA(lv_entries) = lines( ct_thead ).
  LOOP AT ct_thead REFERENCE INTO DATA(lr_thead).
    IF sy-tabix GT 1 AND sy-tabix MOD 100 EQ 0.
      cl_progress_indicator=>progress_indicate(
        EXPORTING
          i_msgid              = 'Z2CA_SCRIPTTEXT_SCAN'
          i_msgno              = '001'
          i_msgv1              = |{ sy-tabix NUMBER = USER }|
          i_msgv2              = |{ lv_entries NUMBER = USER }|
          i_processed          = sy-tabix
          i_total              = lv_entries
          i_output_immediately = abap_true ).
    ENDIF.
    CALL FUNCTION 'READ_FORM'
      EXPORTING
        client     = lr_thead->mandt
        form       = lr_thead->tdform
        language   = lr_thead->tdspras
      TABLES
        form_lines = form_lines.
    IF form_lines IS INITIAL.
      CONTINUE.
    ENDIF.
    IF p_searc EQ abap_true.
      TRY.
          FIND ALL OCCURRENCES OF REGEX p_search
          IN TABLE form_lines
          IGNORING CASE
          RESULTS DATA(results).
        CATCH cx_sy_invalid_regex INTO DATA(lx_sy_invalid_regex).
          MESSAGE lx_sy_invalid_regex->get_text( ) TYPE 'S' DISPLAY LIKE 'E'.
          LEAVE LIST-PROCESSING.
      ENDTRY.

      IF sy-subrc EQ 0.
        LOOP AT form_lines REFERENCE INTO DATA(lr_form_line). "#EC CI_NESTED
          IF lr_form_line->tdformat EQ '/W'.
            DATA(lv_window) = lr_form_line->tdline.
            DATA(lv_element) = CONV tdline( `` ).
            CONTINUE.
          ENDIF.
          IF lr_form_line->tdformat EQ '/E'.
            lv_element = lr_form_line->tdline.
            CONTINUE.
          ENDIF.
          READ TABLE results ASSIGNING FIELD-SYMBOL(<ls_result>) WITH KEY line = sy-tabix.
          IF sy-subrc EQ 0.
            APPEND INITIAL LINE TO <lt_output> ASSIGNING FIELD-SYMBOL(<ls_output>).
            <ls_output> = CORRESPONDING #( lr_thead->* ).
            <ls_output> = CORRESPONDING #( BASE ( <ls_output> ) lr_form_line->* ).
            ASSIGN COMPONENT `WINDOW` OF STRUCTURE <ls_output> TO FIELD-SYMBOL(<lv_window>).
            IF sy-subrc EQ 0.
              <lv_window> = lv_window.
            ENDIF.
            ASSIGN COMPONENT `ELEMENT` OF STRUCTURE <ls_output> TO FIELD-SYMBOL(<lv_element>).
            IF sy-subrc EQ 0.
              <lv_element> = lv_element.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ELSE.
      LOOP AT form_lines REFERENCE INTO lr_form_line.    "#EC CI_NESTED
        IF lr_form_line->tdformat EQ '/W'.
          lv_window = lr_form_line->tdline.
          CLEAR lv_element.
          CONTINUE.
        ENDIF.
        IF lr_form_line->tdformat EQ '/E'.
          lv_element = lr_form_line->tdline.
          CONTINUE.
        ENDIF.
        APPEND INITIAL LINE TO <lt_output> ASSIGNING <ls_output>.
        <ls_output> = CORRESPONDING #( lr_thead->* ).
        <ls_output> = CORRESPONDING #( BASE ( <ls_output> ) lr_form_line->* ).
        ASSIGN COMPONENT `WINDOW` OF STRUCTURE <ls_output> TO <lv_window>.
        IF sy-subrc EQ 0.
          <lv_window> = lv_window.
        ENDIF.
        ASSIGN COMPONENT `ELEMENT` OF STRUCTURE <ls_output> TO <lv_element>.
        IF sy-subrc EQ 0.
          <lv_element> = lv_element.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDLOOP.
  IF <lt_output> IS INITIAL.
    cv_subrc = 8.
  ENDIF.
ENDFORM.                    " FIND_STRING_IN_FORMS

*&---------------------------------------------------------------------*
*& Form  FIND_STRING_IN_TEXTS
*&---------------------------------------------------------------------*
*  Suchbegriff in selektierten Texten suchen
*
*  Search search term in selected texts
*----------------------------------------------------------------------*
*  <->CV_SUBRC  rerun code
*----------------------------------------------------------------------*
FORM find_string_in_texts CHANGING ct_thead TYPE bbpt_thead
                                   cv_subrc TYPE sysubrc.
  DATA lv_answer  TYPE char1.
  DATA form_lines TYPE TABLE OF tline.
  DATA lv_text_string TYPE string.

  FIELD-SYMBOLS <lt_output> TYPE STANDARD TABLE.

  ASSIGN gr_output->* TO <lt_output>.
  DATA(lv_entries) = lines( ct_thead ).
  DATA(lv_entries_found) = 0.
  LOOP AT ct_thead REFERENCE INTO DATA(lr_thead).
    DATA(lv_tabix) = sy-tabix.
    IF lv_tabix GT 1 AND pa_quest IS NOT INITIAL AND lv_tabix MOD pa_quest EQ 0.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          text_question = 'Weiter?'
        IMPORTING
          answer        = lv_answer.
      IF lv_answer EQ 2.
        EXIT.
      ENDIF.
    ENDIF.
    DATA(lv_org_data_are_valid) = abap_false.
    PERFORM check_org_data_are_valid USING lr_thead->tdobject
                                           lr_thead->tdname
                                  CHANGING lv_org_data_are_valid.
    IF lv_org_data_are_valid EQ abap_false.
      CONTINUE.
    ENDIF.
    DATA(lv_entry_found) = abap_false.
    IF lv_tabix GT 1 AND lv_tabix MOD 100 EQ 0.
      cl_progress_indicator=>progress_indicate(
        EXPORTING
          i_msgid              = 'Z2CA_SCRIPTTEXT_SCAN'
          i_msgno              = COND #( WHEN lv_entries_found GT 0
                                         THEN '002'
                                         ELSE '001' )
          i_msgv1              = COND #( WHEN lv_entries_found GT 0
                                         THEN |{ lv_entries_found NUMBER = USER }|
                                         ELSE |{ lv_tabix NUMBER = USER }| )
          i_msgv2              = COND #( WHEN lv_entries_found GT 0
                                         THEN |{ lv_tabix NUMBER = USER }|
                                         ELSE |{ lv_entries NUMBER = USER }| )
          i_msgv3              = COND #( WHEN lv_entries_found GT 0
                                         THEN |{ lv_entries NUMBER = USER }| )
          i_processed          = sy-tabix
          i_total              = lv_entries
          i_output_immediately = abap_true ).
    ENDIF.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = lr_thead->mandt
        id                      = lr_thead->tdid
        language                = lr_thead->tdspras
        name                    = lr_thead->tdname
        object                  = lr_thead->tdobject
      TABLES
        lines                   = form_lines
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
      CONTINUE.
    ENDIF.
    IF form_lines IS INITIAL.
      CONTINUE.
    ENDIF.
    IF p_searc EQ abap_true.
      TRY.
          FIND ALL OCCURRENCES OF REGEX p_search
          IN TABLE form_lines
          IGNORING CASE
          RESULTS DATA(results).
        CATCH cx_sy_invalid_regex INTO DATA(lx_sy_invalid_regex).
          MESSAGE lx_sy_invalid_regex->get_text( ) TYPE 'S' DISPLAY LIKE 'E'.
          LEAVE LIST-PROCESSING.
      ENDTRY.

      IF sy-subrc EQ 0.
        lv_entries_found = lv_entries_found + 1.
        LOOP AT form_lines REFERENCE INTO DATA(lr_form_line). "#EC CI_NESTED
          lv_tabix = sy-tabix.
          IF line_exists( results[ line = lv_tabix ] ).
            APPEND INITIAL LINE TO <lt_output> ASSIGNING FIELD-SYMBOL(<ls_output>).
            <ls_output> = CORRESPONDING #( lr_thead->* ).
            <ls_output> = CORRESPONDING #( BASE ( <ls_output> ) lr_form_line->* ).
          ENDIF.
        ENDLOOP.
      ENDIF.
    ELSE.
      IF p_txtstr EQ abap_true.
        CALL FUNCTION 'IDMX_DI_TLINE_INTO_STRING'
          EXPORTING
            it_tline       = form_lines
          IMPORTING
            ev_text_string = lv_text_string.
        APPEND INITIAL LINE TO <lt_output> ASSIGNING <ls_output>.
        <ls_output> = CORRESPONDING #( lr_thead->* ).
        ASSIGN COMPONENT `TDLINE_AS_STRING` OF STRUCTURE <ls_output> TO FIELD-SYMBOL(<lv_tdtext>).
        IF sy-subrc EQ 0.
          <lv_tdtext> = lv_text_string.
        ENDIF.
        PERFORM fill_org_data_into_output USING lr_thead->tdobject
                                                lr_thead->tdname
                                       CHANGING <ls_output>.
      ELSE.
        LOOP AT form_lines REFERENCE INTO lr_form_line.  "#EC CI_NESTED
          APPEND INITIAL LINE TO <lt_output> ASSIGNING <ls_output>.
          <ls_output> = CORRESPONDING #( lr_thead->* ).
          <ls_output> = CORRESPONDING #( BASE ( <ls_output> ) lr_form_line->* ).
          PERFORM fill_org_data_into_output USING lr_thead->tdobject
                                                  lr_thead->tdname
                                         CHANGING <ls_output>.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDLOOP.
  IF <lt_output> IS INITIAL.
    cv_subrc = 8.
  ENDIF.
ENDFORM.                    " FIND_STRING_IN_TEXTS

FORM check_org_data_are_valid USING iv_tdobject TYPE tdobject
                                    iv_tdname TYPE tdobname
                           CHANGING cv_org_data_are_valid.

  DATA lr_org_data TYPE REF TO data.

  cv_org_data_are_valid = abap_true.

  IF lcl_dynamic_screen=>get_instance( )->is_valid_table( CONV #( iv_tdobject ) ).

    PERFORM create_struct_by_name USING iv_tdobject
                               CHANGING lr_org_data.
    IF lr_org_data IS BOUND.
      ASSIGN lr_org_data->* TO FIELD-SYMBOL(<ls_org_data>).
      IF sy-subrc EQ 0.
        <ls_org_data> = iv_tdname.
        DATA(ls_range) = lcl_dynamic_screen=>get_instance( )->get_range( CONV #( iv_tdobject ) ).
        LOOP AT ls_range-frange_t REFERENCE INTO DATA(lr_field_range)
             WHERE selopt_t IS NOT INITIAL.
          DATA(lv_fieldname) = |{ ls_range-tablename }_{ lr_field_range->fieldname }|.
          ASSIGN COMPONENT lv_fieldname OF STRUCTURE <ls_org_data> TO FIELD-SYMBOL(<lv_value>).
          IF sy-subrc EQ 0.
            IF <lv_value> NOT IN lr_field_range->selopt_t.
              CLEAR cv_org_data_are_valid.
              RETURN.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.

FORM fill_org_data_into_output USING iv_tdobject TYPE tdobject
                                     iv_tdname TYPE tdobname
                            CHANGING cs_output TYPE any.
  DATA lr_org_data TYPE REF TO data.

  IF lcl_dynamic_screen=>get_instance( )->is_valid_table( CONV #( iv_tdobject ) ).

    PERFORM create_struct_by_name USING iv_tdobject
                               CHANGING lr_org_data.
    IF lr_org_data IS BOUND.
      ASSIGN lr_org_data->* TO FIELD-SYMBOL(<ls_org_data>).
      IF sy-subrc EQ 0.
        <ls_org_data> = iv_tdname.
        cs_output = CORRESPONDING #( BASE ( cs_output ) <ls_org_data> ).
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.

FORM create_struct_by_name USING iv_tdobject
                        CHANGING cr_struct_data.
  DATA lo_abap_structdescr TYPE REF TO cl_abap_structdescr.

  PERFORM create_structdescr_by_name USING iv_tdobject
                                  CHANGING lo_abap_structdescr.
  IF lo_abap_structdescr IS BOUND.
    CREATE DATA cr_struct_data TYPE HANDLE lo_abap_structdescr.
  ENDIF.
ENDFORM.

FORM create_structdescr_by_name USING iv_tdobject
                             CHANGING co_abap_structdescr TYPE REF TO cl_abap_structdescr.
  DATA lt_components TYPE abap_component_tab.

  PERFORM get_keyfields_of_table USING iv_tdobject
                              CHANGING lt_components.
  IF lt_components IS NOT INITIAL.
    TRY.
        co_abap_structdescr = cl_abap_structdescr=>create( lt_components ).
      CATCH cx_sy_struct_creation ##NO_HANDLER.
    ENDTRY.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SELECT_TEXT
*&---------------------------------------------------------------------*
*       Kopfdaten der Texte ermitteln
*
*       Determine header data of texts
*----------------------------------------------------------------------*
*      -->uv_name   Textname
*      -->uv_tdid   Text-ID
*      <->CT_THEAD  Gefundene Texte
*----------------------------------------------------------------------*
FORM select_text CHANGING ct_thead TYPE bbpt_thead.

  CALL FUNCTION 'SELECT_TEXT'
    EXPORTING
      client     = COND mandt( WHEN pa_mandt IS NOT INITIAL THEN pa_mandt ELSE '*' )
      object     = '*'
      name       = '*'
      language   = COND langu( WHEN pa_langu IS NOT INITIAL THEN pa_langu ELSE '*' )
      id         = '*'
    TABLES
      selections = ct_thead.

ENDFORM.

FORM reduce_texts_by_selection CHANGING ct_thead TYPE bbpt_thead.
  DO.
    CASE sy-index.
      WHEN 1.
        DATA(lv_where) = COND #( WHEN s_object IS NOT INITIAL
                                 THEN `TDOBJECT NOT IN S_OBJECT` ).
      WHEN 2.
        lv_where = COND #( WHEN s_tdid IS NOT INITIAL
                           THEN |{ COND #( WHEN lv_where IS NOT INITIAL
                                           THEN |{ lv_where } OR | ) }TDID NOT IN S_TDID|
                           ELSE lv_where ).
      WHEN 3.
        lv_where = COND #( WHEN s_name IS NOT INITIAL
                           THEN |{ COND #( WHEN lv_where IS NOT INITIAL
                                           THEN |{ lv_where } OR | ) }TDNAME NOT IN S_NAME|
                           ELSE lv_where ).
      WHEN 4.
        lv_where = |{ COND #( WHEN lv_where IS NOT INITIAL
                              THEN |{ lv_where } OR | ) }TDOBJECT EQ 'FORM'|.
      WHEN OTHERS.
        EXIT.
    ENDCASE.
  ENDDO.
  IF lv_where IS NOT INITIAL.
    DELETE ct_thead WHERE (lv_where).
  ENDIF.
  PERFORM reduce_texts_by_org_data CHANGING ct_thead.
ENDFORM.

FORM reduce_texts_by_org_data CHANGING ct_thead TYPE bbpt_thead.
  DATA(lv_has_ranges) = lcl_dynamic_screen=>get_instance( )->has_ranges( ).
  PERFORM create_table USING ct_thead.
ENDFORM.

FORM create_table USING it_thead TYPE bbpt_thead.
  DATA lt_components TYPE abap_component_tab.

  PERFORM get_components_using_thead USING it_thead
                                  CHANGING lt_components.

  TRY.
      DATA(lo_abap_structdescr) = cl_abap_structdescr=>create( lt_components ).
      DATA(lo_abap_tabledescr) = cl_abap_tabledescr=>create( lo_abap_structdescr ).
      CREATE DATA gr_output TYPE HANDLE lo_abap_tabledescr.
    CATCH cx_sy_table_creation ##NO_HANDLER.
    CATCH cx_sy_struct_creation ##NO_HANDLER.
  ENDTRY.
ENDFORM.

FORM get_components CHANGING ct_components TYPE abap_component_tab.
  DATA ls_se71 TYPE z2ca_se71.
  DATA ls_so10 TYPE z2ca_so10.
  DATA ls_so10x TYPE z2ca_so10x.


  IF pa_se71 EQ abap_true.
    ct_components = CAST cl_abap_structdescr( cl_abap_structdescr=>describe_by_data( ls_se71 ) )->get_components( ).
  ELSE.
    IF p_txtstr EQ abap_false.
      ct_components = CAST cl_abap_structdescr( cl_abap_structdescr=>describe_by_data( ls_so10 ) )->get_components( ).
    ELSE.
      ct_components = CAST cl_abap_structdescr( cl_abap_structdescr=>describe_by_data( ls_so10x ) )->get_components( ).
    ENDIF.
  ENDIF.
ENDFORM.

FORM get_components_using_thead USING it_thead TYPE bbpt_thead
                             CHANGING ct_components TYPE abap_component_tab.
  PERFORM get_components CHANGING ct_components.

  PERFORM get_components_of_org_data USING it_thead
                                  CHANGING ct_components.

ENDFORM.

FORM get_components_of_org_data USING it_thead TYPE bbpt_thead
                             CHANGING ct_components TYPE abap_component_tab.
  DATA(lt_thead) = it_thead.
  SORT lt_thead BY tdobject.
  DELETE ADJACENT DUPLICATES FROM lt_thead COMPARING tdobject.
  LOOP AT lt_thead REFERENCE INTO DATA(lr_thead).
    IF lcl_dynamic_screen=>get_instance( )->is_valid_table( CONV #( lr_thead->tdobject ) ).
      PERFORM get_keyfields_of_table USING lr_thead->tdobject
                                  CHANGING ct_components.
    ENDIF.
  ENDLOOP.
ENDFORM.

FORM get_keyfields_of_table USING iv_tdobject
                         CHANGING ct_components TYPE abap_component_tab.
  DATA(lt_ddic_fields_list) = CAST cl_abap_structdescr( cl_abap_typedescr=>describe_by_name( iv_tdobject ) )->get_ddic_field_list( p_including_substructres = abap_true ).
  DATA(lt_compnents) = CAST cl_abap_structdescr( cl_abap_typedescr=>describe_by_name( iv_tdobject ) )->get_components( ).
  LOOP AT lt_ddic_fields_list REFERENCE INTO DATA(lr_ddic_field) WHERE keyflag EQ abap_true
                                                                   AND datatype NE 'CLNT'.
    APPEND VALUE #( name = |{ iv_tdobject }_{ lr_ddic_field->fieldname }|
                    type = lt_compnents[ name = lr_ddic_field->fieldname ]-type )
           TO ct_components.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form  DISPLAY_RESULT
*&---------------------------------------------------------------------*
FORM display_result.
  DATA lt_fieldcatalog TYPE lvc_t_fcat.
  STATICS lv_first_call TYPE abap_bool VALUE abap_true.

  FIELD-SYMBOLS <lt_output> TYPE STANDARD TABLE.

  ASSIGN gr_output->* TO <lt_output>.

  IF lv_first_call EQ abap_true.
    CLEAR lv_first_call.

    PERFORM get_fieldcatalog CHANGING lt_fieldcatalog.

    DATA(lo_gui_alv_grid) = NEW cl_gui_alv_grid( NEW cl_gui_custom_container( 'RESULTS' ) ).

    lo_gui_alv_grid->set_table_for_first_display(
      EXPORTING
        is_layout                     = VALUE #( zebra      = abap_true
                                                 cwidth_opt = abap_true
                                                 col_opt    = abap_true )
      CHANGING
        it_outtab                     = <lt_output>
        it_fieldcatalog               = lt_fieldcatalog
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4 ).
    IF sy-subrc NE 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDIF.

ENDFORM.                    " DISPLAY_RESULT

FORM get_fieldcatalog CHANGING ct_fieldcatalog TYPE lvc_t_fcat.
  DATA lt_components TYPE abap_component_tab.
  FIELD-SYMBOLS <lt_output> TYPE STANDARD TABLE.

  DATA(lv_text_structure) = COND #( WHEN pa_se71 EQ abap_true
                                    THEN gc_text_structure-se71
                                    WHEN p_txtstr EQ abap_false
                                    THEN gc_text_structure-so10
                                    ELSE gc_text_structure-so10x ).

  ASSIGN gr_output->* TO <lt_output>.
  TRY.
      cl_salv_table=>factory(
        IMPORTING
          r_salv_table   = DATA(salv_table)
        CHANGING
          t_table        = <lt_output>  ).
      ct_fieldcatalog = cl_salv_controller_metadata=>get_lvc_fieldcatalog(
                          r_columns      = salv_table->get_columns( )
                          r_aggregations = salv_table->get_aggregations( ) ).

      PERFORM get_components CHANGING lt_components.
      LOOP AT ct_fieldcatalog ASSIGNING FIELD-SYMBOL(<ls_fieldcatalog>).
        IF line_exists( lt_components[ name = <ls_fieldcatalog>-fieldname ] ).
          <ls_fieldcatalog>-ref_table = lv_text_structure.
          <ls_fieldcatalog>-ref_field = <ls_fieldcatalog>-fieldname.
        ENDIF.
      ENDLOOP.
      IF line_exists( ct_fieldcatalog[ ref_table = '' ] ).
        LOOP AT lcl_dynamic_screen=>get_instance( )->get_tablenames( ) REFERENCE INTO DATA(lr_tablename).
          LOOP AT ct_fieldcatalog ASSIGNING <ls_fieldcatalog> WHERE fieldname CP |{ lr_tablename->* }*|. "#EC CI_NESTED
            <ls_fieldcatalog>-ref_table = lr_tablename->*.
            <ls_fieldcatalog>-ref_field = substring_after( val = <ls_fieldcatalog>-fieldname sub = |{ lr_tablename->* }_| ).
          ENDLOOP.
        ENDLOOP.
      ENDIF.
    CATCH cx_salv_msg ##NO_HANDLER.
  ENDTRY.
ENDFORM.
