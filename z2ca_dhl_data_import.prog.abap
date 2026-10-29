**********************************************************************
* Function:    DHL Routing Code ASC MH10 data import
*
* Description: This report imports Bjjmmttt.DAT zipped into a file.
*
* created:     at 08.08.2024 by Stephan Köster
*
* Copyright:   consolut international ag
*              Ebnatstrasse 65c
*              CH-8200 Schaffhausen
*              Phone +41 52 533 8331
*              Fax   +41 52 533 8332
*              www.consolut.com
*
*------------|-------------|--------------------------------------------
* Date       | change user | modification
*------------|-------------|--------------------------------------------
* xx.xx.xxxx | xxx         | Kommentar
*------------|-------------|--------------------------------------------
REPORT z2ca_dhl_data_import.

INCLUDE z2ca_dhl_data_import_top.
INCLUDE z2ca_dhl_data_import_sel.
INCLUDE z2ca_dhl_data_import_f01.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM selection_screen_value_request.

AT SELECTION-SCREEN.
  PERFORM at_selection_screen.

START-OF-SELECTION.
  PERFORM start_of_selection.

END-OF-SELECTION.
  PERFORM end_of_selection.
