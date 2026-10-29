CLASS z2cl_ca_bil_tran_messages DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_display_structures,
        structure TYPE tabname,
      END OF ty_display_structures.
    TYPES tty_display_structures TYPE STANDARD TABLE OF ty_display_structures
                                 WITH DEFAULT KEY.
    "! <p class="shorttext synchronized">Get instance</p>
    "!
    "! @parameter ro_instance | <p class="shorttext synchronized">Instance</p>
    CLASS-METHODS get_instance
      RETURNING
        VALUE(ro_instance) TYPE REF TO z2cl_ca_bil_tran_messages.

    "! <p class="shorttext synchronized">Set selection screen data</p>
    "!
    "! @parameter it_selection_screen      | <p class="shorttext synchronized">Selection screen data references</p>
    "! @parameter iv_language_for_messages | <p class="shorttext synchronized">Language used for messages</p>
    "! @parameter iv_unique_messages       | <p class="shorttext synchronized">Only unique messages</p>
    "! @parameter ro_instance              | <p class="shorttext synchronized">Instance</p>
    METHODS set_selection_data
      IMPORTING
        it_selection_screen      TYPE z2xx_t_selection_screen
        iv_language_for_messages TYPE spras DEFAULT sy-langu
        iv_unique_messages       TYPE abap_bool DEFAULT abap_true
        iv_last_appeared_message TYPE abap_bool DEFAULT abap_true
      RETURNING
        VALUE(ro_instance)       TYPE REF TO z2cl_ca_bil_tran_messages.

    "! <p class="shorttext synchronized">Has data selected</p>
    "!
    "! @parameter rv_has_data | <p class="shorttext synchronized">Data has been selected</p>
    METHODS has_data
      RETURNING
        VALUE(rv_has_data) TYPE abap_bool.

    "! <p class="shorttext synchronized">Get selected data</p>
    "!
    "! @parameter rt_selected_data | <p class="shorttext synchronized">Selected data</p>
    METHODS get_selected_data
      RETURNING
        VALUE(rt_selected_data) TYPE z2ca_ybil_log_out_t.

    "! <p class="shorttext synchronized">Get structures to be displayed</p>
    "!
    "! @parameter rt_display_structures | <p class="shorttext synchronized">Structures to be displayed</p>
    METHODS get_display_structures
      RETURNING
        VALUE(rt_display_structures) TYPE tty_display_structures.

  PRIVATE SECTION.
    "! <p class="shorttext synchronized">Instance</p>
    CLASS-DATA go_instance TYPE REF TO z2cl_ca_bil_tran_messages.
    "! <p class="shorttext synchronized">Data already selected</p>
    DATA mv_data_selected TYPE abap_bool.
    "! <p class="shorttext synchronized">Language used for messages</p>
    DATA mv_language_for_messages TYPE spras.
    "! <p class="shorttext synchronized">Only unique messages</p>
    DATA mv_unique_messages TYPE abap_bool.
    "! <p class="shorttext synchronized">Last appeared message</p>
    DATA mv_last_appeared_message TYPE abap_bool.
    "! <p class="shorttext synchronized">Selected data</p>
    DATA mt_selected_data TYPE z2ca_ybil_log_out_t.
    "! <p class="shorttext synchronized">Structures to be displayed</p>
    DATA mt_display_structures TYPE tty_display_structures.

    DATA:
      "! <p class="shorttext synchronized">Selection screen data</p>
      BEGIN OF ms_selection_screen_data,
        trnumb TYPE RANGE OF ybil_trnumb,
        busobj TYPE RANGE OF ybil_busobj,
        cosins TYPE RANGE OF ybil_cosins,
        direct TYPE RANGE OF ybil_direct,
        objkey TYPE RANGE OF ybil_objkey,
        prchid TYPE RANGE OF ybil_prchid,
        lockid TYPE RANGE OF ybil_lockid,
        wrkfid TYPE RANGE OF ybil_workflow_wiid,
        status TYPE RANGE OF ybil_trstat,
        xcstat TYPE RANGE OF ybil_xcstat,
        iterat TYPE RANGE OF ybil_iterat,
        exttrn TYPE RANGE OF ybil_exttrn,
        vernum TYPE RANGE OF versno,
        chgrsl TYPE RANGE OF ybil_chgrsl,
        schdat TYPE RANGE OF ybil_schdat,
        schtim TYPE RANGE OF ybil_schtim,
        credat TYPE RANGE OF erdat,
        cretim TYPE RANGE OF erzet,
        upddat TYPE RANGE OF aedat,
        updtim TYPE RANGE OF aezet,
        limit  TYPE int4,
        msgty  TYPE RANGE OF msgty,
      END OF ms_selection_screen_data ##NEEDED.

    "! <p class="shorttext synchronized">Constructor</p>
    "!
    METHODS constructor.

    "! <p class="shorttext synchronized">Select data</p>
    "!
    METHODS _select_data.
