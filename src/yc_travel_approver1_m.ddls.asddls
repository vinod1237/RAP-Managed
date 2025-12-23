@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Approver Projection Travel'
@Metadata.ignorePropagatedAnnotations: true

@Search.searchable: true
@UI.headerInfo: {
    typeName: 'Travel',
    typeNamePlural: 'Travels',
    title: {
        type: #STANDARD,
        value: 'TravelID'
    }
}

define root view entity YC_travel_approver1_m
  provider contract transactional_query
  as projection on YI_travel1_M
{
      @UI.facet: [{
                  id: 'Travel',
                  purpose: #STANDARD,
                  position:10 ,
                  label: 'Travel_Details',
                  type:#IDENTIFICATION_REFERENCE
                     },
                  {
                  id: 'Booking',
                  purpose: #STANDARD,
                  position:20 ,
                  label: 'Booking',
                  type:#LINEITEM_REFERENCE,
                  targetElement: '_booking'
                    } ]

      @UI.lineItem: [{ position: 10 , importance: #HIGH } ]
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @UI.identification: [{ position: 10 }]
  key TravelId,
      @UI: { lineItem: [{ position: 20 }],
           selectionField: [{ position: 10 }],
           identification: [{ position: 20 }]
          }
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: {
                                               name: '/DMO/I_Agency',
                                               element: 'AgencyID'
                                           } }]
      @ObjectModel.text.element: [ 'AgencyName' ]
      AgencyId,
      _agency.Name        as AgencyName,
      @UI: { lineItem: [{ position: 30 }],
       selectionField: [{ position:30 }],
       identification: [{ position: 30 }]
       }
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: {
                                               name: '/DMO/I_Customer',
                                               element: 'CustomerID'
                                           } }]
      @ObjectModel.text.element: [ 'Cname' ]
      CustomerId,
      _customer.FirstName as Cname,
      @UI.lineItem: [{ position: 40 }]
      @UI.identification: [{ position: 40 }]
      BeginDate,
      @UI.lineItem: [{ position: 50 }]
      @UI.identification: [{ position: 50 }]
      EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      @UI.lineItem: [{ position: 60 }]
      @UI.identification: [{ position: 60 }]
      BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      @UI.lineItem: [{ position: 61 }]
      @UI.identification: [{ position: 61 }]
      TotalPrice,
      @Consumption.valueHelpDefinition: [{ entity: {
                                         name: 'I_Currency',
                                         element: 'Currency'
                                     } }]
      CurrencyCode,
      Description,
      @UI: { lineItem: [{ position: 15,importance: #HIGH },
                        {type:#FOR_ACTION,dataAction: 'acceptTravel',label: 'Accept Travel'},
                        {type:#FOR_ACTION,dataAction: 'rejectTravel',label: 'Reject Travel'} ] ,
       selectionField: [{ position: 40  }],
       identification: [{ position: 70 },
       {type:#FOR_ACTION,dataAction: 'acceptTravel',label: 'Accept Travel'},
                        {type:#FOR_ACTION,dataAction: 'rejectTravel',label: 'Reject Travel'}],
       textArrangement: #TEXT_ONLY
       }
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: {
                                               name: '/DMO/I_Overall_Status_VH',
                                               element: 'OverallStatus'
                                           } }]
      @ObjectModel.text.element: [ 'ST' ]
      OverallStatus,
      _status._Text.Text  as ST : localized,
      @UI.hidden: true
      CreatedBy,
      @UI.hidden: true
      CreatedAt,
      @UI.hidden: true
      LastChangedBy,
      @UI.hidden: true
      LastChangedAt,
      /* Associations */
      _agency,
      _booking : redirected to composition child YC_booking_approver1_m,
      _currency,
      _customer,
      _status
}
