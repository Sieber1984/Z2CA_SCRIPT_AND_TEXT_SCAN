REPORT z2ca_script_and_text_scan MESSAGE-ID z2ca_scripttext_scan.

INCLUDE z2ca_script_and_text_scan_top.  " Globale Daten/Global data
INCLUDE z2ca_script_and_text_scan_cl1.  " Dynamic Selection Screen
INCLUDE z2ca_script_and_text_scan_sel.  " Selektionsbildschirm/Selection screen
INCLUDE z2ca_script_and_text_scan_f01.  " Unterprogramme/Subroutines
INCLUDE z2ca_script_and_text_scan_o01.  " Process Before Output Screen 0100
INCLUDE z2ca_script_and_text_scan_i01.  " Process After Input Screen 0100

INITIALIZATION.
  PERFORM initialization.

START-OF-SELECTION.
  PERFORM get_and_prepare_data.

END-OF-SELECTION.
  CALL SCREEN 100.
