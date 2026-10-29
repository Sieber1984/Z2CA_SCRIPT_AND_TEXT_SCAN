TYPE-POOLS: sscr, abap.

TABLES sscrfields.
TABLES thead.

CONSTANTS:
  BEGIN OF gc_text_structure,
    se71  TYPE tabname VALUE 'Z2CA_SE71',
    so10  TYPE tabname VALUE 'Z2CA_SO10',
    so10x TYPE tabname VALUE 'Z2CA_SO10X',
  END OF gc_text_structure.

DATA gs_searchhelp_descr TYPE shlp_descr_t ##NEEDED.
DATA gr_output TYPE REF TO data ##NEEDED.
