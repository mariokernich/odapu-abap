@AbapCatalog.sqlViewName: 'ZVODPUOPROJ'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ODATA & APC Test Tool: User ODATA projects'
@Metadata.ignorePropagatedAnnotations: true
define root view ZC_ODPU_OPROJ 
    as select from zdb_odpu_oproj
{
    key project_name as ProjectName,
    uname as Uname,
    odatatype as Odatatype,
    service_name as ServiceName,
    service_path as ServicePath,
    service_version as ServiceVersion,
    entity_method as EntityMethod,
    entity_name as EntityName,
    function_name as FunctionName,
    action_name as ActionName,
    request_type as RequestType,
    top as Top,
    skip as Skip,
    headers as Headers,
    filters as Filters,
    sorters as Sorters
} where uname = $session.user
