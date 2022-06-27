@AbapCatalog.sqlViewName: 'zmno_cds008'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'cds örnek asso'
define view zmno_ddl008 as select from zmno_ddl007 {
        bukrs,
        belnr,
        gjahr,
        /* Associations */
//        _bs[inner].buzei,
        _ac[inner].buzei,
        _ac[inner].ksl,
        _bs
    
} 
 