CLASS lhc_YI_travel1_M DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR YI_travel1_M RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR YI_travel1_M RESULT result.

    METHODS acceptTravel FOR MODIFY
      IMPORTING keys FOR ACTION YI_travel1_M~acceptTravel RESULT result.

    METHODS copytravel FOR MODIFY
      IMPORTING keys FOR ACTION YI_travel1_M~copytravel.

    METHODS recalcTotPrice FOR MODIFY
      IMPORTING keys FOR ACTION YI_travel1_M~recalcTotPrice.

    METHODS rejectTravel FOR MODIFY
      IMPORTING keys FOR ACTION YI_travel1_M~rejectTravel RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR YI_travel1_M RESULT result.

    METHODS validatecustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR yi_travel1_m~validatecustomer.

    METHODS validatebookingfee FOR VALIDATE ON SAVE
      IMPORTING keys FOR yi_travel1_m~validatebookingfee.

    METHODS validatecurrencycode FOR VALIDATE ON SAVE
      IMPORTING keys FOR yi_travel1_m~validatecurrencycode.

    METHODS validatedates FOR VALIDATE ON SAVE
      IMPORTING keys FOR yi_travel1_m~validatedates.

    METHODS validatestatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR yi_travel1_m~validatestatus.
    METHODS calculatetotalprice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR yi_travel1_m~calculatetotalprice.

    METHODS earlynumbering_cba_Booking FOR NUMBERING
      IMPORTING entities FOR CREATE YI_travel1_M\_Booking.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities
                  FOR CREATE YI_travel1_M.

ENDCLASS.

CLASS lhc_YI_travel1_M IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.
    DATA(lt_entities) = entities.
    DELETE lt_entities WHERE TravelId IS NOT INITIAL.
    TRY.
        cl_numberrange_runtime=>number_get(
          EXPORTING
*        ignore_buffer     =
            nr_range_nr       = '01'
            object            = '/DMO/TRV_M'
        quantity          = CONV #( lines( lt_entities ) )
*        subobject         =
*        toyear            =
      IMPORTING
        number            = DATA(lv_latest_num)
        returncode        = DATA(lv_code)
        returned_quantity = DATA(lv_qty)
        ).
      CATCH cx_nr_object_not_found.
      CATCH cx_number_ranges INTO DATA(lo_error).

        LOOP AT lt_entities INTO DATA(ls_entities).
          APPEND VALUE #( %cid = ls_entities-%cid %key = ls_entities-%key )
                 TO failed-yi_travel1_m .
          APPEND VALUE #( %cid = ls_entities-%cid
                           %key = ls_entities-%key
                           %msg = lo_error )
                  TO reported-yi_travel1_m      .

        ENDLOOP.
        EXIT.

    ENDTRY.

    ASSERT lv_qty = lines( lt_entities ).

    DATA(lv_curr_num) = lv_latest_num - lv_qty.
    LOOP AT lt_entities INTO ls_entities.
      lv_curr_num = lv_curr_num + 1.
      APPEND VALUE #( %cid = ls_entities-%cid TravelId = lv_curr_num ) TO mapped-yi_travel1_m.
    ENDLOOP.

  ENDMETHOD.

  METHOD earlynumbering_cba_Booking.

    DATA : lv_max_booking TYPE /dmo/booking_id.

    READ  ENTITIES OF yi_travel1_m IN LOCAL MODE
    ENTITY YI_travel1_M BY \_booking
    FROM CORRESPONDING #( entities )
    LINK DATA(lt_link_data).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_group_entity>) GROUP BY <ls_group_entity>-TravelId.
      lv_max_booking = REDUCE #( INIT lv_max = CONV /dmo/booking_id( '0' )
                                 FOR  ls_link IN lt_link_data USING KEY entity
                                  WHERE ( source-TravelId = <ls_group_entity>-TravelId )
                                  NEXT lv_max = COND /dmo/booking_id( WHEN lv_max < ls_link-target-BookingId
                                                                              THEN ls_link-target-BookingId
                                                                              ELSE lv_max )  ).
      lv_max_booking = REDUCE #( INIT lv_max = lv_max_booking
                                    FOR ls_entity IN entities USING KEY entity
                                        WHERE ( TravelId = <ls_group_entity>-TravelId )
                                     FOR ls_booking IN ls_entity-%target
                                        NEXT lv_max = COND /dmo/booking_id( WHEN lv_max < ls_booking-BookingId
                                                                                THEN ls_booking-BookingId
                                                                                ELSE lv_max ) ).

      LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entities>) USING KEY entity
                                                             WHERE TravelId = <ls_group_entity>-TravelId.

        LOOP AT <ls_entities>-%target ASSIGNING FIELD-SYMBOL(<ls_booking>).
          APPEND CORRESPONDING #( <ls_booking> ) TO  mapped-yi_booking1_m
                    ASSIGNING FIELD-SYMBOL(<ls_new_map_book>).
          IF <ls_booking>-BookingId IS INITIAL.
            lv_max_booking += 10.
            <ls_new_map_book>-BookingId = lv_max_booking.
          ENDIF.

        ENDLOOP.

      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

  METHOD acceptTravel.

    MODIFY ENTITIES OF yi_travel1_m IN LOCAL MODE
    ENTITY yi_travel1_m
    UPDATE FIELDS ( OverallStatus )
    WITH VALUE #( FOR key IN keys ( %tky = key-%tky
                                    OverallStatus = 'A' ) ).

    READ ENTITIES OF yi_travel1_m IN LOCAL MODE
    ENTITY yi_travel1_m
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    result = VALUE #( FOR ls_res IN lt_result ( %tky = ls_res-%tky
                                                %param = ls_res ) ).



  ENDMETHOD.

  METHOD copytravel.

    DATA : it_travel        TYPE TABLE FOR CREATE yi_travel1_m,
           it_booking_cba   TYPE TABLE FOR CREATE YI_travel1_M\_booking,
           it_booksuppl_cba TYPE TABLE FOR CREATE yi_booking1_m\_bookingsuppl.

    READ TABLE keys ASSIGNING FIELD-SYMBOL(<ls_without_cid>) WITH KEY %cid = ' '.
    ASSERT <ls_without_cid> IS NOT ASSIGNED.

    READ ENTITIES OF yi_travel1_m IN LOCAL MODE
        ENTITY YI_travel1_M
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_travel_r)
        FAILED DATA(lt_failed).

    READ ENTITIES OF yi_travel1_m IN LOCAL MODE
        ENTITY yi_travel1_m BY \_booking
        ALL FIELDS WITH CORRESPONDING #( lt_travel_r )
        RESULT DATA(lt_booking_r).

    READ ENTITIES OF yi_travel1_m IN LOCAL MODE
        ENTITY YI_booking1_m BY \_bookingsuppl
        ALL FIELDS WITH CORRESPONDING #( lt_booking_r )
        RESULT DATA(lt_booksuppl_r).


    LOOP AT lt_travel_r ASSIGNING FIELD-SYMBOL(<ls_travel_r>).

