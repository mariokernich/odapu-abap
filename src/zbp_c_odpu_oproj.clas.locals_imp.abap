CLASS lhc_ZC_ODPU_OPROJ DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zc_odpu_oproj RESULT result.

ENDCLASS.

CLASS lhc_ZC_ODPU_OPROJ IMPLEMENTATION.

  METHOD get_instance_authorizations.
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
