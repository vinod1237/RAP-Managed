@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'draft i'
@Metadata.ignorePropagatedAnnotations: true
define root view entity Ydraft_i_view
  as select from Yi_bookSuppl1_m
{
  key TravelId,
  key BookingId,
  key BookingSupplementId,
      SupplementId,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Price,
      CurrencyCode,
      LastChangedAt
      //    /* Associations */
      //    _booking,
      //    _supplement,
      //    _supplementtext,
      //    _travel
}
