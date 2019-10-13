****************************  P A C I E N T E  ********************************
   DEFI WIND WINDPA FROM 03,00 TO 07,79 ;
                    TITLE  " PACIENTE " ;
                    FOOTER " ESC=Salir ";
                    DOUBLE NOFLOAT NOZOOM NOGROW COLOR SCHEME 10
   ACTI WIND WINDPA
   @ 00,02 SAY "Codigo              :"
   @ 01,02 SAY "Edad                :"
   @ 02,02 SAY "Alergico a          :"
   *** INICIALIZA VARIABLES
   STORE SPACE(1)                  TO M.NACIMIENTO
   STORE SPACE(1)                  TO M.ALERGICO
   STORE SPACE(30)                 TO WNOMBRE
   STORE SPACE(10)                 TO WHISTORIA
   STORE SPACE(20)                 TO WTIPDES
   STORE SPACE(10)                 TO WCEDULA
   STORE SUBSTR(WCODPAC,1,10)      TO WCODPAC1
   STORE SUBSTR(WCODPAC,11,4)      TO WCODPAC2

   STORE VAL(WCODPAC2)             TO WCODPAC2
   @ 00,25 GET WCODPAC1
   @ 00,35 SAY "-"
   @ 00,36 GET WCODPAC2 PICTURE "9999" VALID VALPAC()
   READ
   STORE STR(WCODPAC2,4)                     TO WCODPAC2
   STORE WCODPAC1+WCODPAC2                   TO WCODPAC
   STORE RTRIM(WCODPAC1)+"-"+LTRIM(WCODPAC2) TO WXCODPAC
   IF LASTKEY()=27
      RELE WIND WINDPA
      RETURN
   ENDIF
   @ 00,25 SAY SPACE(40)
   @ 00,25 SAY WXCODPAC+" "+WNOMBRE+" ("+wtipdes+")"
   @ 01,25 SAY STR(INT((DATE()-M.NACIMIENTO)/365),2)
   @ 02,25 SAY M.ALERGICO
   **************************  R E C I P E   **********************************
   *** MEDICAMENTOS
   DEFI WIND WINDME FROM 08,00 TO 15,79 ;
                    TITLE " RECIPE " ;
                    FOOTER " F1=Inc.vacio, F3=Elim, F5=Inc.de Vademec, F10=Posol, ESC=Salir ";
                    DOUBLE NOFLOAT NOZOOM NOGROW COLOR SCHEME 10
   DEFI WIND WINDINME FROM 16,00 TO 21,79 ;
                      TITLE " POSOLOGIA " ;
                      DOUBLE NOFLOAT NOZOOM NOGROW COLOR SCHEME 10
   ACTI WIND WINDME
   SELECT MEDREC
   ON KEY LABEL F1 DO PROCBLA
   ON KEY LABEL F2
   ON KEY LABEL F3 DO PROCMEE
   ON KEY LABEL F4
   ON KEY LABEL F5 DO PROCMEI
   ON KEY LABEL F6
   ON KEY LABEL F7
   ON KEY LABEL F8
   ON KEY LABEL F9
   ON KEY LABEL F10 DO PROCMEN
   BROWSE FIELDS DESCRI:H="NOMBRE",CANTID:H="CANTIDAD",PRESEN:H="PRESENTACION",CONCEN:H="CONCENTRAC.";
                 NOAPPEND NODELETE NOEDIT NOMENU NOOPTIMIZE REST SAVE IN WINDOW WINDME WHEN INDICARE()
   ON KEY LABEL F1
   ON KEY LABEL F2
   ON KEY LABEL F3
   ON KEY LABEL F4 
   ON KEY LABEL F5
   ON KEY LABEL F6
   ON KEY LABEL F7
   ON KEY LABEL F8
   ON KEY LABEL F9
   ON KEY LABEL F10
   *** IMPRIME RECIPE
   DEFI WIND WINDPRIN FROM 12,17 TO 14,62;
                      DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
   ACTIVATE WIND WINDPRIN
   store 1 to wop
   do while .t.
      @ 00,10 get wop pict "@*H Imprimir ;Abandonar" defa wop
      read
      if lastkey()=13
         exit
      endif
   enddo
   RELE WIND WINDPRIN
   IF WOP=1
      DO WHILE .T.
         DO IMPREC
         *** CONTROL DE IMPRESION
         DEFI WIND WINDCON FROM 12,12 TO 14,55 DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
         ACTIVATE WIND WINDCON
         store 1 to wop
         DO WHILE .T.
            @ 00,03 SAY "CONFORME CON IMPRESION ? ";
            GET WOP pict "@*H SI ;NO " defa wop
            READ
            IF LASTKEY()=13
               EXIT
            ENDIF
         ENDDO
         RELE WIND WINDCON
         IF WOP=1
            EXIT
         ENDIF
      ENDDO
   ENDIF
   *** GRABA   RECIPE EN HISTORIA
   *** ???????
   ***
   RELEASE WIND WINDPA
   RELEASE WIND WINDME
   RELEASE WIND WINDINME
   RETURN
   *****************
   FUNCTION INDICARE
   *****************
   ACTI WIND WINDINME
   @ 0,0 SAY INDIC1
   @ 1,0 SAY INDIC2
   @ 2,0 SAY INDIC3
   @ 3,0 SAY INDIC4
   ACTI WIND WINDME
   RETURN
