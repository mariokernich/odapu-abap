@ObjectModel.query.implementedBy: 'ABAP:ZCL_ODPU_PROXY_SERVICES'
define root custom entity ZCE_ODPU_SERVICES
{
  key ServiceName : abap.string;
      ODataType   : abap.char(1);
      ServicePath : abap.string;
      Version     : abap.char(4);
      Favorite    : abap_boolean;
      Description : ddtext;
      GroupId     : /iwfnd/v4_med_group_id;
}
