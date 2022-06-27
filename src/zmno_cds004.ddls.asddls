@AbapCatalog.sqlViewName: 'zmno_cds004'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'cds from'
define view zmno_ddl004 as select from zmno_ddl003( p_bukrs: '1000' , p_gjahr: '2021' ) {
    bukrs,
    belnr,
    gjahr,
    buzei,
    xblnr,
    blart,
    bldat,
    wrbtr,
    waers,
    dmbtr
} 
 