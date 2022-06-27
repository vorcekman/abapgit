class ZCO_CALCULATOR_SOAP1 definition
  public
  inheriting from CL_PROXY_CLIENT
  create public .

public section.

  methods ADD
    importing
      !INPUT type ZADD_SOAP_IN1
    exporting
      !OUTPUT type ZADD_SOAP_OUT1
    raising
      CX_AI_SYSTEM_FAULT .
  methods CONSTRUCTOR
    importing
      !LOGICAL_PORT_NAME type PRX_LOGICAL_PORT_NAME optional
    raising
      CX_AI_SYSTEM_FAULT .
  methods DIVIDE
    importing
      !INPUT type ZDIVIDE_SOAP_IN1
    exporting
      !OUTPUT type ZDIVIDE_SOAP_OUT1
    raising
      CX_AI_SYSTEM_FAULT .
  methods MULTIPLY
    importing
      !INPUT type ZMULTIPLY_SOAP_IN1
    exporting
      !OUTPUT type ZMULTIPLY_SOAP_OUT1
    raising
      CX_AI_SYSTEM_FAULT .
  methods SUBTRACT
    importing
      !INPUT type ZSUBTRACT_SOAP_IN1
    exporting
      !OUTPUT type ZSUBTRACT_SOAP_OUT1
    raising
      CX_AI_SYSTEM_FAULT .
protected section.
private section.
ENDCLASS.



CLASS ZCO_CALCULATOR_SOAP1 IMPLEMENTATION.


  method ADD.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'ADD'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZCO_CALCULATOR_SOAP1'
    logical_port_name   = logical_port_name
  ).

  endmethod.


  method DIVIDE.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'DIVIDE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method MULTIPLY.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'MULTIPLY'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method SUBTRACT.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'SUBTRACT'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.
ENDCLASS.
