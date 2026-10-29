SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-b01.
PARAMETERS p_displa TYPE z2ca_display_text RADIOBUTTON GROUP type USER-COMMAND type_changed.
PARAMETERS p_searc TYPE z2ca_search_text RADIOBUTTON GROUP type.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-b02.
PARAMETERS pa_so10 RADIOBUTTON GROUP rad1 DEFAULT 'X' USER-COMMAND rad.
PARAMETERS pa_se71 RADIOBUTTON GROUP rad1.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-b03.
PARAMETERS pa_mandt TYPE mandt DEFAULT sy-mandt MODIF ID s71.
SELECTION-SCREEN COMMENT 60(30) c_mandt MODIF ID s71.
PARAMETERS pa_langu TYPE langu DEFAULT sy-langu MODIF ID bot.
SELECTION-SCREEN COMMENT 60(30) c_langu MODIF ID bot.
SELECT-OPTIONS s_object  FOR thead-tdobject NO INTERVALS MATCHCODE OBJECT z2ca_tdobject_sh MODIF ID s10.
SELECT-OPTIONS s_form FOR thead-tdform NO INTERVALS MODIF ID s71.
SELECTION-SCREEN COMMENT 60(30) c_form MODIF ID s71.
SELECT-OPTIONS s_name FOR thead-tdname NO INTERVALS MODIF ID s10.
SELECTION-SCREEN COMMENT 60(30) c_name MODIF ID s10.
SELECT-OPTIONS s_tdid FOR thead-tdid   NO INTERVALS MODIF ID s10.
SELECTION-SCREEN COMMENT 60(30) c_tdid MODIF ID s10.
PARAMETERS p_search TYPE string LOWER CASE VISIBLE LENGTH 20 MODIF ID sea.

SELECTION-SCREEN SKIP 1.

SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE TEXT-b04.
SELECTION-SCREEN PUSHBUTTON 2(20) b_dynsel USER-COMMAND start_dyn_sel MODIF ID s10 VISIBLE LENGTH 20.
SELECTION-SCREEN PUSHBUTTON 24(30) b_delran USER-COMMAND delete_range MODIF ID s10 VISIBLE LENGTH 30.
SELECTION-SCREEN END OF BLOCK b4.

SELECTION-SCREEN SKIP 1.

PARAMETERS p_txtstr TYPE xfeld DEFAULT abap_true MODIF ID s10.

SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE TEXT-b05.
PARAMETERS pa_quest TYPE i.
SELECTION-SCREEN END OF BLOCK b5.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN INTO DATA(ls_screen).
    CASE ls_screen-group1.
      WHEN 'S71'.
        IF pa_se71 EQ abap_false.
          ls_screen-output = 0.
          ls_screen-active = 0.
        ENDIF.
      WHEN 'S10'.
        IF pa_so10 EQ abap_false.
          ls_screen-output = 0.
          ls_screen-active = 0.
        ENDIF.
      WHEN 'SEA'.
        IF p_searc EQ abap_false.
          ls_screen-output = 0.
          ls_screen-active = 0.
        ENDIF.
    ENDCASE.
    CASE ls_screen-name.
      WHEN 'B_DYNSEL'.
        IF NOT lcl_dynamic_screen=>get_instance( )->has_valid_tables( ).
          ls_screen-active = 0.
        ELSEIF lcl_dynamic_screen=>get_instance( )->has_ranges( ).
          ls_screen-input = 0.
        ENDIF.
      WHEN 'B_DELRAN'.
        IF NOT lcl_dynamic_screen=>get_instance( )->has_ranges( ).
          ls_screen-active = 0.
        ENDIF.
      WHEN 'S_OBJECT-LOW'.
        IF lcl_dynamic_screen=>get_instance( )->has_ranges( ).
          ls_screen-input = 0.
        ELSE.
          ls_screen-required = 2.
        ENDIF.
      WHEN 'P_SEARCH'.
        ls_screen-required = 2.
    ENDCASE.
    MODIFY SCREEN FROM ls_screen.
  ENDLOOP.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_tdid-low.
  PERFORM tdid_searchhelp.

AT SELECTION-SCREEN ON s_object.
  IF sscrfields-ucomm EQ 'ONLI' AND sy-ucomm EQ space.
    CLEAR: sscrfields-ucomm.
    RETURN.
  ELSEIF sscrfields-ucomm EQ 'ONLI'.
    IF pa_so10 EQ abap_true AND s_object IS INITIAL.
      CLEAR: sy-ucomm.
      MESSAGE e006.
    ENDIF.
  ENDIF.

AT SELECTION-SCREEN ON p_search.
  IF sscrfields-ucomm EQ 'ONLI' AND sy-ucomm EQ space.
    CLEAR: sscrfields-ucomm.
    RETURN.
  ELSEIF sscrfields-ucomm EQ 'ONLI'.
    IF p_searc EQ abap_true AND p_search IS INITIAL.
      CLEAR: sy-ucomm.
      MESSAGE 'Suchbegriff fehlt' TYPE 'E'.
    ENDIF.
  ENDIF.

AT SELECTION-SCREEN.
  PERFORM user_command_1000.
