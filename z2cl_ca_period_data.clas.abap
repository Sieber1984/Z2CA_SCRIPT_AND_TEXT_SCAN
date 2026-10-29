CLASS z2cl_ca_period_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS get_first_day_of_period
      IMPORTING
        iv_date                 TYPE scdatum
        iv_period_ondicator     TYPE perkz
        iv_factory_calendar_key TYPE fabkl
      RETURNING
        VALUE(rv_elastday)      TYPE pedvv.

    CLASS-METHODS get_last_day_of_period
      IMPORTING
        iv_date                 TYPE scdatum
        iv_period_ondicator     TYPE perkz
        iv_factory_calendar_key TYPE fabkl
      RETURNING
        VALUE(rv_elastday)      TYPE pedvv.

  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_period_data,
        iperkz    TYPE perkz,
        ifabkl    TYPE fabkl,
        eperiod   TYPE pedvv,
        eperiop   TYPE pervv,
        efirstday TYPE pedvv,
        elastday  TYPE pedvv,
        epernr    TYPE anzpr,
      END OF ty_period_data.
    TYPES tty_period_data TYPE STANDARD TABLE OF ty_period_data.

    CLASS-DATA gt_period_data TYPE tty_period_data.

    CLASS-METHODS _determine_period_data
      IMPORTING
        iv_date                 TYPE scdatum
        iv_period_ondicator     TYPE perkz
        iv_factory_calendar_key TYPE fabkl
      RETURNING
        VALUE(rs_period_data)   TYPE ty_period_data.
ENDCLASS.



CLASS z2cl_ca_period_data IMPLEMENTATION.
  METHOD get_first_day_of_period.
    rv_elastday = _determine_period_data(
                    iv_date                 = iv_date
                    iv_period_ondicator     = iv_period_ondicator
                    iv_factory_calendar_key = iv_factory_calendar_key )-elastday.
  ENDMETHOD.

  METHOD get_last_day_of_period.
    rv_elastday = _determine_period_data(
                    iv_date                 = iv_date
                    iv_period_ondicator     = iv_period_ondicator
                    iv_factory_calendar_key = iv_factory_calendar_key )-elastday.
  ENDMETHOD.

  METHOD _determine_period_data.
    SELECT SINGLE FROM @gt_period_data AS period_data   ##ITAB_DB_SELECT ##ITAB_KEY_IN_SELECT
           FIELDS *
           WHERE iperkz EQ @iv_period_ondicator
             AND ifabkl EQ @iv_factory_calendar_key
             AND efirstday LE @iv_date
             AND elastday GE @iv_date
           INTO @rs_period_data.
    IF sy-subrc NE 0.
      CALL FUNCTION 'PERIODE_ZUM_DATUM'
        EXPORTING
          idate                      = iv_date
          iperkz                     = iv_period_ondicator
*         iperiv                     =
          ifabkl                     = iv_factory_calendar_key
*         ioffset                    = 0
*         inegoff                    =
        IMPORTING
          eperiod                    = rs_period_data-eperiod
          eperiop                    = rs_period_data-eperiop
          efirstday                  = rs_period_data-efirstday
          elastday                   = rs_period_data-elastday
          epernr                     = rs_period_data-epernr
        EXCEPTIONS
          periv_required             = 1
          periv_not_found            = 2
          perkz_invalid              = 3
          date_invalid               = 4
          factory_calendar_not_found = 5
          OTHERS                     = 6.
      IF sy-subrc EQ 0.
        rs_period_data-iperkz = iv_period_ondicator.
        rs_period_data-ifabkl = iv_factory_calendar_key.
        APPEND rs_period_data TO gt_period_data.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
