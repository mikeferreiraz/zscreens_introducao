*&---------------------------------------------------------------------*
*& Report ZUDEMY_SCREENS1
*&---------------------------------------------------------------------*
*& Author: Mike Ferreira Moura - Praticando Curso Udemy
*&---------------------------------------------------------------------*
REPORT zscreens_introducao.

TABLES: ekko,
        mara,
        sscrfields.

TYPE-POOLS: icon.

DATA: it_ekko  TYPE TABLE OF ekko,
      it_ekko2 TYPE TABLE OF ekko.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  "Parâmetro simples e com match code stdr.
  PARAMETERS: p_matnr TYPE mara-matnr MODIF ID p1.

  "Parâmetro de Checkbox
  PARAMETERS: c_todos TYPE char1 AS CHECKBOX MODIF ID p1 DEFAULT 'X',
              c_matnr TYPE char1 AS CHECKBOX MODIF ID p1,
              c_item  TYPE char1 AS CHECKBOX MODIF ID p1.

  "Parâmetro de Listbox
  PARAMETERS: l_mtart TYPE mara-mbrsh AS LISTBOX VISIBLE LENGTH 50 MODIF ID p1.

  "Parâmetro simples e com match code stdr.
  PARAMETERS: p_mtart TYPE mara-mtart MODIF ID p1.
SELECTION-SCREEN END OF BLOCK b1.



*&---------------------------------------------------------------------*
*& Selection-options
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
  SELECT-OPTIONS: so_ebeln FOR ekko-ebeln MODIF ID p2.
  PARAMETERS: p_ebeln TYPE ekko-ebeln MODIF ID p2.
SELECTION-SCREEN END OF BLOCK b2.




*&---------------------------------------------------------------------*
*& Radio-Button
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS: p_all    RADIOBUTTON GROUP gr1 DEFAULT 'X' USER-COMMAND usr_command.
    SELECTION-SCREEN COMMENT 5(5) TEXT-004 FOR FIELD p_all.
    PARAMETERS: p_opened RADIOBUTTON GROUP gr1.
    SELECTION-SCREEN COMMENT 14(10) TEXT-005 FOR FIELD p_opened.
    PARAMETERS: p_closed RADIOBUTTON GROUP gr1.
    SELECTION-SCREEN COMMENT 26(13) TEXT-006 FOR FIELD p_closed.
  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b3.

*&---------------------------------------------------------------------*
*& Buttons
*&---------------------------------------------------------------------*
SELECTION-SCREEN: FUNCTION KEY 1. "Declaração dos botões.
SELECTION-SCREEN: FUNCTION KEY 2.
SELECTION-SCREEN: FUNCTION KEY 3.
SELECTION-SCREEN: FUNCTION KEY 4.
SELECTION-SCREEN: FUNCTION KEY 5.

*&---------------------------------------------------------------------*
*& Novas Telas
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF SCREEN 9000.
  SELECTION-SCREEN COMMENT /1(40) text1.
  PARAMETERS: p_novo TYPE char10.
SELECTION-SCREEN END OF SCREEN 9000.

SELECTION-SCREEN BEGIN OF SCREEN 9001.
  SELECTION-SCREEN COMMENT /1(40) text2.
  PARAMETERS: p_popup TYPE char10.
SELECTION-SCREEN END OF SCREEN 9001.

*&---------------------------------------------------------------------*
*& Abas
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF TABBED BLOCK t1 FOR 20 LINES.
  SELECTION-SCREEN TAB (20) tab1 USER-COMMAND usrcmd1 DEFAULT SCREEN 101.
  SELECTION-SCREEN TAB (20) tab2 USER-COMMAND usrcmd2 DEFAULT SCREEN 102.
  SELECTION-SCREEN TAB (20) tab3 USER-COMMAND usrcmd3 DEFAULT SCREEN 103.
SELECTION-SCREEN END OF BLOCK t1.

SELECTION-SCREEN BEGIN OF SCREEN 101 AS SUBSCREEN.
  PARAMETERS: p_matnrs TYPE mara-matnr.
SELECTION-SCREEN END OF SCREEN 101.

SELECTION-SCREEN BEGIN OF SCREEN 102 AS SUBSCREEN.
  SELECT-OPTIONS so_matnr FOR mara-matnr.
SELECTION-SCREEN END OF SCREEN 102.

SELECTION-SCREEN BEGIN OF SCREEN 103 AS SUBSCREEN.
  PARAMETERS: p_insert RADIOBUTTON GROUP gr2 DEFAULT 'X',
              p_delete RADIOBUTTON GROUP gr2.
SELECTION-SCREEN END OF SCREEN 103.

*&---------------------------------------------------------------------*
*& Pushbutton
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE TEXT-007.
  SELECTION-SCREEN PUSHBUTTON /1(15) botao1 USER-COMMAND user1.
  SELECTION-SCREEN SKIP 1.
  SELECTION-SCREEN ULINE.
  SELECTION-SCREEN SKIP 1.
  SELECTION-SCREEN PUSHBUTTON /1(15) botao2 USER-COMMAND user2.
SELECTION-SCREEN END OF BLOCK b4.

SELECTION-SCREEN BEGIN OF SCREEN 400 AS WINDOW.
  SELECTION-SCREEN INCLUDE BLOCKS b4.
SELECTION-SCREEN END OF SCREEN 400.

SELECTION-SCREEN BEGIN OF SCREEN 401 AS WINDOW.
  SELECTION-SCREEN INCLUDE BLOCKS b3.
SELECTION-SCREEN END OF SCREEN 401.

