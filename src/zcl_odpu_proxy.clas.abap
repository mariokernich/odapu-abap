CLASS zcl_odpu_proxy DEFINITION
  PUBLIC
  ABSTRACT
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
     METHODS set_data
      CHANGING
        ct_data TYPE STANDARD TABLE.

    DATA mo_request      TYPE REF TO if_rap_query_request.
    DATA mo_response     TYPE REF TO if_rap_query_response.
    DATA mo_filter       TYPE REF TO if_rap_query_filter.
    CONSTANTS c_default_limit TYPE i VALUE 100 ##NO_TEXT.

    METHODS select ABSTRACT.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_odpu_proxy IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    mo_request = io_request.
    mo_response = io_response.
    mo_filter = io_request->get_filter( ).

    select( ).

  ENDMETHOD.

   METHOD set_data.

    IF lines( ct_data ) EQ 0.
      mo_response->set_total_number_of_records( 0 ).
      mo_response->set_data( VALUE string_table( ) ).
      RETURN.
    ENDIF.

    DATA(lt_sort) = VALUE abap_sortorder_tab(
                                 FOR sort_element IN mo_request->get_sort_elements( )
                                 ( name = sort_element-element_name descending = sort_element-descending ) ).

    IF lt_sort IS NOT INITIAL.
      SORT ct_data BY (lt_sort).
    ENDIF.

    DATA(lv_top) = mo_request->get_paging( )->get_page_size( ).

    IF lv_top < 0.
      lv_top = c_default_limit.
    ENDIF.

    DATA(lv_skip) = mo_request->get_paging( )->get_offset( ).

    IF lv_top IS NOT INITIAL OR lv_skip IS NOT INITIAL.
      /iwbep/cl_mgw_data_util=>paging( EXPORTING is_paging = VALUE #( top  = lv_top
                                                                      skip = lv_skip )
                                       CHANGING  ct_data   = ct_data ).
    ENDIF.

    IF mo_request->is_total_numb_of_rec_requested( ).
      mo_response->set_total_number_of_records( lines( ct_data ) ).
    ENDIF.

    mo_response->set_data( ct_data ).

  ENDMETHOD.
ENDCLASS.
