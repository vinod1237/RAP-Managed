CLASS ycl_data_maintain1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES : if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ycl_data_maintain1 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DELETE FROM ytravel_m.
    DELETE FROM ybooking_m.
    DELETE FROM ybooksuppl_m.

* Insert travel dmo data
    INSERT ytravel_m FROM ( SELECT * FROM /dmo/travel_m WHERE travel_id < 90 ).
    COMMIT WORK.
* Insert Booking dmo data
*    INSERT ybooking_m FROM ( SELECT * FROM /dmo/booking_m   INNER JOIN ytravel_m AS z
*                                                           ON booking~travel_id = z~travel_id   ).
    INSERT ybooking_m FROM ( SELECT * FROM /dmo/booking_m WHERE booking_id < 50 ).
    COMMIT WORK.

* Insert bookind suppl dmo data

    INSERT ybooksuppl_m  FROM (  SELECT * FROM /dmo/booksuppl_m ).
    COMMIT WORK.
  ENDMETHOD.
ENDCLASS.
