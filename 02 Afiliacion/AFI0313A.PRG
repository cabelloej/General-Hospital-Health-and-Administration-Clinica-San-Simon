SELECT AFITITU
SET ORDER TO AFITITU3
SAVE SCRE TO WSCRREP
DO WHILE .T.
   RESTORE SCRE FROM WSCRREP
   SHOW MENU MENUAFI
   @ 5,0 TO 13,40 DOUBLE
   @ 5,5 SAY "< CARNET DE AFILIACION >"
   @ 6,1 CLEAR TO 12,39
   STORE 0 TO WTOTAL
   STORE WORGA TO XORGA
   STORE WCEDTITU TO XCEDULA
   @ 07,1 say "ORGANIZACION:"
   @ 09,1 say "C.I. TITULAR:"
   @ 07,14 GET XORGA
   READ
   IF LASTKEY()=27
      SELECT AFITITU
      SET ORDER TO AFITITU1
      SELECT AFIAFI
      SET ORDER TO AFIAFI1
      EXIT
   ENDIF
   @ 09,14 GET XCEDULA
   READ
   IF LASTKEY()=27
      LOOP
   ENDIF
   STORE 13          TO WSALTO
   STORE "I"         TO WSALIDA
   store 1 to wop
   do while .t.
      @ 11,8  get wop pict "@*H Aceptar  ;Cancelar" defa wop
      read
      if lastkey()=13
         exit
      endif
   enddo
   IF WOP = 2
      LOOP
   ENDIF
   HIDE MENU MENUAFI
   SELECT AFITITU
   SEEK XORGA
   IF .NOT. FOUND()
      STORE "NO EXISTEN AFILIADOS DE ESTA ORGANIZACION-CLIENTE" TO WTEXT
      DO AVISO WITH WTEXT
      LOOP
   ENDIF
   SET DEVI TO PRINT
   @ PROW(), PCOL() SAY CHR(27)+CHR(67)+CHR(33)
   EJECT
   SELECT AFITITU
   DO WHILE .NOT. EOF()
      if cedtitu=space(10)
         select afititu
         skip
         loop
      endif
      *** FILTROS
      IF XORGA <> SPACE(4) .AND. XORGA  <> ORGA
         SELECT AFITITU
         SKIP
         LOOP
      ENDIF
      IF XCEDULA <> SPACE(10) .AND. XCEDULA  <> CEDTITU
         SELECT AFITITU
         SKIP
         LOOP
      ENDIF
      *** FIN FILTROS
      STORE 0   TO WPAGINA
      STORE 100 TO WLINEA
      SELECT AFIAFI
      DO WHILE .NOT. EOF() .AND. AFITITU.CEDTITU=AFIAFI.CEDTITU
         STORE WLINEA+1 TO WLINEA
         IF WLINEA >=WSALTO
            STORE WPAGINA + 1 TO WPAGINA
            IF WPAGINA>1
               @ WLINEA,00 SAY CHR(18)
               @ WLINEA,00 SAY "ศออออออออออออออออออออออออออออออออออออออผ"
               DO TEXTO
            ENDIF
            @ 00,00 SAY CHR(18)
            @ 00,00 SAY "ษออออออออออออออออออออออออออออออออออออออป"
            @ 01,00 SAY "บ"
            @ 01,39 SAY "บ"
            @ 01,01 SAY QQWW
            @ 01,01 SAY QQWW
            @ 02,00 SAY "บCARNET DE AFILIACION                  บ"
            @ 03,00 SAY "บNOMBRE:                               บ"
            @ 03,00 SAY " NOMBRE:                                "
            @ 03,08 SAY  RTRIM(AFITITU.PAPELLIDO)+" "+SUBSTR(AFITITU.SAPELLIDO,1,1)+"., "+RTRIM(AFITITU.PNOMBRE)+" "+SUBSTR(AFITITU.SNOMBRE,1,1)
            @ 04,00 SAY "บCEDULA:           CODIGO:             บ"
            @ 04,00 SAY " CEDULA:           CODIGO:              "
            @ 04,08 SAY AFITITU.CEDTITU
            @ 04,26 SAY ALLTRIM(AFITITU.CEDTITU)+"-"+"00"
            @ 05,00 SAY "บVALIDO:           HASTA :             บ"
            @ 05,00 SAY " VALIDO:           HASTA :              "
            @ 05,08 SAY AFITITU.VALDES
            @ 05,26 SAY AFITITU.VALHAS
            @ 06,00 SAY "บ     C A R G A    F A M I L I A R     บ"
            @ 06,00 SAY "      C A R G A    F A M I L I A R      "
            @ 07,00 SAY "บCODIGO    NOMBRE            PARENTESCOบ"
            @ 07,00 SAY " CODIGO    NOMBRE            PARENTESCO "
            STORE 8 TO WLINEA
         ENDIF
         SELECT AFIAFI
         IF PARENTESCO = "00"
            STORE WLINEA-1 TO WLINEA
            SELECT AFIAFI
            SKIP
            LOOP
         ENDIF
         @ WLINEA,00 SAY CHR(18)
         @ WLINEA,00 SAY "บ                                      บ"
         @ WLINEA,00 SAY CHR(15)
         @ WLINEA,03 SAY ALLTRIM(CEDTITU)+"-"+ALLTRIM(CARGA)
         STORE RTRIM(PAPELLIDO)+" "+SUBSTR(SAPELLIDO,1,1)+"., "+RTRIM(PNOMBRE)+" "+SUBSTR(SNOMBRE,1,1)+"." TO WNOMBRE
         @ WLINEA,20 SAY WNOMBRE
         @ WLINEA,57 SAY AFIPAREN.DESCRI
         SELECT AFIAFI
         SKIP
      ENDDO
      DO WHILE WLINEA<WSALTO
         STORE WLINEA+1 TO WLINEA
         @ WLINEA,00 SAY CHR(18)
         @ WLINEA,00 SAY "บ                                      บ"
      ENDDO
      STORE WLINEA+1 TO WLINEA
      @ WLINEA,00 SAY CHR(18)
      @ WLINEA,00 SAY "ศออออออออออออออออออออออออออออออออออออออผ"
      DO TEXTO
      IF LASTKEY()=27
         EXIT
      ENDIF
      SELECT AFITITU
      SKIP
   ENDDO
   @ PROW(), PCOL() SAY CHR(27)+CHR(67)+CHR(66)
   @ PROW(), PCOL() SAY CHR(18)
   EJECT
   SET DEVI TO SCRE
