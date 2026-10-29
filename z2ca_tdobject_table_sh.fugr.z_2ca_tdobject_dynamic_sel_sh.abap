FUNCTION Z_2CA_TDOBJECT_DYNAMIC_SEL_SH.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  TABLES
*"      SHLP_TAB TYPE  SHLP_DESCT
*"      RECORD_TAB STRUCTURE  SEAHLPRES
*"  CHANGING
*"     VALUE(SHLP) TYPE  SHLP_DESCR
*"     VALUE(CALLCONTROL) LIKE  DDSHF4CTRL STRUCTURE  DDSHF4CTRL
*"----------------------------------------------------------------------
  DATA lt_tdobjects_with_text TYPE z2ca_table_obj_t.
  DATA lt_tdobject_range TYPE RANGE OF tdobject.
  DATA lt_tdtext_range TYPE RANGE OF tdtext.

  IF callcontrol-step NE 'SELECT'.
    EXIT.
  ENDIF.

  IF callcontrol-step EQ 'SELECT'.
    CALL FUNCTION 'F4UT_PARAMETER_VALUE_GET'
      EXPORTING
        parameter         = 'TDOBJECT'
      TABLES
        shlp_tab          = shlp_tab    " Table of Elementary Search Helps
        record_tab        = record_tab  " Hit list
      CHANGING
        shlp              = shlp        " Single (Current) Search Help
        callcontrol       = callcontrol " Control of the F4 process
      EXCEPTIONS
        parameter_unknown = 1                " Parameter ist nicht Parameter der Suchhilfe
        OTHERS            = 2.
    IF sy-subrc EQ 0.
      lt_tdobject_range = VALUE #( FOR ls_selopt IN shlp-selopt
                                           WHERE ( shlpfield EQ 'TDOBJECT' )
                                           ( CORRESPONDING #( ls_selopt ) ) ).
      lt_tdtext_range = VALUE #( FOR ls_selopt IN shlp-selopt
                                 WHERE ( shlpfield EQ 'TDTEXT' )
                                 ( CORRESPONDING #( ls_selopt ) ) ).

      IF gt_spras_range IS INITIAL.
        PERFORM fill_language_range.
      ENDIF.

      DATA(lv_order_by) = |Z~TDOBJECT ASCENDING{ COND #( WHEN VALUE #( gt_spras_range[ 1 ]-low OPTIONAL ) GT VALUE #( gt_spras_range[ 2 ]-low OPTIONAL )
                                                         THEN |, T~TDSPRAS DESCENDING|
                                                         ELSE |, T~TDSPRAS ASCENDING| ) }|.
      SELECT FROM z2ca_ttxob AS z
             LEFT OUTER JOIN ttxot AS t
               ON t~tdobject EQ z~tdobject
             FIELDS DISTINCT z~tdobject, t~tdtext, t~tdspras
             WHERE z~tdobject IN @lt_tdobject_range
               AND t~tdtext  IN @lt_tdtext_range
             ORDER BY (lv_order_by)
             INTO TABLE @DATA(lt_tdobjects_with_text_spras).

      DATA(lt_tdobjects_in_sys_languages) = lt_tdobjects_with_text_spras.
      DELETE lt_tdobjects_in_sys_languages WHERE tdspras NOT IN gt_spras_range.
      DELETE ADJACENT DUPLICATES FROM lt_tdobjects_in_sys_languages COMPARING tdobject.
      LOOP AT lt_tdobjects_with_text_spras REFERENCE INTO DATA(lr_result) WHERE tdspras NOT IN gt_spras_range.
        IF NOT line_exists( lt_tdobjects_in_sys_languages[ tdobject = lr_result->tdobject ] ).
          INSERT VALUE #( tdobject = lr_result->tdobject ) INTO TABLE lt_tdobjects_in_sys_languages.
        ENDIF.
      ENDLOOP.
      lt_tdobjects_with_text = CORRESPONDING #( lt_tdobjects_in_sys_languages ).

      CALL FUNCTION 'F4UT_RESULTS_MAP'
        EXPORTING
          source_structure  = shlp-intdescr-selmethod
        TABLES
          shlp_tab          = shlp_tab
          record_tab        = record_tab
          source_tab        = lt_tdobjects_with_text
        CHANGING
          shlp              = shlp
          callcontrol       = callcontrol
        EXCEPTIONS
          illegal_structure = 1
          OTHERS            = 2.

      callcontrol-step = 'DISP'.
    ENDIF.
    EXIT.
  ENDIF.
ENDFUNCTION.