*      APPEND INITIAL LINE TO it_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).
*      <ls_travel>-%cid = keys[ KEY entity TravelId = <ls_travel_r>-TravelId ]-%cid.
*      <ls_travel>-%data = corrESPONDING #( <ls_travel_r> exCEPT TravelId ).
      APPEND VALUE #( %cid = keys[ KEY entity TravelId = <ls_travel_r>-TravelId ]-%cid
                      %data = CORRESPONDING #( <ls_travel_r> EXCEPT travelid ) )

                   TO it_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).

      <ls_travel>-BeginDate = cl_abap_context_info=>get_system_date(  ).
      <ls_travel>-EndDate = cl_abap_context_info=>get_system_date(  ) + 30.
      <ls_travel>-OverallStatus = 'O'.

      APPEND VALUE #( %cid_ref = <ls_travel>-%cid )
                TO it_booking_cba ASSIGNING FIELD-SYMBOL(<it_booking>).

      LOOP AT lt_booking_r ASSIGNING FIELD-SYMBOL(<ls_booking_r>)
                                                USING KEY entity
                                                WHERE TravelId = <ls_travel_r>-TravelId.
        APPEND VALUE #( %cid = <ls_travel>-%cid && <ls_booking_r>-BookingId
                        %data = CORRESPONDING #( <ls_booking_r> EXCEPT travelid ) )
                   TO <it_booking>-%target ASSIGNING FIELD-SYMBOL(<ls_booking_n>).
        <ls_booking_n>-BookingStatus = 'N'.

        APPEND VALUE #( %cid_ref = <ls_booking_n>-%cid )
                TO it_booksuppl_cba ASSIGNING FIELD-SYMBOL(<ls_booksupp>).


        LOOP AT it_booksuppl_cba ASSIGNING FIELD-SYMBOL(<ls_booksuppl_r>)
                                                        USING KEY entity
                                                        WHERE TravelId = <ls_travel_r>-TravelId
                                                          AND BookingId = <ls_booking_r>-BookingId.

          APPEND VALUE #( %cid = <ls_travel>-%cid && <ls_booksuppl_r>-TravelId && <ls_booksuppl_r>-BookingId )
                 TO <ls_booksupp>-%target.

        ENDLOOP.
      ENDLOOP.
    ENDLOOP.

    MODIFY ENTITIES OF yi_travel1_m IN LOCAL MODE
        ENTITY yi_travel1_m
        CREATE FIELDS ( AgencyId CustomerId BeginDate EndDate TotalPrice CurrencyCode OverallStatus Description  )
        WITH it_travel

        ENTITY yi_travel1_m
        CREATE BY \_booking
        FIELDS ( BookingId BookingDate CustomerId CarrierId ConnectionId FlightDate FlightPrice CurrencyCode  BookingStatus )
        WITH it_booking_cba

        ENTITY YI_booking1_m
        CREATE BY \_bookingsuppl
        FIELDS ( BookingSupplementId SupplementId Price CurrencyCode )
        WITH it_booksuppl_cba
        MAPPED DATA(it_mapped).

    mapped-yi_travel1_m = it_mapped-yi_travel1_m.

  ENDMETHOD.

  METHOD recalcTotPrice.

    TYPES : BEGIN OF ty_total,
              price TYPE  /dmo/booking_fee,
              curr  TYPE /dmo/currency_code,
            END OF ty_total.
    DATA : lt_total      TYPE TABLE OF ty_total,
           lv_conv_price TYPE ty_total-price.

    READ ENTITIES OF yi_travel1_m IN LOCAL MODE
    ENTITY YI_travel1_M
    FIELDS ( BookingFee CurrencyCode )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

    DELETE lt_travel WHERE currencycode IS INITIAL.

    READ ENTITIES OF yi_travel1_m IN LOCAL MODE
    ENTITY YI_travel1_M BY \_booking
    FIELDS ( FlightPrice CurrencyCode )
    WITH CORRESPONDING #( lt_travel )
    RESULT DATA(lt_ba_booking).

    READ ENTITIES OF yi_travel1_m IN LOCAL MODE
    ENTITY yi_booking1_m BY \_bookingsuppl
    FIELDS ( Price CurrencyCode )
    WITH CORRESPONDING #( lt_ba_booking )
    RESULT DATA(lt_ba_booksuppl).

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).

      lt_total = VALUE #( ( price = <ls_travel>-BookingFee curr = <ls_travel>-CurrencyCode ) ).

      LOOP AT lt_ba_booking ASSIGNING FIELD-SYMBOL(<ls_booking>)
                                                USING KEY entity
                                                WHERE TravelId = <ls_travel>-TravelId
                                                  AND currencycode IS NOT INITIAL.
        APPEND VALUE #( price = <ls_booking>-FlightPrice curr = <ls_booking>-CurrencyCode )
                TO lt_total.

        LOOP AT lt_ba_booksuppl ASSIGNING FIELD-SYMBOL(<ls_booksuppl>) USING KEY entity
                                                                        WHERE TravelId = <ls_booking>-TravelId
                                                                        AND BookingId = <ls_booking>-BookingId
                                                                        AND currencycode IS NOT INITIAL.

          APPEND VALUE #( price = <ls_booksuppl>-Price curr = <ls_booksuppl>-CurrencyCode )
          TO lt_total.

        ENDLOOP.


      ENDLOOP.
    ENDLOOP.

    LOOP AT lt_total ASSIGNING FIELD-SYMBOL(<ls_total>).
      IF <ls_total>-curr = <ls_travel>-CurrencyCode.
        lv_conv_price = <ls_total>-price.
      ELSE.
        /dmo/cl_flight_amdp=>convert_currency(
          EXPORTING
            iv_amount               = <ls_total>-price
            iv_currency_code_source = <ls_total>-curr
            iv_currency_code_target = <ls_travel>-CurrencyCode
            iv_exchange_rate_date   = cl_abap_context_info=>get_system_date(  )
        IMPORTING
          ev_amount               = lv_Conv_price
        ).
      ENDIF.

      <ls_travel>-TotalPrice = <ls_travel>-TotalPrice + lv_Conv_price.
    ENDLOOP.

    MODIFY ENTITIES OF yi_travel1_m IN LOCAL MODE
    ENTITY YI_travel1_M
    UPDATE FIELDS ( TotalPrice )
    WITH CORRESPONDING #( lt_travel ).



  ENDMETHOD.

  METHOD rejectTravel.
    MODIFY ENTITIES OF yi_travel1_m IN LOCAL MODE
    ENTITY yi_travel1_m
    UPDATE FIELDS ( OverallStatus )
    WITH VALUE #( FOR key IN keys ( %tky = key-%tky
                                  OverallStatus = 'X' ) ).

    READ ENTITIES OF yi_travel1_m IN LOCAL MODE
    ENTITY yi_travel1_m
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    result = VALUE #( FOR ls_res IN lt_result ( %tky = ls_res-%tky
                                                %param = ls_res ) ).
  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF yi_travel1_m IN LOCAL MODE
    ENTITY YI_travel1_M
    FIELDS ( TravelId OverallStatus )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

    result = VALUE #( FOR ls_travel IN lt_travel
                            ( %tky = ls_travel-%tky
                              %features-%action-acceptTravel = COND #( WHEN ls_travel-OverallStatus = 'A'
                                                                           THEN if_abap_behv=>fc-o-disabled
                                                                         ELSE if_abap_behv=>fc-o-enabled )
                              %features-%action-rejectTravel = COND #( WHEN ls_travel-OverallStatus = 'X'
                                                                           THEN if_abap_behv=>fc-o-disabled
                                                                       ELSE if_abap_behv=>fc-o-enabled )
                              %features-%assoc-_booking = COND #( WHEN ls_travel-OverallStatus = 'X'
                                                                           THEN if_abap_behv=>fc-o-disabled
                                                                       ELSE if_abap_behv=>fc-o-enabled )

                                                                        ) ).


  ENDMETHOD.



  METHOD validateCustomer.
    READ ENTITIES OF yi_travel1_m IN LOCAL MODE
    ENTITY YI_travel1_M
    FIELDS ( CustomerId )  WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

    READ TABLE lt_travel INTO DATA(ls_cust) INDEX 1.
    SELECT
    FROM /dmo/customer
    FIELDS ( customer_id )
    WHERE customer_id = @ls_cust-CustomerId
    INTO TABLE @DATA(lt_cust_db).

    IF sy-subrc NE 0.
      LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<fs_travel>).
        IF <fs_travel>-CustomerId IS INITIAL OR NOT line_exists( lt_cust_db[ customer_id = <fs_travel>-CustomerId ] ).
          APPEND VALUE #( %tky = <fs_travel>-%tky ) TO failed-yi_travel1_m.
          APPEND VALUE #( %tky = <fs_travel>-%tky
                          %msg = new_message_with_text(
                                   severity = if_abap_behv_message=>severity-error
                                   text     = 'Customer ID is Unknown'
                                 )
                          )  TO reported-yi_travel1_m.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD validateBookingFee.
  ENDMETHOD.

  METHOD validateCurrencyCode.
  ENDMETHOD.

  METHOD validateDates.
    READ ENTITIES OF yi_travel1_m IN LOCAL MODE
    ENTITY yi_travel1_m
    FIELDS ( BeginDate EndDate ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

    LOOP AT lt_travel INTO DATA(ls_travel).
      IF ls_travel-BeginDate GT ls_travel-EndDate.
        APPEND VALUE #( %key = ls_travel-%key ) TO failed-yi_travel1_m.
        APPEND VALUE #( %tky = ls_travel-%tky
                        %msg = NEW /dmo/cm_flight_messages(
                                                          textid                = /dmo/cm_flight_messages=>begin_date_bef_end_date
                                                          travel_id             = ls_travel-TravelId
                                                          begin_date            = ls_travel-BeginDate
                                                          end_date              =  ls_travel-EndDate
                                                          severity              = if_abap_behv_message=>severity-error )
                        %element-begindate = if_abap_behv=>mk-on
                        %element-enddate = if_abap_behv=>mk-on

                      ) TO reported-yi_travel1_m.

      ELSEIF ls_travel-BeginDate < cl_abap_context_info=>get_system_date(  ).

        APPEND VALUE #( %key = ls_travel-%key ) TO failed-yi_travel1_m.
        APPEND VALUE #( %tky = ls_travel-%tky
                  %msg = NEW /dmo/cm_flight_messages(
                                                    textid                = /dmo/cm_flight_messages=>begin_date_on_or_bef_sysdate
                                                    begin_date            = ls_travel-BeginDate
                                                    severity              = if_abap_behv_message=>severity-error )
                  %element-begindate = if_abap_behv=>mk-on
                  %element-enddate = if_abap_behv=>mk-on

                ) TO reported-yi_travel1_m.


      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateStatus.

    READ ENTITIES OF yi_travel1_m IN LOCAL MODE
      ENTITY yi_travel1_m
      FIELDS ( OverallStatus ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_travel).

    LOOP AT lt_travel INTO DATA(ls_travel).
      CASE ls_travel-OverallStatus.
        WHEN 'O'.
        WHEN 'A'.
        WHEN 'X'.
        WHEN OTHERS.

          APPEND VALUE #( %key = ls_travel-%key ) TO failed-yi_travel1_m.
          APPEND VALUE #( %tky = ls_travel-%tky
                         %msg = NEW /dmo/cm_flight_messages(
                                                           textid                = /dmo/cm_flight_messages=>status_invalid
                                                           status            = ls_travel-overallstatus
                                                           severity              = if_abap_behv_message=>severity-error )
                         %element-OverallStatus = if_abap_behv=>mk-on

               ) TO reported-yi_travel1_m.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.

  METHOD CalculateTotalPrice.
    MODIFY ENTITIES OF yi_travel1_m IN LOCAL MODE
    ENTITY YI_travel1_M
    EXECUTE recalcTotPrice
      FROM CORRESPONDING #( keys ).
  ENDMETHOD.

ENDCLASS.
