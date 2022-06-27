*&---------------------------------------------------------------------*
*& Report ZMNO_XMLKUR1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMNO_XMLKUR1.
*http://www.bi.go.id/en/moneter/informasi-kurs/transaksi-bi/Default.aspx
*http://www.bi.go.id/biwebservice/wskursbi.asmx
*http://www.bi.go.id/biwebservice/wskursbi.asmx?op=getSubKursLokal4
*servisi kullanıldı.


DATA:
    ws_post            TYPE string,
    ws_host            TYPE string,
    wf_string          TYPE string,
    wf_string1         TYPE string,
    wf_string2         TYPE string,
    rlength            TYPE i,
    txlen              TYPE string,
    lv_ip              TYPE string,
    lv_uygulama        TYPE string,
    http_client        TYPE REF TO  if_http_client,
    lv_xml_x           TYPE xstring,
    lo_ixml            TYPE REF TO if_ixml,
    lo_streamfactory   TYPE REF TO if_ixml_stream_factory,
    lo_istream         TYPE REF TO if_ixml_istream,
    lo_parser          TYPE REF TO if_ixml_parser,
    lo_document        TYPE REF TO if_ixml_document,
    lo_curr_node_collection TYPE REF TO if_ixml_node_collection,
    lo_curr_node_iterator   TYPE REF TO if_ixml_node_iterator,
    lo_curr_node            TYPE REF TO if_ixml_node,
    lo_curr_nodemap         TYPE REF TO if_ixml_named_node_map,
    lo_curr_attr            TYPE REF TO if_ixml_node,
    lo_curr_node_list       TYPE REF TO if_ixml_node_list,
    lv_val                  TYPE string,
    lv_length               TYPE i,
    lv_indx                 TYPE i.
DATA : BEGIN OF gt_data OCCURS 0,
    st1 TYPE string,
    st2 TYPE string,
    st3 TYPE string,
    st4 LIKE bseg-wrbtr,
    st5 LIKE bseg-wrbtr,
    st6 TYPE string,
    st7 LIKE bkpf-waers,
  END OF gt_data.

DATA : ct_fcat      TYPE slis_t_fieldcat_alv WITH HEADER LINE,
       st_layout    TYPE slis_layout_alv,
       gt_events    TYPE slis_t_event,
       gt_excluding TYPE slis_t_extab.

*DATA : BEGIN OF ex_events OCCURS 17,
*     event(20),
*   END OF ex_events.
*
*DATA : BEGIN OF ap_events OCCURS 17,
*         event(20),
*       END OF ap_events.

CONSTANTS :  gc_tabname TYPE  slis_tabname VALUE 'GT_DATA',
             gc_repid   TYPE  sy-repid     VALUE sy-repid.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS : p_date TYPE dats.
SELECTION-SCREEN END OF BLOCK b1.

IF p_date IS NOT INITIAL AND sy-datum GT p_date.
  CONCATENATE p_date+0(4) '-' p_date+4(2) '-' p_date+6(2)
  INTO DATA(lv_date).
ELSE .
  CONCATENATE sy-datum+0(4) '-' sy-datum+4(2) '-' sy-datum+6(2)
  INTO lv_date.
ENDIF.


lv_ip =
'http://www.bi.go.id/'.

lv_uygulama = 'https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml'.


CONCATENATE lv_ip
''
INTO ws_host .

CONCATENATE lv_ip
lv_uygulama
INTO ws_post .


CLEAR wf_string .
CONCATENATE

'<?xml version="1.0" encoding="utf-8"?>'
'<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instanc' &
'e" xmlns:xsd='
'"http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2' &
'003/05/soap-envelope">'
'<soap12:Body>'
'<getSubKursLokal4 xmlns="http://tempuri.org/">'
'<startdate>'
*'2016-08-25'
lv_date
'</startdate>'
'</getSubKursLokal4>'
'</soap12:Body>'
'</soap12:Envelope>'
INTO wf_string RESPECTING BLANKS.
CLEAR :rlength , txlen .
rlength = strlen( wf_string ) .
MOVE: rlength TO txlen .



CALL METHOD cl_http_client=>create_by_url
  EXPORTING
    url                = ws_host
  IMPORTING
    client             = http_client
  EXCEPTIONS
    argument_not_found = 1
    plugin_not_active  = 2
    internal_error     = 3
    OTHERS             = 4.

CHECK http_client IS NOT INITIAL.

CALL METHOD http_client->request->set_header_field
  EXPORTING
    name  = '~request_method'
    value = 'POST'.

CALL METHOD http_client->request->set_header_field
  EXPORTING
    name  = '~server_protocol'
    value = 'HTTP/1.1'.

ws_post = '/biwebservice/wskursbi.asmx'.
CALL METHOD http_client->request->set_header_field
  EXPORTING
    name  = '~request_uri'
    value = ws_post.


CALL METHOD http_client->request->set_header_field
  EXPORTING
    name  = 'Content-Type'
    value = 'text/xml; charset=utf-8'.


