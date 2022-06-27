FUNCTION ZMNO_NAMEWEB.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_NAME) TYPE  CHAR25 OPTIONAL
*"     VALUE(IV_UNAME) TYPE  CHAR25 OPTIONAL
*"  EXPORTING
*"     VALUE(IV_GNAME) TYPE  CHAR50
*"----------------------------------------------------------------------

iv_gname = IV_NAME && || && IV_UNAME.



ENDFUNCTION.
