@AbapCatalog.sqlViewName: 'ZMNO_CDS006'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'ASSOCİONS ÖRNEK'
define view ZMNO_DDL006 as select from bkpf as _bf
inner join bseg as _bs
    on _bf.bukrs = _bs.bukrs and _bf.belnr = _bs.belnr and _bf.gjahr = _bs.gjahr
association [0..1] to kna1 as _k1
    on _bs.kunnr = _k1.kunnr
association [0..1] to lfa1 as _l1
   on _l1.lifnr = _bs.lifnr
     {
     key _bf.bukrs,
     key _bf.belnr,
     key _bf.gjahr,
         _bs.kunnr,
         _bs.lifnr,
//    "assocation as public
         _bs.buzei,
         _k1,
         _l1
//         _bs
//         _k1.name1,
//         _l1.name1

} 
where _bs.lifnr != '' or _bs.kunnr != ''
 