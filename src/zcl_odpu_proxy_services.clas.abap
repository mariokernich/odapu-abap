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

    DATA lt_response TYPE TABLE OF zce_odpu_services.

    LOOP AT lt_services INTO DATA(ls_service).
      APPEND INITIAL LINE TO lt_response ASSIGNING FIELD-SYMBOL(<fs_insert>).

      CLEAR: <fs_insert>.

      MOVE-CORRESPONDING ls_service TO <fs_insert>.

      SELECT COUNT(*) FROM zdb_opdu_ofavs
          WHERE uname = @sy-uname
          AND path = @ls_service-servicepath
          INTO @DATA(lv_fav).

      IF lv_fav EQ 1.
        <fs_insert>-IsFavorite = abap_true.
      ENDIF.

    ENDLOOP.

    set_data( CHANGING ct_data = lt_response ).

  ENDMETHOD.

ENDCLASS.
