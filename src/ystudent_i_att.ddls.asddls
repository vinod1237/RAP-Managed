@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'I view For Attachements'
@Metadata.ignorePropagatedAnnotations: true
define view entity Ystudent_i_att
  as select from ystudent_att_tab
  association to parent Ystudent_i_hdr as _Student on $projection.Id = _Student.Id
{
  key attach_id              as AttachId,
      id                     as Id,
      @EndUserText.label: 'Comments'
      comments               as Comments,
      
      @EndUserText.label: 'Attachements'
//      @Semantics.largeObject: {
//          mimeType: 'Mimetype',
//          fileName: 'Filename',
//          acceptableMimeTypes: [ '' ],
//          contentDispositionPreference: #INLINE, 
//          cacheControl: {
//              maxAge: #VERY_LONG
//          }
//      }
      attachement            as Attachement,
      
      @EndUserText.label: 'File Type'
      mimetype               as Mimetype,
      @EndUserText.label: 'File Name'
      filename               as Filename,
      _Student.Lastchangedat as LastChangedAt,
      _Student
}
