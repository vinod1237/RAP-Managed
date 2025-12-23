@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Approver Projection Booking'
@Metadata.ignorePropagatedAnnotations: true

@UI:{ headerInfo: {
          typeName: 'Booking',
          typeNamePlural: 'Bookings',
          title: {
              type: #STANDARD,
              value: 'BookingId'
          }
      }}
@Search.searchable: true
define view entity YC_booking_approver1_m
  as projection on YI_booking1_m
{
      @UI.facet: [{
          id: 'Booking',
          purpose: #STANDARD,
          position: 10 ,
          label: 'Booking',
          type:#IDENTIFICATION_REFERENCE
      }
      //      {
      //          id: 'Booksuppl',
      //          purpose: #STANDARD,
      //          position: 20 ,
      //          label: 'Booking Supplemnets',
      //          type: #LINEITEM_REFERENCE,
      //        targetElement: '_bookingsuppl'
      //      }
      ]
      @Search.defaultSearchElement: true
  key TravelId,
      @UI: { lineItem: [{ position: 10 }],
      identification: [{ position: 10 }] }
  key BookingId,
      @UI:{lineItem: [{ position: 20  }],
      identification: [{ position: 20 }] }
      BookingDate,
      @UI:{lineItem: [{ position: 30  }],
      identification: [{ position: 30 }]}
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: {
                                             name: '/DMO/I_Customer',
                                             element: 'CustomerID'
                                         } }]
      @ObjectModel.text.element: [ 'cname' ]
      CustomerId,
      _customer.last_name as cname,
      @UI:{lineItem: [{ position: 40  }],
      identification: [{ position: 40 }] }
      @Consumption.valueHelpDefinition: [{ entity: {
                                           name: '/DMO/I_Carrier',
                                           element: 'AirlineID'
                                       } }]
      @ObjectModel.text.element: [ 'carriername' ]
      CarrierId,
      _carrier.AirlineID  as carriername,
      @UI:{lineItem: [{ position: 50  }],
      identification: [{ position: 50 }] }

      ConnectionId,
      @UI:{lineItem: [{ position: 60  }],
      identification: [{ position: 60 }] }
      FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      @UI:{lineItem: [{ position: 70  }],
      identification: [{ position: 70 }] }
      FlightPrice,

      CurrencyCode,
      @UI:{lineItem: [{ position: 80  }],
      identification: [{ position: 80 }],
      textArrangement: #TEXT_ONLY }
      @Consumption.valueHelpDefinition: [{ entity: {
                                             name: '/DMO/I_Booking_Status_VH',
                                             element: 'BookingStatus'
                                         } }]
      BookingStatus,

      @UI.hidden: true
      LastChangedAt,
      /* Associations */
//      _bookingsuppl,
//      _carrier,
//      _connection,
//      _customer,
//      _status,
      _travel : redirected to parent YC_travel_approver1_m
}
