@ObjectModel.query.implementedBy: 'ABAP:ZCL_ODPU_PROXY_APC'
define custom entity ZCE_ODPU_APC
{
  key application_id      : apc_application_id;
  key version             : r3state;
      path                : apc_appl_path;
      class_name          : seoclsname;
      protocol_type_id    : apc_wsp_protocol_type_id;
      amc_message_type_id : amc_message_type_id;
}
