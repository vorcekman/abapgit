FUNCTION ZRE_REGC_REGC_PAI_EXAMPLE.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_SICHT) TYPE  BUS0SICHT-SICHT DEFAULT SPACE
*"--------------------------------------------------------------------

  DATA:
    lo_busobj     TYPE REF TO if_reca_bus_object,
    ld_activity   TYPE recaactivity.

*-------------------------------------------------------------------
* Don't implement any checks here!
* Implement checks with BAdI-Method RECN_CONTRACT->CHECK_ALL
*-------------------------------------------------------------------

* Get instance of actual object
  CALL FUNCTION 'REGC_GET_BUSOBJ'
    IMPORTING
      eo_busobj   = lo_busobj
      ed_activity = ld_activity.

* Set Data of Customer-Include
  IF ( lo_busobj IS BOUND             ) AND
     ( ld_activity <> '03' ).                     "not read-only
    CALL FUNCTION 'API_RE_CN_CHANGE'
      EXPORTING
        io_object    = lo_busobj
        is_ci_data   = recn_contract_ci
        if_ci_data_x = 'X'
      EXCEPTIONS
        error        = 1
        OTHERS       = 2.
    IF sy-subrc <> 0.                             " Should not happen
      MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno
              DISPLAY LIKE sy-msgty
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.

ENDFUNCTION.
