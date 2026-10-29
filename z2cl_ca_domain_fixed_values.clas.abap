CLASS z2cl_ca_domain_fixed_values DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES:
      "! <p class="shorttext synchronized">Domain fixed value key</p>
      BEGIN OF ty_domain_fixed_values,
        domain   TYPE domname,
        language TYPE spras,
      END OF ty_domain_fixed_values.

    "! <p class="shorttext synchronized">Get instance</p>
    "!
    "! @parameter is_domain_fixed_values_key | <p class="shorttext synchronized">Domain fixed value key</p>
    "! @parameter ro_instance                | <p class="shorttext synchronized">Instance</p>
    CLASS-METHODS get_instance
      IMPORTING
        is_domain_fixed_values_key TYPE ty_domain_fixed_values
      RETURNING
        VALUE(ro_instance)         TYPE REF TO z2cl_ca_domain_fixed_values.

    "! <p class="shorttext synchronized">Get instance by data reference</p>
    "!
    "! @parameter ir_data_reference | <p class="shorttext synchronized">Data reference</p>
    "! @parameter iv_language       | <p class="shorttext synchronized">Language of instance</p>
    "! @parameter ro_instance       | <p class="shorttext synchronized">Instance</p>
    CLASS-METHODS get_instance_by_data_ref
      IMPORTING
        ir_data_reference  TYPE REF TO data
        iv_language        TYPE spras DEFAULT sy-langu
      RETURNING
        VALUE(ro_instance) TYPE REF TO z2cl_ca_domain_fixed_values.

    "! <p class="shorttext synchronized">Get domian fixed value description</p>
    "!
    "! @parameter iv_fixed_value             | <p class="shorttext synchronized">Domain fixed value</p>
    "! @parameter iv_use_master_language_alt | <p class="shorttext synchronized">Use domain master language, if no value in instance language</p>
    "! @parameter rv_fixed_value_description | <p class="shorttext synchronized">Domain fixed value description</p>
    METHODS get_fixed_value_description
      IMPORTING
        iv_fixed_value                    TYPE domvalue_l
        iv_use_master_language_alt        TYPE abap_bool DEFAULT abap_true
      RETURNING
        VALUE(rv_fixed_value_description) TYPE ddtext.

  PRIVATE SECTION.
    "! <p class="shorttext synchronized">Instances</p>
    CLASS-DATA gt_instances TYPE STANDARD TABLE OF REF TO z2cl_ca_domain_fixed_values.
    "! <p class="shorttext synchronized">Domain fixed value key</p>
    DATA ms_domain_fixed_values_key TYPE ty_domain_fixed_values.
    "! <p class="shorttext synchronized">Domain master language</p>
    DATA mv_master_language TYPE spras.
    "! <p class="shorttext synchronized">Domain fixed values</p>
    DATA mt_domain_fixed_values TYPE STANDARD TABLE OF dd07v.

    "! <p class="shorttext synchronized">Constructor</p>
    "!
    "! @parameter is_domain_fixed_values_key | <p class="shorttext synchronized">Domain fixed value key</p>
    METHODS constructor
      IMPORTING
        is_domain_fixed_values_key TYPE ty_domain_fixed_values.

    "! <p class="shorttext synchronized">Determine master language of domain</p>
    "!
    METHODS _determine_master_language.

    "! <p class="shorttext synchronized">Determine domain fixed values</p>
    "!
    METHODS _determine_domain_fixed_values.
ENDCLASS.



CLASS z2cl_ca_domain_fixed_values IMPLEMENTATION.
  METHOD constructor.
    ms_domain_fixed_values_key = is_domain_fixed_values_key.
    _determine_master_language( ).
    _determine_domain_fixed_values( ).
    APPEND me TO gt_instances.
  ENDMETHOD.

  METHOD get_instance.
    ro_instance = COND #( WHEN line_exists( gt_instances[ table_line->ms_domain_fixed_values_key = is_domain_fixed_values_key ] )
                          THEN gt_instances[ table_line->ms_domain_fixed_values_key = is_domain_fixed_values_key ]
                          ELSE NEW #( is_domain_fixed_values_key ) ).
  ENDMETHOD.

  METHOD get_instance_by_data_ref.
    DATA(lo_abap_typedescr) = cl_abap_typedescr=>describe_by_data_ref( ir_data_reference ).
    IF lo_abap_typedescr IS INSTANCE OF cl_abap_elemdescr AND lo_abap_typedescr->is_ddic_type( ).
      DATA(lv_domain) = CAST cl_abap_elemdescr( lo_abap_typedescr )->get_ddic_field( )-domname.
    ELSE.
      lv_domain = '?'.
    ENDIF.
    ro_instance = get_instance( VALUE #( domain   = lv_domain
                                         language = iv_language ) ).
  ENDMETHOD.

  METHOD get_fixed_value_description.
    rv_fixed_value_description = VALUE #( mt_domain_fixed_values[ domvalue_l = iv_fixed_value ]-ddtext OPTIONAL ).
    IF rv_fixed_value_description IS INITIAL AND iv_use_master_language_alt EQ abap_true AND
       ms_domain_fixed_values_key-language NE mv_master_language.
      rv_fixed_value_description = z2cl_ca_domain_fixed_values=>get_instance(
                                       VALUE #( BASE ms_domain_fixed_values_key
                                                language = mv_master_language ) )->get_fixed_value_description(
                                                                                       iv_fixed_value             = iv_fixed_value
                                                                                       iv_use_master_language_alt = abap_false ).
    ENDIF.
  ENDMETHOD.

  METHOD _determine_master_language.
    SELECT SINGLE FROM tadir
           FIELDS masterlang
           WHERE pgmid EQ 'R3TR'
             AND object EQ 'DOMA'
             AND obj_name EQ @ms_domain_fixed_values_key-domain
           INTO @mv_master_language.
  ENDMETHOD.

  METHOD _determine_domain_fixed_values.
    CALL FUNCTION 'DD_DOMVALUES_GET'
      EXPORTING
        domname        = ms_domain_fixed_values_key-domain
        text           = 'T'
        langu          = ms_domain_fixed_values_key-language
      TABLES
        dd07v_tab      = mt_domain_fixed_values
      EXCEPTIONS
        wrong_textflag = 1
        OTHERS         = 2.
    IF sy-subrc NE 0.
      CLEAR mt_domain_fixed_values.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
