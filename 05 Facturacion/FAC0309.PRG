defi wind windfac from 1,0 to 20,79   ;
          title " IMPRIMIR CTAS X COBRAR " ;
          double nofloat nozoom nogrow shadow color scheme 10

***
STORE .T. TO R0205
DO WHILE R0205
   STORE SPACE(02) TO WGRU
   STORE SPACE(15) TO WCLI
   STORE SPACE(10) TO WDOC
   STORE SPACE(10) TO WREF
   STORE SPACE(03) TO WAREA
   STORE 1         TO WESTADO
   STORE 1         TO WORDEN
   STORE 1         TO WSALIDA

   STORE CTOD("  -  -  ") TO WELA1
   STORE CTOD("  -  -  ") TO WELA2
   STORE CTOD("  -  -  ") TO WVEN1
   STORE CTOD("  -  -  ") TO WVEN2
   STORE CTOD("  -  -  ") TO WCAN1
   STORE CTOD("  -  -  ") TO WCAN2

   HIDE MENU MENUFAC
   ACTI WIND WINDFAC
   @ 0,0 CLEAR
   @ 01,5 SAY    "GRUPO  CLTE.:" 
   @ 02,5 SAY    "CODIGO CLTE.:"
   @ 03,5 SAY    "No.DOCUMENTO:"
   @ 04,5 SAY    "REFERENCIA  :"
   @ 05,5 SAY    "AREA DE SERV:"

   @ 07,5 SAY    "*ELABORACION*"
   @ 08,5 SAY    "DESDE FECHA :"
   @ 09,5 SAY    "HASTA FECHA :"

   @ 11,5 SAY    "*VENCIMIENTO*"
   @ 12,5 SAY    "DESDE FECHA :"
   @ 13,5 SAY    "HASTA FECHA :"

   @ 01,50 SAY   "*  ESTADO   *"
   @ 02,50 SAY   "POR COBRAR .1"
   @ 03,50 SAY   "CANCELADA ..2"
   @ 04,50 say   "           [ ]"
   
   @ 06,50 SAY   "*  ORDEN    *"
   @ 07,50 say   "COD.CUENTA  1"
   @ 08,50 say   "COD.CLIENTE 2"
   @ 09,50 say   "           [ ]"
   
   @ 11,50 SAY   "*  SALIDA   *"
   @ 12,50 say   "MONITOR ....1"
   @ 13,50 say   "IMPRESORA...2"
   @ 14,50 say   "           [ ]"
   
   STORE "OPRIMA <ESC> PARA SALIR" to mes
   do mensaje with mes
   @ 01,18 GET WGRU
   READ
   IF LASTKEY()=27
      SET CENTURY ON
      RELE WIND WINDFAC
      SHOW MENU MENUFAC
      RETURN
   ENDIF
   
   @ 02,18 GET WCLI
   READ
   IF LASTKEY()=27
      LOOP
   ENDIF
   @ 03,18 GET WDOC
   READ
   IF LASTKEY()=27
      LOOP
   ENDIF
   @ 04,18 GET WREF
   READ
   IF LASTKEY()=27
      LOOP
   ENDIF
   @ 05,18 GET WAREA
   READ
   IF LASTKEY()=27
      LOOP
   ENDIF

   @ 08,18 GET WELA1
   @ 09,18 GET WELA2
   READ
   IF WELA2<WELA1
      STORE "VERIFIQUE CRITERIO DE FECHAS DE ELABORACION (Ù)" TO MES
      DO AVISO WITH MES
      LOOP
   ENDIF
   @ 12,18 GET WVEN1
   @ 13,18 GET WVEN2
   READ
   IF WVEN2<WVEN1
      STORE "VERIFIQUE CRITERIO DE FECHAS DE VENCIMIENTO (Ù)" TO MES
      DO AVISO WITH MES
      LOOP
   ENDIF
   @ 04,62 get WESTADO picture "#" range 1,2
   READ

   @ 09,62 get worden  picture "#" range 1,2
   read
   
   @ 14,62 get wsalida picture "#" range 1,2
   read
   
   STORE "CONTINUAR ? (S/N)" TO TEX
   STORE "SN" TO WCH
   DO PREGUNTA
   IF WCH = "N"
      LOOP
   ENDIF
   DEACT WIND WINDFAC
   SAVE SCRE TO INF1

   STORE 0 TO PAGINA
   STORE 100 TO LINE
   IF WSALIDA = 1
      STORE 22 TO WSALTO
      @ 0,0 CLEAR
   ELSE
      SET DEVI TO PRINT
      STORE 55 TO WSALTO
   ENDIF
   STORE 0 TO FLAGSAL
   STORE 0 TO WTOTALINF
   STORE 0 TO WTOTALCOM

   SELECT FACCXC
   IF WORDEN=1
      SET ORDER TO FACCXC1
   ELSE 
      SET ORDER TO FACCXC2
   ENDIF
   GO TOP
   DO WHILE .NOT. EOF()
      IF WGRU <> SPACE(02) 
         SELECT FACCLI 
         SEEK FACCXC.CODCLI
         IF FOUND()
            STORE FACCLI.DESCLI TO WXDESCLI
            STORE FACCLI.CODGRU TO WXGRU
         ELSE
            STORE SPACE(30)     TO WXDESCLI
            STORE SPACE(02)     TO WXGRU
         ENDIF
         SELECT FACCXC
         IF WGRU<>WXGRU
            SKIP
            LOOP
         ENDIF
      ENDIF
      IF WCLI <> SPACE(15) .AND. CODCLI <> WCLI
         SKIP
         LOOP
      ENDIF
      IF WDOC <> SPACE(10) .AND.  CODCXC <> WDOC
         SKIP
         LOOP
      ENDIF
      IF WREF <> SPACE(10) .AND.  REFERENCIA <> WREF
         SKIP
         LOOP
      ENDIF
      IF WAREA <> SPACE(3)
         SELECT FACDCGE
         SEEK FACCXC.REFERENCIA
         IF FOUND()
            STORE AREA     TO WFACAREA
         ELSE
            STORE SPACE(3) TO WFACAREA
         ENDIF
         SELECT FACCXC
         IF WAREA<>WFACAREA
            SKIP
            LOOP
         ENDIF
      ENDIF
      IF WELA1 = CTOD("  -  -  ")
         *** REGISTRO APROBADO
      ELSE
         IF ELABORADO >= WELA1 .AND. ELABORADO <=WELA2
            *** REGISTRO APROBRADO
         ELSE
            SKIP
            LOOP
         ENDIF
      ENDIF
      IF WVEN1 = CTOD("  -  -  ")
         *** REGISTRO APROBADO
      ELSE
         IF VENCE     >= WVEN1 .AND. VENCE     <=WVEN2
            *** REGISTRO APROBRADO
         ELSE
            SKIP
            LOOP
         ENDIF
      ENDIF
      IF WESTADO = 1
         IF CANCELADO <> CTOD("  -  -  ")
            SKIP
            LOOP
         ENDIF
      ELSE
         IF CANCELADO = CTOD("  -  -  ")
            SKIP
            LOOP
         ENDIF
      ENDIF
      STORE LINE+1 TO LINE
      DO SALTO
      STORE FUNNOMCLI() TO WNOMCLI
      @ LINE,00 SAY CODCXC
      @ LINE,08 SAY DTOC(ELABORADO)
      @ LINE,19 SAY DTOC(VENCE)
      IF CANCELADO<>CTOD("  -  -    ")
         @ LINE,30 SAY "S"
      ENDIF
      STORE 0 TO WSALDO
      DO CALSALDO
      @ LINE,29 SAY STR(WSALDO,12,2)
      @ LINE,42 SAY REFERENCIA
      @ LINE,53 SAY SUBSTR(WNOMCLI,1,25)
      STORE WTOTALINF+WSALDO TO WTOTALINF
      SKIP
   ENDDO
   IF WTOTALINF > 0
      STORE LINE+1 TO LINE
      @ LINE,5 SAY "T O T A L E S:"
      @ LINE,31 SAY STR(WTOTALINF,12,2)
   ENDIF
   IF FLAGSAL = 1
      LOOP
   ENDIF
   IF WSALIDA = 2
      SET DEVI TO SCRE
      EJECT
   ELSE
      STORE "OPRIMA (Ù) PARA FINALIZAR" TO MES
      DO AVISO WITH MES
      RESTORE SCRE FROM INF1
   ENDIF
