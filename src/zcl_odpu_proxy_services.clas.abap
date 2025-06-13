CLASS zcl_odpu_proxy_services DEFINITION
  INHERITING FROM zcl_odpu_proxy
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  PROTECTED SECTION.
    METHODS: select REDEFINITION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_odpu_proxy_services IMPLEMENTATION.
  METHOD select.

     DATA(lt_services) = zcl_odpu=>get_all_services( ).

     set_data( changing ct_data = lt_services ).

  ENDMETHOD.

ENDCLASS.