*&---------------------------------------------------------------------*
*& Match code
*&---------------------------------------------------------------------*
PARAMETERS: p_matnr3 TYPE char18 MATCHCODE OBJECT zmatnr.


INITIALIZATION. "PBO
  PERFORM f_carrega_dados.
  PERFORM f_criar_botoes.

AT SELECTION-SCREEN OUTPUT.
  PERFORM f_modifica_tela.

AT SELECTION-SCREEN ON p_matnr.
  PERFORM f_valida_entrada.

AT SELECTION-SCREEN.
  PERFORM f_evento_botao.

START-OF-SELECTION.
  PERFORM f_executar_programa.



FORM f_criar_botoes.

  DATA: ls_button TYPE smp_dyntxt.

  "Botão 1
  ls_button-text = 'Criar material'.
  ls_button-icon_id = icon_create.
  ls_button-quickinfo = 'Criar material'.
  sscrfields-functxt_01 = ls_button.

  "Botão 2
  ls_button-text = 'Alterar material'.
  ls_button-icon_id = icon_change.
  ls_button-quickinfo = 'Alterar material'.
  sscrfields-functxt_02 = ls_button.

  "Botão 3
  ls_button-text = 'Remover material'.
  ls_button-icon_id = icon_delete.
  ls_button-quickinfo = 'Remover material'.
  sscrfields-functxt_03 = ls_button.

  "Botão 4
  ls_button-text = 'Tela Cheia'.
  ls_button-icon_id = icon_businav_szenario.
  ls_button-quickinfo = 'Tela Cheia'.
  sscrfields-functxt_04 = ls_button.

  "Botão 5
  ls_button-text = 'Pop-up'.
  ls_button-icon_id = icon_system_modus_create.
  ls_button-quickinfo = 'Pop-up'.
  sscrfields-functxt_05 = ls_button.

ENDFORM.


FORM f_evento_botao.

  CASE sy-ucomm.
    WHEN 'FC01'. BREAK-POINT. "Botao Criar
    WHEN 'FC02'. BREAK-POINT. "Botao Alterar
    WHEN 'FC03'. BREAK-POINT. "Botao Deletar
    WHEN 'FC04'.
      CALL SELECTION-SCREEN 9000.
    WHEN 'FC05'.
      CALL SELECTION-SCREEN 9001 STARTING AT 5 5 ENDING AT 50 8.
    WHEN 'USRCMD1'.
      "BREAK-POINT.
    WHEN 'USER1'.
      CALL SELECTION-SCREEN 400 STARTING AT 5 5.
    WHEN 'USER2'.
      CALL SELECTION-SCREEN 401 STARTING AT 5 5.

  ENDCASE.


*  IF  sy-ucomm EQ 'FC01'. "Criar
*    BREAK-POINT.
*  ENDIF.
*
*  IF  sy-ucomm EQ 'FC02'. "Alterar
*    BREAK-POINT.
*  ENDIF.
*
*  IF  sy-ucomm EQ 'FC03'. "Deletar
*    BREAK-POINT.
*  ENDIF.


ENDFORM.


*&---------------------------------------------------------------------*
*& Form - Perform
*&---------------------------------------------------------------------*

FORM f_valida_entrada.

  DATA it_matnr TYPE mara-matnr.

  SELECT SINGLE matnr
    INTO it_matnr
    FROM mara
    WHERE matnr EQ p_matnr.

  IF p_matnr IS NOT INITIAL.
    MESSAGE 'Material não encontrado' TYPE 'S' DISPLAY LIKE 'W'.
  ENDIF.

  CLEAR it_matnr.

ENDFORM.

FORM f_modifica_tela.

  LOOP AT SCREEN.

    IF p_all EQ 'X'.
      IF screen-group1 EQ 'P1' OR screen-group1 EQ 'P2'.
        screen-invisible = 0.
      ENDIF.
    ENDIF.

    IF p_opened EQ 'X'. "Parameters
      IF screen-group1 EQ 'P1'.
        screen-invisible = 0.
        screen-input     = 1.
        screen-active    = 1.
      ENDIF.

      IF screen-group1 EQ 'P2'.
        screen-invisible = 1.
        screen-input     = 0.
        screen-active    = 0.
      ENDIF.
    ENDIF.

    IF p_closed EQ 'X'. "Select-options
      IF screen-group1 EQ 'P1'.
        screen-invisible = 1.
        screen-input     = 0.
        screen-active    = 0.
      ENDIF.

      IF screen-group1 EQ 'P2'.
        screen-invisible = 0.
        screen-input     = 1.
        screen-active    = 1.
      ENDIF.
    ENDIF.

    IF screen-name EQ 'P_EBELN'.
      screen-input = 0.
    ENDIF.

    MODIFY SCREEN.

  ENDLOOP.

ENDFORM.


FORM f_carrega_dados.

  text1  = 'Nova tela - Cheia'.
  text2  = 'Nova tela - Pop-up'.
  tab1   = 'Material Simples'.
  tab2   = 'Range de Materiais'.
  tab3   = 'Ação'.
  botao1 = 'Inserir'.
  botao2 = 'Deletar'.

  p_ebeln = '100'.

ENDFORM.

FORM f_executar_programa.

*SELECT *
*  INTO TABLE it_ekko[]
*  FROM ekko
*  WHERE ebeln IN so_ebeln[].
*
*SELECT *
*INTO TABLE it_ekko2[]
*FROM ekko
*WHERE ebeln EQ p_ebeln.
*
*BREAK-POINT.

  IF p_all EQ 'X'.

  ENDIF.

ENDFORM.
