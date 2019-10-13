***
SELECT ALMLOT
STORE .T. TO R0201
DO WHILE R0201
   GO TOP
   @ 04,0 CLEAR
   @ 04,37 SAY "SUBALMACENES"
   @ 05,1 TO 5,78
   STORE SPACE(20) TO WWDESDE
   STORE SPACE(3) TO WLIN
   STORE 0 TO WMODAL
   STORE SPACE(20) TO WDESDE
   STORE REPLICATE("Z",20) TO WWHASTA
   STORE SPACE(20) TO WHASTA
   @ 06,5 SAY    "LINEA DE VTA.:"
   @ 08,5 SAY    "** INTERVALO **"
   @ 09,5 SAY    "DESDE CODIGO :"
   @ 10,5 SAY    "HASTA CODIGO :"
  * @ 12,5 SAY    "*** MODALIDAD ***"
  * @ 13,5 SAY    "AMBAS  ........ 0"
  * @ 14,5 SAY    "LOTES VENCIDOS..1"
  * @ 15,5 SAY    "LOTES VIGENTES..2"
  * @ 16,5 say    "               [ ]"
   @ 19,5 SAY    "** SALIDA **"
   @ 20,5 say    "MONITOR ...1"
   @ 21,5 say    "IMPRESORA..2"
   @ 22,5 say    "          [ ]"
   store 1 to wsalida

   STORE "OPRIMA <ESC> PARA SALIR" to mes
   do mensaje with mes
   @ 6,20 GET WLIN
   READ
   IF READKEY() = 12 .OR READKEY() = 268
      RETURN
   ENDIF
   @ 09,20 GET WDESDE
   READ
   IF READKEY() = 12 .OR READKEY() = 268
      RETURN
   ENDIF
   @ 10,20 GET WHASTA
   READ
   IF READKEY() = 12 .OR READKEY() = 268
      RETURN
   ENDIF
   IF WDESDE = SPACE(20)
      STORE WWDESDE TO WDESDE
      STORE "PRIMERO                        " TO WMES1
      @ 09,20 SAY WMES1
   ENDIF
   IF WHASTA = SPACE(20)
      STORE WWHASTA TO WHASTA
      STORE "ULTIMO                         " TO WMES2
      @ 10,20 SAY WMES2
   ENDIF
   *@ 16,21 GET WMODAL PICTURE "#" RANGE 0,2
   *READ

   IF WHASTA < WDESDE
      STORE "VERIFIQUE EL INTERVALO (Ù)" TO MES
      DO AVISO WITH MES
      LOOP
   ENDIF
   @ 22,16 get wsalida picture "#" range 1,2
   read
   SAVE SCRE TO INF1
   STORE "CONTINUAR ? (S/N)" TO TEX
   STORE "SN" TO WCH
   DO PREGUNTA
   IF WCH = "N"
      RETURN
   ENDIF

   STORE 0 TO PAGINA
   STORE 100 TO LINE
   IF WSALIDA = 1
      STORE 22 TO WSALTO
      @ 0,0 CLEAR
   ELSE
      SET DEVI TO PRINT
      STORE 55 TO WSALTO
   ENDIF
   LOCATE FOR CODART >= WDESDE
   DO WHILE .NOT. EOF() .AND. CODART <= WHASTA
      IF WLIN <> SPACE(3)
         STORE CODART TO WCOD
         SELECT ALMART
         FIND &WCOD
         IF EOF()
            STORE "XXX"  TO WARTLIN
         ELSE
            STORE LINEA TO WARTLIN
         ENDIF
         SELECT ALMLOT
         IF WLIN <> WARTLIN
            SKIP
            LOOP
         ENDIF
      ENDIF
      *IF WMODAL <> 0
      *   IF WMODAL = 1 .AND.  DATE() < FECHAING+ALMART->LOTEVEN
      *      SKIP
      *      LOOP
      *   ELSE
      *      IF WMODAL = 2 .AND.  DATE() >= FECHAING+ALMART->LOTEVEN
      *         SKIP
      *         LOOP
      *      ENDIF
      *   ENDIF
      *ENDIF
      STORE LINE+1 TO LINE
      IF LINE >= WSALTO
         STORE PAGINA + 1 TO PAGINA
         IF WSALIDA=1 .AND. PAGINA<>1
            STORE "CONTINUAR ? (S/N)" TO TEX
            STORE "SN" TO WCH
            DO PREGUNTA
            IF WCH = "N"
               RETURN
            ENDIF
            @ 0,0 CLEAR
         ENDIF
         @ 1,0   SAY QQWW
         @ 1,60  SAY "FECHA :"+DTOC(DATE())
         @ 2,0   SAY  "SUBALMACENES DE ARTICULOS"
         @ 2,60  SAY "PAGINA:"+STR(PAGINA,2)
         @ 04,0  SAY "CODIGO ARTICULO"
         @ 04,22 SAY "SUBALMACEN"
         @ 04,34 SAY "  UNIDADES"
         @ 04,46 SAY "FECHA INC."
         *@ 04,58 SAY "FECHA VEN."
         *@ 04,70 SAY "ESTADO"
         @ 5,0   SAY REPLICATE("-",80)
         STORE 6 TO LINE
      ENDIF
      *** LOCALIZA EL ARTICULO EN MAESTRO PARA TOMAR LA VIDA DEL ARTICULO
      STORE CODART TO WCOD
      SELECT ALMART
      SEEK WCOD
      IF EOF()
        STORE "ERROR DE DATOS, ARTICULO DEL SUBALMACEN NO EXISTE EN MAETRO" TO MES
        DO AVISO WITH MES
        RETURN
      ENDIF
      SELECT ALMLOT
      @ LINE,0 SAY CODART
      @ LINE,22 SAY CODLOT
      @ LINE,34 SAY STR(UNIDADES,10,2)
      @ LINE,46 SAY DTOC(FECHAING)
      *@ LINE,58 SAY DTOC(FECHAING+ALMART->LOTEVEN)
      *IF DATE()>=FECHAING+ALMART->LOTEVEN
      *   @ LINE, 70 SAY "(VENCIDA)"
      *   @ LINE, 70 SAY "(VENCIDA)"
      *ELSE
      *   @ LINE,70 SAY "OK"
      *ENDIF
      SKIP
   ENDDO
   IF WSALIDA = 2
      SET DEVI TO SCRE
      EJECT
   ELSE
      STORE "OPRIMA (Ù) PARA FINALIZAR" TO MES
      DO AVISO WITH MES
      RESTORE SCRE FROM INF1
   ENDIF
ENDDO
RETURN
