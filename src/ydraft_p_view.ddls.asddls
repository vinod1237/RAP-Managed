@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'draft p'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ydraft_p_view
  provider contract transactional_query
  as projection on Ydraft_i_view
{
      @UI.facet: [{
              id: 'BOOKING_Suppl',
              purpose: #STANDARD,
              position:10 ,
              label: 'Booking Suppl Details',
              type:#IDENTIFICATION_REFERENCE
                 }]

      @UI.lineItem: [{ position: 10 }]
      @UI.identification: [{ position: 10 }]
  key TravelId,
      @UI.lineItem: [{ position: 20 }]
      @UI.identification: [{ position: 20 }]
  key BookingId,
      @UI.lineItem: [{ position: 30 }]
      @UI.identification: [{ position: 30 }]
  key BookingSupplementId,
      @UI.lineItem: [{ position: 40 }]
      @UI.identification: [{ position: 40 }]
      SupplementId,
      @UI.lineItem: [{ position: 50 }]
      @UI.identification: [{ position: 50 }]
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Price,
      @UI.lineItem: [{ position: 60 }]
      @UI.identification: [{ position: 60 }]
      CurrencyCode,
      @UI.lineItem: [{ position: 70 }]
      @UI.identification: [{ position: 70 }]
      LastChangedAt
}
