STORE .T. TO presupuesto
SELECT MATDCGE
FIND &wnumero2
IF EOF()
   STORE "ERROR, DESAPARECIO EL DOCUMENTO A IMPRIMIR" TO mes
   DO aviso WITH mes
   RETURN
ENDIF
STORE REFERENCIA TO WREFERENCIA
STORE PARA       TO WPARA
STORE ELABORADO  TO WELABORADO
STORE MONTO      TO WMONTO
STORE COMENT1    TO WCOMENT1
STORE COMENT2    TO WCOMENT2
STORE COMENT3    TO WCOMENT3
STORE COMENT4    TO WCOMENT4
STORE DEPTO      TO WDEPTO
STORE USUARIO    TO WUSUARIO
SELECT SYSPTO
SEEK WPARA
IF EOF()
   STORE "NO REGISTRADO" TO WDESPARA
ELSE
   STORE DESCRI          TO WDESPARA
ENDIF

SELECT MATDCDE
SEEK WNUMERO2
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
@ PROW(), PCOL() SAY CHR(18)
@ PROW(), PCOL() SAY CHR(27)+CHR(67)+CHR(33)
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
      @ 03,50 say CHR(14)+WDOCDES1
      @ 04,50 say CHR(14)+WDOCDES2
      @ 05,50 say CHR(14)+WDOCDES3
      @ 06,54 SAY CHR(14)+WNUMERO
      @ 07,00 SAY "FECHA       :"
      @ 07,14 SAY DTOC(WELABORADO)
      *@ 07,76 SAY PAGINA PICTURE "99"
      @ 08,00 SAY "REF.DEL DCTO:"
      @ 08,14 SAY SUBSTR(WREFERENCIA,1,3)+".No."+SUBSTR(WREFERENCIA,4,7)
      @ 09,00 SAY "PARA        :"
      @ 09,14 SAY SUBSTR(WDESPARA,1,24)
      @ 10,00 SAY CHR(18)
      @ 10,00 SAY CHR(15)
      @ 10,00 SAY "+-----+------------+--------------------------------------+----------+---------------+----------------+--------------+"
      @ 11,00 SAY "|RENG.|    CANTIDAD|DESCRIPCION DEL RENGLON               |UNIDAD    |PRECIO UNITARIO|   TOTAL RENGLON|  UBICACION   |"
      @ 12,00 SAY "+-----+------------+--------------------------------------+----------+---------------+----------------+--------------+"
      STORE 13 TO wline
   ENDIF
   @ wline,0 SAY  "|     |            |                                      |          |               |                |              |"
   @ wline,1 SAY renglon
   @ wline,7 SAY cantidad PICTURE "9,999,999.99"
   STORE tipitem TO wtipitem
   STORE item    TO wclaveitem
   SELECT MATART
   FIND &wclaveitem
   IF EOF()
      STORE "NO DEFINIDO EN ALMACEN" TO wartdes
   ELSE
      STORE descri    TO wartdes
      STORE descri2   TO wartdes2
      STORE descri3   TO wartdes3
      STORE descri4   TO wartdes4
      STORE UNIMED    TO WUNIMED
      STORE UBICACION TO WUBICACION
   ENDIF
   SELECT MATDCDE
   @ wline,20 SAY ALLTRIM(WCLAVEITEM)+"-"+ALLTRIM(WARTDES)
   IF wartdes2 <> SPACE(40)
      STORE wline+1 TO wline
      @ wline,0 SAY  "|     |            |                                      |          |               |                |              |"
      @ wline,20 SAY wartdes2
   ENDIF
   IF wartdes3 <> SPACE(40)
      STORE wline+1 TO wline
      @ wline,0 SAY  "|     |            |                                      |          |               |                |              |"
      @ wline,20 SAY wartdes3
   ENDIF
   IF wartdes4 <> SPACE(40)
      STORE wline+1 TO wline
      @ wline,0 SAY  "|     |            |                                      |          |               |                |              |"
      @ wline,20 SAY wartdes4
   ENDIF

   @ WLINE,60 SAY WUNIMED
   IF WUSERUBI="MAT"
     *@ wline,71  SAY costo   PICTURE "99,999,999.99"
      STORE (cantidad*costo) to wtotal
     *@ wline,87 SAY wtotal PICTURE "99,999,999.99"
      STORE wmontodoc + wtotal TO wmontodoc
   ENDIF
   @ WLINE,104 SAY WUBICACION
   SELECT MATDCDE
   SKIP
ENDDO
DO WHILE wline <=19
   STORE wline + 1 TO wline
   @ wline,0 SAY  "|     |            |                                      |          |               |                |              |"
ENDDO
@ 21,0 SAY "|--------------------------------------------------------------------------------------------------------------------|"
SELECT MATDCDE
STORE "TOTAL GENERAL  :" TO WDOCTEXT
STORE .T. TO WFLAGFIN
DO WPAGPIE
SET DEVI TO SCRE
RETURN
********************************************************************************
PROC WPAGPIE
@ 22,0 SAY CHR(18)
@ 22,0 SAY " OBSERVACIONES  :"
@ 22,38 SAY WDOCTEXT
*@ 22,55 SAY WMONTODOC PICTURE "99,999,999.99"
@ 23,1 SAY Wcoment1
@ 24,1 SAY Wcoment2
@ 25,1 SAY WCOMENT3
@ 26,1 SAY WCOMENT4
@ 28,01 SAY "_____________________________"
@ 28,35 SAY "_____________________________"
@ 29,01 SAY "         RECIBIDO            "
@ 29,35 SAY "       FIRMA Y FECHA         "
@ PROW(), PCOL() SAY CHR(18)
@ PROW(), PCOL() SAY CHR(27)+CHR(67)+CHR(66)
RETURN

