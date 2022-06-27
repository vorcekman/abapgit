*&---------------------------------------------------------------------*
*& Report ZMNO_WEBSERVICE_XML
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMNO_WEBSERVICE_XML.
DATA :p_url TYPE string,
      p_client TYPE REF TO if_http_client,
      p_document TYPE REF TO if_ixml_document,
      lv_xml TYPE string,

      l_ixml            TYPE REF TO if_ixml,
      l_streamfactory   TYPE REF TO if_ixml_stream_factory,
      l_istream         TYPE REF TO if_ixml_istream,
      l_parser          TYPE REF TO if_ixml_parser,
      lv_xml_x          TYPE xstring.

 DATA  :
        gv_request     TYPE          string,
        gv_get_request TYPE          string,
        gv_result      TYPE          string,
        gv_buffer      TYPE          xstring,
        gv_xml_string  TYPE          xstring,
        gv_encode      TYPE          abap_encoding
                       VALUE         4110,
*        gc_client      TYPE  REF TO  if_http_client,
*        gs_t0002       TYPE          zsd_t_0002,
        """inserted - kasman - 29.08.2017 --->>>
        gv_method      TYPE          string,
        """<<<--- inserted - kasman - 29.08.2017
        gv_req_length  TYPE          i,
        gv_txt_length  TYPE          string,
        gv_host        TYPE          string,
        gt_return      TYPE  TABLE OF bapiret2
                       WITH  HEADER LINE.
 DATA  : BEGIN OF  gt_xml_response OCCURS  0.
    INCLUDE STRUCTURE smum_xmltb.
DATA  : END OF  gt_xml_response.
*   CONCATENATE
*        '<soapenv:Envelope xmlns:int="http://integration.univera.com.tr" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">'
*          '<soapenv:Header/>'
*          '<soapenv:Body>'
*          '<int:IntegrationSendEntitySetWithLogin>'
*          '<int:strUserName>SAPAKTARIM</int:strUserName>'
*          '<int:strPassWord>S@p@Ktar1m</int:strPassWord>'
*          '<int:bytFirmaKod>1</int:bytFirmaKod>'
*          '<int:lngCalismaYili>2022</int:lngCalismaYili>'
*          '<int:lngDistributorKod>1</int:lngDistributorKod>'
*          '<int:objPanIntEntityList>'
*          '<int:GenericEntityIntegration>'
*          '<int:clsGenericEntityIntegration>'
*          '<int:Kod>0</int:Kod>'
*          '<int:Yil>2022</int:Yil>'
*          '<int:Referans>M9</int:Referans>'
*          '<int:LngField1>2</int:LngField1>'
*          '<int:LngField2>2</int:LngField2>'
*          '<int:TxtField1>B</int:TxtField1>'
*          '<int:DblField1>21</int:DblField1>'
*        '<int:TrhField1>2022-01-01</int:TrhField1>'
*        '</int:clsGenericEntityIntegration>'
*        '</int:GenericEntityIntegration>'
*        '</int:objPanIntEntityList>'
*        '</int:IntegrationSendEntitySetWithLogin>'
*        '</soapenv:Body>'
*        '</soapenv:Envelope>'
*  INTO gv_request.
*   gv_req_length = strlen( gv_request ).

  MOVE  : gv_req_length TO  gv_txt_length.
  p_url = 'http://demoapimerkez.pos.derinbilgi.com/swagger/index.html'.
  CALL METHOD cl_http_client=>create_by_url
    EXPORTING
      url                = p_url

    IMPORTING
      client             = p_client
    EXCEPTIONS
      argument_not_found = 1
      plugin_not_active  = 2
      internal_error     = 3
      OTHERS             = 4.

CALL METHOD p_client->AUTHENTICATE(
   EXPORTING
     CLIENT = '100'
     USERNAME = 'MOZTURK'
     PASSWORD = '1994NebI'
     LANGUAGE = 'E'
     ).

  CALL METHOD p_client->request->set_header_field
    EXPORTING
      name  = '~request_method'
      value = 'GET'.

*  CALL METHOD p_client->request->set_header_field
*    EXPORTING
*      name  = '~server_protocol'
*      value = 'HTTP/1.1'.
  CALL METHOD p_client->send
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2.

  CALL METHOD p_client->receive
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2
      http_processing_failed     = 3.
    gv_result = p_client->response->get_cdata( ).

  p_client->close( ).