ENDCLASS.



CLASS z2cl_ca_bil_tran_messages IMPLEMENTATION.
  METHOD constructor.
    go_instance = me.
  ENDMETHOD.

  METHOD get_instance.
    ro_instance = COND #( WHEN go_instance IS BOUND
                          THEN go_instance
                          ELSE NEW #( ) ).
  ENDMETHOD.

  METHOD set_selection_data.
    DATA lv_elemdescr_count  TYPE i.
    DATA lv_tabledescr_count TYPE i.

    DATA lo_abap_typedescr_src   TYPE REF TO cl_abap_typedescr.
    DATA lo_abap_tabledescr_src  TYPE REF TO cl_abap_tabledescr.
    DATA lo_abap_structdescr_src TYPE REF TO cl_abap_structdescr.
    DATA lo_abap_typedescr_des   TYPE REF TO cl_abap_typedescr.
    DATA lo_abap_tabledescr_des  TYPE REF TO cl_abap_tabledescr.
    DATA lo_abap_structdescr_des TYPE REF TO cl_abap_structdescr.

    FIELD-SYMBOLS <ltv_source> TYPE any.

    mv_language_for_messages = iv_language_for_messages.
    mv_unique_messages = iv_unique_messages.
    mv_last_appeared_message = iv_last_appeared_message.
    LOOP AT it_selection_screen REFERENCE INTO DATA(lr_selection_screen) WHERE data IS NOT INITIAL. "#EC CI_STDSEQ
      ASSIGN COMPONENT lr_selection_screen->name OF STRUCTURE ms_selection_screen_data
             TO FIELD-SYMBOL(<ltv_destination>).
      IF sy-subrc EQ 0.
        FREE: lo_abap_typedescr_src, lo_abap_tabledescr_src, lo_abap_structdescr_src,
              lo_abap_typedescr_des, lo_abap_tabledescr_des, lo_abap_structdescr_des.

        CLEAR: lv_elemdescr_count, lv_tabledescr_count.

        lo_abap_typedescr_src = cl_abap_typedescr=>describe_by_data_ref( lr_selection_screen->data ).
        TRY.
            lo_abap_tabledescr_src ?= lo_abap_typedescr_src.
            lv_tabledescr_count = lv_tabledescr_count + 1.
          CATCH cx_sy_move_cast_error.
            IF lo_abap_typedescr_src IS INSTANCE OF cl_abap_elemdescr.
              lv_elemdescr_count = lv_elemdescr_count + 1.
            ELSE.
              CONTINUE.
            ENDIF.
        ENDTRY.

        lo_abap_typedescr_des = cl_abap_typedescr=>describe_by_data( <ltv_destination> ).
        TRY.
            lo_abap_tabledescr_des ?= lo_abap_typedescr_des.
            lv_tabledescr_count = lv_tabledescr_count + 1.
          CATCH cx_sy_move_cast_error.
            IF lo_abap_typedescr_des IS INSTANCE OF cl_abap_elemdescr.
              lv_elemdescr_count = lv_elemdescr_count + 1.
            ELSE.
              CONTINUE.
            ENDIF.
        ENDTRY.
        IF lv_tabledescr_count EQ 2.
          TRY.
              lo_abap_structdescr_src ?= lo_abap_tabledescr_src->get_table_line_type( ).
              lo_abap_structdescr_des ?= lo_abap_tabledescr_des->get_table_line_type( ).
              DATA(lt_components_src) = lo_abap_structdescr_src->get_components( ).
              DATA(lt_components_des) = lo_abap_structdescr_des->get_components( ).
              IF lt_components_src NE lt_components_des.
                CONTINUE.
              ENDIF.
            CATCH cx_sy_move_cast_error.
              CONTINUE.
          ENDTRY.
        ELSEIF lv_elemdescr_count NE 2.
          CONTINUE.
        ENDIF.
        ASSIGN lr_selection_screen->data->* TO <ltv_source>.
        <ltv_destination> = <ltv_source>.
      ENDIF.
    ENDLOOP.
    CLEAR mv_data_selected.
    ro_instance = go_instance.
  ENDMETHOD.

  METHOD has_data.
    _select_data( ).
    rv_has_data = xsdbool( mt_selected_data IS NOT INITIAL ).
  ENDMETHOD.

  METHOD _select_data.
    IF mv_data_selected EQ abap_true.
      RETURN.
    ENDIF.
    ycl_bil_transaction=>create_from_criteria(
      EXPORTING
        it_r_trnumb = ms_selection_screen_data-trnumb
        it_r_busobj = ms_selection_screen_data-busobj
        it_r_cosins = ms_selection_screen_data-cosins
        it_r_direct = ms_selection_screen_data-direct
        it_r_objkey = ms_selection_screen_data-objkey
        it_r_prchid = ms_selection_screen_data-prchid
        it_r_lockid = ms_selection_screen_data-lockid
        it_r_wrkfid = ms_selection_screen_data-wrkfid
        it_r_status = ms_selection_screen_data-status
        it_r_xcstat = ms_selection_screen_data-xcstat
        it_r_iterat = ms_selection_screen_data-iterat
        it_r_exttrn = ms_selection_screen_data-exttrn
        it_r_vernum = ms_selection_screen_data-vernum
        it_r_chgrsl = ms_selection_screen_data-chgrsl
        it_r_schdat = ms_selection_screen_data-schdat
        it_r_schtim = ms_selection_screen_data-schtim
        it_r_credat = ms_selection_screen_data-credat
        it_r_cretim = ms_selection_screen_data-cretim
        it_r_upddat = ms_selection_screen_data-upddat
        it_r_updtim = ms_selection_screen_data-updtim
        iv_limit    = ms_selection_screen_data-limit
      IMPORTING
        et_tran     = DATA(lt_transaction_data) ).

    TRY.
        ycl_bil_entity=>get_objects_by_busobj(
          EXPORTING
            iv_busobj     = ytbil_busobj-mb01
          IMPORTING
            et_entity_ref = DATA(lt_entity_instances) ).
        LOOP AT lt_entity_instances INTO DATA(lo_entity).
          IF lo_entity->is_head( ).
            DATA(lv_head_entity) = lo_entity->get_key( )-entity.
            EXIT.
          ENDIF.
        ENDLOOP.
      CATCH ycx_bil_object_not_exist.
    ENDTRY.

    DATA(lv_order_by) = |{ COND #( WHEN mv_last_appeared_message EQ abap_true
                                   THEN |trnumb, msgty, msgid, msgno, lognum descending, recnum descending|
                                   ELSE |trnumb, msgty, msgid, msgno, lognum, recnum| ) }|.

    FIELD-SYMBOLS <lt_entity_data> TYPE STANDARD TABLE.

    mt_display_structures = VALUE #( ( CONV #( 'YBIL_TRAN' ) )
                                     ( CONV #( 'YBIL_LOGM' ) ) ).
    LOOP AT lt_transaction_data REFERENCE INTO DATA(lr_transaction_data).
      SELECT FROM ybil_logm
             FIELDS *
             WHERE trnumb EQ @lr_transaction_data->trnumb
               AND msgty IN @ms_selection_screen_data-msgty
             ORDER BY (lv_order_by)
             INTO TABLE @DATA(lt_ybil_logm).
      IF sy-subrc EQ 0.
        APPEND VALUE #( ybil_tran = CORRESPONDING #( lr_transaction_data->* ) )
               TO mt_selected_data
               ASSIGNING FIELD-SYMBOL(<ls_output>).
        DATA(lo_domain_fixed_values) = z2cl_ca_domain_fixed_values=>get_instance_by_data_ref(
          ir_data_reference = REF #( lr_transaction_data->status )
          iv_language       = mv_language_for_messages ).
        IF lo_domain_fixed_values IS BOUND.
          <ls_output>-ybil_tran-status_descr = lo_domain_fixed_values->get_fixed_value_description(
            CONV #( lr_transaction_data->status ) ).
        ENDIF.
        DATA(lo_transaction) = ycl_bil_transaction=>get_object( lr_transaction_data->trnumb ).

        lo_transaction->get_entity_data(
          EXPORTING
            iv_dbtier      = ytbil_dbtier-bil
          IMPORTING
            et_entity_data = DATA(lt_entity_data) ).
        LOOP AT lt_entity_data REFERENCE INTO DATA(lr_entity_data).
          DATA(ls_entity_key) = lr_entity_data->object->get_key( ).
          DATA(lv_entity_key) = |YBIL_{ to_upper( ls_entity_key-busobj ) }_{ to_upper( ls_entity_key-entity ) }|.
          ASSIGN COMPONENT lv_entity_key OF STRUCTURE <ls_output>
                 TO FIELD-SYMBOL(<ls_entity_output_data>).
          IF sy-subrc EQ 0.
            IF lr_entity_data->table IS BOUND.
              ASSIGN lr_entity_data->table->* TO <lt_entity_data>.
              LOOP AT <lt_entity_data> ASSIGNING FIELD-SYMBOL(<ls_entity_data>) TO 1.
                <ls_entity_output_data> = CORRESPONDING #( <ls_entity_data> ).
              ENDLOOP.
            ENDIF.
            IF NOT line_exists( mt_display_structures[ structure = lv_entity_key ] ).
              APPEND VALUE #( structure = lv_entity_key ) TO mt_display_structures.
            ENDIF.
          ENDIF.
        ENDLOOP.

        IF mv_unique_messages EQ abap_true.
          DELETE ADJACENT DUPLICATES FROM lt_ybil_logm COMPARING msgty msgid msgno.
        ENDIF.
        SORT lt_ybil_logm BY trnumb lognum recnum.
        LOOP AT lt_ybil_logm REFERENCE INTO DATA(lr_message).
          IF sy-tabix GT 1.
            APPEND <ls_output> TO mt_selected_data ASSIGNING <ls_output>.
          ENDIF.
          <ls_output>-ybil_logm = VALUE #( BASE CORRESPONDING #( lr_message->* )
                                           spras = mv_language_for_messages
                                           message = z2cl_ca_t100_message=>get_instance(
                                                         VALUE #( message_id = <ls_output>-ybil_logm-msgid
                                                                  language   = mv_language_for_messages ) )->get_message_text(
                                                             iv_message_number = lr_message->msgno
                                                             iv_message_v1     = lr_message->msgv1
                                                             iv_message_v2     = lr_message->msgv2
                                                             iv_message_v3     = lr_message->msgv3
                                                             iv_message_v4     = lr_message->msgv4 ) ).
        ENDLOOP.
      ENDIF.
    ENDLOOP.
    mv_data_selected = abap_true.
  ENDMETHOD.

  METHOD get_selected_data.
    _select_data( ).
    rt_selected_data = mt_selected_data.
  ENDMETHOD.

  METHOD get_display_structures.
    _select_data( ).
    rt_display_structures = mt_display_structures.
  ENDMETHOD.
ENDCLASS.