ENDDO
SELECT FACCXC
SET ORDER TO FACCXC1
RETURN
**********      
PROC SALTO
**********
IF LINE >= WSALTO
   STORE PAGINA + 1 TO PAGINA
   IF WSALIDA=1 .AND. PAGINA<>1
      STORE "CONTINUAR ? (S/N)" TO TEX
      STORE "SN" TO WCH
      DO PREGUNTA
      IF WCH = "N"
         STORE 1 TO FLAGSAL
         EXIT
      ENDIF
      @ 0,0 CLEAR
   ENDIF
   @ 0,0   SAY CHR(18)
   @ 1,0   SAY QQWW
   @ 1,0   SAY CHR(15)
   @ 1,60  SAY "FECHA :"+DTOC(DATE())
   @ 2,0   SAY  "RESUMEN DE CTAS. X COBRAR"
   @ 2,60  SAY "PAGINA:"+STR(PAGINA,2)
      
   @ 05,0  SAY "No.     EMISION    VENCE           SALDO  REFCIA.    CLIENTE                "
   @ 06,0  SAY "------- ---------- ---------- ----------- ---------- -----------------------"
   STORE 7 TO LINE
ENDIF
RETURN
**************
FUNC FUNNOMCLI
**************
SELECT FACCLI
SEEK FACCXC.CODCLI
IF .NOT. FOUND()
   STORE ""     TO WNOMCLI    
ELSE
   STORE DESCLI TO WNOMCLI
ENDIF
SELECT FACCXC
RETURN WNOMCLI
***************
PROC CALSALDO
***************
STORE 0   TO WTOTPAG
SELECT FACCXCTR
SET ORDER TO FACCXCT1
SEEK FACCXC.CODCXC
DO WHILE .NOT. EOF() .AND. FACCXC.CODCXC = FACCXCTR.CODCXC
   STORE WTOTPAG+MONTO TO WTOTPAG
   SKIP
ENDDO
STORE FACCXC.TOTDOC - WTOTPAG TO WSALDO
SELECT FACCXC
RETURN

