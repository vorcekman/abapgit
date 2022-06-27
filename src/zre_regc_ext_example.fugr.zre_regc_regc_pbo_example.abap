FUNCTION ZRE_REGC_REGC_PBO_EXAMPLE.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_SICHT) TYPE  BUS0SICHT-SICHT DEFAULT SPACE
*"--------------------------------------------------------------------
  DATA:
    lo_busobj TYPE REF TO if_reca_bus_object.

*-------------------------------------------------------------------
* Only operations necessary to show data on GUI are done here.
* Implement BAdI-Method RECN_CONTRACT->SUBSTITUTE
* in order to set default values for CI-Include data
*-------------------------------------------------------------------

* Get instance of actual object
  CALL FUNCTION 'REGC_GET_BUSOBJ'
    IMPORTING
      eo_busobj = lo_busobj.

* Get Data of Customer-Include
  IF lo_busobj IS BOUND.
    CALL FUNCTION 'API_RE_CN_GET_DETAIL'
      EXPORTING
        io_object  = lo_busobj
      IMPORTING
        es_ci_data = recn_contract_ci
      EXCEPTIONS
        error      = 1
        OTHERS     = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno
              DISPLAY LIKE sy-msgty
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.
ENDFUNCTION.
