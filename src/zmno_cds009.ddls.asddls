@AbapCatalog.sqlViewName: 'zmno_cds009'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'kolaylık cds komutları'
define view zmno_ddl009     with parameters p_islem : abap.char( 1 ),
                    p_sayi  : abap.int1
as select from bseg {
 bukrs,
 belnr,
 gjahr,
 $parameters.p_sayi as zsayi,
 $parameters.p_islem as zislem,
 case $parameters.p_islem
 when '+' then
 wrbtr +  $parameters.p_sayi
 when '-' then
 wrbtr -  $parameters.p_sayi
 when '*' then
 wrbtr *  $parameters.p_sayi
 end as zsonuc,
  cast(div(wrbtr, 3) as abap.curr( 13, 3 ) ) as zdiv,
 division(wrbtr, 3, 3) as zdivision,
 ceil(division(wrbtr, 3, 3)) as zceil,
 floor(division(wrbtr, 3, 3))   as zfloor,
 round(division(wrbtr, 3, 3), 0) as zround0,
 round(division(wrbtr, 3, 3), 1) as zround1,
 round(division(wrbtr, 3, 3), 2) as zround2,
 round(division(wrbtr, 3, 3), 3) as zround3,
 coalesce( wrbtr,5  ) as hesap
// $session.user as user
} 
 