FUNCTION ZRE_REGC_REGC_FMOD2_EXAMPLE .
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(FLDGR) LIKE  TBZ3W-FLDGR
*"     VALUE(IN_STATUS) LIKE  BUS000FLDS-FLDSTAT
*"  EXPORTING
*"     VALUE(OUT_STATUS) LIKE  BUS000FLDS-FLDSTAT
*"--------------------------------------------------------------------

*---------------------------------------------------------------------
* Set OUT_STATUS to
*   optional:        '.'
*   required:        '+'
*   display:         '*'
*   suppressed:      '-'
*
* IN_STATUS = SPACE means not specified
*
* FLDGR is the fieldgroup in BDT-Customizing
*---------------------------------------------------------------------

* set default
  out_status = in_status.


ENDFUNCTION.
