CLASS lhc_yi_booksuppl1_m DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validateCurrencyCode FOR VALIDATE ON SAVE
      IMPORTING keys FOR Yi_bookSuppl1_m~validateCurrencyCode.

    METHODS validateprice FOR VALIDATE ON SAVE
      IMPORTING keys FOR Yi_bookSuppl1_m~validateprice.

    METHODS validateSupplement FOR VALIDATE ON SAVE
      IMPORTING keys FOR Yi_bookSuppl1_m~validateSupplement.
    METHODS CalculateTotalPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Yi_bookSuppl1_m~CalculateTotalPrice.

ENDCLASS.

CLASS lhc_yi_booksuppl1_m IMPLEMENTATION.

  METHOD validateCurrencyCode.
  ENDMETHOD.

  METHOD validateprice.
  ENDMETHOD.

  METHOD validateSupplement.
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
