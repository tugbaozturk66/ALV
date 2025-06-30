*&---------------------------------------------------------------------*
*& Report ZTO_SAP04_0151
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zto_sap04_0151.

*Alıştırma – 4: İkinci veya üçüncü alıştırmada gösterdiğiniz ALV için yeni bir PF_Status ve User
*Command oluşturun. “Geri butonunu düzenleyin”. Ayrıca 3 adet buton oluşturun. Birinci butona
*basıldığında ALV’de bulunan satir sayısını kullanıcıya bilgi mesajı olarak verin. İkinci butona
*basıldığında seyahat acentelerinin bulunduğu şehirlerin toplam sayısını kullanıcıya bilgi mesajı olarak
*verin. (Bazı seyahat şirketleri ayni şehirde bulunuyor.) Üçüncü butona basıldığında seçili satirin
*bilgilerini popup ALV olarak ekrana getirin. (Kullanıcının tek bir satir seçtiğini kabul ediyoruz.)

DATA: gs_str            TYPE zto_stravelag,
      gt_table          TYPE TABLE OF zto_stravelag,
      gs_table          TYPE  zto_stravelag,
      gt_table_sel      TYPE TABLE OF zto_stravelag,
      gt_fieldcat       TYPE lvc_t_fcat,
      gs_layout         TYPE lvc_s_layo,
      gt_fieldcat_popup TYPE slis_t_fieldcat_alv.

SELECT-OPTIONS : so_agnum FOR gs_str-agencynum.

START-OF-SELECTION.

  "1.asama
  SELECT * FROM zto_stravelag
    INTO TABLE gt_table
    WHERE agencynum IN so_agnum.

  "2. asama
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'ZTO_STRAVELAG'
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

  " 3. asama
  gs_layout-zebra      = abap_true.
  gs_layout-cwidth_opt = abap_true.
  gs_layout-sel_mode   = 'A'.

  "4. asama
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      i_callback_program       = sy-repid
      is_layout_lvc            = gs_layout
      it_fieldcat_lvc          = gt_fieldcat
      i_callback_pf_status_set = 'PF_151'
      i_callback_user_command  = 'UC_151'
    TABLES
      t_outtab                 = gt_table
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
    BREAK-POINT.
  ENDIF.

FORM pf_151 USING lt_extab TYPE slis_t_extab.

  SET PF-STATUS 'PF_STATUS_151'..
ENDFORM.

FORM uc_151 USING lv_ucomm    TYPE sy-ucomm
              ls_selfield    TYPE slis_selfield.

  DATA : lv_no_lines TYPE n LENGTH 2,
         lv_msg      TYPE string.

  CASE lv_ucomm.
    WHEN 'LEAVE'.
      LEAVE PROGRAM.
    WHEN 'NO_LINES'.
      lv_no_lines = lines( gt_table ).
      CONCATENATE TEXT-001 lv_no_lines INTO lv_msg SEPARATED BY space.
      MESSAGE lv_msg TYPE 'I'.
    WHEN 'NO_CITIES'.
      DATA : lt_table TYPE TABLE OF zto_stravelag.
      lt_table = gt_table.

      SORT lt_table BY city.
      DELETE ADJACENT DUPLICATES FROM lt_table COMPARING city.
      lv_no_lines = lines( lt_table ).
      CONCATENATE TEXT-002 lv_no_lines INTO lv_msg SEPARATED BY space.
      MESSAGE lv_msg TYPE 'I'.
    WHEN 'SEL_LINE'.
      READ TABLE gt_table INTO gs_table INDEX ls_selfield-tabindex.

      IF sy-subrc IS INITIAL.
        APPEND gs_table TO gt_table_sel.
        CLEAR : gs_table.

        CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
          EXPORTING
            i_program_name         = sy-repid
            i_structure_name       = 'ZTO_STRAVELAG'
            i_bypassing_buffer     = abap_true
          CHANGING
            ct_fieldcat            = gt_fieldcat_popup
          EXCEPTIONS
            inconsistent_interface = 1
            program_error          = 2
            OTHERS                 = 3.
        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.

        CALL FUNCTION 'REUSE_ALV_POPUP_TO_SELECT'
          EXPORTING
            i_title               = 'Info selected line.'
            i_screen_start_column = 5
            i_screen_start_line   = 5
            i_screen_end_column   = 165
            i_screen_end_line     = 8
            i_tabname             = 'GT_TABLE_SEL'
*           I_STRUCTURE_NAME      =
            it_fieldcat           = gt_fieldcat_popup
            i_callback_program    = sy-repid
*          IMPORTING
*           e_exit                = gv_answer
          TABLES
            t_outtab              = gt_table_sel
          EXCEPTIONS
            program_error         = 1
            OTHERS                = 2.

      ENDIF.

*  	WHEN OTHERS.
  ENDCASE.
  .
ENDFORM.
