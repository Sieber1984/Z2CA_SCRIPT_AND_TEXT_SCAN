CLASS lcl_selection_screen DEFINITION CREATE PRIVATE.
  PUBLIC SECTION.
    CLASS-METHODS get_instance
      RETURNING
        VALUE(ro_instance) TYPE REF TO lcl_selection_screen.

    METHODS pbo.

    METHODS pai_on_field
      IMPORTING
        iv_fieldname    TYPE fieldname
      CHANGING
        cv_syucomm      TYPE syucomm
        cv_screen_ucomm TYPE syucomm.

  PRIVATE SECTION.
    CONSTANTS:
      BEGIN OF co_modif_ids,
        obligatory            TYPE c LENGTH 3 VALUE 'OBL',
        read_only             TYPE c LENGTH 3 VALUE 'REO',
        invisible             TYPE c LENGTH 3 VALUE 'INV',
        obligatory_fieldgroup TYPE c LENGTH 3 VALUE 'OG+',
      END OF co_modif_ids.

    CLASS-DATA go_instance TYPE REF TO lcl_selection_screen.

    METHODS constructor.
ENDCLASS.

CLASS lcl_selection_screen IMPLEMENTATION.
  METHOD constructor.
    go_instance = me.
  ENDMETHOD.

  METHOD get_instance.
    ro_instance = COND #( WHEN go_instance IS BOUND
                          THEN go_instance
                          ELSE NEW #( ) ).
  ENDMETHOD.

  METHOD pbo.
    LOOP AT SCREEN INTO DATA(ls_screen).
      CASE ls_screen-group1.
        WHEN co_modif_ids-read_only.
          ls_screen-input = 0.
        WHEN co_modif_ids-invisible.
          ls_screen-active = 0.
        WHEN co_modif_ids-obligatory.
          CASE ls_screen-group3.
            WHEN 'PAR' OR 'LOW'.
              ls_screen-required = 2.
          ENDCASE.
        WHEN OTHERS.
          IF ls_screen-group1 IS NOT INITIAL AND
             ls_screen-group1 CP co_modif_ids-obligatory_fieldgroup.
            ls_screen-required = 2.
          ENDIF.
      ENDCASE.
      MODIFY SCREEN FROM ls_screen.
    ENDLOOP.
  ENDMETHOD.

  METHOD pai_on_field.
    FIELD-SYMBOLS <lv_screen_field_description> TYPE any.
    IF ( cv_screen_ucomm EQ 'ONLI' OR cv_screen_ucomm EQ 'SJOB' ) AND
       cv_syucomm EQ space.
      CLEAR: cv_screen_ucomm.
      RETURN.
    ELSEIF ( cv_screen_ucomm EQ 'ONLI' OR cv_screen_ucomm EQ 'SJOB' ).
      DATA(lv_actual_group4) = '   '.
      LOOP AT SCREEN.
        IF screen-group4 NE lv_actual_group4.
          lv_actual_group4 = screen-group4.
          UNASSIGN <lv_screen_field_description>.
        ENDIF.
        CASE screen-group3.
          WHEN 'TXT'.
            ASSIGN (screen-name) TO <lv_screen_field_description>.
          WHEN 'PAR' OR 'LOW'.
            IF screen-name EQ iv_fieldname.
              IF screen-required EQ 2.
                ASSIGN (screen-name) TO FIELD-SYMBOL(<lv_screen_field_value>).
                IF sy-subrc EQ 0 AND <lv_screen_field_value> IS INITIAL.
                  CLEAR cv_syucomm.
                  IF <lv_screen_field_description> IS ASSIGNED.
                    MESSAGE e278(00) WITH <lv_screen_field_description>.
                  ELSE.
                    MESSAGE e055(00).
                  ENDIF.
                ENDIF.
                EXIT.
              ELSE.
                EXIT.
              ENDIF.
            ENDIF.
        ENDCASE.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
