STORE .T.     TO pres
DO WHILE pres
   @ 0,0 CLEAR
   STORE wdocdes1 TO wheader
   @ 00,40 - (LEN(wheader)/2) SAY wheader                                
   @ 01,0 SAY "+------------------------------------------------------------------------------+"
   @ 02,0 SAY "|NUMERO  :             REFERENCIA:                             FECHA:          |"
   @ 03,0 SAY "+------------------------------------------------------------------------------+"
   @ 04,0 SAY "|PARA    :                                                                     |"
   @ 05,0 SAY "+-----+-+--------------------------+---------+-------------+-------------------+"
   @ 06,0 SAY "|RENG.|T|CODIGO DEL BIEN           | CANTIDAD|        COSTO|              TOTAL|"
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
   @ 20,0 SAY "                                               TOTAL DOCTO.:                    "

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
   SELECT MATDCGE
   STORE WTIPODOC+WNUMERO TO WNUMERO2
   SEEK WNUMERO2
   IF .NOT.FOUND()
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
      STORE SPACE(10)        TO WREFERENCIA
      IF WTIPODOC="REQ"
         IF WUSERUBI<>"MAT"
            STORE WUSERUBI   TO WPARA
         ELSE
            STORE SPACE(3)   TO WPARA
         ENDIF
      ELSE
         STORE SPACE(3)      TO WPARA
      ENDIF
      STORE DATE()           TO WELABORADO
      ***
   ELSE
      STORE .F.              TO WFLAGING
      STORE .F.              TO WFLAGACT
      STORE .F.              TO WFLAGGEN
      STORE .F.              TO WFLAGACIN
      STORE REFERENCIA       TO WREFERENCIA
      STORE PARA             TO WPARA
      STORE ELABORADO        TO WELABORADO
   ENDIF
   IF .NOT. WFLAGING
      @ 2,69 SAY WELABORADO
      @ 4,10 SAY WPARA
      IF WTIPODOC="REQ".AND.WPARA<>WUSERUBI
         STORE "DOCUMENTO NO PERTECECE A SU DEPARTAMENTO" TO MES
         DO AVISO WITH MES
         LOOP
      ENDIF
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
         DO MATGENDC
         IF WFLAGGEN
            STORE WCLAVEREF TO WREFERENCIA
            STORE PARA      TO WPARA
            STORE ELABORADO TO WELABORADO
            STORE .F. TO WFLAGING
         ENDIF
      ENDIF

      ***  FECHA DE ELABORACION
      STORE "INDIQUE LA FECHA DE ELABORACION DEL DOCUMENTO" TO MES
      DO MENSAJE WITH MES
      @ 2,69 GET WELABORADO
      READ

      IF WPARA=SPACE(3)
         @ 4,10 GET WPARA
         READ
         IF WPARA=SPACE(3)
            STORE 5 TO LIBRREC
            STORE 5 TO CIBRREC
            DO MATWINRE
            STORE CODPTO TO WPARA
         ENDIF
      ENDIF
      SELECT SYSPTO
      SEEK WPARA
      IF FOUND()
         STORE DESCRI          TO WPARADES
      ELSE
         STORE "NO REGISTRADO" TO WPARADES
      ENDIF
      @ 04,10 SAY WPARADES

      STORE "CONFORME ? (S/N)" TO tex
      STORE "SN" TO wch
      DO PREGUNTA
      IF WCH = "N"
         LOOP
      ENDIF
      SELECT MATDCGE
      IF WFLAGING
         IF FILLOC()
            APPEND BLANK
            REPLACE NUMERO      WITH WNUMERO2
            REPLACE REFERENCIA  WITH WREFERENCIA
            UNLOCK ALL
            FLUSH
         ELSE
            LOOP
         ENDIF
      ENDIF
      IF WFLAGACT
         IF RECLOC()
            REPLACE PARA        WITH WPARA
            REPLACE ELABORADO   WITH WELABORADO
            REPLACE ORIGEN      WITH WUSERUBI
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
   ***********************************************************
   SELECT MATDCGE
   STORE .T. TO actualiza
   DO WHILE actualiza
      STORE 100 TO wline
      STORE 0 TO pagina
      STORE 0 TO wmontodoc
      STORE 8 TO wcleaner
      DO WHILE wcleaner <=16
         @ WCLEANER,0 SAY "|     | |                          |         |             |                   |"
         STORE wcleaner + 1 TO wcleaner
      ENDDO
      SELECT MATDCDE
      FIND &wnumero2
      DO WHILE .NOT. EOF() .AND. numero = wnumero2
         STORE wline + 1 TO wline
         IF wline >=17
            STORE pagina + 1 TO pagina
            IF pagina > 1
               STORE "OPRIMA <ENTER> PARA CONTINUAR" TO mes
               DO aviso WITH mes
            ENDIF
            STORE 8 TO wline
         ENDIF
         @ wline,1  SAY renglon
         @ wline,7  SAY tipitem
         @ wline,9  SAY item
         @ wline,36 SAY cantidad  PICTURE "######.##"
         IF WUSERUBI="MAT"
            @ wline,48 SAY costo     PICTURE "########.##"
            STORE (cantidad*costo)   TO WTOTAL
            @ wline,68 SAY wtotal    PICTURE "########.##"
            STORE wmontodoc + wtotal TO wmontodoc
         ENDIF
         SELECT MATDCDE
         SKIP
      ENDDO
      SELECT MATDCGE
      IF RECLOC()
         REPLACE MONTO WITH WMONTODOC
         UNLOCK ALL
         FLUSH
      ENDIF
      @ 20,0 SAY SPACE(35)
      @ 21,0 SAY SPACE(35)
      @ 22,0 SAY SPACE(35)
      
      STORE 0         TO WNUMRENG
      STORE SPACE(20) TO witem
      STORE "B"       TO WTIPITEM
      STORE .T.       TO veritem
      DO WHILE veritem
         SELECT MATDCDE
         @ 18,7  SAY SPACE(1)
         @ 18,9  SAY SPACE(20)
         @ 18,30 SAY SPACE(5)
         @ 18,36 SAY SPACE(9)
         @ 18,48 SAY SPACE(11)
         @ 18,60 SAY SPACE(5)
         @ 18,68 SAY SPACE(11)
         IF WUSERUBI="MAT"
            @ 18,66 SAY wmontodoc PICTURE "999,999,999.99"
         ENDIF
         STORE "INGRESE EL CODIGO DE RENGLON A PROCESAR, OPRIMA <ESC> PARA SALIR" TO mes
         DO mensaje WITH mes
         @ 18,1 GET wnumreng PICTURE "99999"
         READ
         IF wnumreng = 0 .OR. LASTKEY() = 27
             IF wflagela
               SELECT MATDCGE
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
            IF WTIPODOC="NOT".AND.WFLAGACIN
               DO MATACTIN
            ENDIF
            STORE .F. TO veritem
            STORE .F. TO actualiza
            LOOP
         ENDIF
         IF WTIPODOC="REQ".AND.MATDCGE->PROCESADO<>SPACE(10)
            STORE "NO SE PUEDE MODIFICAR REQUISICION YA PROCESADA" TO MES
            DO AVISO WITH MES
            LOOP
         ENDIF
         STORE LTRIM(STR(WNUMRENG,5))                  TO WRENGLON
         STORE REPLICATE("0",5-LEN(WRENGLON))+WRENGLON TO WRENGLON
         @ 18,1 SAY WRENGLON
         STORE wnumero2+wrenglon TO wclave
         SELECT MATDCDE
         FIND &wclave
         IF EOF()
            STORE "RENGLON NO REGISTRADO EN "+wdocdes1+", INGRESAR ? (S/N)" TO tex
            STORE "SN" TO wch
            DO pregunta
            IF wch = "N"
               LOOP
            ENDIF
            @ 18,7 SAY WTIPITEM
            STORE "CODIGO A PROCESAR. <ENTER>=Ver articulos, <ESC>=Salir" TO mes
            DO mensaje WITH mes
            @ 18,9 GET witem
            READ
            IF READKEY() = 12 .OR. READKEY() = 268
               STORE .F. TO veritem
               STORE .F. TO actualiza
               LOOP
            ENDIF
            IF witem = SPACE(20)
               SELECT MATART
               GO TOP
               SAVE SCRE TO s99
               STORE 5 TO LIBRART
               STORE 5 TO CIBRART
               DO MATWINAR
               STORE CODIGO TO WITEM
               RESTORE SCRE FROM s99
               @ 18,09 SAY WITEM
            ENDIF
            SELECT MATART
            FIND &witem
            IF EOF()
               STORE "CODIGO NO REGISTRADO EN ARTICULOS, VERIFIQUE" TO mes
               DO aviso WITH mes
               LOOP
            ENDIF
            STORE descri TO wdescri
            STORE unimed TO wunimed
            STORE uniexi TO wuniexi
            STORE COSEXI TO WCOSTO
            @ 20,1 SAY "DESCRIPCION :"+SUBSTR(wdescri,1,30)
            @ 21,1 SAY "UNID./ MED. :"+wunimed
            @ 22,1 SAY "EXISTENCIA  :"+STR(WUNIEXI,10,2)

            STORE 0        TO wcantidad
            STORE .T.      TO wflagcant
            DO WHILE wflagcant
               STORE "INDIQUE LA CANTIDAD DE UNIDADES" TO MES
               DO MENSAJE WITH MES
               @ 18,36 GET wcantidad PICTURE "######.##"
               READ
               IF LASTKEY()=27
                  STORE .F. TO WFLAGCANT
                  EXIT
               ENDIF
               IF WCANTIDAD > 0
                  IF WCANTIDAD>WUNIEXI
                     STORE "ADVERTENCIA: EXISTENCIAS NO CUBREN UNIDADES, VERIFIQUE" TO mes
                     DO aviso WITH mes
                     *LOOP
                  ELSE
                     EXIT
                  ENDIF
               ENDIF
            ENDDO
            IF .NOT.WFLAGCANT
               LOOP
            ENDIF

            IF WUSERUBI="MAT"
               @ 18,48 SAY wcosto    PICTURE "########.##"
               STORE (wcantidad*wcosto) TO WTOTAL
               @ 18,68 SAY wtotal PICTURE "########.##"
            ENDIF

            STORE "CONFORME ? (S/N)" TO tex
            STORE "SN" TO wch
            DO pregunta
            IF wch = "N"
               LOOP
            ENDIF
            STORE .T. TO WFLAGACIN
            SELECT MATDCDE
            IF FILLOC()
               APPEND BLANK
               REPLACE numero    WITH wnumero2
               REPLACE renglon   WITH wrenglon
               REPLACE tipitem   WITH wtipitem
               REPLACE item      WITH witem
               REPLACE cantidad  WITH wcantidad
               REPLACE costo     WITH wcosto

               REPLACE ORIGEN      WITH "MAT"
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
            STORE COSTO     TO wCOSTO
  
            SELECT MATART
            FIND &witem
            IF EOF()
               STORE "BIEN NO REGISTRADO" TO WDESART
            ELSE
               STORE DESCRI               TO WDESART
            ENDIF
            STORE uniexi TO wuniexi

            SELECT MATDCDE
            @ 18,07 SAY wtipitem
            @ 18,09 SAY witem
            @ 18,36 SAY wcantidad PICTURE "######.##"
            IF WUSERUBI<>"MAT"
               @ 18,48 SAY wcosto    PICTURE "########.##"
               STORE (wcantidad*wcosto ) TO WTOTAL
               @ 18,68 SAY wtotal    PICTURE "########.##"
            ENDIF
            STORE "OPCIONES: (M)ODIFICAR, (E)LIMINAR, (S)ALIR" TO tex
            STORE "SME" TO wch
            DO pregunta
            STORE wch TO wsme
            IF wsme = "S"
               STORE .F. TO veritem
               LOOP
            ENDIF
            IF wsme = "E"
               IF wtipodoc="REQ".and.matdcge.procesado<>space(10)
                  STORE "REQUISICION YA PROCESADA, NO PUEDE SER ELIMINADA" TO MES
                  DO AVISO WITH MES
               ELSE
                  STORE "ESTA USTED SEGURO ? (S/N)" TO tex
                  STORE "NS" TO wch
                  DO pregunta
                  IF wch = "S"
                     STORE .T. TO WFLAGACIN
                     IF FILLOC()
                        REPLACE ORIGEN      WITH "MAT"
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
            ENDIF
            IF WSME = "M"
               IF WTIPODOC="REQ".AND.MATDCGE->PROCESADO<>SPACE(10)
                  STORE "REQUISICION YA PROCESADA. NO SE PUEDE MODIFICAR" TO MES
                  DO AVISO WITH MES
                  LOOP
               ENDIF
               STORE .T.       TO wflagcant
               STORE wcantidad TO wlastcant
               DO WHILE wflagcant
                  STORE "INDIQUE LA CANTIDAD DE UNIDADES" TO MES
                  DO MENSAJE WITH MES
                  @ 18,36 GET wcantidad PICTURE "######.##"
                  READ
                  IF LASTKEY()=27
                     STORE .F. TO WFLAGCANT
                     EXIT
                  ENDIF
                  IF wcantidad > 0
                     IF wcantidad-wlastcant > wuniexi
                        STORE "ADVERTENCIA: EXISTENCIAS NO CUBREN UNIDADES, VERIFIQUE" TO mes
                        DO aviso WITH mes
                        LOOP
                     ELSE
                        EXIT
                     ENDIF
                  ENDIF
               ENDDO
               IF .NOT.WFLAGCANT
                  LOOP
               ENDIF
               IF WUSERUBI="MAT"
                  @ 18,48 SAY wcosto   PICTURE "########.##"
                  STORE (wcantidad*wcosto) TO WTOTAL
                  @ 18,68 SAY wtotal PICTURE "########.##"
               ENDIF
               STORE "CONFORME ? (S/N)" TO tex
               STORE "SN" TO wch
               DO pregunta
               IF wch = "S"
                  STORE .T. TO WFLAGACIN
                  IF RECLOC()
                     REPLACE cantidad    WITH wcantidad
                     REPLACE costo       WITH wcosto
                     REPLACE ORIGEN      WITH "MAT"
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
