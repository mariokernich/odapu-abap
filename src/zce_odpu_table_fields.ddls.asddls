@ObjectModel.query.implementedBy: 'ABAP:ZCL_ODPU_PROXY_TABLE_FIELDS'
define custom entity ZCE_ODPU_TABLE_FIELDS
{
  key TableName : tabname;
      FieldName : abap.string(0);
}
