STORE .T. TO R0205
DO WHILE R0205
   SELECT ALMART
   GO TOP
   @ 04,0 CLEAR
   @ 04,30 SAY "MOVIMIENTOS DE ARTICULOS"
   @ 05,1 TO 5,78
   STORE SPACE(3)         TO WLIN
   STORE SPACE(20)        TO WWDESDE
   STORE SPACE(20)        TO WDESDE
   STORE CTOD("  -  -  ") TO WFECHA1
   STORE CTOD("  -  -  ") TO WFECHA2
   STORE CTOD("01-01-80") TO WWFEC1
   STORE CTOD("31-12-99") TO WWFEC2
   STORE SPACE(2)         TO WOPE
   STORE SPACE(10)        TO WDOC
   STORE SPACE(3)         TO WORI
   STORE SPACE(15)        TO WPROCLI

   STORE REPLICATE("Z",20) TO WWHASTA
   STORE SPACE(20) TO WHASTA
   @ 06,5 SAY    "LINEA DE VTA.:"
   @ 08,5 SAY    "**INTERVALO**"
   @ 09,5 SAY    "DESDE CODIGO :"
   @ 10,5 SAY    "HASTA CODIGO :"

   @ 12,5 SAY    "*CRITERIO*"
   @ 13,5 SAY    "DESDE FECHA:"
   @ 14,5 SAY    "HASTA FECHA:"
   @ 15,5 SAY    "OPERACION  :"
   @ 16,5 SAY    "DOCUMENTO  :"
   @ 17,5 SAY    "ORIGEN     :"
   @ 18,5 SAY    "PROV/CLTE. :"

   @ 08,50 SAY    "* SALIDA *"
   @ 09,50 say    "MONITOR ...1"
   @ 10,50 say    "IMPRESORA..2"
   @ 11,50 say    "          [ ]"
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
   @ 23,0
   @ 10,20 GET WHASTA
   READ
   IF READKEY() = 12 .OR READKEY() = 268
      RETURN
   ENDIF
   IF WDESDE = SPACE(20)
      STORE WWDESDE TO WDESDE
      STORE "PRIMERO                   " TO WMES1
      @ 09,20 SAY WMES1
   ENDIF
   IF WHASTA = SPACE(20)
      STORE WWHASTA TO WHASTA
      STORE "ULTIMO                    " TO WMES2
      @ 10,20 SAY WMES2
   ENDIF
   IF WHASTA < WDESDE
      STORE "VERIFIQUE EL INTERVALO (Ù)" TO MES
      DO AVISO WITH MES
      LOOP
   ENDIF

   @ 13,20 GET WFECHA1
   @ 14,20 GET WFECHA2
   READ
   IF WFECHA1= CTOD("  -  -  ")
      STORE WWFEC1  TO WFECHA1
      STORE "PRIMERA         " TO WMES1
      @ 13,20 SAY WMES1
   ENDIF
   IF WFECHA2= CTOD("  -  -  ")
      STORE WWFEC2  TO WFECHA2
      STORE "ULTIMA          " TO WMES2
      @ 14,20 SAY WMES2
   ENDIF
   IF WFECHA2< WFECHA1
      STORE "VERIFIQUE CRITERIO DE FECHAS (Ù)" TO MES
      DO AVISO WITH MES
      LOOP
   ENDIF

   STORE .T. TO VEROP
   DO WHILE VEROP
      @ 15,20 GET WOPE
      READ
      IF WOPE=SPACE(2) .OR. WOPE="EN" .OR. WOPE="SA" .OR.;
         WOPE="AE" .OR. WOPE="AS" .OR. WOPE="AC" .OR. WOPE = "DE" .OR. WOPE = "DS"
         STORE .F. TO VEROP
      ELSE
         STORE SPACE(2) TO WOPE
         STORE "EN=ENTR, SA=SAL, AE=AJ.ENT, AS=AJ.SAL, AC=AJ.COS, DE=DEV.ENT, DS=DEV.SA" TO MES
         DO AVISO WITH MES
      ENDIF
   ENDDO

   @ 16,20 GET WDOC
   READ
   STORE .T. TO VEROP
   DO WHILE VEROP
      @ 17,20 GET WORI
      READ
      IF WORI=SPACE(3) .OR. WORI = "COM" .OR. WORI = "VTA" .OR. WORI="INV"
         STORE .F. TO VEROP
      ELSE
         STORE SPACE(3) TO WORI
         STORE "COM=COMPRAS, VTA=VENTAS, INV=INVENTARIO" TO MES
         DO AVISO WITH MES
      ENDIF
   ENDDO

   @ 18,20 GET WPROCLI
   READ

   @ 11,61 get wsalida picture "#" range 1,2
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
   STORE 0 TO FLAGSAL
   SELECT ALMTRA
   LOCATE FOR CODIGO >= WDESDE
   DO WHILE .NOT. EOF()
      IF CODIGO > WHASTA
         EXIT
      ENDIF
      IF FECHA >= WFECHA1 .AND. FECHA <= WFECHA2
         *** REGISTRO APROBADO
      ELSE
         SKIP
         LOOP
      ENDIF
      IF WOPE <> SPACE(2) .AND. WOPE <> OPERACION
        SKIP
        LOOP
      ENDIF
      IF WDOC <> SPACE(10) .AND. WDOC <> REFERENCIA
        SKIP
        LOOP
      ENDIF
      IF WORI <> SPACE(3) .AND. WORI <> ORIGEN
        SKIP
        LOOP
      ENDIF
      IF WPROCLI <> SPACE(15) .AND. WPROCLI <> PROCLI
        SKIP
        LOOP
      ENDIF
      IF WLIN <> SPACE(3)
         STORE CODIGO TO WCOD
         SELECT ALMART
         FIND &WCOD
         IF EOF()
            STORE "XXX"  TO WARTLIN
         ELSE
            STORE LINEA TO WARTLIN
         ENDIF
         SELECT ALMTRA
         IF WLIN <> WARTLIN
            SKIP
            LOOP
         ENDIF
      ENDIF

      STORE LINE+1 TO LINE
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
         @ 1,0   SAY QQWW
         @ 1,60  SAY "FECHA :"+DTOC(DATE())
         @ 2,0   SAY  "TRANSACCIONES"
         @ 2,60  SAY "PAGINA:"+STR(PAGINA,2)
         @ 04,0 SAY "+--------------------+--------+--+----------+---+-------+----------+-----------+"
         @ 05,0 SAY "|CODIGO              | FECHA  |OP| REFERENC.|ORI|PRO/CLI| UNIDADES |COSTO TOTAL|"
         @ 06,0 SAY "+--------------------+--------+--+----------+---+-------+----------+-----------+"
         STORE 7 TO LINE
      ENDIF
      @ LINE,1 SAY CODIGO
      @ LINE,22 SAY DTOC(FECHA)
      @ LINE,31 SAY OPERACION
      @ LINE,34 SAY REFERENCIA
      @ LINE,45 SAY ORIGEN
      @ LINE,50 SAY PROCLI
      @ LINE,57 SAY STR(UNIDADES,10,2)
      @ LINE,68 SAY STR(COSTO,11,2)
      SKIP
   ENDDO
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
RETURN

