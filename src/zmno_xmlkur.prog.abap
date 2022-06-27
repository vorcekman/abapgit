*&---------------------------------------------------------------------*
*& Report ZMNO_XMLKUR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMNO_XMLKUR.
DATA :p_url TYPE string,
      p_client TYPE REF TO if_http_client,
      p_document TYPE REF TO if_ixml_document,
      lv_xml TYPE string,

      l_ixml            TYPE REF TO if_ixml,
      l_streamfactory   TYPE REF TO if_ixml_stream_factory,
      l_istream         TYPE REF TO if_ixml_istream,
      l_parser          TYPE REF TO if_ixml_parser,
      lv_xml_x          TYPE xstring,

        curr_node_collection  TYPE REF TO if_ixml_node_collection,
        curr_node_iterator    TYPE REF TO if_ixml_node_iterator,
        curr_node             TYPE REF TO if_ixml_node,
        curr_nodemap          TYPE REF TO if_ixml_named_node_map,
        curr_attr             TYPE REF TO if_ixml_node,
        curr_node_list        TYPE REF TO if_ixml_node_list,
        lv_val                TYPE string,
        lv_length             TYPE i,
        lv_indx               TYPE i.

DATA: BEGIN OF pt_itcur OCCURS 0,
        kurst LIKE tcurr-kurst,
        fcurr LIKE tcurr-fcurr,
        ukurs LIKE tcurr-ukurs,
        tcurr LIKE tcurr-tcurr,
        gdatu LIKE tcurr-gdatu,
      END OF pt_itcur.
DATA : gv_check.

DATA : gs_itcur LIKE LINE OF pt_itcur.
*p_url = 'https://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml'.
* p_url = 'https://www.tcmb.gov.tr/kurlar/today.xml'.
p_url = 'http://www.nbp.pl/Kursy/xml/a039z090225.xml'.
*TABLES : z04_kur001c.

 DATA: lv_mesaj(200).
  DATA: lv_id TYPE i.
  CLEAR lv_mesaj.
*  SELECT MAX( id ) FROM z04_kur001c
*    INTO lv_id.

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
  IF sy-subrc NE 0.

*    CONVERT INVERTED-DATE sy-datum INTO DATE z04_kur001c-tarih.
*    z04_kur001c-id    = lv_id.
*    z04_kur001c-msgid = sy-msgid.
*    z04_kur001c-msgty = sy-msgty.
*    z04_kur001c-msgno = sy-msgno.
*    z04_kur001c-msgv1 = sy-msgv1.
*    z04_kur001c-msgv2 = sy-msgv2.
*    z04_kur001c-msgv3 = sy-msgv3.
*    z04_kur001c-msgv4 = sy-msgv4.
*    MODIFY z04_kur001c.
*    PERFORM cikis USING lv_mesaj.
    EXIT.
  ENDIF.

  CALL METHOD p_client->AUTHENTICATE(
   EXPORTING
     CLIENT = '100'
     USERNAME = 'MOZTURK'
     PASSWORD = '1994NebI.'
     LANGUAGE = 'T'
     ).
    IF sy-subrc eq 0.

    ENDIF.

  p_client->request->set_header_field( name  = '~request_method' "~REQUEST_METHOD ~request_method
                                       value = 'GET' ).

* Get request:
  CALL METHOD p_client->send
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2
      http_processing_failed     = 3
      OTHERS                     = 4.
  IF sy-subrc NE 0.


*    CONVERT INVERTED-DATE sy-datum INTO DATE z04_kur001c-tarih.
*    z04_kur001c-id    = lv_id.
*    z04_kur001c-msgid = sy-msgid.
*    z04_kur001c-msgty = sy-msgty.
*    z04_kur001c-msgno = sy-msgno.
*    z04_kur001c-msgv1 = sy-msgv1.
*    z04_kur001c-msgv2 = sy-msgv2.
*    z04_kur001c-msgv3 = sy-msgv3.
*    z04_kur001c-msgv4 = sy-msgv4.
*    MODIFY z04_kur001c.
*    PERFORM cikis USING lv_mesaj.
    EXIT.
  ENDIF.

* Prepare client-receive:
  CALL METHOD p_client->receive
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2
      http_processing_failed     = 3
      OTHERS                     = 4.
  IF sy-subrc NE 0.

*    CONVERT INVERTED-DATE sy-datum INTO DATE z04_kur001c-tarih.
*    z04_kur001c-id    = lv_id.
*    z04_kur001c-msgid = sy-msgid.
*    z04_kur001c-msgty = sy-msgty.
*    z04_kur001c-msgno = sy-msgno.
*    z04_kur001c-msgv1 = sy-msgv1.
*    z04_kur001c-msgv2 = sy-msgv2.
*    z04_kur001c-msgv3 = sy-msgv3.
*    z04_kur001c-msgv4 = sy-msgv4.
*    MODIFY z04_kur001c.
*    PERFORM cikis USING lv_mesaj.

    EXIT.
  ENDIF.







