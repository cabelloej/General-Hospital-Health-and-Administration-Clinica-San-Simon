***
SELECT ALMART
STORE .T. TO R0201
DO WHILE R0201
   @ 04,0 CLEAR
   @ 04,29 SAY "RESUMEN DE EXISTENCIAS"
   @ 05,1 TO 5,78
   STORE SPACE(3) TO WLIN
   STORE SPACE(20) TO WWDESDE
   STORE SPACE(20) TO WDESDE
   STORE REPLICATE("Z",20) TO WWHASTA
   STORE SPACE(20) TO WHASTA
   @ 06,5 SAY    "LINEA DE VTA.:"
   @ 08,5 SAY    "**INTERVALO**"
   @ 09,5 SAY    "DESDE CODIGO :"
   @ 10,5 SAY    "HASTA CODIGO :"

   @ 12,5 SAY    "*MODALIDAD*"
   @ 13,5 say    "LIST.NORMAL..1"
   @ 14,5 say    "ALERTA EXI...2"
   @ 15,5 say    "            [ ]"
   STORE 1 TO WMODO
   @ 17,5 SAY    "* SALIDA *"
   @ 18,5 say    "MONITOR .....1"
   @ 19,5 say    "IMPRESORA....2"
   @ 20,5 say    "            [ ]"
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
   ELSE
      STORE WDESDE TO WMES1
   ENDIF
   IF WHASTA = SPACE(20)
      STORE WWHASTA TO WHASTA
      STORE "ULTIMO                         " TO WMES2
      @ 10,20 SAY WMES2
   ELSE
      STORE WHASTA TO WMES2
   ENDIF
   IF WHASTA < WDESDE
      STORE "VERIFIQUE INTERVALO. (Ù)" TO MES
      DO AVISO WITH MES
      LOOP
   ENDIF
   @ 15,18 get WMODO picture "#" range 1,2
   READ
   @ 20,18 get wsalida picture "#" range 1,2
   read

   SAVE SCRE TO INF1
   STORE "CONTINUAR ? (S/N)" TO TEX
   STORE "SN" TO WCH
   DO PREGUNTA
   IF WCH = "N"
      RETURN
   ENDIF
   STORE 0 TO WTOTCOS
   STORE 0 TO PAGINA
   STORE 100 TO LINE
   IF WSALIDA = 1
      STORE 22 TO WSALTO
      @ 0,0 CLEAR
   ELSE
      SET DEVI TO PRINT
      STORE 55 TO WSALTO
   ENDIF
   GO TOP
   DO WHILE .NOT. EOF() 
      IF CODIGO < WDESDE
         SELECT ALMART
         SKIP
         LOOP
      ENDIF
      IF CODIGO > WHASTA
         SELECT ALMART
         SKIP
         LOOP
      ENDIF
      IF WLIN <> SPACE(3) .AND. WLIN <> LINEA
         SKIP
         LOOP
      ENDIF
     IF WMODO=2 .AND. UNIEXI > MINIMO
         SKIP
         LOOP
      ENDIF
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
         @ 2,0   SAY  "RESUMEN DE EXISTENCIAS"
         @ 2,60  SAY "PAGINA:"+STR(PAGINA,2)
         @ 3,0   SAY "DEL CODIGO:"+RTRIM(WMES1)+" HASTA EL:"+RTRIM(WMES2)
         @ 05,0  SAY "CODIGO"
         @ 05,21 SAY "LIN"
         @ 05,24 SAY "    MINIMO"
         @ 05,35 SAY "    MAXIMO"
         @ 05,46 SAY "EXI.ACTUAL"
         @ 05,57 SAY "     COSTO"
         @ 05,68 SAY "COSTO TOTAL"
         @ 6,0   SAY REPLICATE("-",80)
         STORE 7 TO LINE
      ENDIF
      @ LINE,0 SAY CODIGO
      @ LINE,21 SAY LINEA
      @ LINE,24 SAY STR(MINIMO,10,2)
      @ LINE,35 SAY STR(MAXIMO,10,2)
      @ LINE,46 SAY STR(UNIEXI,10,2)
      @ LINE,57 SAY STR(COSEXI,10,2)
      @ LINE,68 SAY STR((COSEXI*UNIEXI),11,2)
      STORE WTOTCOS+(UNIEXI*COSEXI) TO WTOTCOS
      SKIP
   ENDDO
   IF WTOTCOS>0
      STORE LINE+1 TO LINE
      @ LINE,0 SAY "COSTO TOTAL DE ESTE INFORME:"
      @ LINE,67 SAY STR(WTOTCOS,12,2)
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
RETURN
