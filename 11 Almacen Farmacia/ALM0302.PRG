SELECT ALMART
STORE .T. TO R0201
DO WHILE R0201
   @ 04,0 CLEAR
   @ 04,30 SAY "ARTICULOS"
   @ 05,1 TO 5,78
   STORE 1         TO WORD
   STORE SPACE(3)  TO WLIN
   STORE SPACE(20) TO WWDESDE
   STORE SPACE(20) TO WDESDE
   STORE REPLICATE("Z",20) TO WWHASTA
   STORE SPACE(20) TO WHASTA

   @ 06,5 SAY    "*   ORDEN   * "
   @ 07,5 SAY    "ALFABETICO.. 1"
   @ 08,5 SAY    "CODIGO ..... 2"
   @ 09,5 SAY    "            [ ]"

   @ 11,5 SAY    "LINEA DE VTA.:"

   @ 13,5 SAY    "* ARTICULOS * "
   @ 14,5 SAY    "DESDE CODIGO :"
   @ 15,5 SAY    "HASTA CODIGO :"

   @ 17,5 SAY    "*   SALIDA   *"
   @ 18,5 say    "MONITOR .... 1"
   @ 19,5 say    "IMPRESORA... 2"
   @ 20,5 say    "            [ ]"
   STORE "OPRIMA <ESC> PARA SALIR" TO MES
   DO MENSAJE WITH MES
   @ 09,18 get word    picture "#" range 1,2
   READ
   IF READKEY() = 12 .OR READKEY() = 268
      RETURN
   ENDIF
   @ 11,20 GET WLIN
   READ
   IF READKEY() = 12 .OR READKEY() = 268
      RETURN
   ENDIF
   @ 14,20 GET WDESDE
   READ
   IF READKEY() = 12 .OR READKEY() = 268
      RETURN
   ENDIF
   @ 15,20 GET WHASTA
   READ
   IF READKEY() = 12 .OR READKEY() = 268
      RETURN
   ENDIF
   IF WDESDE = SPACE(20)
      STORE WWDESDE TO WDESDE
      STORE "PRIMERO                        " TO WMES1
      @ 14,20 SAY WMES1
   ENDIF
   IF WHASTA = SPACE(20)
      STORE WWHASTA TO WHASTA
      STORE "ULTIMO                         " TO WMES2
      @ 15,20 SAY WMES2
   ENDIF
   IF WHASTA < WDESDE
      STORE "VERIFIQUE INTERVALO. (Ù)" TO MES
      DO AVISO WITH MES
      LOOP
   ENDIF
   store 1 to wsalida
   @ 20,18 get wsalida picture "#" range 1,2
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
      STORE 18 TO WSALTO
      @ 0,0 CLEAR
   ELSE
      SET DEVI TO PRINT
      STORE 50 TO WSALTO
   ENDIF

   if word=1
      set order to almart3
   else
      set order to almart
   endif
   go top

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
         @ 0,0   SAY CHR(18)
         @ 1,0   SAY QQWW
         @ 1,60  SAY "FECHA :"+DTOC(DATE())
         @ 2,0   SAY  "LISTADO DE ARTICULOS"
         @ 2,60  SAY "PAGINA:"+STR(PAGINA,2)
         if wsalida=1
            @ 04,00 SAY "CODIGO"
            @ 04,21 SAY "DESCRIPCION"
            @ 04,62 SAY "LIN."
            @ 04,70 SAY "EXISTENCIA"
            @ 5,0   SAY REPLICATE("-",80)
         else
            @ 04,000 say chr(15)
            @ 04,000 SAY "CODIGO"
            @ 04,021 SAY "DESCRIPCION"
            @ 04,062 SAY "LIN."
            @ 04,070 SAY "EXISTENCIA"
            @ 04,085 SAY "ULT. COSTO"
            @ 04,100 SAY "    PRECIO"
            @ 5,0   SAY REPLICATE("-",115)
         endif
         STORE 6 TO LINE
      ENDIF
      @ LINE,00 SAY CODIGO
      @ LINE,21 SAY DESCRI
      @ LINE,62 SAY LINEA
      @ LINE,69 SAY STR(UNIEXI,11,2)
      IF WSALIDA=2
         IF ULTCANTI>0
            @ LINE,85 SAY STR(ULTCOSTO/ULTCANTI,11,2)
         ENDIF
         @ LINE,100 SAY STR(PRECIOA,11,2)
      ENDIF
      IF DESCRI2 <> SPACE(40)
         STORE LINE+1 TO LINE
         @ LINE,21 SAY DESCRI2
      ENDIF
      IF DESCRI3 <> SPACE(40)
         STORE LINE+1 TO LINE
         @ LINE,21 SAY DESCRI3
      ENDIF
      IF DESCRI4 <> SPACE(40)
         STORE LINE+1 TO LINE
         @ LINE,21 SAY DESCRI4
      ENDIF
      STORE LINE + 1 TO LINE
      if wsalida=1
         @ LINE,0 SAY REPLICATE("-",80)
      else
         @ LINE,0 SAY REPLICATE("-",115)
      endif
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
set order to almart
RETURN
