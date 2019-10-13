SELECT ALMLOT
GO TOP
IF EOF()
   APPEND BLANK
ENDIF
@ 4,0 CLEAR
STORE "SUBALMACENES" TO WHEADER
@ 4,40 - (LEN(WHEADER)/2) SAY WHEADER
@ 5,0
@ 5,01 SAY "CODIGO-ARTICULO"
@ 5,25 SAY "SUBALMACEN"
@ 5,45 SAY "UNIDADES"
@ 5,60 SAY "FECHA-INICIO"
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
      @ 7,1 CLEAR TO 18,78
      DO WHILE .NOT. EOF() .AND. WCONT < WRANGO
         STORE WLINE+WCONT TO WSCRELIN
         STORE WLINE+WCONT TO WLASTLIN
         STORE RECNO() TO WLASTREC
         @ WSCRELIN ,01  SAY CODART
         @ WSCRELIN ,25  SAY CODLOT
         @ WSCRELIN ,45  SAY STR(UNIDADES,10,2)
         @ WSCRELIN ,60  SAY FECHAING
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
   GO WCLEARREC
   STORE WCLEARLIN TO WSCRELIN
   @ WSCRELIN ,01  SAY CODART
   @ WSCRELIN ,25  SAY CODLOT
   @ WSCRELIN ,45  SAY STR(UNIDADES,10,2)
   @ WSCRELIN ,60  SAY FECHAING

   ** PARA MARCAR EL REGISTRO ACTUAL
   SET COLOR TO B/W+
   GO WREVERSE
   STORE WEDILIN TO WSCRELIN
   @ WSCRELIN ,01  SAY CODART
   @ WSCRELIN ,25  SAY CODLOT
   @ WSCRELIN ,45  SAY STR(UNIDADES,10,2)
   @ WSCRELIN ,60  SAY FECHAING
   STORE WREVERSE TO WCLEARREC
   STORE WSCRELIN TO WCLEARLIN
   SET COLOR TO W+/B

   *** PARA INDICAR LA ROTACION DEL MENU (SI LA HUBO)
   IF XFLAG
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
      STORE CODART TO WSEL
      RETURN
   ENDIF
   *** ENTER (INICIO DE OPERACIONES DE ACTUALIZACION DE DATOS
   IF WMUEVE = 13
      DO CASE
         CASE WMENU = 1
              STORE 100 TO WSCRELIN
              STORE .T. TO WACT
              DO WHILE WACT
                 STORE WSCRELIN + 1 TO WSCRELIN
                 STORE SPACE(LEN(CODART)) TO WCODART
                 STORE SPACE(LEN(CODLOT)) TO WCODLOT
                 STORE 0 TO WUNIDADES
                 STORE CTOD("  -  -  ") TO WFECHAING
                 IF WSCRELIN > 18
                    @ 7,1 CLEAR TO 18,78
                    STORE 7 TO WSCRELIN
                 ENDIF
                 @ WSCRELIN ,01  GET WCODART
                 @ WSCRELIN ,25  GET WCODLOT
              *  @ WSCRELIN ,45  GET WUNIDADES PICTURE "#######.##"
                 @ WSCRELIN ,60  GET WFECHAING
                 READ
                 IF WCODART = SPACE(LEN(CODART)) .OR. WCODLOT = SPACE(LEN(CODLOT)) .OR. READKEY() = 12 .OR. READKEY() = 268
                    STORE .F. TO WACT
                    GO TOP
                    STORE RECNO() TO WINICIO
                    STORE .T. TO FLAGJUMP
                    STORE 0 TO WREVERSE
                    LOOP
                 ENDIF
                 SELECT ALMART
                 FIND &WCODART
                 IF EOF()
                    STORE "CODIGO DE ARTICULO NO EXISTE EN FICHERO DE ARTICULOS. <ENTER>" TO MES
                    DO AVISO WITH MES
                    SELECT ALMLOT
                    STORE WSCRELIN - 1  TO WSCRELIN
                    LOOP
                 ENDIF
                 IF ALMACEN<>WUSERUBI
                    STORE "ARTICULO PERTENECE A OTRO ALMACEN" TO MES
                    DO AVISO WITH MES
                    STORE WSCRELIN - 1  TO WSCRELIN
                    LOOP
                 ENDIF
                 SELECT ALMLOT
                 STORE WCODART+WCODLOT TO WCLAVE
                 FIND &WCLAVE
                 IF .NOT. EOF()
                    STORE "CODIGO DE LOTE YA EXISTE PARA ESTE ARTICULO. <ENTER>" TO MES
                    DO AVISO WITH MES
                    SELECT ALMLOT
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
                 APPEND BLANK
                 REPLACE CODART    WITH WCODART
                 REPLACE CODLOT    WITH WCODLOT
                 *REPLACE UNIDADES WITH WUNIDADES
                 REPLACE FECHAING  WITH WFECHAING
                 REPLACE USUARIO   WITH WUSERCODE
                 REPLACE USUARIOF  WITH DATE()
                 FLUSH
              ENDDO
         CASE WMENU = 2
         CASE WMENU = 3
              SELECT ALMART
              FIND &WCODART
              IF EOF()
                 STORE "CODIGO DE ARTICULO NO EXISTE EN FICHERO DE ARTICULOS. <ENTER>" TO MES
                 DO AVISO WITH MES
                 SELECT ALMLOT
                 LOOP
              ENDIF
              IF ALMACE<>WUSERUBI
                 STORE "ARTICULO PERTENECE A OTRO ALMACEN: "+ALMACEN TO MES
                 DO AVISO WITH MES
                 LOOP
              ENDIF
              SELECT ALMLOT
              STORE "ESTA SEGURO QUE DESEA ELIMINAR (S/N)" TO TEX
              STORE "NS" TO WCH
              DO PREGUNTA
              IF WCH = "S"
                 STORE CODART TO WCODART
                 STORE CODLOT TO WCODLOT
                 STORE WCODART+WCODLOT TO WCLAVE
                 IF FILLOC()
                    DELETE
                    UNLOCK ALL
                 ENDIF
                 SELECT ALMLOTTR
                 DO WHILE .T.
                    FIND &WCLAVE
                    IF .NOT. EOF()
                       IF RECLOC()
                          DELETE
                          UNLOCK ALL
                       ENDIF
                    ELSE
                       EXIT
                    ENDIF
                 ENDDO
                 SELECT ALMLOT
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
                    IF EOF()
                       RETURN
                    ENDIF
                    STORE RECNO() TO WINICIO
                    STORE .T. TO FLAGJUMP
                    STORE 0 TO WREVERSE
                 ENDIF
              ENDIF
         CASE WMENU = 4
              RETURN
         CASE WMENU = 5
              SAVE SCRE TO S9
              STORE SPACE(LEN(CODART)) TO WCODART
              @ WSCRELIN, 01 GET WCODART
              READ
              IF WCODART <> SPACE(LEN(CODART))
                 FIND &WCODART
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
      ENDCASE
   ENDIF
ENDDO
RETURN
