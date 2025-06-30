*&---------------------------------------------------------------------*
*& Report ZTO_SAP04_0156
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTO_SAP04_0156.

*Alıştırma – 9: Yeni bir database tablosu oluşturun. (Örneğin ZCM_SCARR) Satir yapısı SCARR database
*tablosu ile tamamen ayni olsun. Daha sonra yeni bir rapor oluşturun ve SCARR tablosundaki bütün
*bilgileri okuyup oluşturduğunuz yeni database tablosu içine kaydedin. Oluşturduğunuz ve içini
*doldurduğunuz tablodaki bütün satırları okuyup ALV’sini gösterin. SE41 işlem kodu yardımıyla SAP’ye
*ait PF_Status objesinin kopyasını oluşturun ve ALV fonksiyonu içerisinde kullanın. Kopya PF-Status
*içinde yeni bir buton oluşturun ve basıldığında kullanıcıdan birer adet CARRID, CARRNAME,
*CURRCODE ve URL alsın. Alınan veriyi kullanarak database tablosuna yeni bir satir ekleyin ve ALV’yi
*yenileyin.

DATA: gt_scarr    TYPE TABLE OF zto_sap04_scarr,
      gt_fieldcat TYPE lvc_t_fcat,
      gs_layout   TYPE lvc_s_layo,
      gv_success.

START-OF-SELECTION.

  SELECT * FROM zto_sap04_scarr
    INTO TABLE gt_scarr.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'zto_sap04_scarr'
      i_bypassing_buffer     = abap_true
    CHANGING
      ct_fieldcat            = gt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  IF sy-subrc <> 0.
    BREAK-POINT.
  ENDIF.

  gs_layout-zebra      = abap_true.
  gs_layout-cwidth_opt = abap_true.
  gs_layout-sel_mode   = 'A'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      i_callback_program       = sy-repid
      is_layout_lvc            = gs_layout
      it_fieldcat_lvc          = gt_fieldcat
      i_callback_pf_status_set = 'PF_0156'
      i_callback_user_command  = 'UC_0156'
    TABLES
      t_outtab                 = gt_scarr
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.

  IF sy-subrc <> 0.
    BREAK-POINT.
  ENDIF.

FORM pf_0156 USING lt_extab TYPE slis_t_extab.
  SET PF-STATUS 'PF_STATUS_0156'.
ENDFORM.

FORM uc_0156 USING lv_ucomm    TYPE sy-ucomm
                  ls_selfield TYPE slis_selfield.

  CASE lv_ucomm.
    WHEN 'LEAVE'.
      LEAVE PROGRAM.
    WHEN 'SCARR'.

      CALL FUNCTION 'ZTO_FM_SAP04_17'
        IMPORTING
          ev_success = gv_success.

      IF gv_success = abap_true.

        SELECT * FROM zto_sap04_scarr
          INTO TABLE gt_scarr.

        ls_selfield-refresh = abap_true.
      ENDIF.

    WHEN OTHERS.
  ENDCASE.

ENDFORM.