ENDDO
RETURN
***************
PROCEDURE TEXTO
STORE WLINEA+4 TO WLINEA
@ WLINEA,00 SAY CHR(15)
@ WLINEA,02 SAY "   La presente credencial identifica al titular como AFILIADO"
STORE WLINEA+1 TO WLINEA
@ WLINEA,02 SAY "al "+QQWW+"."
STORE WLINEA+1 TO WLINEA
@ WLINEA,02 SAY "   Para hacer efectivos nuestros servicios,  es indispensable"
STORE WLINEA+1 TO WLINEA
@ WLINEA,02 SAY "que el AFILIADO  presente la cedula anexo  a esta credencial."
STORE WLINEA+1 TO WLINEA
@ WLINEA,02 SAY "   Para solicitar consulta medica, el AFILIADO debe dirigirse"
STORE WLINEA+1 TO WLINEA
@ WLINEA,02 SAY "a las oficinas de Control de Citas ubicada en el Hospital."
STORE WLINEA+1 TO WLINEA
@ WLINEA,02 SAY "   En caso de emergencias, presentar este carnet en el puesto"
STORE WLINEA+1 TO WLINEA
@ WLINEA,02 SAY "de Emergencias del Hospital."
STORE WLINEA+1 TO WLINEA
@ WLINEA,02 SAY "   Para  mayor  informacion  dirigirse  a nuestra  oficina de"
STORE WLINEA+1 TO WLINEA
@ WLINEA,02 SAY "informacion."
RETURN

