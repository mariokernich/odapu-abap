CLASS zcl_odpu_proxy_apc DEFINITION
  INHERITING FROM zcl_odpu_proxy
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  PROTECTED SECTION.
    METHODS: select REDEFINITION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_odpu_proxy_apc IMPLEMENTATION.
  METHOD select.

     DATA lv_descr TYPE ddtext.
     DATA lt_data TYPE TABLE OF ZCE_ODPU_APC.

     SELECT
        apc_appl~application_id AS ApplicationId,
        apc_appl~version AS Version,
        apc_appl~path AS Path,
        apc_appl~class_name AS ClassName,
        apc_wsp_type~protocol_type_id AS ProtocolTypeId
     FROM apc_appl
        JOIN apc_wsp_type ON apc_appl~version = apc_wsp_type~version
            INTO TABLE @DATA(lt_results).

     LOOP AT lt_results ASSIGNING FIELD-SYMBOL(<fs_result>).
        APPEND INITIAL LINE TO lt_data ASSIGNING FIELD-SYMBOL(<fs_insert>).
        CLEAR: lv_descr.
        SELECT SINGLE description FROM apc_appl_text
            WHERE application_id = @<fs_result>-applicationid
            AND version = @<fs_result>-version
            AND lang = @sy-langu
            INTO @lv_descr.
        MOVE-CORRESPONDING <fs_result> TO <fs_insert>.
        <fs_insert>-Description = lv_descr.
     ENDLOOP.

     set_data( changing ct_data = lt_data ).

  ENDMETHOD.

ENDCLASS.
