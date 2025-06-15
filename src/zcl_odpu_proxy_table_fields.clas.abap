CLASS zcl_odpu_proxy_table_fields DEFINITION
  INHERITING FROM zcl_odpu_proxy
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  PROTECTED SECTION.
    METHODS: select REDEFINITION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_odpu_proxy_table_fields IMPLEMENTATION.
  METHOD select.

    DATA lt_response TYPE TABLE OF zce_odpu_table_fields.

    DATA(lt_filters) = mo_request->get_filter( )->get_as_ranges( ).

    IF NOT line_exists( lt_filters[ name = `TABLENAME` ] ).
      RAISE EXCEPTION TYPE zcx_odpu_rap.
    ENDIF.

    DATA(lv_tabname) = lt_filters[ name = `TABLENAME` ]-range[ 1 ]-low.

    DATA: lt_components  TYPE cl_abap_structdescr=>component_table,
          lo_structdescr TYPE REF TO cl_abap_structdescr.

    lo_structdescr ?= cl_abap_typedescr=>describe_by_name( lv_tabname ).
    lt_components = lo_structdescr->get_components( ).

    LOOP AT lt_components INTO DATA(ls_component).
      APPEND INITIAL LINE TO lt_response ASSIGNING FIELD-SYMBOL(<fs_insert>).

      CLEAR: <fs_insert>.
      <fs_insert>-TableName = lv_tabname.
      <fs_insert>-FieldName = ls_component-name.

    ENDLOOP.

    set_data( CHANGING ct_data = lt_response ).

  ENDMETHOD.

ENDCLASS.
