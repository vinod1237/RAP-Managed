@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity YC_booking1
  as projection on YI_booking1_m
{
  key TravelId,
  key BookingId,
      BookingDate,
      @ObjectModel.text.element: [ 'lastname' ]
      CustomerId,
      _customer.last_name as lastname,
      @ObjectModel.text.element: [ 'carriername' ]
      CarrierId,
      _carrier.Name       as carriername,
      ConnectionId,
      FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,
      CurrencyCode,
      @ObjectModel.text.element: [ 'bookindstatus' ]
      BookingStatus,
      _status._Text.Text  as bookindstatus : localized,
      LastChangedAt,
      /* Associations */
      _bookingsuppl : redirected to composition child yC_booksuppl1,
      _carrier,
      _connection,
      _customer,
      _status,
      _travel       : redirected to parent YC_travel1
}
