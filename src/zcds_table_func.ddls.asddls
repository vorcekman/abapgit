@EndUserText.label: 'ZCDS_TABLE_FUNC'
@ClientHandling.type: #CLIENT_DEPENDENT 
define table function ZCDS_TABLE_FUNC
with parameters IV_STRING : abap.char( 255 )
returns {
  CLIENT      : abap.clnt;
  RBUKRS      : abap.char( 4 );
  BELNR       : belnr_d;
  GJAHR       : gjahr;
  BUZEI       : buzei;
  BUDAT       : budat;
  BLART       : blart_d;
  RACCT       : racct;
  RACCT_TEXT  : abap.char( 50 );
  HSL         : wertv12;
  OSL         : wertv12;
  LIFNR       : lifnr;
  KUNNR       : kunnr;
  VENDOR_TEXT : abap.char( 50 );
  CUST_TEXT   : abap.char( 50 );
  
}
implemented by method ZCL_AMDP_PROJECT_001=>GET_DATA;
