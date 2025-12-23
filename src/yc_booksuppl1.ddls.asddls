@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'booking suppl Projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity yC_booksuppl1
  as projection on Yi_bookSuppl1_m
{
  key TravelId,
  key BookingId,
  key BookingSupplementId,
  @ObjectModel.text.element: [ 'supplementdesc' ]
      SupplementId,
      _supplementtext.Description as supplementdesc :localized,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Price,
      CurrencyCode,
      LastChangedAt,
      /* Associations */
      _booking : redirected to parent YC_booking1,
      _supplement,
      _supplementtext,
      _travel : redirected to YC_travel1
}
