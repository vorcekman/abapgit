FUNCTION ZMNO_FWEBSERVICE.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_BUKRS) TYPE  BUKRS OPTIONAL
*"     VALUE(IV_GJAHR) TYPE  GJAHR OPTIONAL
*"  EXPORTING
*"     VALUE(IT_TABLE) TYPE  ZMNO_SWEBT
*"----------------------------------------------------------------------
    SELECT  BUKRS,
            BELNR,
            GJAHR,
            BUZEI,
            XBLNR,
            BLART,
            BLDAT,
            WRBTR,
            WAERS,
            DMBTR
      FROM zmno_cds003( p_bukrs = @iv_bukrs , p_gjahr = @iv_gjahr )
      INTO TABLE @IT_TABLE.




ENDFUNCTION.
