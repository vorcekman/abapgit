*&---------------------------------------------------------------------*
*& Report ZMNO_XMLKUR2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMNO_XMLKUR2.

DATA: lo_http_client TYPE REF TO if_http_client,
             lv_service TYPE string.
*-------------------------------------------------------------------------------*
***This service returns the count of the entityset

*lv_service = 'https://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml'.
*
**** Use CL_HTTP_CLIENT to consume the OData service using the method "create_by_url"
*cl_http_client=>create_by_url(
*     EXPORTING
*       url                = lv_service
*     IMPORTING
*       client             = lo_http_client
*     EXCEPTIONS
*       argument_not_found = 1
*       plugin_not_active  = 2
*       internal_error     = 3
*       OTHERS             = 4 ).
*
**** Call the following method to autheticate the user/password and client for the remote connection.
*CALL METHOD LO_HTTP_CLIENT->AUTHENTICATE(
*   EXPORTING
*     CLIENT = '200'
*     USERNAME = '*'
*     PASSWORD = '*'
*     LANGUAGE = 'E'
*     ).
***** Send the request
*   lo_http_client->send(
*     EXCEPTIONS
*       http_communication_failure = 1
*       http_invalid_state         = 2 ).
*
**** Receive the respose
*  lo_http_client->receive(
*     EXCEPTIONS
*       http_communication_failure = 1
*       http_invalid_state         = 2
*       http_processing_failed     = 3 ).
*
**** Read the result
**  CLEAR lv_result .
*   data(lv_result) = lo_http_client->response->get_cdata( ).
* write: lv_result.

DATA: url         TYPE STRING,
      http_client TYPE REF TO IF_HTTP_CLIENT,
      return_code TYPE I,
      content     TYPE STRING.

url = 'https://www.ecb.europa.eu/rss/fxref-gbp.html'.
cl_http_client=>create_by_url( EXPORTING url    = url
                               IMPORTING client = http_client ).

http_client->send( ).
http_client->receive( ).
http_client->response->get_status( IMPORTING code = return_code ).
content = http_client->response->get_cdata( ).
http_client->close( ).
