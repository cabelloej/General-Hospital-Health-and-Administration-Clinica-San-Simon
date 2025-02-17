*** VERIFICA QUE SEA UNA NOTA
STORE .F. TO WFLAGGEN
IF WTIPODOC = "NOT"
   STORE "REQ" TO WREF
   STORE "REQUISICION DE MATERIALES" TO WREFDES
   STORE .T. TO WFLAGCLI
ELSE
   RETURN
ENDIF

*** PIDE EL NUMERO DE SOLICITUD
STORE "REFERENCIA: "+WREFDES+" No.:" TO MES
DO MENSAJE WITH MES
STORE SPACE(7) TO WNUMREF
@ 23,62 GET WNUMREF
READ
IF WNUMREF<>SPACE(7)
   STORE ALLTRIM(WNUMREF)                      TO WNUMREF
   STORE REPLICATE("0",7-LEN(WNUMREF))+WNUMREF TO WNUMREF
   @ 23,62 SAY WNUMREF
ELSE
   RETURN
ENDIF

*** BUSCA LA SOLICITUD
STORE WREF+WNUMREF TO WCLAVEREF
SELECT MATDCGE
STORE RECNO() TO WREGDOC
SEEK WCLAVEREF
IF EOF()
   STORE WREFDES+" No."+WNUMREF+" NO EXISTE. <ENTER>" TO MES
   DO AVISO WITH MES
   STORE SPACE(10) TO WCLAVEREF
   RETURN
ENDIF

*** VERIFICA QUE ESTE PROCESADA ADMINISTRATIVAMENTE
IF PROCESADO<>SPACE(10)
   STORE "OPERACION RECHAZADA. REQUISICION PROCESADA CON : "+PROCESADO TO MES
   DO AVISO WITH MES
   STORE SPACE(10) TO WCLAVEREF
   RETURN
ENDIF

*** VERIFICAR LOS RENG. DE LA REF.
SELECT MATDCDE
STORE 0 TO WTOTPRO
FIND &WCLAVEREF
DO WHILE .NOT. EOF() .AND. NUMERO = WCLAVEREF
   STORE RECNO()   TO WRECDE
   STORE RENGLON   TO WREN
   STORE TIPITEM   TO WTIP
   STORE ITEM      TO WITE
   STORE CANTIDAD  TO WCAN
   STORE COSTO     TO WCOS
   IF FILLOC()
      APPEND BLANK
      REPLACE NUMERO    WITH WNUMERO2
      REPLACE RENGLON   WITH WREN
      REPLACE TIPITEM   WITH WTIP
      REPLACE ITEM      WITH WITE
      REPLACE CANTIDAD  WITH WCAN
      REPLACE COSTO     WITH WCOS

      REPLACE ORIGEN      WITH "MAT"
      REPLACE DEPTO       WITH WUSERUBI
      REPLACE USUARIO     WITH WUSERCODE
      REPLACE USUARIOF    WITH DATE()
      FLUSH
      UNLOCK ALL
   ENDIF
   STORE WTOTPRO + 1 TO WTOTPRO
   GO WRECDE
   SKIP
ENDDO
SELECT MATDCGE
IF WTOTPRO > 0
   SCATT MEMVAR
   STORE WNUMERO2  TO M.NUMERO
   STORE WCLAVEREF TO M.REFERENCIA
   STORE WUSERUBI  TO M.DEPTO
   STORE WUSERCODE TO M.USUARIO
   STORE DATE()    TO M.USUARIOF
   store .t. to wflaggen
   IF FILLOC()
      APPEND BLANK
      GATH MEMVAR
      SEEK WCLAVEREF
      IF EOF()
         STORE "ERROR: DESAPARECIO LA REQUISICION. NO PUDO SER MARCADA COMO EJECUTADA" TO MES
         DO AVISO WITH MES
      ELSE
         REPLACE PROCESADO WITH WNUMERO2
      ENDIF
      FLUSH
      UNLOCK ALL
   ENDIF
ENDIF
SELECT MATDCGE
GO WREGDOC
RETURN

