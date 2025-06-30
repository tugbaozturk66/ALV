*&---------------------------------------------------------------------*
*& Report ZTO_SAP04_0157
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTO_SAP04_0157.

DATA: gt_spfli    TYPE TABLE OF zto_sap04_spfli,
      gs_spfli    TYPE zto_sap04_spfli,
      gt_fieldcat TYPE lvc_t_fcat,
      gs_fieldcat TYPE lvc_s_fcat,
      gs_layout   TYPE lvc_s_layo,
      gv_success.

START-OF-SELECTION.

  SELECT * FROM zto_sap04_spfli
  INTO TABLE gt_spfli.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'zto_sap04_spfli'
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
      i_callback_pf_status_set = 'PF_157'
      i_callback_user_command  = 'UC_157'
    TABLES
      t_outtab                 = gt_spfli
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.

  IF sy-subrc <> 0.
    BREAK-POINT.
  ENDIF.

FORM pf_157 USING lt_extab TYPE slis_t_extab.
  SET PF-STATUS 'PF_STATUS_157'.
ENDFORM.

FORM uc_157 USING lv_ucomm    TYPE sy-ucomm
                  ls_selfield TYPE slis_selfield.

  CASE lv_ucomm.
    WHEN 'LEAVE'.
      LEAVE PROGRAM.
    WHEN 'EDIT'.

      LOOP AT gt_fieldcat INTO gs_fieldcat WHERE fieldname = 'CITYTO' OR fieldname = 'CITYFROM'.

        gs_fieldcat-edit = abap_true.

        MODIFY gt_fieldcat FROM gs_fieldcat INDEX sy-tabix.

      ENDLOOP.

*      ls_selfield-refresh = abap_true.
      CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
        EXPORTING
          i_callback_program       = sy-repid
          is_layout_lvc            = gs_layout
          it_fieldcat_lvc          = gt_fieldcat
          i_callback_pf_status_set = 'PF_157'
          i_callback_user_command  = 'UC_157'
        TABLES
          t_outtab                 = gt_spfli
        EXCEPTIONS
          program_error            = 1
          OTHERS                   = 2.

      IF sy-subrc <> 0.
        BREAK-POINT.
      ENDIF.

    WHEN 'SAVE'.
      READ TABLE gt_spfli INTO gs_spfli INDEX ls_selfield-tabindex.
      IF sy-subrc IS INITIAL.
        MODIFY zto_sap04_spfli FROM gs_spfli.
      ENDIF.

    WHEN OTHERS.
  ENDCASE.

ENDFORM.
