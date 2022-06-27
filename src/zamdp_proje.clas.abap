CLASS zamdp_proje DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES:
  if_amdp_marker_hdb.
  class-METHODS :
    get_data_from_mara IMPORTING VALUE(ip_mandt) TYPE MARA-MANDT
                                 VALUE(ip_matnr) TYPE mara-matnr
                                 VALUE(ip_spras) TYPE makt-spras DEFAULT 'T'
                       EXPORTING VALUE(ET_MARA)  TYPE ZAMDP_S0001t.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zamdp_proje IMPLEMENTATION.

METHOD get_data_from_mara by DATABASE PROCEDURE FOR
                          HDB LANGUAGE SQLSCRIPT
                          options READ-ONLY
                          using mara makt.

    DECLARE lv_test NVARCHAR( 5 );
    lv_test := 'nebi_';

   ET_MARA =
   SELECT t1.matnr,
          t1.matkl,
          t2.maktx,
          ( lv_test || ltrim( t1.matnr , '0' ) || nchar( 25 ) || t2.maktx ) as text
         FROM MARA AS T1
   inner join makt as t2
   on t1.mandt = t2.mandt
   and t1.matnr = t2.matnr
   and t2.spras = :ip_spras
   WHERE t1.matnr = :ip_matnr;

  ENDMETHOD.
ENDCLASS.
