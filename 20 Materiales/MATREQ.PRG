STORE "REQUISICION DE MATERIALES: (I)NCLUIR, (A)CTUALIZAR, (S)ALIR" TO TEX
STORE "SIA" TO WCH
DO PREGUNTA
IF WCH="S"
   RETURN
ENDIF
IF WCH="I"
   SELECT MATDATA
   IF RECLOC()
      REPLACE MATSERIREQ WITH MATSERIREQ+1
      STORE MATSERIREQ   TO   WNUMNUM
      FLUSH
      UNLOCK ALL
   ENDIF
ELSE
   STORE 0 TO WNUMNUM
ENDIF
STORE 0              TO WNUMERO
STORE "REQ"          TO WTIPODOC
STORE "REQUISICION"   TO WDOCDES1
STORE "    DE     "   TO WDOCDES2
STORE "MATERIALES "  TO WDOCDES3
STORE SPACE(10)      TO WNUMERO2
STORE DATE()         TO WELABORADO
STORE 0              TO WMONTODOC
STORE .F.            TO WFLAGELA
DO MATELADC
IF .NOT. WFLAGELA
   RETURN
ENDIF
STORE "DESEA IMPRIMIR LA "+WDOCDES1+" ? (S/N)" TO TEX
STORE "SN" TO WCH
DO PREGUNTA
IF WCH = "S"
   DO WHILE .T.
      DO MATIMPDC
      STORE "CONFORME CON IMPRESION ? (S/N)" TO TEX
      STORE "SN" TO WCH
      DO PREGUNTA
      IF WCH="S"
         EXIT
      ENDIF
   ENDDO
ENDIF

