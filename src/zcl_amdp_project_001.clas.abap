CLASS zcl_amdp_project_001 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

  interfaces IF_AMDP_MARKER_HDB.
*  INTERFACES if_ex_cts_request_check.
  TYPES:
      BEGIN OF TY_ACDOCA,
        MANDT  TYPE ACDOCA-RCLNT,
        RBUKRS TYPE ACDOCA-RBUKRS,
        BELNR  TYPE ACDOCA-BELNR,
        GJAHR  TYPE ACDOCA-GJAHR,
        BUZEI  TYPE ACDOCA-BUZEI,
        BUDAT  TYPE ACDOCA-BUDAT,
        BLART  TYPE ACDOCA-BLART,
        RACCT  TYPE ACDOCA-RACCT,
        RACCT_TEXT TYPE SKAT-TXT50,
        HSL    TYPE ACDOCA-HSL,
        OSL    TYPE ACDOCA-OSL,
        LIFNR  TYPE ACDOCA-LIFNR,
        KUNNR  TYPE ACDOCA-KUNNR,
        VENDOR_TEXT TYPE TXT50,
        CUST_TEXT   TYPE TXT50,
      END   OF TY_ACDOCA,
      TT_ACDOCA TYPE STANDARD TABLE OF TY_ACDOCA,

      BEGIN OF TY_VENDOR,
        LIFNR TYPE BUT000-PARTNER,
        TEXT  TYPE TXT50,
      END   OF TY_VENDOR,
      TT_VENDOR TYPE STANDARD TABLE OF TY_VENDOR,

      BEGIN OF TY_CUST,
        KUNNR TYPE BUT000-PARTNER,
        TEXT  TYPE TXT50,
      END   OF TY_CUST,
      TT_CUST TYPE STANDARD TABLE OF TY_CUST.
       CLASS-METHODS:
      GET_DATA  FOR TABLE FUNCTION ZCDS_TABLE_FUNC.

  PROTECTED SECTION.
  PRIVATE SECTION.
  class-METHODS:
      GET_DATA_FROM_VENDOR EXPORTING VALUE(EV_VENDOR) TYPE TT_VENDOR,
      GET_DATA_FROM_CUST   EXPORTING VALUE(EV_CUST)   TYPE TT_CUST,
      GET_DATA_FROM_ACDOCA IMPORTING VALUE(IV_STRING) TYPE STRING
                           EXPORTING VALUE(EV_ACDOCA) TYPE TT_ACDOCA.
ENDCLASS.



CLASS zcl_amdp_project_001 IMPLEMENTATION.

METHOD GET_DATA_FROM_ACDOCA BY DATABASE PROCEDURE FOR HDB
                              LANGUAGE SQLSCRIPT
                              OPTIONS READ-ONLY
                              USING ACDOCA SKAT.
    --init MANDT variable
*    DECLARE lv_CLNT "$ABAP.type( mandt )" := session_context('CLIENT');
*    DECLARE lv_CLNT1 "$ABAP.type( mandt )" := session_context('CLIENT');
    --init SPRAS variable
*    DECLARE lv_langu "$ABAP.type( SPRAS )" := 'T';

    --GET DATA FROM SOURCE
   EV_ACDOCA =
      SELECT T1.RCLNT AS MANDT,
             T1.RBUKRS,
             T1.BELNR,
             T1.GJAHR,
             T1.BUZEI,
             T1.BUDAT,
             T1.blart,
             LTRIM( T1.RACCT,'' ) AS RACCT,
             T2.TXT50 AS RACCT_TEXT,
             T1.HSL,
             T1.OSL,
             T1.LIFNR,
             T1.KUNNR,
             '' AS VENDOR_TEXT,
             '' AS CUST_TEXT
        FROM ACDOCA     AS T1
       INNER JOIN SKAT  AS T2
          ON T1.RCLNT = T2.MANDT
         AND T1.rclnt = session_context('CLIENT')
         AND T2.MANDT = session_context('CLIENT')
         AND T1.RACCT = T2.saknr
         AND T2.SPRAS = 'T'
         AND T1.KTOPL = T2.KTOPL;
*         Where ( IV_STRING ) ;

   --USING APPLY FILTER TO TABLE
   EV_ACDOCA = APPLY_FILTER( :EV_ACDOCA, :IV_STRING );
  ENDMETHOD.
   METHOD GET_DATA_FROM_CUST BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
                            OPTIONS READ-ONLY
                            USING KNA1.
    --init MANDT variable
*    DECLARE lv_CLNT "$ABAP.type( MANDT )" := session_context('CLIENT');

    EV_CUST = SELECT T1.KUNNR,
                     T1.NAME1 AS TEXT
                FROM KNA1 AS T1
               WHERE T1.MANDT = session_context('CLIENT');
  ENDMETHOD.

  METHOD GET_DATA_FROM_VENDOR BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT
                              OPTIONS READ-ONLY
                              USING LFA1.
    --init MANDT variable
*    DECLARE lv_CLNT "$ABAP.type( MANDT )" := session_context('CLIENT');
*    declare lv_client "$ABAP.type(  )"

    EV_VENDOR = SELECT T1.LIFNR,
                       T1.NAME1 AS TEXT
                  FROM LFA1 AS T1
                 WHERE T1.MANDT = session_context('CLIENT');
  ENDMETHOD.

  METHOD GET_DATA BY DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT
                  OPTIONS READ-ONLY
                  USING ZCL_AMDP_PROJECT_001=>GET_DATA_FROM_VENDOR
                        ZCL_AMDP_PROJECT_001=>GET_DATA_FROM_CUST
                        ZCL_AMDP_PROJECT_001=>GET_DATA_FROM_ACDOCA.
    --init MANDT variable
*    DECLARE lv_CLNT "$ABAP.type( MANDT )" := session_context('CLIENT');

    --GET DATA FROM VENDOR MASTER DATA
    CALL "ZCL_AMDP_PROJECT_001=>GET_DATA_FROM_VENDOR"( EV_VENDOR => :EV_VENDOR );
    --GET DATA FROM CUSTOMER MASTER DATA
    CALL "ZCL_AMDP_PROJECT_001=>GET_DATA_FROM_CUST"( EV_CUST => :EV_CUST );
    --GET DATA FROM FI TRANSACTION DATA
    CALL "ZCL_AMDP_PROJECT_001=>GET_DATA_FROM_ACDOCA"(
                                                        IV_STRING => :IV_STRING,
                                                        EV_ACDOCA => :EV_ACDOCA
                                                     );



    --RETURN VALUE
    RETURN     SELECT  T1.mandt AS CLIENT,
                       T1.RBUKRS,
                       T1.BELNR,
                       T1.GJAHR,
                       T1.BUZEI,
                       T1.BUDAT,
                       T1.BLART,
                       T1.RACCT,
                       T1.RACCT_TEXT,
                       T1.HSL,
                       T1.OSL,
                       T1.LIFNR,
                       T1.KUNNR,
                       T3.TEXT              AS VENDOR_TEXT,
                       T2.TEXT              AS CUST_TEXT
                  FROM      :EV_ACDOCA      AS T1
                  LEFT JOIN :EV_CUST        AS T2
                    ON T2.KUNNR = T1.KUNNR
                  LEFT JOIN :EV_VENDOR      AS T3
                    ON T3.LIFNR = T1.LIFNR
                 ORDER BY T1.RBUKRS,
                          T1.BELNR,
                          T1.GJAHR;


  ENDMETHOD.

ENDCLASS.
