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

     SELECT
        apc_appl~application_id AS application_id,
        apc_appl~version AS version,
        apc_appl~path AS path,
        apc_appl~class_name AS class_name,
        apc_wsp_type~protocol_type_id AS protocol_type_id,
        apc_wsp_type~amc_message_type_id AS amc_message_type_id
     FROM apc_appl
        JOIN apc_wsp_type
            ON apc_appl~version = apc_wsp_type~version
            INTO TABLE @DATA(lt_results).

     set_data( changing ct_data = lt_results ).

  ENDMETHOD.

ENDCLASS.
