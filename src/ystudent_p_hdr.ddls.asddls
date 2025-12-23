@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'P view For Student'
@Metadata.ignorePropagatedAnnotations: true
define root view entity Ystudent_P_hdr
  provider contract transactional_query
  as projection on Ystudent_i_hdr
{

      @UI.facet: [{
      id: 'StudentData',
      purpose: #STANDARD,
      label: 'Student Data',
      type: #IDENTIFICATION_REFERENCE,
      position: 10
      },
      {
      id: 'Upload',
      purpose: #STANDARD,
      label: 'Uload Attachements',
      type: #LINEITEM_REFERENCE,
      position: 20,
      targetElement: '_Attachements'
      }]

      @UI: { selectionField: [{ position: 10 }],
      lineItem: [{ position: 10 }],
      identification: [{ position: 10 }]
       }
      @EndUserText.label: 'Student Id'
  key Id,

      @UI: {  lineItem: [{ position: 20 }],
              identification: [{ position: 20 }]
              }
      @EndUserText.label: 'First Name'
      Firstname,
      @UI: {  lineItem: [{ position: 30 }],
        identification: [{ position: 30 }]
        }
      @EndUserText.label: 'Last Name'
      Lastname,
      @UI: {  lineItem: [{ position: 40 }],
        identification: [{ position: 40 }]
        }
      @EndUserText.label: 'Age'
      Age,
      @UI: {  lineItem: [{ position: 50 }],
        identification: [{ position: 50 }]
        }
      @EndUserText.label: 'Course'
      Course,
      @UI: {  lineItem: [{ position: 60 }],
        identification: [{ position: 60 }]
        }
      @EndUserText.label: 'Course duration'
      Courseduration,
      @UI: {  lineItem: [{ position: 70 }],
        identification: [{ position: 70 }]
        }
      @EndUserText.label: 'Status'
      Status,
      @UI: {  lineItem: [{ position: 80 }],
        identification: [{ position: 80 }]
        }
      @EndUserText.label: 'Gender'
      Gender,
      @UI: {  lineItem: [{ position: 90 }],
        identification: [{ position: 90 }]
        }
      @EndUserText.label: 'DOB'
      Dob,
      Lastchangedat,
      Locallastchangedat,
      /* Associations */
      _Attachements : redirected to composition child Ystudent_P_att
}
