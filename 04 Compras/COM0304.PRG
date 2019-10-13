*** ESTADO DE ORDENES DE COMPRA
SELECT COMDCGE
STORE .T. TO R0201
DO WHILE R0201
   GO TOP
   STORE 0 TO WMONTO
   @ 04,00 CLEAR
   @ 04,20 SAY "LISTADO DE ESTADO DE ORDENES DE COMPRA"
   @ 05,00 TO 22,79
   @ 06,5 SAY    "EDO. DE ORDEN:"
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
   STORE "ESTADOS: Todas=0, Recibidas=1, Pendientes=2, <ESC>=Salir" TO MES
   DO MENSAJE WITH MES
   STORE 0 TO WEDODOC
   @ 06,20 GET WEDODOC PICT "9" RANGE 0,2
   READ
   STORE SPACE(10) TO WDESDOC
   DO CASE
      CASE WEDODOC=0
         STORE "Todas"      TO WDESDOC
      CASE WEDODOC=1
         STORE "Recibidas"  TO WDESDOC
      CASE WEDODOC=2
         STORE "Pendientes" TO WDESDOC
   ENDCASE
   @ 06,35 SAY WDESDOC
   IF LASTKEY()=27
      RETURN
   ENDIF
    
   STORE SPACE(10) TO WREFER
   STORE "CODIGO DE DOCUMENTO REFERENCIAL" TO MES
   DO MENSAJE WITH MES
   @ 07,20 GET WREFER 
   READ
   IF WREFER=SPACE(10)
      @ 07,35 SAY "Todas"
   ENDIF
      
   DO WHILE .T.
      STORE "CODIGO DEL PROVEEDOR DESEADO, <ENTER>=Todos" to mes
      DO MENSAJE WITH MES
      STORE SPACE(12) TO WPROVE
      @ 08,20 GET WPROVE
      READ
      IF WPROVE=SPACE(12)
         @ 08,35 SAY "Todos"
      ENDIF
      IF WPROVE<>SPACE(12)
         SELECT BCBENEFI
         SEEK WPROVE
         IF FOUND()
            @ 08,35 SAY DESCRI
            EXIT
         ELSE
            STORE "PROVEEDOR NO REGISTRADO" TO MES
            DO AVISO WITH MES
            LOOP
         ENDIF     
      ELSE
         @ 08,35 SAY "Todos"
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
   STORE "TIPOS DE BENEFICIARIO: Todos=0, Clinica=1, Afiliados=2" TO MES
   DO MENSAJE WITH MES
   @ 11,20 GET WBENEFI PICT "9" RANGE 0,2
   READ
   STORE SPACE(9) TO WBEN
   DO CASE
      CASE WBENEFI=0
           STORE SPACE(1)    TO WBENEFI
           STORE "Todos"     TO WBEN
      CASE WBENEFI=1
           STORE "C"         TO WBENEFI
           STORE "Clinica"   TO WBEN
      CASE WBENEFI=2
           STORE "A"         TO WBENEFI
           STORE "Afiliados" TO WBEN
   ENDCASE
   @ 11,35 SAY WBEN
   
   @ 16,16 GET WSALIDA PICT "#" RANGE 1,2
   READ
   IF WSALIDA = 1
      STORE "Monitor" TO WSAL
      STORE 22 TO WSALTO
   ELSE
      STORE "Impresora" TO WSAL
      STORE 60 TO WSALTO
   ENDIF
   @ 16,35 SAY WSAL

   SAVE SCRE TO INF1
   STORE "CONTINUAR ? (S/N)" TO TEX
   STORE "SN" TO WCH
   DO PREGUNTA
   IF WCH = "N"
      RETURN
   ENDIF

   STORE 0 TO PAGINA
   STORE 100 TO LINE
   STORE SPACE(9) TO WSAL
   IF WSALIDA = 1
      @ 0,0 CLEAR
   ELSE
      SET DEVI TO PRINT
   ENDIF
   @ 16,35 SAY WSAL
   SELECT COMDCGE
   SEEK "ORD"
   IF .NOT.FOUND()
      STORE "NO HAY ORDENES EN ARCHIVO" TO MES
      DO AVISO WITH MES
      LOOP
   ENDIF
   SELECT COMDCGE
   DO WHILE .NOT. EOF() .AND.SUBSTR(NUMERO,1,3)="ORD"

      *** FILTRO DE ESTADO DE ORDENES 
      IF WEDODOC<>0
         IF WEDODOC=1.AND.RECIBIDA<>"S"
            SKIP
            LOOP
         ENDIF
         IF WEDODOC=2.AND.RECIBIDA<>SPACE(1)
            SKIP
            LOOP
         ENDIF
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
         @ 2,0   SAY "ESTADO DE ORDENES DE COMPRA"
         @ 2,60  SAY "PAGINA:"+STR(PAGINA,2)
         @ 4,0   SAY "EDO.:"+WDESDOC
         IF WREFER=SPACE(10)
            @ 4,18 SAY "REFER: Todos"
         ELSE
            @ 4,18 SAY "REFER: "+WREFER
         ENDIF
         IF WPROVE=SPACE(12)
            @ 4,36 SAY "PROV: Todos"
         ELSE
            @ 4,36 SAY "PROV: "+WPROVE
         ENDIF
         IF WBENEFI=SPACE(14)
            @ 4,56SAY "BENEF: Todos"
         ELSE
            @ 4,56 SAY "BENEF: "+WBEN
         ENDIF
         @ 05,0  SAY "DESDE: "+DTOC(WDESDE)
         @ 05,18 SAY "HASTA: "+DTOC(WHASTA)

         @ 07,0  SAY "RC."
         @ 07,4  SAY "NUMERO "
         @ 07,13 SAY "REFERENCIA"
         @ 07,24 SAY "PROVEEDOR   "
         @ 07,37 SAY "ELABORADO "
         @ 07,48 SAY "BENEFICIARIO  "
         @ 07,66 SAY "         MONTO"
         
         @ 8,0   SAY REPLICATE("-",80)
         STORE 9 TO LINE
      ENDIF
      IF RECIBIDA="S"
         @ LINE,0  SAY "SI"
      ELSE
         @ LINE,0  SAY "NO"
      ENDIF
      @ LINE,4  SAY SUBSTR(NUMERO,4,7)
      @ LINE,13 SAY REFERENCIA
      @ LINE,24 SAY PROVEEDOR
      @ LINE,37 SAY ELABORADO
      IF TIPBENEFI="C"
         @ LINE,48  SAY "CLINICA"
      ELSE
         @ LINE,48  SAY BENEFI
      ENDIF
      @ LINE,66 SAY MONTO PICT "999,999,999.99"
      WMONTO=WMONTO+MONTO
      SKIP
   ENDDO
   *** COLOCAR TOTALES
   *******************
   IF WMONTO > 0
      STORE LINE+2 TO LINE
      @ LINE,63 SAY "============"
      @ LINE,51 SAY "MONTO TOTAL:"
      @ LINE,66 SAY WMONTO PICT "999,999,999.99"
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