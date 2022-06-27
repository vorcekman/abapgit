*&---------------------------------------------------------------------*
*& Report ZMNO_NEW_SYNTAX
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmno_new_syntax.

*include zmno_new_syntax_form.
*include ZMNO_NEW_SYNTAX_STATUS_0100O01.
DATA: gv_belnr TYPE belnr_d,
      gv_where TYPE string.

DATA: out TYPE REF TO if_demo_output.

out = cl_demo_output=>new( ).
SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS:
  p_rbukrs TYPE bukrs MODIF ID a,
  p_gjahr  TYPE gjahr MODIF ID a,
  p_bukrs  TYPE bukrs MODIF ID b OBLIGATORY,
  p_gjahr1 TYPE gjahr MODIF ID b OBLIGATORY.
SELECT-OPTIONS:
  s_belnr  FOR  gv_belnr MODIF ID a.
PARAMETERS :
  r_amdp RADIOBUTTON GROUP gr1  MODIF ID g DEFAULT 'X',
  r_cds1 RADIOBUTTON GROUP gr1 MODIF ID g,
  r_cds2 RADIOBUTTON GROUP gr1 MODIF ID g,
  r_cds3 RADIOBUTTON GROUP gr1 MODIF ID g,
  r_kod  RADIOBUTTON GROUP gr1 MODIF ID g.
SELECTION-SCREEN: END OF BLOCK b1.


DATA : gt_data  TYPE zamdp_s0001t,
       lv_matnr TYPE matnr.
lv_matnr = '207'.

*lv_matnr = |{ '207' ALPHA = IN }|.

*DATA(lv_matnr2) = |{ lv_matnr ALPHA = in }|.

CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
  EXPORTING
    input        = lv_matnr
  IMPORTING
    output       = lv_matnr
  EXCEPTIONS
    length_error = 1
    OTHERS       = 2.
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

AT SELECTION-SCREEN  OUTPUT.

  LOOP AT SCREEN.
    IF r_amdp EQ 'X'.
      IF screen-group1 EQ 'A'.
        screen-active = '1'.
      ELSE.
        screen-active = '0'.
      ENDIF.
    ELSEIF r_cds1 EQ 'X'.
      IF screen-group1 = 'A' OR screen-group1 = 'B'.
        screen-active = '0'.

      ENDIF.
    ELSEIF r_cds2 EQ 'X'.
      IF screen-group1 = 'A'.
        screen-active = '0'.
      ELSEIF screen-group1 = 'B'.
        screen-active = '1'.

      ENDIF.
    ELSEIF r_cds3 EQ 'X'.
      IF screen-group1 = 'A' OR screen-group1 = 'B'.
        screen-active = '0'.
      ELSE.
        screen-active = '1'.

      ENDIF.

    ENDIF.
    IF screen-group1 EQ 'G'.
      screen-active = '1'.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.



START-OF-SELECTION.
  " 1NCİ AMDP
  IF r_amdp = 'X'.
*if not cl_abap_dbfeatures=>use_features(
**           connection                  =
*           requested_features          =  VALUE #(
*                                                    ( cl_abap_dbfeatures=>call_amdp_method )
*                                                    ( cl_abap_dbfeatures=>amdp_table_function )
*                                                        )
*  ).
*  cl_demo_output=>display( ' SİSTEM AMDP"Yİ DESTEKLEMEZ. LÜTFEN BAŞKA YOLLAR KULLANIN' ).
*  ELSE.
*    zamdp_proje=>get_data_from_mara(
*      EXPORTING
*        ip_mandt = SY-mandt
*        ip_matnr = lv_matnr
**        ip_spras = 'T'
*       IMPORTING
*           et_mara  = gt_data
*           ).
*    IF sy-subrc eq 0.
*      cl_demo_output=>display_data( EXPORTING value = gt_data ).
*    ENDIF.
*    ENDIF.
*
*         CATCH cx_abap_invalid_param_value.  "

    "2NCİ AMDP

    PERFORM transfer_params_to_string.

    SELECT *
      FROM zcds_table_func( iv_string = @gv_where )
      INTO TABLE @DATA(gt_output).
    out->display( gt_output ).

  ELSEIF r_cds1 = 'X'.
    SELECT * FROM zmno_cds002
      INTO TABLE @DATA(lt_cds002).
    out->display( lt_cds002 ).
  ELSEIF r_cds2 = 'X'.
    SELECT *
      FROM zmno_cds003( p_bukrs = @p_bukrs , p_gjahr = @p_gjahr1 )
      INTO TABLE @DATA(lt_cds003).
    out->display( lt_cds003 ).

  ELSEIF r_kod = 'X'.
    cl_salv_gui_table_ida=>create_for_cds_view('ZMNO_DDL002')->fullscreen( )->display( ). " cds ekrana direk gösterir.

  ELSEIF r_cds3 = 'X'.
    SELECT bukrs,belnr,gjahr , \_bs-buzei as kalem , \_bs-lifnr as satıcı , \_bs-kunnr as musteri
        FROM zmno_ddl007  INTO TABLE @DATA(lt_cds007).

    out->display( lt_cds007 ).
  ENDIF.
*&---------------------------------------------------------------------*
*&  TRANSFER PARAMETER AND SELECT-OPTION TO STRING VALUE
*&---------------------------------------------------------------------*
FORM transfer_params_to_string.
  DATA(lv_condition) = cl_shdb_seltab=>combine_seltabs(
                                          it_named_seltabs = VALUE #(
                                                                      ( name = 'BELNR'  dref = REF #( s_belnr[]  ) )
                                                                    )
                                                      ).
  IF p_rbukrs IS NOT INITIAL.
    gv_where = |RBUKRS = '{ p_rbukrs }'|.
  ENDIF.

  IF p_gjahr IS NOT INITIAL.
    IF p_rbukrs IS NOT INITIAL.
      gv_where = | { gv_where } AND GJAHR = '{ p_gjahr }'|.
    ELSE.
      gv_where = | GJAHR = '{ p_gjahr }'|.
    ENDIF.

  ENDIF.

  IF lv_condition IS NOT INITIAL.
    gv_where = |{ lv_condition } AND { gv_where } |.
  ELSE.
    gv_where = |{ gv_where }|.
  ENDIF.
ENDFORM.
