CLASS lhc_yi_booking1_m DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS earlynumbering_cba_Bookingsupp FOR NUMBERING
      IMPORTING entities FOR CREATE YI_booking1_m\_Bookingsuppl.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR YI_booking1_m RESULT result.

    METHODS validateconnection FOR VALIDATE ON SAVE
      IMPORTING keys FOR yi_booking1_m~validateconnection.

    METHODS validatecurrencycode FOR VALIDATE ON SAVE
      IMPORTING keys FOR yi_booking1_m~validatecurrencycode.

    METHODS validatecustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR yi_booking1_m~validatecustomer.

    METHODS validateflightprice FOR VALIDATE ON SAVE
      IMPORTING keys FOR yi_booking1_m~validateflightprice.

    METHODS validatestatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR yi_booking1_m~validatestatus.
    METHODS calculatetotalprice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR yi_booking1_m~calculatetotalprice.


ENDCLASS.

CLASS lhc_yi_booking1_m IMPLEMENTATION.

  METHOD earlynumbering_cba_Bookingsupp.


    DATA : max_booking_suppl_id TYPE  /dmo/booking_supplement_id.

    READ  ENTITIES OF yi_travel1_m IN LOCAL MODE
    ENTITY YI_booking1_m BY \_bookingsuppl
    FROM CORRESPONDING #( entities )
    LINK DATA(booking_supplements).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<booking_group>) GROUP BY <booking_group>-%tky.

      " Get highest bookingsupplement_id  from booking belong to booking

      max_booking_suppl_id = REDUCE #( INIT lv_max = CONV /dmo/booking_supplement_id( '0' )
                                       FOR  booksuppl IN booking_supplements USING KEY entity
                                       WHERE ( source-TravelId = <booking_group>-TravelId
                                               AND source-BookingId = <booking_group>-BookingId )
                                       NEXT lv_max = COND /dmo/booking_id( WHEN lv_max < booksuppl-target-BookingSupplementId
                                                                              THEN booksuppl-target-BookingSupplementId
                                                                              ELSE lv_max )  ).
      " Get highest assign bookingsupplement_id  from incoming entities
      max_booking_suppl_id = REDUCE #( INIT lv_max = max_booking_suppl_id
                                       FOR ls_entity IN entities USING KEY entity
                                                              WHERE ( TravelId = <booking_group>-TravelId
                                                                      AND BookingId = <booking_group>-BookingId )
                                       FOR target IN ls_entity-%target
                                                              NEXT lv_max = COND  /dmo/booking_supplement_id( WHEN lv_max < target-BookingSupplementId
                                                                                                                 THEN  target-BookingSupplementId
                                                                                                              ELSE lv_max ) ).
      " Loop Over all entries in entities with the same travel id and booing id

      LOOP AT entities ASSIGNING FIELD-SYMBOL(<booking>) USING KEY entity
                                                             WHERE TravelId = <booking_group>-TravelId
                                                              AND BookingId = <booking_group>-BookingId.

        LOOP AT <booking>-%target ASSIGNING FIELD-SYMBOL(<booksuppl_wo_numbers>).

          APPEND CORRESPONDING #( <booksuppl_wo_numbers> ) TO  mapped-yi_booksuppl1_m  ASSIGNING FIELD-SYMBOL(<mapped_booksupl>).
          " assign new booking supplement id
          IF <booksuppl_wo_numbers>-BookingSupplementId IS INITIAL.
            max_booking_suppl_id += 1.
            <mapped_booksupl>-BookingSupplementId = max_booking_suppl_id.
          ENDIF.

        ENDLOOP.

      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF YI_travel1_M IN LOCAL MODE
    ENTITY YI_travel1_M BY \_booking
    FIELDS ( TravelId BookingId BookingStatus )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_book).

    result = VALUE #( FOR ls_book IN lt_book ( %tky = ls_book-%tky
                                               %features-%assoc-_bookingsuppl = COND #( WHEN ls_book-BookingStatus = 'X'
                                                                                            THEN if_abap_behv=>fc-o-disabled
                                                                                        ELSE if_abap_behv=>fc-o-enabled ) )  ).


  ENDMETHOD.

  METHOD validateConnection.
  ENDMETHOD.

  METHOD validateCurrencyCode.
  ENDMETHOD.

  METHOD validateCustomer.
  ENDMETHOD.

  METHOD validateFlightPrice.
  ENDMETHOD.

  METHOD validateStatus.
  ENDMETHOD.

  METHOD CalculateTotalPrice.
    DATA : lt_travel TYPE STANDARD TABLE OF yi_travel1_m WITH UNIQUE HASHED KEY key COMPONENTS TravelId.

    lt_travel = CORRESPONDING #( keys DISCARDING DUPLICATES MAPPING TravelId = TravelId ).

    MODIFY ENTITIES OF yi_travel1_m IN LOCAL MODE
    ENTITY YI_travel1_M
    EXECUTE recalcTotPrice
    FROM CORRESPONDING #( lt_travel ).


  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
