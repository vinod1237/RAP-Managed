@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'P view For attachements'
@Metadata.ignorePropagatedAnnotations: true
define view entity Ystudent_P_att
  as projection on Ystudent_i_att
{
      @UI.facet: [{
           id: 'StudentData',
           purpose: #STANDARD,
           label: 'Attachement Information',
           type: #IDENTIFICATION_REFERENCE,
           position: 10
           }]

      @UI: {
      lineItem: [{ position: 10 }],
      identification: [{ position: 10 }]
       }

  key AttachId,
      @UI: {
       lineItem: [{ position: 20 }],
       identification: [{ position: 20 }]
        }
      Id,
      @UI: {
      lineItem: [{ position: 30 }],
      identification: [{ position: 30 }]
      }
      @EndUserText.label: 'Comments'
      Comments,
      @UI: {
      lineItem: [{ position: 40 }],
      identification: [{ position: 40 }]
      }
      @EndUserText.label: 'Attachement'

      @Semantics.largeObject: {
      mimeType: 'Mimetype',
      fileName: 'Filename',
      acceptableMimeTypes: [ 'application/pdf' ],
      contentDispositionPreference: #ATTACHMENT,
      cacheControl: {
        maxAge: #SHORT
      }
      }

      Attachement,
      @EndUserText.label: 'File Type'
      Mimetype,
      @EndUserText.label: 'File Name'
      Filename,
      LastChangedAt,
      /* Associations */
      _Student : redirected to parent Ystudent_P_hdr
}
