CLASS zcl_odpu DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS get_v2_url
      IMPORTING
        !iv_external_service_doc_name TYPE /iwfnd/med_mdl_service_grp_id
        !iv_namespace                 TYPE /iwfnd/med_mdl_namespace
        !iv_version                   TYPE /iwfnd/med_mdl_version OPTIONAL
      RETURNING
        VALUE(rv_metadata_url)        TYPE string
      RAISING
        /iwfnd/cx_med_mdl_access .

    CLASS-METHODS get_v2_services
      RETURNING
        VALUE(rt_services) TYPE zodpu_tt_odata_services.
    CLASS-METHODS get_v4_services
      RETURNING
        VALUE(rt_services) TYPE zodpu_tt_odata_services .
    CLASS-METHODS get_all_services
      RETURNING
        VALUE(rt_services) TYPE zodpu_tt_odata_services.
    CLASS-METHODS get_v4_url
      IMPORTING
        iv_group_id       TYPE /iwfnd/v4_med_group_id
        is_service_detail TYPE  /iwfnd/if_v4_publishing_types=>ty_s_bep_service_info
      RETURNING
        VALUE(rv_url)     TYPE string.

    CLASS-METHODS get_root_url
      RETURNING
        VALUE(rv_root_url) TYPE string.
    CLASS-METHODS get_app_url RETURNING
                                VALUE(rv_root_url) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_odpu IMPLEMENTATION.

  METHOD get_all_services.

    DATA(lt_v2) = zcl_odpu=>get_v2_services( ).
    DATA(lt_v4) = zcl_odpu=>get_v4_services( ).

    rt_services = VALUE zodpu_tt_odata_services( ( LINES OF lt_v2 ) ( LINES OF lt_v4 ) ).

  ENDMETHOD.


  METHOD get_v2_services.

    DATA  lt_service_groups       TYPE /iwfnd/t_med_rst_sg_headers.
    DATA  ls_service_group        TYPE /iwfnd/s_med_rst_sg_header.
    DATA  ls_service              TYPE /iwfnd/s_mgw_reg_service.
    DATA  lt_parameters           TYPE /iwfnd/t_ifl_selection_par.
    DATA  lt_srv_infos            TYPE /iwfnd/if_med_info=>ty_t_med_sin.
    DATA  ls_srv_info             TYPE /iwfnd/if_med_info=>ty_s_med_sin.

    DATA lt_services TYPE STANDARD TABLE OF /iwfnd/s_mgw_reg_service.
    DATA(lv_path) = /iwfnd/cl_icf_access=>gcs_icf_paths-lib_10.

    /iwfnd/cl_med_exploration=>query_for_service_groups(
    EXPORTING
      it_parameters              = lt_parameters
    IMPORTING
      et_matching_service_groups = lt_service_groups ).

    /iwfnd/cl_med_info=>get_all_services(
      IMPORTING
        et_services = lt_srv_infos ).

    LOOP AT lt_service_groups INTO ls_service_group.

      CLEAR ls_service.
      MOVE-CORRESPONDING ls_service_group TO ls_service.

      ls_service-service_name           = ls_service_group-object_name.
      ls_service-external_service_name  = ls_service_group-service_name.

      CLEAR ls_srv_info.
      READ TABLE lt_srv_infos INTO ls_srv_info
                              WITH TABLE KEY  srv_identifier  = ls_service-srv_identifier
                                              is_active       = 'A'
                                              name            = /iwfnd/if_med_info=>gcs_med_service_info_name-external_data_source_type.
      ls_service-external_data_source_type = ls_srv_info-value.

      CLEAR ls_srv_info.
      READ TABLE lt_srv_infos INTO ls_srv_info
                              WITH TABLE KEY  srv_identifier  = ls_service-srv_identifier
                                              is_active       = 'A'
                                              name            = /iwfnd/if_med_info=>gcs_med_service_info_name-external_data_source_id.
      ls_service-external_data_source_id = ls_srv_info-value.

      APPEND ls_service TO lt_services.

    ENDLOOP.

    LOOP AT lt_services INTO DATA(ls_insert).
      APPEND INITIAL LINE TO rt_services ASSIGNING FIELD-SYMBOL(<fs_insert>).
      <fs_insert>-odatatype = '2'.
      <fs_insert>-servicename = ls_insert-service_name.
      <fs_insert>-description = ls_insert-description.
      <fs_insert>-version = ls_insert-service_version.
      get_v2_url(
        EXPORTING
          iv_external_service_doc_name = ls_insert-external_service_name
          iv_namespace                 = ls_insert-namespace
          iv_version                   = ls_insert-service_version
        RECEIVING
          rv_metadata_url              = <fs_insert>-servicepath
      ).
    ENDLOOP.

  ENDMETHOD.

  METHOD get_v4_url.

    DATA: lv_group_id      TYPE /iwfnd/v4_med_group_id,
          lv_service_id    TYPE /iwfnd/v4_med_service_id,
          lv_repository_id TYPE /iwfnd/v4_med_repository_id,
          lv_system_alias  TYPE /iwfnd/if_v4_routing_types=>ty_e_system_alias.

    lv_group_id = iv_group_id.
    TRANSLATE lv_group_id TO LOWER CASE.
    IF lv_group_id(1) <> '/'.
      CONCATENATE '/sap/'
                  lv_group_id
        INTO lv_group_id.
    ENDIF.

    lv_service_id = is_service_detail-service_id.
    TRANSLATE lv_service_id TO LOWER CASE.
    IF lv_service_id(1) <> '/'.
      CONCATENATE '/sap/'
                  lv_service_id
        INTO lv_service_id.
    ENDIF.

    lv_repository_id = is_service_detail-repository_id.
    TRANSLATE lv_repository_id TO LOWER CASE.

    CONCATENATE '/sap/opu/odata4'
                lv_group_id
                '/'
                lv_repository_id
                lv_service_id
                '/'
                is_service_detail-service_version
      INTO rv_url.

  ENDMETHOD.

  METHOD get_v4_services.

    SELECT * FROM srvb_bindtype
        WHERE bind_type_version = 'V4'
        AND bind_type = 'ODATA'
        INTO TABLE @DATA(lt_v4).

    DATA(mo_publishing_config) = /iwfnd/cl_v4_publishing_config=>get_instance( ).
    DATA(lt_groups) = mo_publishing_config->get_groups( ).

    SELECT * FROM /iwfnd/c_v4_msgr INTO TABLE @DATA(lt_results).

    LOOP AT lt_results INTO DATA(ls_group).

      mo_publishing_config->get_bep_groups(
          EXPORTING
            iv_system_alias   = 'LOCAL'
            iv_group_id       = ls_group-group_id
          IMPORTING
            et_bep_group_info = DATA(lt_bep_group_info)
      ).

      LOOP AT lt_bep_group_info INTO DATA(ls_bep_group_info).

        LOOP AT ls_bep_group_info-t_service_info INTO DATA(ls_service_info).

          IF ls_service_info-service_alias IS NOT INITIAL.
            CONTINUE.
          ENDIF.

          APPEND INITIAL LINE TO rt_services ASSIGNING FIELD-SYMBOL(<fs_insert>).

          <fs_insert>-odatatype = '4'.
          <fs_insert>-groupid = ls_bep_group_info-group_id.

          <fs_insert>-servicepath = zcl_odpu=>get_v4_url(
              iv_group_id       = ls_bep_group_info-group_id
              is_service_detail = ls_service_info
            ).
          <fs_insert>-version = ls_service_info-service_version.
          <fs_insert>-description = ls_service_info-description.

        ENDLOOP.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_root_url.

    DATA  lv_host           TYPE string.
    DATA  lv_port           TYPE string.
    DATA  lv_protocol       TYPE string.


    CALL FUNCTION 'TH_GET_VIRT_HOST_DATA'
      EXPORTING
        protocol = 1    "http protocol
        virt_idx = 0
      IMPORTING
        hostname = lv_host
        port     = lv_port
      EXCEPTIONS
        OTHERS   = 99.

    IF sy-subrc = 0.
      lv_protocol = 'http'.

    ELSE.
      CALL FUNCTION 'TH_GET_VIRT_HOST_DATA'
        EXPORTING
          protocol = 2 "https protocol
          virt_idx = 0
        IMPORTING
          hostname = lv_host
          port     = lv_port
        EXCEPTIONS
          OTHERS   = 99.

      IF sy-subrc IS INITIAL.
        lv_protocol = 'https'.

      ELSE.
        RAISE EXCEPTION TYPE /iwfnd/cx_med_mdl_access
          EXPORTING
            textid = /iwfnd/cx_med_mdl_access=>no_odata_url_found.
      ENDIF.

    ENDIF.

    CONCATENATE lv_protocol '://' lv_host ':' lv_port INTO rv_root_url.

  ENDMETHOD.


  METHOD get_v2_url.

    DATA  lv_url            TYPE string.
    DATA  lv_path           TYPE string.
    DATA  lv_namespace      TYPE /iwfnd/med_mdl_namespace.
    DATA  ls_url_parameter  TYPE ihttpnvp.
    DATA  lt_url_parameters TYPE tihttpnvp.
    DATA  lv_url_paramters  TYPE string.
    DATA  lv_version        TYPE c LENGTH 4.

    lv_path = /iwfnd/cl_icf_access=>gcs_icf_paths-lib_10.

    IF iv_namespace IS INITIAL.
      lv_namespace = '/sap/'.
    ELSE.
      lv_namespace = iv_namespace.
    ENDIF.

    CONCATENATE lv_path lv_namespace iv_external_service_doc_name INTO lv_url.

    IF iv_version IS INITIAL.
      CONCATENATE  '/' lv_url '/' INTO lv_url.
    ELSE.
      IF iv_version = 1.
        CONCATENATE '/' lv_url '/' INTO lv_url.
      ELSE.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = iv_version
          IMPORTING
            output = lv_version.

        CONCATENATE '/' lv_url ';v=' lv_version '/' INTO lv_url.
      ENDIF.
    ENDIF.

    rv_metadata_url = lv_url.

  ENDMETHOD.

  METHOD get_app_url.

    DATA: str_host TYPE string.
    DATA: str_port TYPE string.
    DATA: str_prot TYPE string.

    CALL FUNCTION 'TH_GET_VIRT_HOST_DATA'
      EXPORTING
        protocol       = 1
        virt_idx       = 0
      IMPORTING
        hostname       = str_host
        port           = str_port
      EXCEPTIONS
        not_found      = 1
        internal_error = 2
        OTHERS         = 3.

    str_prot = 'HTTP'.

    IF sy-subrc <> 0.
      IF sy-subrc  NE 0.
        CALL FUNCTION 'TH_GET_VIRT_HOST_DATA'
          EXPORTING
            protocol       = 2
            virt_idx       = 0
          IMPORTING
            hostname       = str_host
            port           = str_port
          EXCEPTIONS
            not_found      = 1
            internal_error = 2
            OTHERS         = 3.
        IF sy-subrc EQ 0.
          str_prot = 'HTTPS'.
        ELSE.
          MESSAGE e082(shttp).
        ENDIF.
      ELSE.
        MESSAGE e082(shttp).
      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
