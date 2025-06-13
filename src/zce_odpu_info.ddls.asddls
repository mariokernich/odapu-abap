@ObjectModel.query.implementedBy: 'ABAP:ZCL_ODPU_PROXY_INFO'
define root custom entity ZCE_ODPU_INFO
{
  key Version           : abap.string(0);
      RemoteVersion     : abap.string(0);
      UpdateAvailable   : abap_boolean;
      LatestReleaseBody : abap.string(0);
}
