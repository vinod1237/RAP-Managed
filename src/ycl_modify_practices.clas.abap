CLASS ycl_modify_practices DEFINITION PUBLIC .

  PUBLIC SECTION.
    INTERFACES : if_oo_adt_classrun.

ENDCLASS.

CLASS ycl_modify_practices IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

*    MODIFY ENTITY YI_travel1_M
*
*    CREATE FROM VALUE #( ( %cid = 'cid1'
*                         %data-BeginDate = '20251201'
*                         %control-BeginDate = if_abap_behv=>mk-on ) )
*
*    CREATE BY \_booking
*    FROM VALUE #( ( %cid_ref = 'cid1'
*                    %target = VALUE #( ( %cid = 'cid2' %data-BookingDate = '20251201'
*                         %control-BookingDate = if_abap_behv=>mk-on ) ) ) )



*    MODIFY ENTITY YI_booking1_m
*       DELETE FROM VALUE #( ( %key-TravelId = '4320'
*                              %key-BookingId = '10'  ) )
*
*        FAILED DATA(lt_fail)
*        MAPPED DATA(lt_data)
*        REPORTED FINAL(lt_re).


* Auto Fill CID

*    MODIFY ENTITY YI_travel1_M
*    CREATE AUTO FILL CID WITH VALUE #( ( %data-BeginDate = '20251212' %control-BeginDate = if_abap_behv=>mk-on ) )
*        FAILED DATA(lt_fail)
*        MAPPED DATA(lt_data)
*        REPORTED FINAL(lt_re).


* Update

*    MODIFY ENTITIES OF YI_travel1_M
*        ENTITY YI_travel1_M
*            UPDATE FIELDS ( BeginDate )
*            WITH VALUE #( ( %key-TravelId = '00004329'
*                            %data-BeginDate = '20251215' ) )
*        ENTITY YI_travel1_M
*            DELETE FROM VALUE #( ( TravelId = '4329' ) )
*
*         FAILED DATA(lt_fail)
*         MAPPED DATA(lt_data)
*         REPORTED FINAL(lt_re).

    MODIFY ENTITY YI_travel1_M
    UPDATE SET FIELDS WITH VALUE #( ( %key-TravelId = '00000004'
                                      BeginDate = '20251212' ) )
          FAILED DATA(lt_fail)
          MAPPED DATA(lt_data)
          REPORTED FINAL(lt_re).

    COMMIT ENTITIES.

    IF lt_fail IS NOT INITIAL.
      out->write( lt_fail ).
    ELSE.

      out->write( 'Updated.' ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
