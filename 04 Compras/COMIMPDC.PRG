IF COMDCGE->TIPBENEFI="A"
   SELECT 20
   USE AFIAFI INDEX AFIAFI1
   SEEK COMDCGE->BENEFI
   IF FOUND()
      STORE ALLTRIM(PAPELLIDO)+" "+ALLTRIM(PNOMBRE)+ALLTRIM(SNOMBRE) TO WNOMBRE
   ELSE
      STORE "NO REGISTRADO EN AFILIADOS" TO WNOMBRE
   ENDIF
   SELECT 20
   USE
ELSE
   STORE SPACE(30) TO WNOMBRE
ENDIF

STORE .T. TO presupuesto
SELECT COMDCGE
FIND &wnumero2
IF EOF()
   STORE "ERROR, DESAPARECIO EL DOCUMENTO A IMPRIMIR" TO mes
   DO aviso WITH mes
   RETURN
ENDIF
STORE referencia TO wreferencia
STORE PROVEEDOR  TO WCODPRO
STORE REFERPROVE TO WREFERPROVE
STORE ELABORADO  TO WELABORADO
STORE SUBDOC     TO WSUBDOC
STORE PORIMP     TO WPORIMP
STORE SUBIMP     TO WSUBIMP
STORE MONTO      TO WMONTO
STORE VENCE      TO WVENCE
STORE COMENT1    TO WCOMENT1
STORE COMENT2    TO WCOMENT2
STORE COMENT3    TO WCOMENT3
STORE COMENT4    TO WCOMENT4
STORE TIPBENEFI  TO WTIPBENEFI
STORE BENEFI     TO WBENEFI
SELECT COMPRO
FIND &WCODPRO
IF EOF()
   STORE "NO REGISTRADO" TO wdesPRO
   STORE SPACE(20) TO wDESPRO2
   STORE SPACE(20) TO wDESPRO3
   STORE SPACE(20) TO wdirPRO1
   STORE SPACE(20) TO wdirPRO2
ELSE
   STORE desCRI  TO wdesPRO
   STORE "     " TO wdesPRO2
   STORE "     " TO wdesPRO3

   STORE "     " TO wdirPRO1
   STORE "     " TO wdirPRO2
ENDIF
SELECT COMDCDE
FIND &wnumero2
IF EOF()
   STORE "DOCUMENTO SIN RENGLONES, VERIFIQUE" TO mes
   DO aviso WITH mes
   RETURN
