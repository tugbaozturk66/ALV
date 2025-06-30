*&---------------------------------------------------------------------*
*& Report ZTO_SAP04_0146
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zto_sap04_0146.

DATA : gt_spfli TYPE TABLE OF spfli,
       gt_fieldcat TYPE LVC_T_FCAT,
       gs_layout TYPE lvc_s_layo.

START-OF-SELECTION.

" 1. asama veriyi cekme
SELECT * FROM spfli
  INTO TABLE gt_spfli.

" 2. field katalog olusturma
CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
 EXPORTING
   I_STRUCTURE_NAME             = 'SPFLI'
   I_BYPASSING_BUFFER           = abap_true
  CHANGING
    ct_fieldcat                 = gt_fieldcat
 EXCEPTIONS
   INCONSISTENT_INTERFACE       = 1
   PROGRAM_ERROR                = 2
   OTHERS                       = 3
          .
IF sy-subrc <> 0.
BREAK-POINT.
ENDIF.

"3.layout olusturma
gs_layout-zebra      = abap_true.
gs_layout-cwidth_opt = abap_true.
gs_layout-sel_mode   = 'A'.

"alv alma
CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
 EXPORTING
   I_CALLBACK_PROGRAM                = sy-repid
   IS_LAYOUT_LVC                     = gs_layout
   IT_FIELDCAT_LVC                   = gt_fieldcat
  TABLES
    t_outtab                          = gt_spfli
 EXCEPTIONS
   PROGRAM_ERROR                     = 1
   OTHERS                            = 2
          .
IF sy-subrc <> 0.
BREAK-POINT.
ENDIF.
