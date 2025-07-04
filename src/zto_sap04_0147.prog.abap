*&---------------------------------------------------------------------*
*& Report ZTO_SAP04_0147
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zto_sap04_0147.

TYPES : BEGIN OF gty_str,
          kutu      TYPE c LENGTH 1,
          carrid    TYPE c LENGTH 3,
          connid    TYPE c LENGTH 4,
          fldate    TYPE datum,
          price     TYPE p DECIMALS 2,
          currency  TYPE c LENGTH 3,
          planetype TYPE c LENGTH 10,
        END OF gty_str.

DATA : gt_table    TYPE TABLE OF gty_str,
       gt_fieldcat TYPE slis_t_fieldcat_alv,
       gs_fieldcat TYPE slis_fieldcat_alv,
       gs_layout   TYPE slis_layout_alv.

START-OF-SELECTION.

  SELECT * FROM sflight
    INTO CORRESPONDING FIELDS OF TABLE gt_table.

  gs_fieldcat-fieldname = 'CARRID'.
  gs_fieldcat-seltext_m = 'Airline Code'.
  gs_fieldcat-key = abap_true.
  gs_fieldcat-just = 'C'.

  APPEND gs_fieldcat TO gt_fieldcat.
  CLEAR : gs_fieldcat.

  gs_fieldcat-fieldname = 'CONNID'.
  gs_fieldcat-seltext_m = 'Connection Number'.
  gs_fieldcat-key = abap_true.
  gs_fieldcat-just = 'C'.

  APPEND gs_fieldcat TO gt_fieldcat.
  CLEAR : gs_fieldcat.

  gs_fieldcat-fieldname = 'FLDATE'.
  gs_fieldcat-seltext_m = 'Flight Date'.
  gs_fieldcat-key = abap_true.
  gs_fieldcat-just = 'C'.

  APPEND gs_fieldcat TO gt_fieldcat.
  CLEAR : gs_fieldcat.

  gs_fieldcat-fieldname = 'PRICE'.
  gs_fieldcat-seltext_m = 'AIRFARE'.


  APPEND gs_fieldcat TO gt_fieldcat.
  CLEAR : gs_fieldcat.

  gs_fieldcat-fieldname = 'CURRENCY'.
  gs_fieldcat-seltext_m = 'LOCAL CURRENCY'.

  APPEND gs_fieldcat TO gt_fieldcat.
  CLEAR : gs_fieldcat.

  gs_fieldcat-fieldname = 'PLANETYPE'.
  gs_fieldcat-seltext_m = 'AIRCRAFT TYPE'.

  APPEND gs_fieldcat TO gt_fieldcat.
  CLEAR : gs_fieldcat.

  gs_layout-zebra = abap_true.
  gs_layout-colwidth_optimize = abap_true.
  gs_layout-box_fieldname = 'KUTU'.

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
 EXPORTING
   I_CALLBACK_PROGRAM                = 'sy-repid '
   IS_LAYOUT                         = gs_layout
   IT_FIELDCAT                       = gt_fieldcat
  TABLES
    t_outtab                          = gt_table
 EXCEPTIONS
   PROGRAM_ERROR                     = 1
   OTHERS                            = 2
          .
IF sy-subrc <> 0.
BREAK-POINT.
ENDIF.
