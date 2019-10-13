SELECT MATLIN
GO TOP
IF EOF()
   DO INCLUYE
ENDIF
SET COLOR TO W+/B
@ 4,0 CLEAR
STORE "LINEAS DE ARTICULOS" TO WHEADER
@ 4,40 - (LEN(WHEADER)/2) SAY WHEADER
@ 5,0
@ 5,01 SAY "CODIGO"
@ 5,12 SAY "DESCRIPCION"
@ 21,0 SAY "³PgUp=Pag.Arr³PgDn=Pag.Abj³Home=Inic³End=Final³=Ant.³=Sig.³ESC=Salir³Ù=Acep.³"
@ 6,0 TO 19,79
STORE  "INCLUIR    " TO XMENU1
STORE  "MODIFICAR  " TO XMENU2
STORE  "ELIMINAR   " TO XMENU3
STORE  "SELECCIONAR" TO XMENU4
STORE  "BUSCAR     " TO XMENU5
STORE 4 TO WMENU
STORE .T. TO XFLAG

STORE 12 TO WRANGO
GO TOP
STORE RECNO() TO WINICIO
STORE 0 TO WREVERSE
STORE 0 TO WEDILIN
STORE .T. TO FLAGJUMP
STORE .T. TO WEDITAR
DO WHILE WEDITAR
   IF FLAGJUMP
      STORE 0       TO WCONT
      STORE 07      TO WLINE
      GO WINICIO
      SET COLOR TO W+/B
      @ 7,1 CLEAR TO 18,78
      DO WHILE .NOT. EOF() .AND. WCONT < WRANGO
         STORE WLINE+WCONT TO WSCRELIN
         STORE WLINE+WCONT TO WLASTLIN
         STORE RECNO() TO WLASTREC
         @ WSCRELIN ,01  SAY CODIGO
         @ WSCRELIN ,12  SAY DESCRI
         STORE WCONT + 1 TO WCONT
         SKIP
      ENDDO
      STORE .F. TO FLAGJUMP
   ENDIF

   IF WREVERSE = 0
      STORE WLASTREC TO WREVERSE
      STORE WLASTLIN TO WEDILIN
      STORE WINICIO  TO WCLEARREC
      STORE WLINE    TO WCLEARLIN
   ENDIF

   ** PARA BORRAR EL REGISTRO ANTERIOR
   SET COLOR TO W+/B
   GO WCLEARREC
   STORE WCLEARLIN TO WSCRELIN
   @ WSCRELIN ,01  SAY CODIGO
   @ WSCRELIN ,12  SAY DESCRI

   ** PARA MARCAR EL REGISTRO ACTUAL
   SET COLOR TO B/W+
   GO WREVERSE
   STORE WEDILIN TO WSCRELIN
   @ WSCRELIN ,01  SAY CODIGO
   @ WSCRELIN ,12  SAY DESCRI
   STORE WREVERSE TO WCLEARREC
   STORE WSCRELIN TO WCLEARLIN
   SET COLOR TO W+/B

   *** PARA INDICAR LA ROTACION DEL MENU (SI LA HUBO)
   IF XFLAG
      SET COLOR TO W+/B
      @ 20,05 SAY  XMENU1
      @ 20,20 SAY  XMENU2
      @ 20,35 SAY  XMENU3
      @ 20,50 SAY  XMENU4
      @ 20,65 SAY  XMENU5
      SET COLOR TO B/W+
      STORE "XMENU"+STR(WMENU,1) TO WMACRO
      @ 20,5+((WMENU-1)*15)  SAY &WMACRO
      STORE .F. TO XFLAG
      SET COLOR TO W+/B
   ENDIF

   *** CAPTURA DE INTERACTIVIDAD
   CLEAR TYPEAHEAD
   STORE INKEY(0) TO WMUEVE
   *** PAGE DOWN
   IF WMUEVE = 3
      GO WINICIO
      SKIP +12
      IF .NOT. EOF()
         STORE RECNO() TO WINICIO
         STORE .T.     TO FLAGJUMP
         STORE WINICIO TO WREVERSE
         STORE WLINE   TO WEDILIN
         STORE WINICIO TO WCLEARREC
         STORE WLINE   TO WCLEARLIN
      ENDIF
   ENDIF
   *** PAGE UP
   IF WMUEVE =  18
      GO WINICIO
      SKIP -12
      STORE RECNO() TO WINICIO
      STORE .T. TO FLAGJUMP
      STORE 0 TO WREVERSE
   ENDIF
   *** HOME
   IF WMUEVE = 1
      GO TOP
      IF .NOT. EOF()
         STORE RECNO() TO WINICIO
         STORE .T. TO FLAGJUMP
         STORE WINICIO TO WREVERSE
         STORE WLINE   TO WEDILIN
         STORE WINICIO TO WCLEARREC
         STORE WLINE   TO WCLEARLIN
      ENDIF
   ENDIF
   *** END
   IF WMUEVE = 6
      GO BOTT
      SKIP -11
      STORE RECNO() TO WINICIO
      STORE 0 TO WREVERSE
      STORE .T. TO FLAGJUMP
   ENDIF
   *** DOWN ARROW
   IF WMUEVE = 24
      SKIP +1
      IF WEDILIN < (WLINE+(WCONT-1))
         STORE WREVERSE    TO WCLEARREC
         STORE RECNO()     TO WREVERSE
         STORE WEDILIN     TO WCLEARLIN
         STORE WEDILIN + 1 TO WEDILIN
      ENDIF
   ENDIF
   *** UP ARROW
   IF WMUEVE = 5
      SKIP -1
      IF WEDILIN > WLINE
         STORE WREVERSE    TO WCLEARREC
         STORE RECNO()     TO WREVERSE
         STORE WEDILIN     TO WCLEARLIN
         STORE WEDILIN - 1 TO WEDILIN
      ENDIF
   ENDIF
   *** RIGHT ARROW
   IF WMUEVE = 4
      STORE .T. TO XFLAG
      STORE WMENU+1 TO WMENU
      IF WMENU > 5
         STORE 1 TO WMENU
      ENDIF
   ENDIF
   *** LEFT ARROW
   IF WMUEVE = 19
      STORE .T. TO XFLAG
      STORE WMENU-1 TO WMENU
      IF WMENU < 1
         STORE 5 TO WMENU
      ENDIF
   ENDIF
   *** ESCAPE
   IF WMUEVE = 27
      STORE CODIGO TO WSEL
      RETURN
   ENDIF
   *** ENTER (INICIO DE OPERACIONES DE ACTUALIZACION DE DATOS
   IF WMUEVE = 13
      DO CASE
         CASE WMENU = 1
              DO INCLUYE
         CASE WMENU = 2
              DO MODIFICA
         CASE WMENU = 3
              DO ELIMINA
         CASE WMENU = 4
              RETURN
         CASE WMENU = 5
              DO BUSCA
      ENDCASE
   ENDIF
ENDDO
RETURN
************
PROC INCLUYE
************
              STORE 100 TO WSCRELIN
              STORE .T. TO WACT
              DO WHILE WACT
                 STORE WSCRELIN + 1 TO WSCRELIN
                 STORE SPACE(LEN(CODIGO)) TO WCODIGO
                 STORE SPACE(LEN(DESCRI)) TO WDESCRI
                 IF WSCRELIN > 18
                    @ 7,1 CLEAR TO 18,78
                    STORE 7 TO WSCRELIN
                 ENDIF
                 @ WSCRELIN ,01  GET WCODIGO
                 @ WSCRELIN ,12  GET WDESCRI
                 READ
                 IF WCODIGO = SPACE(LEN(CODIGO)) .OR. READKEY() = 12 .OR. READKEY() = 268
                    STORE .F. TO WACT
                    GO TOP
                    STORE RECNO() TO WINICIO
                    STORE .T. TO FLAGJUMP
                    STORE 0 TO WREVERSE
                    LOOP
                 ENDIF
                 FIND &WCODIGO
                 IF .NOT. EOF()
                    STORE "CODIGO YA EXISTE EN EL FICHERO. <ENTER>" TO MES
                    DO AVISO WITH MES
                    STORE WSCRELIN - 1 TO WSCRELIN
                    LOOP
                 ENDIF
                 STORE "CONFORME ? (S/N)" TO TEX
                 STORE "SN" TO WCH
                 DO PREGUNTA
                 IF WCH = "N"
                    STORE WSCRELIN - 1  TO WSCRELIN
                    LOOP
                 ENDIF
                 IF FILLOC()
                    APPEND BLANK
                    REPLACE CODIGO   WITH WCODIGO
                    REPLACE DESCRI   WITH WDESCRI
                    REPLACE ORIGEN   WITH "INV"
                    REPLACE DEPTO    WITH WUSERUBI
                    REPLACE USUARIO  WITH WUSERCODE
                    REPLACE USUARIOF WITH DATE()
                    UNLOCK ALL
                    FLUSH
                 ENDIF
              ENDDO
              RETURN
*************
PROC MODIFICA
*************
              STORE .T. TO WACT
              STORE CODIGO TO WCODINI
              STORE CODIGO TO WCODIGO
              STORE DESCRI TO WDESCRI
              DO WHILE WACT
                 @ WSCRELIN ,01  GET WCODIGO
                 @ WSCRELIN ,12  GET WDESCRI
                 READ
                 IF WCODIGO = SPACE(LEN(CODIGO)) .OR. READKEY() = 12 .OR. READKEY() = 268
                    STORE .F. TO WACT
                    LOOP
                 ENDIF
                 IF WCODIGO <> CODIGO
                    FIND &WCODIGO
                    IF .NOT. EOF()
                       STORE "CODIGO YA EXISTE EN EL FICHERO. <ENTER>" TO MES
                       DO AVISO WITH MES
                       LOOP
                    ENDIF
                 ENDIF
                 STORE "CONFORME ? (S/N)" TO TEX
                 STORE "SN" TO WCH
                 DO PREGUNTA
                 IF WCH = "N"
                    LOOP
                 ENDIF
                 IF RECLOC()
                    REPLACE CODIGO   WITH WCODIGO
                    REPLACE DESCRI   WITH WDESCRI
                    REPLACE ORIGEN   WITH "INV"
                    REPLACE DEPTO    WITH WUSERUBI
                    REPLACE USUARIO  WITH WUSERCODE
                    REPLACE USUARIOF WITH DATE()
                    UNLOCK ALL
                    FLUSH
                 ENDIF
                 STORE .F. TO WACT
                 *** SI CAMBIO EL CODIGO REORGANIZAR LA POSICION
                 IF WCODIGO <> WCODINI
                    FIND &WCODIGO
                    STORE RECNO() TO WINICIO
                    STORE .T. TO FLAGJUMP
                    STORE WINICIO TO WREVERSE
                    STORE WLINE   TO WEDILIN
                    STORE WINICIO TO WCLEARREC
                    STORE WLINE   TO WCLEARLIN
                 ENDIF
              ENDDO
              RETURN
************
PROC ELIMINA
************
              STORE "ESTA SEGURO QUE DESEA ELIMINAR (S/N)" TO TEX
              STORE "NS" TO WCH
              DO PREGUNTA
              IF WCH = "S"
                 IF FILLOC()
                    REPLACE ORIGEN   WITH "INV"
                    REPLACE DEPTO    WITH WUSERUBI
                    REPLACE USUARIO  WITH WUSERCODE
                    REPLACE USUARIOF WITH DATE()
                    DELETE
                    UNLOCK ALL
                 ENDIF
                 SKIP
                 IF .NOT. EOF()
                    STORE RECNO() TO WINICIO
                    STORE .T. TO FLAGJUMP
                    STORE RECNO() TO WREVERSE
                    STORE RECNO() TO WCLEARREC
                    STORE WLINE   TO WEDILIN
                    STORE WLINE   TO WCLEARLIN
                 ELSE
                    GO TOP
                    STORE RECNO() TO WINICIO
                    STORE .T. TO FLAGJUMP
                    STORE 0 TO WREVERSE
                 ENDIF
              ENDIF
              RETURN
**********
PROC BUSCA
**********
              SAVE SCRE TO S9
              STORE SPACE(LEN(CODIGO)) TO WCODIGO
              @ WSCRELIN, 01 GET WCODIGO
              READ
              IF WCODIGO <> SPACE(LEN(CODIGO))
                 FIND &WCODIGO
                 IF .NOT. EOF()
                    STORE RECNO() TO WINICIO
                    STORE .T. TO FLAGJUMP
                    STORE RECNO() TO WREVERSE
                    STORE RECNO() TO WCLEARREC
                    STORE WLINE   TO WEDILIN
                    STORE WLINE   TO WCLEARLIN
                 ELSE
                    RESTORE SCRE FROM S9
                 ENDIF
              ELSE
                 RESTORE SCRE FROM S9
              ENDIF
              RETURN
