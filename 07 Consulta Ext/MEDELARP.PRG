   DEFI WIND WINDPA FROM 03,00 TO 15,79 ;
                    TITLE  " REPOSO MEDICO " ;
                    FOOTER " ESC=Salir ";
                    DOUBLE NOFLOAT NOZOOM NOGROW COLOR SCHEME 10
   ACTI WIND WINDPA
   @ 00,02 SAY "Codigo              :"
   @ 01,02 SAY "Duracion            :"
   @ 02,02 SAY "Inicio              :"
   @ 03,02 SAY "Elaborado           :"
   @ 04,02 SAY "Diagnostico         :"
   *** INICIALIZA VARIABLES
   STORE SPACE(1)                  TO M.NACIMIENTO
   STORE SPACE(30)                 TO WNOMBRE
   STORE SPACE(10)                 TO WCEDULA
   STORE SPACE(1)                  TO WSEXO
   STORE SUBSTR(WCODPAC,1,10)      TO WCODPAC1
   STORE SUBSTR(WCODPAC,11,4)      TO WCODPAC2
   ***
   STORE SPACE(30)        TO WDURACION
   STORE DATE()           TO WINICIO
   STORE DATE()           TO WELABORADO
   STORE SPACE(50)        TO WDIAGNOST1
   STORE SPACE(50)        TO WDIAGNOST2
   STORE SPACE(50)        TO WDIAGNOST3
   STORE SPACE(50)        TO WDIAGNOST4
   STORE SPACE(50)        TO WDIAGNOST5


   STORE VAL(WCODPAC2)             TO WCODPAC2
   @ 00,25 GET WCODPAC1
   @ 00,35 SAY "-"
   @ 00,36 GET WCODPAC2 PICTURE "9999" VALID VALPAC()
   READ
   STORE STR(WCODPAC2,4)                        TO WCODPAC2
   STORE WCODPAC1+WCODPAC2                      TO WCODPAC
   STORE RTRIM(WCODPAC1)+"-"+LTRIM(WCODPAC2)    TO WXCODPAC
   IF LASTKEY()=27
      RELE WIND WINDPA
      RETURN
   ENDIF
   STORE  STR(INT((DATE()-M.NACIMIENTO)/365),2) TO WEDAD
   @ 00,25 SAY SPACE(40)
   @ 00,25 SAY WXCODPAC+" "+WNOMBRE
   @ 01,25 GET WDURACION
   @ 02,25 GET WINICIO
   @ 03,25 GET WELABORADO
   @ 04,25 GET WDIAGNOST1
   @ 05,25 GET WDIAGNOST2
   @ 06,25 GET WDIAGNOST3
   @ 07,25 GET WDIAGNOST4
   @ 08,25 GET WDIAGNOST5
   READ
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
         DO IMPREP
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
   *** GRABA   REPOSO EN HISTORIA
   *** ???????
   ***
   RELEASE WIND WINDPA
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
         STORE "N"           TO WTIPPAC
         STORE "No afiliado" TO WTIPDES
         STORE NACIMIENTO    TO M.NACIMIENTO
         STORE SEXO          TO WSEXO
         STORE CODPAC        TO WCEDULA
         STORE ALLTRIM(PAPELLIDO)+" "+ALLTRIM(SAPELLIDO)+" "+ALLTRIM(PNOMBRE)+" "+ALLTRIM(SNOMBRE) TO WNOMBRE
         RETURN .T.
      ENDIF
   ELSE
      STORE "A"          TO WTIPPAC
      STORE "Afiliado"   TO WTIPDES
      STORE NACIMIENTO   TO M.NACIMIENTO
      STORE SEXO         TO WSEXO
      STORE CEDAFI       TO WCEDULA
      STORE ALLTRIM(PAPELLIDO)+" "+ALLTRIM(SAPELLIDO)+" "+ALLTRIM(PNOMBRE)+" "+ALLTRIM(SNOMBRE) TO WNOMBRE
      RETURN .T.
   ENDIF
   RETURN .T.
   ***********
   PROC IMPREP
   ***********
   SET DEVI TO PRINT
   @ PROW(), PCOL() SAY CHR(18)
   @ PROW(), PCOL() SAY CHR(27)+CHR(67)+CHR(33)
   @ 00,00 SAY CHR(14)+QQWW
   @ 00,00 SAY CHR(14)+QQWW
   @ 01,00 SAY CHR(15)+WDIRECC1+" "+WDIRECC2
   @ 08,26 SAY chr(14)+"REPOSO MEDICO"
   @ 12,10 SAY "     Por medio de la presente se hace contar que el paciente:"
   @ 14,10 say alltrim(wnombre)
   @ 16,10 say "portador de la cedula  de identidad No. "+wcedula
   @ 18,10 say "amerita reposo domiciliario por un periodo de: "+wduracion
   @ 20,10 say "a partir del dia :"+dtoc(winicio)
   @ 22,10 say "Diagnostico:"+wdiagnost1
   @ 24,10 say "            "+wdiagnost2
   @ 26,10 say "            "+wdiagnost3
   @ 28,10 say "            "+wdiagnost4
   @ 30,10 say "            "+wdiagnost5
   @ 36,10 say "     Constancia que se expide en Maturin con fecha: "+dtoc(welaborado)
   @ 43,30 SAY "------------------------"
   @ 44,30 SAY "Dr(a)."+WNOMMED
   @ 45,30 SAY WNOMESP
   @ 46,30 SAY "No.Colegio : "+wcolegio
   @ 47,30 SAY "No.M.S.A.S.: "+wmsas

   EJECT
   @ PROW(), PCOL() SAY CHR(18)
   @ PROW(), PCOL() SAY CHR(27)+CHR(67)+CHR(66)
   SET DEVI TO SCRE
   RETURN
