@AbapCatalog.sqlViewName: 'zmno_cds003'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'parametre view örnek'
define view zmno_ddl003
    with parameters p_bukrs : bukrs , p_gjahr : gjahr
as select from bkpf as bf
inner join bseg as bs on bf.bukrs = bs.bukrs and bf.belnr = bs.belnr and bf.gjahr = bs.gjahr {
    key bf.bukrs,
    key bf.belnr,
    key bf.gjahr,
    key bs.buzei,
        bf.xblnr,
        bf.blart,
        bf.bldat,
        bs.wrbtr,
        bf.waers,
        bs.dmbtr
           
}  
where bf.bukrs = $parameters.p_bukrs
and   bf.gjahr = $parameters.p_gjahr
 