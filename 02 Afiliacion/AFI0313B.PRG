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
   *STORE 0 TO WCONCAR
   SET DEVI TO PRINT
   @ PROW(), PCOL() SAY CHR(27)+CHR(67)+CHR(22)
   *EJECT
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
      SELECT AFIAFI
      DO WHILE .NOT. EOF() .AND. AFITITU.CEDTITU=AFIAFI.CEDTITU
         *STORE WCONCAR+1 TO WCONCAR
         *IF WCONCAR=5
         *   @ 15,00 SAY "."
         *   STORE 0 TO WCONCAR
         *ENDIF
         @ 00,00 SAY CHR(18)
         @ 00,00 SAY "ษออออออออออออออออออออออออออออออออออออออป"
         @ 01,00 SAY CHR(18)
         @ 01,00 SAY "บ                                      บ"
         @ 01,01 SAY QQWW
         @ 01,00 SAY CHR(15)
         @ 01,75 SAY "   La presente credencial identifica al titular como AFILIADO"
         @ 02,00 SAY CHR(18)
         @ 02,00 SAY "บCARNET DE AFILIACION      ........... บ"
         @ 02,00 SAY CHR(15)
         @ 02,75 SAY "al "+QQWW
         @ 03,00 SAY CHR(18)
         @ 03,00 SAY "บ                          . F O T O . บ"
         @ 03,00 SAY CHR(15)
         @ 03,75 SAY "   Para hacer efectivos nuestros servicios,  es indispensable"
         @ 04,00 SAY CHR(18)
         @ 04,00 SAY "บ                          ........... บ"
         @ 04,00 SAY CHR(15)
         @ 04,75 SAY "que el AFILIADO  presente la cedula anexo  a esta credencial."
         @ 05,00 SAY CHR(18)
         @ 05,00 SAY "บ                          ........... บ"
         @ 05,00 SAY CHR(15)
         @ 05,75 SAY "   Para solicitar consulta medica, el AFILIADO debe dirigirse"
         @ 06,00 SAY CHR(18)
         @ 06,00 SAY "บ                          ........... บ"
         @ 06,00 SAY CHR(15)
         @ 06,75 SAY "a las oficinas de Control de Citas ubicada en el Hospital."
         @ 07,00 SAY CHR(18)
         @ 07,00 SAY "บCODIGO:             CEDULA:           บ"
         @ 07,08 SAY ALLTRIM(AFIAFI.CEDTITU)+"-"+ALLTRIM(AFIAFI.CARGA)
         @ 07,28 SAY ALLTRIM(AFIAFI.CEDAFI)
         @ 07,00 SAY CHR(15)
         @ 07,75 SAY "   En caso de emergencias, presentar este carnet en el puesto"
         @ 08,00 SAY CHR(18)
         @ 08,00 SAY "บNOMBRE:                               บ"
         @ 08,08 SAY  SUBSTR(ALLTRIM(AFIAFI.PAPELLIDO)+" "+ALLTRIM(AFIAFI.SAPELLIDO)+", "+ALLTRIM(AFIAFI.PNOMBRE)+" "+ALLTRIM(AFIAFI.SNOMBRE),1,30)
         @ 08,00 SAY CHR(15)
         @ 08,75 SAY "de Emergencias del Hospital."
         @ 09,00 SAY CHR(18)
         @ 09,00 SAY "บF.NAC.:             PRTSCO:           บ"
         @ 09,08 SAY  DTOC(AFIAFI.NACIMIENTO)
         @ 09,28 SAY AFIPAREN.DESCRI
        *@ 09,28 SAY  (DATE()-AFIAFI.NACIMIENTO)/365  PICTURE "99"
         @ 09,00 SAY CHR(15)
         @ 09,75 SAY "   Para  mayor  informacion  dirigirse  a nuestra  oficina de"
         @ 10,00 SAY CHR(18)
         @ 10,00 SAY "บCLNTE.:             PLAN  :           บ"
         @ 10,08 SAY  AFITITU.ORGA
         @ 10,28 SAY  AFITITU.PLAN
         @ 10,00 SAY CHR(15)
         @ 10,75 SAY "informacion."
         @ 11,00 SAY CHR(18)
         @ 11,00 SAY "บVALIDO:             HASTA :           บ"
         @ 11,08 SAY  DTOC(AFITITU.VALDES)
         @ 11,28 SAY  DTOC(AFITITU.VALHAS)
         @ 12,00 SAY CHR(18)
         @ 12,00 SAY "ศออออออออออออออออออออออออออออออออออออออผ"
         @ 13,00 SAY CHR(18)

         *DO TEXTO
         SELECT AFIAFI
         SKIP
         IF LASTKEY()=27
            EXIT
         ENDIF
      ENDDO
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
*PROCEDURE TEXTO
*@ 04,00 SAY CHR(15)
*@ 04,02 SAY "   La presente credencial identifica al titular como AFILIADO"
*@ 05,02 SAY "al HOSPITAL DE CLINICAS SAN SIMON."
*@ 06,02 SAY "   Para hacer efectivos nuestros servicios,  es indispensable"
*@ 07,02 SAY "que el AFILIADO  presente la cedula anexo  a esta credencial."
*@ 08,02 SAY "   Para solicitar consulta medica, el AFILIADO debe dirigirse"
*@ 09,02 SAY "a las oficinas de Control de Citas ubicada en el Hospital."
*@ 10,02 SAY "   En caso de emergencias, presentar este carnet en el puesto"
*@ 11,02 SAY "de Emergencias del Hospital."
*@ 12,02 SAY "   Para  mayor  informacion  dirigirse  a nuestra  oficina de"
*@ 13,02 SAY "informacion."
*RETURN

