@ObjectModel.query.implementedBy: 'ABAP:ZCL_ODPU_PROXY_APC'
define custom entity ZCE_ODPU_APC
{
  key ApplicationId    : apc_application_id;
  key Version          : r3state;
      Path             : apc_appl_path;
      ClassName        : seoclsname;
      ProtocolTypeId   : apc_wsp_protocol_type_id;
      AmcMessageTypeId : amc_message_type_id;
      Description      : ddtext;
}
