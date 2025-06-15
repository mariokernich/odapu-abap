CLASS lhc_ZC_ODPU_OPROJ DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zc_odpu_oproj RESULT result.
    METHODS mark_favorite FOR MODIFY
      IMPORTING keys FOR ACTION zc_odpu_oproj~mark_favorite.

ENDCLASS.

CLASS lhc_ZC_ODPU_OPROJ IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD mark_favorite.

    LOOP AT keys INTO DATA(ls_key).
      DATA(lv_user) = sy-uname.
      DATA ls_delete TYPE zdb_opdu_ofavs.
      ls_delete-uname = lv_user.
      ls_delete-path = ls_key-%param-ServicePath.
      DELETE zdb_opdu_ofavs FROM ls_delete.

      IF ls_key-%param-Value EQ abap_true.
        DATA ls_insert TYPE zdb_opdu_ofavs.
        ls_insert-uname = lv_user.
        ls_insert-path = ls_key-%param-ServicePath.
        INSERT zdb_opdu_ofavs FROM ls_insert.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZC_ODPU_OPROJ DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZC_ODPU_OPROJ IMPLEMENTATION.

  METHOD save_modified.

    DATA : lt_projects TYPE STANDARD TABLE OF zdb_odpu_oproj.
    DATA : lt_projects_delete TYPE STANDARD TABLE OF zdb_odpu_oproj.

    IF create IS NOT INITIAL.
      lt_projects = CORRESPONDING #( create-zc_odpu_oproj MAPPING FROM ENTITY ).
      LOOP AT lt_projects INTO DATA(ls_project).
        ls_project-uname = sy-uname.
        INSERT zdb_odpu_oproj FROM ls_project.
      ENDLOOP.
    ENDIF.

    IF delete IS NOT INITIAL.
      lt_projects_delete = CORRESPONDING #( delete-zc_odpu_oproj MAPPING FROM ENTITY ).
      LOOP AT lt_projects_delete INTO DATA(ls_project_delete).
        ls_project_delete-uname = sy-uname.
        DELETE zdb_odpu_oproj FROM ls_project_delete.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
