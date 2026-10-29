*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: Z2CA_TTXOB_V....................................*
TABLES: Z2CA_TTXOB_V, *Z2CA_TTXOB_V. "view work areas
CONTROLS: TCTRL_Z2CA_TTXOB_V
TYPE TABLEVIEW USING SCREEN '0100'.
DATA: BEGIN OF STATUS_Z2CA_TTXOB_V. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_Z2CA_TTXOB_V.
* Table for entries selected to show on screen
DATA: BEGIN OF Z2CA_TTXOB_V_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE Z2CA_TTXOB_V.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF Z2CA_TTXOB_V_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF Z2CA_TTXOB_V_TOTAL OCCURS 0010.
INCLUDE STRUCTURE Z2CA_TTXOB_V.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF Z2CA_TTXOB_V_TOTAL.

*.........table declarations:.................................*
TABLES: TTXOB                          .
TABLES: TTXOT                          .
TABLES: Z2CA_TTXOB                     .
