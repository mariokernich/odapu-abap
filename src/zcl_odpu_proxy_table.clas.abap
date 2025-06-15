CLASS zcl_odpu_proxy_table DEFINITION
  INHERITING FROM zcl_odpu_proxy
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  PROTECTED SECTION.
    METHODS: select REDEFINITION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_odpu_proxy_table IMPLEMENTATION.
  METHOD select.

    DATA lt_response TYPE TABLE OF zce_odpu_table.

    DATA(lv_conditions) = mo_request->get_filter( )->get_as_sql_string( ).

    SELECT dd02l~tabname AS TableName,
       dd02t~ddtext  AS Description
      FROM dd02l
      LEFT OUTER JOIN dd02t
        ON dd02t~tabname = dd02l~tabname
       AND dd02t~ddlanguage = @sy-langu
      "WHERE (lv_conditions)
      INTO TABLE @DATA(lt_tables).

    LOOP AT lt_tables INTO DATA(ls_table).
      APPEND INITIAL LINE TO lt_response ASSIGNING FIELD-SYMBOL(<fs_insert>).
      CLEAR: <fs_insert>.
      MOVE-CORRESPONDING ls_table TO <fs_insert>.

    ENDLOOP.

    set_data( CHANGING ct_data = lt_response ).

  ENDMETHOD.

ENDCLASS.