ENDIF
STORE .T. TO actualiza
STORE 100 TO wline
STORE 0 TO pagina
STORE 0 TO wmontodoc
SET DEVI TO PRINT
DO WHILE .NOT. EOF() .AND. numero = wnumero2
   STORE wline + 1 TO wline
   IF wline >=47
      STORE pagina + 1 TO pagina
      IF WMONTODOC>0
         STORE "        VAN:" TO WDOCTEXT
         STORE .F. TO WFLAGFIN
         DO WPAGPIE
      ENDIF
      @ 01,00 SAY CHR(18)
      @ 01,00 SAY CHR(14)+QQWW
      @ 05,53 say CHR(14)+WDOCDES1
      @ 06,53 say CHR(14)+WDOCDES2
      @ 07,53 say CHR(14)+WDOCDES3
      @ 08,00 SAY "+---------------------------------------------+ +------------------------------+"
      @ 09,00 SAY "|PROVEEDOR:                                   | |DOCUMENTO No:                 |"
      @ 09,11 SAY wdespro
      @ 09,63 SAY WNUMERO
      @ 10,00 SAY "|R.I.F.   :                                   | |------------------------------|"
      @ 10,11 SAY WCODPRO
      @ 11,00 SAY "|---------------------------------------------| |FECHA:            PAGINA:     |"
      @ 11,56 SAY DTOC(welaborado)
      @ 11,76 SAY PAGINA PICTURE "99"
      @ 12,00 SAY "|DIRECCION:                                   | |------------------------------|"
      @ 12,11 SAY wdirpro1
      @ 13,00 SAY "|                                             | |REFERENCIA  :                 |"
      @ 13,11 SAY wdirpro2
      @ 13,63 SAY SUBSTR(WREFERENCIA,1,3)+".No."+SUBSTR(WREFERENCIA,4,7)
      @ 14,00 SAY "|REF.PROVD:                                   | |------------------------------|"
      @ 14,11 SAY WREFERPROVE
      @ 15,00 SAY "|---------------------------------------------+ |BENEFICIARIO:                 |"
      @ 15,63 SAY COMDCGE->BENEFI
      @ 16,00 SAY "|VENCE    :                                   | |                              |"
      @ 16,11 SAY WVENCE
      @ 16,49 SAY SUBSTR(WNOMBRE,1,30)
      @ 17,00 SAY "+---------------------------------------------+ +------------------------------+"
      @ 20,00 SAY CHR(18)
      @ 20,00 SAY CHR(15)
      @ 20,00 SAY "+-----+------------+------------------------------------------------------------------+----------+---------------+----------------------+"
      @ 21,00 SAY "|RENG.|    CANTIDAD|DESCRIPCION DEL RENGLON                                           |UNIDAD    |PRECIO UNITARIO|         TOTAL RENGLON|"
      @ 22,00 SAY "+-----+------------+------------------------------------------------------------------+----------+---------------+----------------------+"

      STORE 23 TO wline
   ENDIF
   @ wline,0 SAY "|     |            |                                                                  |          |               |                      |"
   @ wline,1 SAY renglon
   @ wline,7 SAY cantidad PICTURE "9,999,999.99"
   STORE tipitem TO wtipitem
   STORE item    TO wclaveitem
   IF WTIPITEM="B"
      SELECT ALMART
      FIND &wclaveitem
      IF EOF()
         STORE "NO DEFINIDO EN ALMACEN" TO wartdes
      ELSE
         STORE descri  TO wartdes
         STORE descri2 TO wartdes2
         STORE descri3 TO wartdes3
         STORE descri4 TO wartdes4
         STORE PRESUND TO WUNIMED
      ENDIF
   ELSE
      SELECT SYSSERVI
      STORE SUBSTR(wclaveitem,1,12) TO WCLAVEITEM
      FIND &wclaveitem
      IF EOF()
         STORE "NO DEFINIDO EN SERVICIOS" TO wartdes
      ELSE
         STORE descri    TO wartdes
         STORE SPACE(40) TO wartdes2
         STORE SPACE(40) TO wartdes3
         STORE SPACE(40) TO wartdes4
         STORE UNIDAD    TO WUNIMED
      ENDIF
   ENDIF
   SELECT COMDCDE
   @ wline,20 SAY wartdes
   IF wartdes2 <> SPACE(40)
      STORE wline+1 TO wline
      @ wline,0 SAY "|     |            |                                                                  |          |               |                      |"
      @ wline,20 SAY wartdes2
   ENDIF
   IF wartdes3 <> SPACE(40)
      STORE wline+1 TO wline
      @ wline,0 SAY "|     |            |                                                                  |          |               |                      |"
      @ wline,20 SAY wartdes3
   ENDIF
   IF wartdes4 <> SPACE(40)
      STORE wline+1 TO wline
      @ wline,0 SAY "|     |            |                                                                  |          |               |                      |"
      @ wline,20 SAY wartdes4
   ENDIF

   @ WLINE,87 SAY WUNIMED
   IF SUBSTR(wnumero2,1,3) <> "COT"
      @ wline,100 SAY precio  PICTURE "99,999,999.99"
      STORE (cantidad*precio) to wtotal
      @ wline,123 SAY wtotal PICTURE "99,999,999.99"
      STORE wmontodoc + wtotal TO wmontodoc
   ENDIF
   SELECT COMDCDE
   SKIP
ENDDO
DO WHILE wline <= 47
   STORE wline + 1 TO wline
   @ wline,0 SAY "|     |            |                                                                  |          |               |                      |"
ENDDO
@ 48,0       SAY "|---------------------------------------------------------------------------------------------------------------------------------------|"
SELECT COMDCDE
STORE "SUBTOTAL       :" TO WDOCTEXT
STORE .T. TO WFLAGFIN
DO WPAGPIE
EJECT
SET DEVI TO SCRE
RETURN
********************************************************************************
PROC WPAGPIE
@ 48,0 SAY CHR(18)
@ 49,0 SAY " OBSERVACIONES  :"
@ 49,48 SAY WDOCTEXT
IF SUBSTR(wnumero2,1,3) <> "COT"
   @ 49,65 SAY WSUBDOC PICTURE "999,999,999.99"
ENDIF

@ 50,1 SAY Wcoment1

@ 50,48 SAY "PORC. IMPUESTOS:"
IF SUBSTR(wnumero2,1,3) <> "COT".AND.WFLAGFIN
   @ 50,65 SAY WPORIMP PICTURE "999,999,999.99"
ENDIF
@ 51,1 SAY Wcoment2
@ 51,48 SAY "TOTAL IMPUESTOS:"
IF SUBSTR(wnumero2,1,3) <> "COT".AND.WFLAGFIN
   @ 51,65 SAY WSUBIMP PICTURE "999,999,999.99"
ENDIF
@ 52,1 SAY WCOMENT3
@ 52,48 SAY "TOTAL GENERAL  :"
IF SUBSTR(wnumero2,1,3) <> "COT".AND.WFLAGFIN
   @ 52,65 SAY WMONTO  PICTURE "999,999,999.99"
ENDIF
@ 53,1 SAY WCOMENT4
@ 56,01 SAY "RECIBIDO POR:______________________________"
@ 56,50 SAY "_____________________________"
@ 57,50 SAY "      FIRMA Y SELLO "
@ 60,01 SAY "FECHA:_____________________________________"
RETURN

