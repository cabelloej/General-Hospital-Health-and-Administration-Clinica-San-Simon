STORE .T. TO R0201
DO WHILE R0201
   STORE 0 TO WMONTO
   SELECT COMDCGE
   GO TOP
   @ 04,00 CLEAR
   @ 04,26 SAY "LISTADO RESUMIDO DE DOCUMENTOS"
   @ 05,00 TO 22,79
   @ 06,5 SAY    "TIPO DE DCTO.:"
   @ 07,5 SAY    "REFERENCIA   :"
   @ 08,5 SAY    "PROVEEDOR    :"
   @ 09,5 SAY    "DESDE        :"
   @ 10,5 SAY    "HASTA        :"
   @ 11,5 SAY    "BENEFICIARIO :"
      
   @ 13,5 SAY    "* SALIDA *"
   @ 14,5 say    "MONITOR ...1"
   @ 15,5 say    "IMPRESORA..2"
   @ 16,5 say    "          [ ]"
   store 1 to wsalida
   STORE "TIPOS: Todos=0, Sol.=1, Ord.=2, Rec=3, Dev=4, <ESC>=Salir" TO MES
   DO MENSAJE WITH MES
   STORE 0 TO WTIPDOC
   @ 06,20 GET WTIPDOC PICT "9" RANGE 0,4
   READ
   IF LASTKEY()=27
      RETURN
   ENDIF
   DO CASE
      CASE WTIPDOC=0
         STORE "Todos    "  TO WDESDOC
         STORE "   "        TO WTIPDOC
      CASE WTIPDOC=1
         STORE "SOLICITUD"  TO WDESDOC
         STORE "SOL"        TO WTIPDOC
      CASE WTIPDOC=2
         STORE "ORDEN"      TO WDESDOC
         STORE "ORD"        TO WTIPDOC
      CASE WTIPDOC=3
         STORE "RECEPCION"  TO WDESDOC
         STORE "REC"        TO WTIPDOC
      CASE WTIPDOC=4
         STORE "DEVOLUCION" TO WDESDOC
         STORE "DEV"        TO WTIPDOC
   ENDCASE
   @ 06,40 SAY WDESDOC
    
   STORE SPACE(10) TO WREFER
   STORE "CODIGO DE DOCUMENTO REFERENCIAL" TO MES
   DO MENSAJE WITH MES
   @ 07,20 GET WREFER 
   READ
   IF WREFER=SPACE(10)
      @ 07,40 SAY "Todos"
   ENDIF
   DO WHILE .T.
      STORE "CODIGO DEL PROVEEDOR DESEADO, <ENTER>=Todos" to mes
      DO MENSAJE WITH MES
      STORE SPACE(12) TO WPROVE
      @ 08,20 GET WPROVE
      READ
      IF WPROVE<>SPACE(12)
         SELECT BCBENEFI
         SEEK WPROVE
         IF FOUND()
            @ 08,40 SAY DESCRI
            EXIT
         ELSE
            STORE "PROVEEDOR NO REGISTRADO" TO MES
            DO AVISO WITH MES
            LOOP
         ENDIF     
      ELSE
         @ 08,40 SAY "Todos"
         EXIT
      ENDIF
   ENDDO

   STORE DATE() TO WDESDE
   STORE DATE() TO WHASTA
   DO WHILE .T.
      STORE "RANGO DE FECHAS DE ELABORACION DE DOCUMENTOS" TO MES
      DO MENSAJE WITH MES
      @ 09,20 GET WDESDE
      @ 10,20 GET WHASTA
      READ
      IF WHASTA<WDESDE
         STORE "ERROR EN RANGO DE FECHAS, VERIFIQUE" TO MES
         DO AVISO WITH MES
         LOOP
      ELSE
         EXIT
      ENDIF   
   ENDDO
   
   STORE 0 TO WBENEFI
   STORE SPACE(9) TO WBEN
   STORE "TIPOS DE BENEFICIARIO: Todos=0, Clinica=1, Afiliados=2" TO MES
   DO MENSAJE WITH MES
   @ 11,20 GET WBENEFI PICT "9" RANGE 0,2
   READ
   DO CASE
      CASE WBENEFI=0
           STORE SPACE(1)   TO WBENEFI
           STORE "Todos"    TO WBEN
      CASE WBENEFI=1
           STORE "C"        TO WBENEFI
           STORE "Clinica"  TO WBEN
      CASE WBENEFI=2
           STORE "A"        TO WBENEFI
           STORE "Afiliado" TO WBEN
   ENDCASE
   @ 11,40 SAY WBEN

   @ 16,16 GET WSALIDA PICT "#" RANGE 1,2
   READ
   IF WSALIDA = 1
      STORE "Monitor"   to wsal
      STORE 22 TO WSALTO
   ELSE
      SET DEVI TO PRINT
      STORE "Impresora" to wsal
      STORE 60 TO WSALTO
   ENDIF
   @ 16,40 say wsal

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
      @ 0,0 CLEAR
   ELSE
      SET DEVI TO PRINT
   ENDIF

   IF WTIPDOC=SPACE(3)
      GO TOP
   ELSE
      SEEK WTIPDOC
      IF .NOT.FOUND()
         STORE "NO HAY DOCUMENTOS DE ESTE TIPO EN ARCHIVO" TO MES
         DO AVISO WITH MES
         LOOP
      ENDIF
   ENDIF
   SELECT COMDCGE
   DO WHILE .NOT. EOF() 
      *** FILTRO TIPO DE DOCUMENTO
      IF WTIPDOC<>SPACE(3).AND.SUBSTR(NUMERO,1,3)<>WTIPDOC
         EXIT
      ENDIF
      *** FILTRO REFERENCIA
      IF WREFER<>SPACE(10).AND.REFERENCIA<>WREFER
         SKIP
         LOOP
      ENDIF    
      *** FILTRO PROVEEDOR
      IF WPROVE<>SPACE(12).AND.PROVEEDOR<>WPROVE
         SKIP
         LOOP
      ENDIF    
      *** FILTRO DE FECHAS
      IF ELABORADO>=WDESDE.AND.ELABORADO<=WHASTA
         *** NO PROBLEM     
      ELSE
         SKIP
         LOOP
      ENDIF
      *** FILTRO BENEFICIARIO
      IF WBENEFI<>SPACE(1).AND.TIPBENEFI<>WBENEFI
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
         @ 2,0   SAY "LISTADO RESUMIDO DE DOCUMENTOS"
         @ 2,60  SAY "PAGINA:"+STR(PAGINA,2)
         @ 4,0   SAY "DCTO:"+WDESDOC
         IF WREFER=SPACE(10)
            @ 4,18 SAY "REFER: Todos"
         ELSE
            @ 4,18  SAY "REFER: "+WREFER
         ENDIF
         IF WPROVE=SPACE(12)
            @ 4,36 SAY "PROV: Todos"
         ELSE
            @ 4,36  SAY "PROV: "+WPROVE
         ENDIF
         IF WBENEFI=SPACE(14)
            @ 4,56 SAY "BENEF: Todos"
         ELSE
            @ 4,56  SAY "BENEF: "+WBEN
         ENDIF
         @ 5,00  SAY "DESDE: "+DTOC(WDESDE)
         @ 5,18  SAY "HASTA: "+DTOC(WHASTA)
         
         @ 07,0  SAY "DOC"
         @ 07,4  SAY "NUMERO "
         @ 07,12 SAY "REFERENCIA"
         @ 07,24 SAY "PROVEEDOR   "
         @ 07,37 SAY "ELABORADO "
         @ 07,48 SAY "BENEFICIARIO  "
         @ 07,63 SAY "         MONTO"
         
         @ 8,0   SAY REPLICATE("-",80)
         STORE 9 TO LINE
      ENDIF
      @ LINE,0  SAY SUBSTR(NUMERO,1,3)+"."
      @ LINE,4  SAY SUBSTR(NUMERO,4,7)
      @ LINE,12 SAY SUBSTR(REFERENCIA,1,3)+"."+SUBSTR(REFERENCIA,4,7)
      @ LINE,24 SAY PROVEEDOR
      @ LINE,37 SAY ELABORADO
      IF TIPBENEFI="C"
         @ LINE,48  SAY "CLINICA"
      ELSE
         @ LINE,48  SAY BENEFI
      ENDIF
      @ LINE,63 SAY MONTO PICT "999,999,999.99"
      WMONTO=WMONTO+MONTO
      SKIP
   ENDDO

   *** COLOCAR TOTALES
   *******************
   IF WMONTO > 0
      STORE LINE+1 TO LINE
      @ LINE,63 SAY "============"
      STORE LINE+1 TO LINEA
      @ LINE,51 SAY "MONTO TOTAL:"
      @ LINE,63 SAY WMONTO PICTURE "999,999,999.99"
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