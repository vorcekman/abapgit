@AbapCatalog.sqlViewName: 'zmno_cds007'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'ASSOCİONS ÖRNEK 2'
define view zmno_ddl007 as select from bkpf as _bf
association [1..1] to bseg as _bs
     on _bf.bukrs = _bs.bukrs and _bf.belnr = _bs.belnr and _bf.gjahr = _bs.gjahr
association [1..*] to acdoca as _ac
     on _ac.rbukrs = _bf.bukrs and _ac.belnr = _bf.belnr and _ac.gjahr = _bf.gjahr     

     {
     key _bf.bukrs,
     key _bf.belnr,
     key _bf.gjahr,

//    "assocation as public
     
//        _bs.buzei,
        _bs,
        _ac
        
    
}  
//group by _bf.bukrs , _bf.belnr , _bf.gjahr


 