****************************  V A D E M E C U M  ******************************
   *****************
   PROCEDURE PROCMEI
   *****************
   PUSH KEY CLEAR
   DEFI WIND WINDVAC FROM 09,00 TO 20,79 ;
                     TITLE " VADEMECUM " ;
                     FOOTER " F4=Buscar, F5=Ord x Cod, F6=Ord Alf, F7=Ord x Tip, ESC=Salir ";
                     DOUBLE NOFLOAT NOZOOM NOGROW COLOR SCHEME 10
   DEFI WIND WINDVACIN FROM 21,00 TO 24,79 ;
                       TITLE " POSOLOGIA " ;
                       DOUBLE NOFLOAT NOZOOM NOGROW COLOR SCHEME 10
   ACTI WIND WINDVAC
   ON KEY LABEL F4 DO PROCVBC
   ON KEY LABEL F5 DO PROCVOC
   ON KEY LABEL F6 DO PROCVOA
   ON KEY LABEL F7 DO PROCVOT
   SELECT ALMART
   SET ORDER TO ALMART
   BROWSE FIELDS WCODIGO=SUBSTR(CODIGO,1,15):H="CODIGO", DESCRI:H="MEDICAMENTO", PRESENTAC:H="PRESENTACION", CONCENTRA:H="CONCENTRAC.";
                 FOR VADEMECUM="S";
                 NOAPPEND NODELETE NOEDIT NOMENU NOOPTIMIZE REST SAVE IN WINDOW WINDVAC WHEN INDICAVA()
   SELECT MEDREC
   IF FILLOC()
      APPEND BLANK
      UNLOCK ALL
      IF RECLOC()
         REPLACE DESCRI WITH ALMART.DESCRI
         REPLACE PRESEN WITH ALMART.PRESENTAC
         REPLACE CONCEN WITH ALMART.CONCENTRA
         REPLACE INDIC1 WITH ALMART.POSOLOGI1
         REPLACE INDIC2 WITH ALMART.POSOLOGI2
         UNLOCK ALL
      ENDIF
   ELSE
      STORE "OPERACION ABORTADA, REINTENTE" TO WTEXT
      DO AVISO WITH WTEXT
   ENDIF
   RELEASE WIND WINDVAC
   RELEASE WIND WINDVACIN
   POP KEY
   RETURN
   *****************
   FUNCTION INDICAVA
   *****************
   ACTI WIND WINDVACIN
   @ 0,0 SAY POSOLOGI1
   @ 1,0 SAY POSOLOGI2
   ACTI WIND WINDVAC
   RETURN
   ************
   PROC PROCMEN
   ************
   ACTIVATE WIND WINDINME
   PUSH KEY CLEAR
   IF RECLOC()
      @ 00,00 GET INDIC1
      @ 01,00 GET INDIC2
      @ 02,00 GET INDIC3
      @ 03,00 GET INDIC4
      READ
   ENDIF
   ACTIVATE WIND WINDME
   POP KEY
   RETURN
   *****************
   PROCEDURE PROCMEE
   *****************
   PUSH KEY CLEAR
   IF RECLOC()
      DELETE
      UNLOCK ALL
   ENDIF
   POP KEY
   RETURN
   ****************
   PROCEDURE PROCBLA
   ****************
   PUSH KEY CLEAR
   DEAC WIND WINDME
   SELECT MEDREC
   IF FILLOC()
      APPEND BLANK
      UNLOCK ALL
   ENDIF
   ACTIVATE WIND WINDME
   POP KEY
   RETURN
   ****************
   PROCEDURE VALPAC
   ****************
   STORE WCODPAC1+STR(WCODPAC2,4) TO WCODPAC
   SELECT AFIAFI
   SET ORDER TO AFIAFI1
   SEEK WCODPAC
   IF .NOT. FOUND()
      SELECT SYSPAC
      SET ORDER TO SYSPAC
      SEEK WCODPAC
      IF .NOT. FOUND()
         STORE "PACIENTE NO REGISTRADO COMO AFILIADO NI COMO NO-AFILIADO" TO WTEXT
         DO AVISO WITH WTEXT
         RETURN .F.
      ELSE
         STORE "N"                 TO WTIPPAC
         STORE "No afiliado"       TO WTIPDES
         STORE SUBSTR(CODPAC,1,10) TO WCEDULA
         STORE NACIMIENTO          TO M.NACIMIENTO
         STORE HISTORIA            TO M.HISTORIA
         STORE ALERGICO            TO M.ALERGICO
         STORE RTRIM(PAPELLIDO)+" "+RTRIM(SAPELLIDO)+", "+RTRIM(PNOMBRE)+" "+RTRIM(SNOMBRE) TO WNOMBRE
         STORE HISTORIA     TO WNUMHIS
         RETURN .T.
      ENDIF
   ELSE
      STORE "A"          TO WTIPPAC
      STORE "Afiliado"   TO WTIPDES
      STORE CEDAFI       TO WCEDULA
      STORE NACIMIENTO   TO M.NACIMIENTO
      STORE HISTORIA     TO M.HISTORIA
      STORE ALERGICO     TO M.ALERGICO
      STORE RTRIM(PAPELLIDO)+" "+RTRIM(SAPELLIDO)+", "+RTRIM(PNOMBRE)+" "+RTRIM(SNOMBRE) TO WNOMBRE
      STORE HISTORIA     TO WNUMHIS
      RETURN .T.
   ENDIF
   RETURN .T.
   ***********
   PROC IMPREC
   ***********
   SET DEVI TO PRINT
   @ PROW(), PCOL() SAY CHR(18)
   @ PROW(), PCOL() SAY CHR(27)+CHR(67)+CHR(33)
   store 100 to wline
   store 0   to wpage
   select medrec
   go top
   do while .not. eof()
      store wline + 1 to wline
      if wline>=25
         do impdoc
         store wpage+1 to wpage
         @ 00,00 SAY CHR(14)+QQWW
         @ 00,00 SAY CHR(14)+QQWW
         @ 01,00 SAY CHR(15)+WDIRECC1+" "+WDIRECC2+chr(18)
         @ 02,00 SAY CHR(15)+WRIF+CHR(18)
         @ 03,26 SAY chr(14)+"RECIPE MEDICO"
         @ 04,60 SAY "Fecha  : "+dtoc(date())
         @ 05,60 SAY "Pagina : "+str(wpage,2)
         @ 06,00 SAY CHR(15)+"Paciente : "+WXCODPAC+"  "+ALLTRIM(WNOMBRE)+"  C.I. No. "+WCEDULA+CHR(18)
         @ 07,00 SAY REPLICATE("-",80)
         @ 08,00 SAY "MEDICAMENTO"
         @ 08,00 SAY "MEDICAMENTO"
         @ 08,45 SAY "CANTIDAD"
         @ 08,45 SAY "CANTIDAD"
         @ 08,54 SAY "PRESENTACION"
         @ 08,54 SAY "PRESENTACION"
         @ 08,69 SAY "CONCENTRAC."
         @ 08,69 SAY "CONCENTRAC."
         @ 09,00 SAY "----------------------------------------"
         @ 09,45 SAY "--------"
         @ 09,54 SAY "------------"
         @ 09,69 SAY "-----------"
         store 10 to wline
      endif
      @ wline,00 say descri
      @ wline,45 say cantid
      @ wline,54 say presen
      @ wline,69 say concen
     skip
   enddo
   do impdoc
   ***** INDICACIONES
   store 100 to wline
   store 0   to wpage
   select medrec
   go top
   do while .not. eof()
      store wline + 1 to wline
      if wline>=25
         do impdoc
         store wpage+1 to wpage
         @ 01,00 SAY CHR(14)+QQWW
         @ 01,00 SAY CHR(14)+QQWW
         @ 02,00 SAY CHR(15)+WDIRECC1+" "+WDIRECC2+chr(18)
         @ 03,00 SAY CHR(15)+"R.I.F. :"+WRIF+CHR(18)
         @ 04,26 SAY chr(14)+"INDICACIONES"
         @ 05,60 SAY "Fecha  : "+dtoc(date())
         @ 06,60 SAY "Pagina : "+str(wpage,2)
         @ 07,00 SAY CHR(15)+"Paciente : "+WXCODPAC+"  "+ALLTRIM(WNOMBRE)+"  C.I. No. "+WCEDULA+CHR(18)
         @ 08,00 SAY REPLICATE("-",80)
         store 09 to wline
      endif

      @ wline,00 say chr(14)+descri
      @ wline,00 say chr(14)+descri
      if indic1<>space(78)
         store wline+1 to wline
         @ wline,00 say indic1
      endif
      if indic2<>space(78)
         store wline+1 to wline
         @ wline,00 say indic2
      endif
      if indic3<>space(78)
         store wline+1 to wline
         @ wline,00 say indic3
      endif
      if indic4<>space(78)
         store wline+1 to wline
         @ wline,00 say indic4
      endif
      skip
   enddo
   do impdoc
   EJECT
   @ PROW(), PCOL() SAY CHR(18)
   @ PROW(), PCOL() SAY CHR(27)+CHR(67)+CHR(66)
   SET DEVI TO SCRE
   RETURN
   ************
   PROC IMPDOC
   ************
   if wpage>0
      @ 26,25 SAY "Doctor(a)    : "+WNOMMED
      @ 27,25 SAY "Especialidad : "+WNOMESP
      @ 28,25 SAY "No.Colegio   : "+WCOLEGIO
      @ 29,25 SAY "No.M.S.A.S.  : "+WMSAS
      @ 30,00 SAY REPLICATE("-",80)
   endif
   RETURN
   ************
   PROC PROCVBC
   ************
   PUSH KEY CLEAR
   DEFI WIND WPROCBC FROM 9,00 TO 11,79;
                     TITLE " BUSCAR "  ;
                     DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
   ACTI WIND WPROCBC
   DO WHILE .T.
      STORE SPACE(20) TO WBUS
      @ 00,01 SAY "CLAVE :"
      @ 00,09 GET WBUS
      READ
      IF LASTKEY()=27
         EXIT
      ENDIF
      SEEK ALLTRIM(WBUS)
      IF FOUND()
         EXIT
      ELSE
         STORE "NO REGISTRADO, VERIFIQUE" TO WTEXT
         DO AVISO WITH WTEXT
      ENDIF
   ENDDO
   RELEASE WIND WPROCBC
   POP KEY
   RETURN
   ************
   PROC PROCVOC
   ************
   SET ORDER TO ALMART
   RETURN
   ************
   PROC PROCVOA
   ************
   SET ORDER TO ALMART3
   RETURN
   ************
   PROC PROCVOT
   ************
   SET ORDER TO ALMART4
   RETURN
   ************

