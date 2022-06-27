@AbapCatalog.sqlViewName: 'ZMNO_CDS002'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS ÖRNEK 1'
define view ZMNO_DDL002 as select from bkpf as bf
inner join bseg as bs on bf.bukrs = bs.bukrs and bf.belnr = bs.belnr and bf.gjahr = bs.gjahr
left outer join kna1 as k1 on bs.kunnr = k1.kunnr
left outer join lfa1 as l1 on bs.lifnr = l1.lifnr
  {
    key bf.bukrs,
    key bf.belnr,
    key bf.gjahr,
    key bs.buzei,
        bf.xblnr,
        bf.blart,
        bf.bldat,
        bs.wrbtr,
        bf.waers,
        bs.dmbtr,
    case
    when bs.kunnr = '' then bs.lifnr
    else bs.kunnr
    end as musteri_no,
    case 
    when bs.kunnr = '' then l1.name1
    else k1.name1
    end as musteri
           
} 
 