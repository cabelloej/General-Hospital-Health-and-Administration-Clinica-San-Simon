STORE .T.     TO pres
DO WHILE pres
   @ 0,0 CLEAR
   STORE "ACTUALIZAR "+wdocdes1 TO wheader
   @ 00,40 - (LEN(wheader)/2) SAY wheader                                
   @ 00,58 SAY "ELABORADO :"
   @ 01,0 SAY "+-----------------+------------------------------------------------------------+"
   @ 02,0 SAY "|NUMERO  :        |PROV.   :                               REF.PROV.:          |"
   @ 03,0 SAY "+-----------------+------------------------------------------------------------+"
   @ 04,0 SAY "|BENEFIC.:        |NOMBRE  :                                  VENCE :          |"
   @ 05,0 SAY "+-----+-+---------+----------------+---------+-------------+-------------------+"
   @ 06,0 SAY "|RENG.|T|CODIGO DEL BIEN/SERVICIO  | CANTIDAD|       PRECIO|              TOTAL|"
   @ 07,0 SAY "+-----+-+--------------------------+---------+-------------+-------------------+"
   @ 08,0 SAY "|     | |                          |         |             |                   |"
   @ 09,0 SAY "|     | |                          |         |             |                   |"
   @ 10,0 SAY "|     | |                          |         |             |                   |"
   @ 11,0 SAY "|     | |                          |         |             |                   |"
   @ 12,0 SAY "|     | |                          |         |             |                   |"
   @ 13,0 SAY "|     | |                          |         |             |                   |"
   @ 14,0 SAY "|     | |                          |         |             |                   |"
   @ 15,0 SAY "|     | |                          |         |             |                   |"
   @ 16,0 SAY "|     | |                          |         |             |                   |"
   @ 17,0 SAY "+-----+-+--------------------------+---------+-------------+-------------------+"
   @ 18,0 SAY "|     | |                          |         |             |                   |"
   @ 19,0 SAY "+-----+-+--------------------------+---------+-------------+-------------------+"
   @ 20,0 SAY "                                              PORC.IMPUESTO:                    "
   @ 21,0 SAY "                                                  IMPUESTOS:                    "
   @ 22,0 SAY "                                               TOTAL DOCTO.:                    "

   STORE "NUMERO DEL "+wdocdes1+" A PROCESAR. <ESC> PARA SALIR" TO mes
   DO mensaje WITH mes
   @ 2,10 GET wnumnum PICTURE "9999999"
   READ
   IF wnumnum = 0 .OR. READKEY()=12.OR.READKEY()=268
      EXIT
   ENDIF
   STORE LTRIM(STR(WNUMNUM,7))                 TO WNUMERO
   STORE REPLICATE("0",7-LEN(WNUMERO))+WNUMERO TO WNUMERO
   @ 2,10 SAY WNUMERO
   SELECT COMDCGE
   STORE WTIPODOC+WNUMERO TO WNUMERO2
   FIND &WNUMERO2
   IF EOF()
      STORE wdocdes1+" NO EXISTE, INGRESAR? (S/N)" TO tex
      STORE "SN" TO wch
      DO pregunta
      IF wch = "N"
         LOOP
      ENDIF
      STORE .T.              TO WFLAGACIN
      STORE .T.              TO WFLAGING
      STORE .T.              TO WFLAGACT
      STORE .F.              TO WFLAGGEN
      STORE SPACE(7)         TO WREFERENCIA
      STORE SPACE(12)        TO WPROVEEDOR
      STORE DATE()           TO WELABORADO
      *STORE 0                TO WMONTO
      STORE SPACE(1)         TO WTIPBENEFI
      STORE SPACE(14)        TO WBENEFICIA
      STORE SPACE(10)        TO WREFERPROVE
      STORE 0                TO WPORIMP
      STORE CTOD("  -  -  ") TO WVENCE
      ***
   ELSE
      IF ALMACEN <> WEJCINV
         STORE "DOCUMENTO PERTENECE A OTRO ALMACEN, SELECCIONE AL ENTRAR AL MODULO" TO MES
         DO AVISO WITH MES
         LOOP
      ENDIF
      STORE .F.              TO WFLAGING
      STORE .F.              TO WFLAGACT
      STORE .F.              TO WFLAGGEN
      STORE .F.              TO WFLAGACIN
      STORE REFERENCIA       TO WREFERENCIA
      STORE PROVEEDOR        TO WPROVEEDOR
      STORE ELABORADO        TO WELABORADO
      *STORE MONTO            TO WMONTO
      STORE TIPBENEFI        TO WTIPBENEFI
      STORE BENEFI           TO WBENEFICIA
      STORE REFERPROVE       TO WREFERPROVE
      STORE PORIMP           TO WPORIMP
      STORE VENCE            TO WVENCE
   ENDIF
   IF .NOT. WFLAGING
      @ 2,29 SAY WPROVEEDOR
      @ 0,69 SAY WELABORADO
      @ 2,69 SAY WREFERPROVE
      @ 4,69 SAY WVENCE
      @ 4,10 SAY WTIPBENEFI
      @ 4,29 SAY WBENEFICIA
      STORE "OPCIONES : (C)ONTINUAR, (A)BANDONAR" TO TEX
      STORE "CA" TO WCH
      DO PREGUNTA
      IF WCH="A"
         LOOP
      ELSE
         STORE .T. TO WFLAGACT
      ENDIF
   ENDIF
   IF WFLAGACT
      IF WFLAGING
         STORE SPACE(10) TO WCLAVEREF
         DO COMGENDC
         IF WFLAGGEN
            STORE .F. TO WFLAGING
         ENDIF
      ENDIF
      IF (WTIPODOC="REC".OR.WTIPODOC="DEV").AND.COMDCGE->REFERENCIA=SPACE(10)
         STORE "DOCUMENTO NO PROCEDE SIN REFERENCIA" TO MES
         LOOP
      ENDIF

      *** PROVEEDORES
      IF (WTIPODOC="COT") .OR.;
         ((WTIPODOC="ORD".OR.WTIPODOC="REC").AND.COMDCGE->REFERENCIA=SPACE(10))
         STORE .T. TO VIENDOPRO
         DO WHILE VIENDOPRO
            STORE "OPRIMA <ENTER> PARA CONSULTAR PROVEEDORES" TO MES
            DO MENSAJE WITH MES
            @ 2,29 GET WPROVEEDOR
            READ
            IF LASTKEY()=27
               STORE .F. TO VIENDOPRO
               EXIT
            ENDIF
            SELECT COMPRO
            IF WPROVEEDOR = SPACE(12)
               SAVE SCRE TO s99
               GO TOP
               DO COMWINPR
               STORE CODIGO TO WPROVEEDOR
               RESTORE SCRE FROM s99
               LOOP
            ELSE
               SET ORDER TO BCBENEF1
               FIND &WPROVEEDOR
               IF EOF()
                  STORE "CODIGO NO REGISTRADO" TO mes
                  DO aviso WITH mes
                  LOOP
               ELSE
                  STORE CODIGO TO WPROVEEDOR
                  STORE DESCRI TO WPROVEDES
                  EXIT
               ENDIF
            ENDIF
         ENDDO
         IF .NOT. VIENDOPRO
            LOOP
         ENDIF
      ELSE
         SELECT COMPRO
         SEEK COMDCGE->PROVEEDOR
         IF EOF()
            STORE COMDCGE->PROVEEDOR        TO WPROVEEDOR
            STORE "PROVEEDOR NO REGISTRADO" TO WPROVEDES
         ELSE
            STORE CODIGO TO WPROVEEDOR
            STORE DESCRI TO WPROVEDES
         ENDIF
      ENDIF
      @ 2,29 SAY WPROVEDES
 
      ***  FECHA DE ELABORACION
      @ 0,69 GET WELABORADO
      READ
      IF LASTKEY()=27
         LOOP
      ENDIF

      *** REFERENCIA DEL PROVEEDOR
      IF WTIPODOC="REC"
         @ 2,69 GET WREFERPROVE
         @ 4,69 GET WVENCE
         IF LASTKEY()=27
            LOOP
         ENDIF
         READ
      ENDIF

      *** BENEFICIARIO
      IF (WTIPODOC="ORD".AND.COMDCGE->REFERENCIA=SPACE(10)).OR.;
         (WTIPODOC="REC".AND.COMDCGE->REFERENCIA=SPACE(10))
         STORE SPACE(8) TO WTIPBENDES

         *** AJUSTE CON MODULOS SEPARADOS
         IF WEJCINV<>SPACE(3)
            STORE "C" TO WTIPBENEFI
         ELSE
            STORE "A" TO WTIPBENEFI
         ENDIF
         @ 4,10 SAY WTIPBENEFI
         DO VALTIP
         
         *@ 4,10 GET WTIPBENEFI VALID VALTIP()
         *READ
         @ 4,10 SAY WTIPBENDES
         STORE SPACE(20)  TO WBENEFIDES
         STORE SPACE(20)  TO WNOMBRE
         STORE SPACE(14)  TO WCODPAC
         IF WTIPBENEFI="A"
            STORE SUBSTR(WBENEFICIA,1,10)      TO WCODPAC1
            STORE VAL(SUBSTR(WBENEFICIA,11,4)) TO WCODPAC2
            @ 04,29 GET WCODPAC1
            @ 04,39 SAY "-"
            @ 04,40 GET WCODPAC2 PICTURE "9999" VALID VALPAC()
            READ
            IF LASTKEY()=27
               LOOP
            ENDIF
            STORE WNOMBRE   TO WBENEFIDES
            STORE WCODPAC   TO WBENEFICIA
         ELSE
            STORE SPACE(30) TO WBENEFIDES
            STORE SPACE(30) TO WBENEFICIA
         ENDIF
         @ 04,29 SAY SPACE(30)
         @ 04,29 SAY SUBSTR(WBENEFIDES,1,30)
      ELSE
         IF WTIPBENEFI="A"
            @ 4,10 SAY "Afiliado"
         ELSE
            @ 4,10 SAY "Clinica"
         endif
         STORE SPACE(20)  TO WBENEFIDES
         STORE SPACE(20)  TO WNOMBRE
         STORE SPACE(14)  TO WCODPAC
         IF WTIPBENEFI="A"
            STORE SUBSTR(WBENEFICIA,1,10)      TO WCODPAC1
            STORE VAL(SUBSTR(WBENEFICIA,11,4)) TO WCODPAC2
            DO VALPAC
            STORE WNOMBRE   TO WBENEFIDES
            STORE WCODPAC   TO WBENEFICIA
         ELSE
            STORE SPACE(30) TO WBENEFIDES
            STORE SPACE(30) TO WBENEFICIA
         ENDIF
         @ 04,29 SAY SPACE(30)
         @ 04,29 SAY SUBSTR(WBENEFIDES,1,30)
      ENDIF

      STORE "CONFORME ? (S/N)" TO tex
      STORE "SN" TO wch
      DO PREGUNTA
      IF WCH = "N"
         LOOP
      ENDIF
      SELECT COMDCGE
      IF WFLAGING
         IF FILLOC()
            APPEND BLANK
            REPLACE NUMERO      WITH WNUMERO2
            IF SUBSTR(WCLAVEREF,4,7)<>SPACE(7)
               REPLACE REFERENCIA  WITH WCLAVEREF
            ELSE
               REPLACE REFERENCIA  WITH SPACE(10)
            ENDIF
            UNLOCK ALL
            FLUSH
         ELSE
            LOOP
         ENDIF
      ENDIF
      IF WFLAGACT
         IF RECLOC()
            REPLACE PROVEEDOR   WITH WPROVEEDOR
            REPLACE REFERPROVE  WITH WREFERPROVE
            REPLACE ELABORADO   WITH WELABORADO
            REPLACE VENCE       WITH WVENCE
            REPLACE TIPBENEFI   WITH WTIPBENEFI
            REPLACE BENEFI      WITH WBENEFICIA
            REPLACE ALMACEN     WITH WEJCINV

            REPLACE ORIGEN      WITH "COM"
            REPLACE DEPTO       WITH WUSERUBI
            REPLACE USUARIO     WITH WUSERCODE
            REPLACE USUARIOF    WITH DATE()
            UNLOCK ALL
            FLUSH
         ELSE
            LOOP
         ENDIF
      ENDIF
      STORE .T. TO WFLAGELA
   ELSE
      STORE .F. TO WFLAGELA
   ENDIF
   **************************************************************************
   SELECT COMDCGE
   STORE .T. TO actualiza
   DO WHILE actualiza
      STORE 100 TO wline
      STORE 0 TO pagina
      STORE 0 TO wmontodoc
      SELECT COMDCDE
      FIND &wnumero2
      DO WHILE .NOT. EOF() .AND. numero = wnumero2
         STORE wline + 1 TO wline
         IF wline >=17
            STORE 8 TO wcleaner
            STORE pagina + 1 TO pagina
            IF pagina > 1
               STORE "OPRIMA <ENTER> PARA CONTINUAR" TO mes
               DO aviso WITH mes
            ENDIF
            DO WHILE wcleaner <=16
               @ WCLEANER,0 SAY "|     | |                          |         |             |                   |"
               STORE wcleaner + 1 TO wcleaner
            ENDDO
            STORE 8 TO wline
         ENDIF
         @ wline,1  SAY renglon
         @ wline,7  SAY tipitem
         @ wline,9  SAY item
         @ wline,36 SAY cantidad  PICTURE "######.##"
         @ wline,48 SAY precio    PICTURE "########.##"
         STORE (cantidad*precio)  TO WTOTAL
         @ wline,68 SAY wtotal    PICTURE "########.##"
         STORE wmontodoc + wtotal TO wmontodoc
         SELECT COMDCDE
         SKIP
      ENDDO
      SELECT COMDCGE
      IF RECLOC()
         REPLACE SUBDOC WITH WMONTODOC
         UNLOCK ALL
         FLUSH
      ENDIF
      @ 20,0 SAY SPACE(35)
      @ 21,0 SAY SPACE(35)
      @ 22,0 SAY SPACE(35)
      
      STORE 0   TO wnumreng
      STORE "B" TO WTIPITEM
      STORE .T. TO veritem
      DO WHILE veritem
         STORE SPACE(20) TO witem
         SELECT COMDCDE
         @ 18,7  SAY SPACE(1)
         @ 18,9  SAY SPACE(20)
         @ 18,30 SAY SPACE(5)
         @ 18,36 SAY SPACE(9)
         @ 18,48 SAY SPACE(11)
         @ 18,60 SAY SPACE(5)
         @ 18,68 SAY SPACE(11)
         @ 18,68 SAY wmontodoc PICTURE "########.##"
         
         STORE "INGRESE EL CODIGO DE RENGLON A PROCESAR, OPRIMA <ESC> PARA SALIR" TO mes
         DO mensaje WITH mes
         @ 18,1 GET wnumreng PICTURE "99999"
         READ
         STORE ALLTRIM(STR(wnumreng,5))                TO WRENGLON
         STORE REPLICATE("0",5-LEN(WRENGLON))+WRENGLON TO WRENGLON
         @ 18,1 SAY wrenglon PICTURE "99999"
         IF LASTKEY() = 27
            IF WTIPODOC="ORD"
               @ 20,74 GET WPORIMP PICTURE "99.99"
               READ
            ENDIF
            STORE (WMONTODOC*WPORIMP)/100 TO WSUBIMP
            STORE WMONTODOC+WSUBIMP       TO WMONTO
            @ 21,65 SAY WSUBIMP PICTURE "999,999,999.99"
            @ 22,65 SAY WMONTO  PICTURE "999,999,999.99"
            SELECT COMDCGE
            IF RECLOC()
               REPLACE PORIMP   WITH WPORIMP
               REPLACE SUBIMP   WITH WSUBIMP
               REPLACE MONTO    WITH WMONTO
               UNLOCK ALL
            ENDIF
            IF wflagela
               SELECT COMDCGE
               SAVE SCRE TO ejc
               @ 15,00 CLEAR TO 21,41
               @ 15,00       TO 21,41
               @ 15,13 SAY " OBSERVACIONES "
               IF RECLOC()
                  @ 16,01 GET coment1
                  @ 17,01 GET coment2
                  @ 18,01 GET coment3
                  @ 19,01 GET coment4
                  @ 20,01 GET coment5
                  UNLOCK ALL
               ENDIF
               READ
               RESTORE SCRE FROM ejc
            ENDIF
            IF (WTIPODOC="REC".OR.WTIPODOC="DEV").AND.(WFLAGACIN).AND.WEJCINV<>SPACE(3)
               DO COMACTIN
            ENDIF
            IF (WTIPODOC="REC".OR.WTIPODOC="DEV").AND.(WFLAGACIN)
               DO COMACTCP
            ENDIF
            STORE .F. TO veritem
            STORE .F. TO actualiza
            LOOP
         ENDIF
         STORE wnumero2+wrenglon TO wclave
         SELECT COMDCDE
         FIND &wclave
         IF EOF()
            STORE "RENGLON NO REGISTRADO EN "+wdocdes1+", INGRESAR ? (S/N)" TO tex
            STORE "SN" TO wch
            DO pregunta
            IF wch = "N"
               *STORE .F. TO veritem
               LOOP
            ENDIF

            STORE .F. TO WFLAGTIP
            DO WHILE .T.
               STORE "TIPO DE RENGLON: B=Bienes, S=Servicios" TO MES
               DO MENSAJE WITH MES
               @ 18,7 GET WTIPITEM
               READ
               IF WFLAGCALL="C"
                  IF WTIPITEM="B".OR.WTIPITEM="S"
                     STORE .T. TO WFLAGTIP
                     EXIT
                  ENDIF
               ELSE
                  IF WTIPITEM="S"
                     STORE .T. TO WFLAGTIP
                     EXIT
                  ENDIF
               ENDIF
            ENDDO
            IF .NOT.WFLAGTIP
               LOOP
            ENDIF

            STORE "CODIGO A PROCESAR. <ENTER>=Ver art/serv, <ESC>=Salir" TO mes
            DO mensaje WITH mes
            @ 18,9 GET witem
            READ
            IF READKEY() = 12 .OR. READKEY() = 268
               STORE .F. TO veritem
               STORE .F. TO actualiza
               LOOP
            ENDIF
            IF WITEM = SPACE(20).AND. WTIPITEM="B"
               SELECT ALMART
               STORE WEJCINV+"ART2" TO WNEWORDER
               SET ORDER TO &WNEWORDER
               GO TOP
               SAVE SCRE TO s99
               STORE 5 TO LIBRVAC
               STORE 5 TO CIBRVAC
               DO MEDCONVA
               STORE CODIGO TO WITEM
               SELECT ALMART
               STORE WEJCINV+"ART" TO WNEWORDER
               SET ORDER TO &WNEWORDER
               SELECT COMDCDE
               RESTORE SCRE FROM s99
            ENDIF
            IF witem = SPACE(20) .AND. WTIPITEM="S"
               SELECT SYSSERVI
               GO TOP
               SAVE SCRE TO s99
               STORE 5 TO LIBRSER
               STORE 2 TO CIBRSER
               DO COMWINSE
               STORE SERVICIO TO WITEM
               SELECT COMDCDE
               RESTORE SCRE FROM s99
            ENDIF

            IF WTIPITEM="B"
               SELECT ALMART
               FIND &witem
               IF EOF()
                  STORE "CODIGO NO REGISTRADO EN ARTICULOS, VERIFIQUE" TO mes
                  DO aviso WITH mes
                  LOOP
               ENDIF
               STORE descri         TO wdescri
               *STORE unimed        TO wunimed
               STORE PRESUND        TO wunimed
               STORE uniexi/PRESCAP TO wuniexi
               IF ULTCANTI>0
                  STORE (ULTCOSTO/(ULTCANTI/PRESCAP)) TO WPRECIO
               ELSE
                  STORE 0                             TO WPRECIO
               ENDIF
            ELSE
               SELECT SYSSERVI
               STORE SUBSTR(witem,1,12) TO WITEM
               FIND &witem
               IF EOF()
                  STORE "CODIGO NO REGISTRADO EN SERVICIOS, VERIFIQUE" TO mes
                  DO aviso WITH mes
                  LOOP
               ENDIF
               STORE descri TO wdescri
               STORE UNIDAD TO wunimed
               STORE 0      TO wuniexi
               STORE COSTO  TO WPRECIO
            ENDIF
            @ 20,1 SAY "DESCRIPCION :"+SUBSTR(wdescri,1,35)
            @ 21,1 SAY "UNID./ MED. :"+wunimed
            @ 22,1 SAY "ULTIMO COSTO:"+STR(wprecio,12,2)

            STORE 0        TO wcantidad
            STORE SPACE(5) TO wlote
            STORE .T.      TO wflagcant
            DO WHILE wflagcant
               @ 18,36 GET wcantidad PICTURE "######.##"
               READ
               IF wcantidad > 0
                  STORE .F. TO wflagcant
               ENDIF
               IF WTIPITEM="B".AND. (WCANTIDAD*ALMART->PRESCAP)+WUNIEXI > ALMART->MAXIMO .AND. WTIPODOC <> "DEV"
                  STORE "ADVERTENCIA: MAXIMO EXCEDIDO,<ENTER>" TO mes
                  DO aviso WITH mes
                  LOOP
               ENDIF
            ENDDO

            IF WTIPODOC="ORD"
               @ 18,48 GET wprecio   PICTURE "########.##"
               READ
            ELSE
               @ 18,48 SAY wprecio   PICTURE "########.##"
            ENDIF
            STORE (wcantidad*wprecio) TO WTOTAL
            @ 18,68 SAY wtotal PICTURE "########.##"

            STORE "CONFORME ? (S/N)" TO tex
            STORE "SN" TO wch
            DO pregunta
            IF wch = "N"
               LOOP
            ENDIF
            STORE .T. TO WFLAGACIN
            SELECT COMDCDE
            IF FILLOC()
               APPEND BLANK
               REPLACE numero    WITH wnumero2
               REPLACE renglon   WITH wrenglon
               REPLACE tipitem   WITH wtipitem
               REPLACE item      WITH witem
               REPLACE cantidad  WITH wcantidad
               REPLACE precio    WITH wprecio

               REPLACE ORIGEN      WITH "COM"
               REPLACE DEPTO       WITH WUSERUBI
               REPLACE USUARIO     WITH WUSERCODE
               REPLACE USUARIOF    WITH DATE()
               UNLOCK ALL
               FLUSH
            ENDIF
         ELSE
            STORE tipitem   TO wtipitem
            STORE item      TO witem
            STORE cantidad  TO wcantidad
            STORE precio    TO wprecio
  
            IF WTIPITEM="B"
               SELECT ALMART
               FIND &witem
               IF EOF()
                  STORE "BIEN NO REGISTRADO" TO WDESART
               ELSE
                  STORE DESCRI               TO WDESART
               ENDIF
               STORE uniexi TO wuniexi
            ELSE
               SELECT SYSSERVI
               FIND &witem
               IF EOF()
                  STORE "BIEN NO REGISTRADO" TO WDESART
               ELSE
                  STORE DESCRI               TO WDESART
               ENDIF
            ENDIF

            SELECT COMDCDE
            @ 18,07 SAY wtipitem
            @ 18,09 SAY witem
            @ 18,36 SAY wcantidad PICTURE "######.##"
            @ 18,48 SAY wprecio   PICTURE "########.##"
            STORE (wcantidad*wprecio) TO WTOTAL
            @ 18,68 SAY wtotal    PICTURE "########.##"
            STORE "OPCIONES: (M)ODIFICAR, (E)LIMINAR, (S)ALIR" TO tex
            STORE "SME" TO wch
            DO pregunta
            STORE wch TO wsme
            IF wsme = "S"
               STORE .F. TO veritem
               LOOP
            ENDIF
            IF wsme = "E"
               STORE "ESTA USTED SEGURO ? (S/N)" TO tex
               STORE "NS" TO wch
               DO pregunta
               IF wch = "S"
                  STORE .T. TO WFLAGACIN
                  IF FILLOC()
                     REPLACE ORIGEN      WITH "COM"
                     REPLACE DEPTO       WITH WUSERUBI
                     REPLACE USUARIO     WITH WUSERCODE
                     REPLACE USUARIOF    WITH DATE()
                     DELETE
                     UNLOCK ALL
                     FLUSH
                  ENDIF
                  STORE .F. TO veritem
                  LOOP
               ENDIF
            ENDIF
            IF wsme = "M"
               STORE .T.       TO wflagcant
               STORE wcantidad TO wlastcant
               DO WHILE wflagcant
                  @ 18,36 GET wcantidad PICTURE "######.##"
                  READ
                  IF wcantidad > 0
                     STORE .F. TO wflagcant
                  ENDIF
                  IF WTIPITEM="B".AND. (WCANTIDAD*ALMART->PRESCAP)+WUNIEXI > ALMART->MAXIMO .AND. WTIPODOC <> "DEV"
                     STORE "ADVERTENCIA: MAXIMO EXCEDIDO,<ENTER>" TO mes
                     DO aviso WITH mes
                     LOOP
                  ENDIF
               ENDDO
               IF WTIPODOC <> "ORD"
                  @ 18,48 SAY wprecio   PICTURE "########.##"
               ELSE
                  @ 18,48 GET wprecio   PICTURE "########.##"
                  READ
               ENDIF
               STORE (wcantidad*wprecio) TO WTOTAL
               @ 18,68 SAY wtotal PICTURE "########.##"
               STORE "CONFORME ? (S/N)" TO tex
               STORE "SN" TO wch
               DO pregunta
               IF wch = "S"
                  STORE .T. TO WFLAGACIN
                  IF RECLOC()
                     REPLACE cantidad WITH wcantidad
                     REPLACE precio WITH wprecio
                     REPLACE ORIGEN      WITH "COM"
                     REPLACE DEPTO       WITH WUSERUBI
                     REPLACE USUARIO     WITH WUSERCODE
                     REPLACE USUARIOF    WITH DATE()
                     UNLOCK ALL
                     FLUSH
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
         STORE .F. TO veritem
         LOOP
      ENDDO
   ENDDO
