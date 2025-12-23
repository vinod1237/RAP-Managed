CLASS ycl_read_practice DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ycl_read_practice IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.


* Sort Form Read

*    READ ENTITY yi_travel1_m
*    FROM VALUE #( ( %key-TravelId = '00000004'
*                    %control = VALUE #( AgencyId = if_abap_behv=>mk-on
*                                        CustomerId = if_abap_behv=>mk-on
*                                        BeginDate = if_abap_behv=>mk-on ) ) )
*      RESULT DATA(lt_data)
*      FAILED DATA(lt_fail)  .
*
*    IF lt_fail IS NOT INITIAL.
*      out->write( 'read File' ).
*    ELSE.
*      out->write( lt_data ).
*    ENDIF.


*    READ ENTITY yi_travel1_m
*    FIELDS ( AgencyId CustomerId BeginDate EndDate BookingFee TotalPrice )
*    WITH VALUE #( ( %key-TravelId = '00000004' )
*                  ( %key-TravelId = '00000001' ) )
*      RESULT DATA(lt_data)
*      FAILED DATA(lt_fail)  .

*    READ ENTITY yi_travel1_m
*    ALL FIELDS
*    WITH VALUE #( ( %key-TravelId = '00000004' )
*                  ( %key-TravelId = '00000001' ) )
*      RESULT DATA(lt_data)
*      FAILED DATA(lt_fail)  .

*    READ ENTITY yi_travel1_m
*    BY \_booking
*    ALL FIELDS
*    WITH VALUE #( ( %key-TravelId = '00000004' )
*                  ( %key-TravelId = '00000001' ) )
*      RESULT DATA(lt_data)
*      FAILED DATA(lt_fail)  .
*
*    IF lt_fail IS NOT INITIAL.
*      out->write( 'read File' ).
*    ELSE.
*      out->write( lt_data ).
*    ENDIF.


* Longer Form

*    READ ENTITIES OF yi_travel1_m
*
*    ENTITY YI_travel1_M
*       ALL FIELDS WITH VALUE #( ( %key-TravelId = '00000004' )
*                      ( %key-TravelId = '00000001' ) )
*       RESULT DATA(lt_travel)
*
*    ENTITY YI_booking1_m
*       ALL FIELDS WITH VALUE #( ( %key-TravelId = '00000001'
*                                    %key-BookingId = '0001' ) )
*       RESULT DATA(lt_booking)
*
*        FAILED DATA(lt_fail)  .
*
*    IF lt_fail IS NOT INITIAL.
*      out->write( 'read File' ).
*    ELSE.
*      out->write( lt_travel ).
*      out->write( lt_booking ).
*    ENDIF.

* Dynamic Form

    DATA : it_optab         TYPE abp_behv_retrievals_tab,
           it_travel        TYPE TABLE FOR READ IMPORT  yi_travel1_m,
           it_travel_result TYPE TABLE FOR READ RESULT yi_travel1_m.

    it_travel = VALUE #( ( %key-TravelId = '00000004'
                           %control = VALUE #( AgencyId = if_abap_behv=>mk-on
                                 CustomerId = if_abap_behv=>mk-on
                                 BeginDate = if_abap_behv=>mk-on )
                        ) ).

    it_optab = VALUE #( ( op = if_abap_behv=>op-r
                          entity_name = 'yi_travel1_m'
                          instances = REF #( it_travel )
                          results = REF #( it_travel_result ) ) ).
    READ ENTITIES
    OPERATIONS it_optab
    FAILED DATA(it_fail)  .
    IF it_fail IS NOT INITIAL.
      out->write( 'read File' ).
    ELSE.
      out->write( it_travel_result ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
