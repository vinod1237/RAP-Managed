@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Suppl Interface'
@Metadata.ignorePropagatedAnnotations: true
define view entity Yi_bookSuppl1_m
  as select from ybooksuppl_m
  association        to parent YI_booking1_m  as _booking        on  $projection.BookingId = _booking.BookingId
                                                                 and $projection.TravelId  = _booking.TravelId

  association [1..1] to YI_travel1_M          as _travel         on  $projection.TravelId = _travel.TravelId
  association [1..1] to /dmo/supplement       as _supplement     on  $projection.SupplementId = _supplement.supplement_id
  association [1..*] to /DMO/I_SupplementText as _supplementtext on  $projection.SupplementId = _supplementtext.SupplementID
{
  key travel_id             as TravelId,
  key booking_id            as BookingId,
  key booking_supplement_id as BookingSupplementId,
      supplement_id         as SupplementId,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price                 as Price,
      currency_code         as CurrencyCode,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      last_changed_at       as LastChangedAt,
      _travel,
      _booking,
      _supplement,
      _supplementtext
}