CALL METHOD http_client->request->set_header_field
  EXPORTING
    name  = 'Content-Length'
    value = txlen.


CALL METHOD http_client->request->set_cdata
  EXPORTING
    data   = wf_string
    offset = 0
    length = rlength.

CALL METHOD http_client->send
  EXCEPTIONS
    http_communication_failure = 1
    http_invalid_state         = 2.

CALL METHOD http_client->receive
  EXCEPTIONS
    http_communication_failure = 1
    http_invalid_state         = 2
    http_processing_failed     = 3.



CLEAR wf_string1 .

CALL METHOD http_client->get_last_error
  IMPORTING
    message = wf_string2.

wf_string1 = http_client->response->get_cdata( ).


CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
  EXPORTING
    text   = wf_string1
  IMPORTING
    buffer = lv_xml_x
  EXCEPTIONS
    failed = 1
    OTHERS = 2.
IF sy-subrc NE 0.

  EXIT .
ENDIF.
lo_ixml = cl_ixml=>create( ).


lo_streamfactory = lo_ixml->create_stream_factory( ).


lo_istream =
 lo_streamfactory->create_istream_xstring( string = lv_xml_x ).


lo_document = lo_ixml->create_document( ).


lo_parser = lo_ixml->create_parser( stream_factory = lo_streamfactory
                                  istream        = lo_istream
                                  document       = lo_document ).

IF lo_parser->parse( ) NE 0.
  "hata mesajı
  EXIT.
ENDIF.


lo_curr_node_collection =
            lo_document->get_elements_by_tag_name( name = 'Table' ).

lo_curr_node_iterator = lo_curr_node_collection->create_iterator( ).
lo_curr_node = lo_curr_node_iterator->get_next( ).

WHILE lo_curr_node IS NOT INITIAL.
*  lo_curr_nodemap = lo_curr_node->get_attributes( ).

  APPEND INITIAL LINE TO gt_data.
  READ TABLE gt_data ASSIGNING FIELD-SYMBOL(<fs_data>) INDEX
                                                       sy-index.
  CLEAR : lv_val.

  lo_curr_node_list = lo_curr_node->get_children( ).
  CLEAR lv_length.
  lv_length = lo_curr_node_list->get_length( ).
  DO lv_length TIMES.
    lv_indx = sy-index - 1.
    lo_curr_attr = lo_curr_node_list->get_item( lv_indx ).
    CLEAR lv_val.
    IF lo_curr_attr IS NOT INITIAL.
      lv_val = lo_curr_attr->get_value( ).

      ASSIGN COMPONENT sy-index OF STRUCTURE <fs_data> TO
      FIELD-SYMBOL(<fs_field>).
      <fs_field> = lv_val.
    ENDIF.
  ENDDO.

  lo_curr_node = lo_curr_node_iterator->get_next( ).

ENDWHILE.


CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = gc_repid
      i_internal_tabname     = gc_tabname
      i_inclname             = gc_repid
    CHANGING
      ct_fieldcat            = ct_fcat[].

LOOP AT ct_fcat.
  CASE ct_fcat-fieldname.
    WHEN 'ST1'.
      ct_fcat-no_out = 'X'.
      ct_fcat-col_pos = 5.
    WHEN 'ST2'.
      ct_fcat-no_out = 'X'.
      ct_fcat-col_pos = 6.
    WHEN 'ST3'.
      ct_fcat-seltext_s = 'Birim'.
      ct_fcat-seltext_m = 'Birim'.
      ct_fcat-seltext_l = 'Birim'.
      ct_fcat-reptext_ddic = 'Birim'.
      ct_fcat-col_pos = 2.
    WHEN 'ST4'.

      ct_fcat-seltext_s = 'ForexBuying'.
      ct_fcat-seltext_m = 'ForexBuying'.
      ct_fcat-seltext_l = 'ForexBuying'.
      ct_fcat-reptext_ddic = 'ForexBuying'.
    WHEN 'ST5'.

      ct_fcat-seltext_s = 'ForexSelling'.
      ct_fcat-seltext_m = 'ForexSelling'.
      ct_fcat-seltext_l = 'ForexSelling'.
      ct_fcat-reptext_ddic = 'ForexSelling'.
      ct_fcat-col_pos = 3.
    WHEN 'ST6'.
      ct_fcat-no_out = 'X'.
      ct_fcat-col_pos = 7.
    WHEN 'ST7'.
      ct_fcat-key = 'X'.
      ct_fcat-col_pos = 1.
  ENDCASE.
  MODIFY ct_fcat.
ENDLOOP.
st_layout-colwidth_optimize = 'X'.
st_layout-zebra = 'X'.
CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
     EXPORTING
       i_callback_program       = gc_repid
       is_layout                = st_layout
       it_fieldcat              = ct_fcat[]
       it_events                = gt_events[]
       it_excluding             = gt_excluding
     TABLES
       t_outtab                 = gt_data.