* Get HTML:
  lv_xml = p_client->response->get_cdata( ).

  CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
    EXPORTING
      text   = lv_xml
    IMPORTING
      buffer = lv_xml_x
    EXCEPTIONS
      failed = 1
      OTHERS = 2.
  IF sy-subrc NE 0.

*    CONVERT INVERTED-DATE sy-datum INTO DATE z04_kur001c-tarih.
*    z04_kur001c-id    = lv_id.
*    z04_kur001c-msgid = sy-msgid.
*    z04_kur001c-msgty = sy-msgty.
*    z04_kur001c-msgno = sy-msgno.
*    z04_kur001c-msgv1 = sy-msgv1.
*    z04_kur001c-msgv2 = sy-msgv2.
*    z04_kur001c-msgv3 = sy-msgv3.
*    z04_kur001c-msgv4 = sy-msgv4.
*    MODIFY z04_kur001c.
*    PERFORM cikis USING lv_mesaj.
    EXIT.
  ENDIF.

* Creating the main iXML factory
  l_ixml = cl_ixml=>create( ).

* Creating a stream factory
  l_streamfactory = l_ixml->create_stream_factory( ).

* wrap the xstring containing the manifest file into an input stream
  l_istream =
           l_streamfactory->create_istream_xstring( string = lv_xml_x ).

* Creating a document
  p_document = l_ixml->create_document( ).

* Create a Parser
  l_parser = l_ixml->create_parser( stream_factory = l_streamfactory
                                    istream        = l_istream
                                    document       = p_document ).
* Parse the stream
  IF l_parser->parse( ) NE 0.

    lv_mesaj = 'xml dönüştürmede hata'.

*    CONVERT INVERTED-DATE sy-datum INTO DATE z04_kur001c-tarih.
*    z04_kur001c-id    = lv_id.
*    z04_kur001c-msgid = sy-msgid.
*    z04_kur001c-msgty = sy-msgty.
*    z04_kur001c-msgno = sy-msgno.
*    z04_kur001c-msgv1 = sy-msgv1.
*    z04_kur001c-msgv2 = sy-msgv2.
*    z04_kur001c-msgv3 = sy-msgv3.
*    z04_kur001c-msgv4 = sy-msgv4.
*    MODIFY z04_kur001c.
*    PERFORM cikis USING lv_mesaj.
    MESSAGE lv_mesaj TYPE 'E'.
    EXIT.
  ENDIF.




  curr_node_collection =
    p_document->get_elements_by_tag_name( name = 'Cube' ).
  curr_node_iterator   = curr_node_collection->create_iterator( ).
  curr_node            = curr_node_iterator->get_next( ).
  WHILE curr_node IS NOT INITIAL.

    " En Son JPY Gelsin
    IF sy-index GT 12.
      EXIT.
    ENDIF.

    curr_nodemap = curr_node->get_attributes( ).
    curr_attr = curr_nodemap->get_named_item( name = 'CurrencyCode' ).

    CLEAR: lv_val.
    IF curr_attr IS NOT INITIAL.
      CLEAR: pt_itcur.
      lv_val = curr_attr->get_value( ).
      pt_itcur-fcurr = lv_val .
    ENDIF.

    curr_node_list = curr_node->get_children( ).
    CLEAR: lv_length.
    lv_length = curr_node_list->get_length( ).

    DO lv_length TIMES.

      lv_indx = sy-index - 1.
      curr_attr = curr_node_list->get_item( lv_indx ).
      " Sadece Çeviri Kurlarını Al
      CHECK lv_indx BETWEEN 3 AND 6 .
      CLEAR: lv_val.

      IF curr_attr IS NOT INITIAL.
        lv_val = curr_attr->get_value( ).
        CASE lv_indx.
          WHEN 3.
            pt_itcur-kurst = 'M'.
          WHEN 4.
            pt_itcur-kurst = 'S'.
          WHEN 5.
            pt_itcur-kurst = 'E'.
          WHEN 6.
            pt_itcur-kurst = 'F'.
        ENDCASE.
        pt_itcur-ukurs = lv_val.
        pt_itcur-gdatu = sy-datum.
        pt_itcur-tcurr = 'TRY'.
        APPEND pt_itcur.
      ENDIF.

    ENDDO.

    curr_node = curr_node_iterator->get_next( ).

  ENDWHILE.

*  TABLES : z04_trcurr.
  LOOP AT pt_itcur INTO gs_itcur.
*    z04_trcurr-mandt = sy-mandt.
*    z04_trcurr-kurst = gs_itcur-kurst.
*    z04_trcurr-fcurr = gs_itcur-fcurr.
*    z04_trcurr-tcurr = gs_itcur-tcurr.
*    CONVERT INVERTED-DATE gs_itcur-gdatu INTO DATE gs_itcur-gdatu.
*    z04_trcurr-gdatu = gs_itcur-gdatu.
*    z04_trcurr-ukurs = gs_itcur-ukurs.
*    MODIFY z04_trcurr.

  ENDLOOP.