ENDDO
RETURN
******************************
func valTIP
do while .t.
   if wtipbenefi<>"A".and.wtipbenefi<>"C"
      defi wind winTIP  from 05,00 to 08,15
      acti wind winTIP
      @ 00,00 clear
      IF WTIPBENEFI="A"
         STORE 2 to wvalop
      ELSE
         STORE 1 to wvalop
      ENDIF
      do while .t.
         @ 00,01 get wvalop pict "@*V Clinica ;Afiliado"
         read
         if lastkey()=13
            exit
         endif
      enddo
      if wvalop=1
         store "C"        to WTIPBENEFI
         store "Clinica " to WTIPBENDES
      else
         store "A"        to WTIPBENEFI
         store "Afiliado" to WTIPBENDES
      endif
      rele wind winTIP
   else
      if wtipbenefi="C"
         store "Clinica " to WTIPBENDES
      else
         store "Afiliado" to WTIPBENDES
      endif
   endif
   exit
enddo
return .t.
************
PROCEDURE VALPAC
STORE WCODPAC1+STR(WCODPAC2,4) TO WCODPAC
SELECT 20
USE AFIAFI INDEX AFIAFI1
SEEK WCODPAC
IF .NOT. FOUND()
   *STORE "N" TO WTIPPAC
   *SELECT CITPAC
   *SEEK WCODPAC
   *IF .NOT. FOUND()
      *STORE "PACIENTE NO AFILIADO, FAVOR INGRESAR APELLIDO Y NOMBRE" TO WTEXT
      *DO AVISO WITH WTEXT
      *STORE SPACE(15) TO WPAPELLIDO
      *STORE SPACE(15) TO WPNOMBRE
      *@ 21,30 GET WPAPELLIDO
      *@ 21,46 GET WPNOMBRE
      *READ
      *IF LASTKEY()=27
      *   RETURN .F.
      *ENDIF
      *STORE ALLTRIM(WPAPELLIDO)+", "+ALLTRIM(WPNOMBRE) TO WNOMBRE
      *STORE .T. TO WINGPAC
   *ELSE
      *STORE ALLTRIM(PAPELLIDO)+", "+ALLTRIM(PNOMBRE)   TO WNOMBRE
   *ENDIF

   STORE "PACIENTE NO AFILIADO, VERIFIQUE" TO WTEXT
   DO AVISO WITH WTEXT
   STORE .F. TO WFLAGPAC
ELSE
   *STORE "A" TO WTIPPAC
   STORE ALLTRIM(PAPELLIDO)+", "+ALLTRIM(PNOMBRE) TO WNOMBRE
   STORE .T. TO WFLAGPAC
ENDIF
SELECT 20
USE
RETURN WFLAGPAC

