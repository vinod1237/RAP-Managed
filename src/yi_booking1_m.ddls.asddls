@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Root Entity'
@Metadata.ignorePropagatedAnnotations: true
define view entity YI_booking1_m
  as select from ybooking_m
  association        to parent YI_travel1_M         as _travel     on  $projection.TravelId = _travel.TravelId
  composition [1..*] of Yi_bookSuppl1_m as _bookingsuppl
  association [1..1] to /DMO/I_Carrier           as _carrier    on  $projection.CarrierId = _carrier.AirlineID
  association [1..1] to /dmo/customer            as _customer   on  $projection.CustomerId = _customer.customer_id
  association [1..1] to /DMO/I_Connection        as _connection on  $projection.CarrierId    = _connection.AirlineID
                                                                and $projection.ConnectionId = _connection.ConnectionID
  association [1..1] to /DMO/I_Booking_Status_VH as _status     on  $projection.BookingStatus = _status.BookingStatus

{
  key travel_id       as TravelId,
  key booking_id      as BookingId,
      booking_date    as BookingDate,
      customer_id     as CustomerId,
      carrier_id      as CarrierId,
      connection_id   as ConnectionId,
      flight_date     as FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      flight_price    as FlightPrice,
      currency_code   as CurrencyCode,
      booking_status  as BookingStatus,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      last_changed_at as LastChangedAt,
      _travel,
      _bookingsuppl,
      _carrier,
      _customer,
      _connection,
      _status
}
