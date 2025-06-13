CLASS zcl_odpu_proxy_info DEFINITION
  INHERITING FROM zcl_odpu_proxy
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  PROTECTED SECTION.
    METHODS: select REDEFINITION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_odpu_proxy_info IMPLEMENTATION.
  METHOD select.

    DATA lt_response TYPE TABLE OF zce_odpu_info.

    APPEND INITIAL LINE TO lt_response ASSIGNING FIELD-SYMBOL(<fs_insert>).

    CLEAR: <fs_insert>.

    zcl_odpu=>get_latest_release(
        IMPORTING
            ev_name = DATA(lv_version)
            ev_body = DATA(lv_release_notes) ).

    IF lv_version IS NOT INITIAL.

      DATA(lv_has_update) = zcl_odpu=>compare_versions(
             EXPORTING
             iv_version_cur = zif_odpu=>c_version
             iv_version_new = lv_version ).

      <fs_insert>-RemoteVersion = lv_version.
      <fs_insert>-UpdateAvailable = lv_has_update.
      <fs_insert>-LatestReleaseBody = lv_release_notes.

    ENDIF.

    <fs_insert>-Version = zif_odpu=>c_version.

    set_data( CHANGING ct_data = lt_response ).

  ENDMETHOD.

ENDCLASS.
