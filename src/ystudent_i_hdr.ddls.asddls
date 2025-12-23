@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'I view For Student'
@Metadata.ignorePropagatedAnnotations: true
define root view entity Ystudent_i_hdr
  as select from ystudent_hdr_tab
  composition [0..*] of Ystudent_i_att as _Attachements
{
      @EndUserText.label: 'Student Id'
  key id                 as Id,
      @EndUserText.label: 'First Name'
      firstname          as Firstname,
      @EndUserText.label: 'Last Name'
      lastname           as Lastname,
      @EndUserText.label: 'Age'
      age                as Age,
      @EndUserText.label: 'Course'
      course             as Course,
      @EndUserText.label: 'Course duration'
      courseduration     as Courseduration,
      @EndUserText.label: 'Status'
      status             as Status,
      @EndUserText.label: 'Gender'
      gender             as Gender,
      @EndUserText.label: 'DOB'
      dob                as Dob,
      lastchangedat      as Lastchangedat,
      locallastchangedat as Locallastchangedat,

      _Attachements
}
