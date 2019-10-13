SELECT AFITITU
SET ORDER TO AFITITU3
SAVE SCRE TO WSCRREP
DO WHILE .T.
   RESTORE SCRE FROM WSCRREP
   SHOW MENU MENUAFI
   @ 5,0 TO 15,40 DOUBLE
   @ 5,5 SAY "< DATOS DE AFILIADOS DEL TITULAR >"
   @ 6,1 CLEAR TO 12,39
   STORE 0 TO WTOTAL
   STORE WORGA TO XORGA
   STORE WCEDTITU TO XCEDULA
   @ 07,1 say "ORGANIZACION:"
   @ 09,1 say "C.I. TITULAR:"
   @ 11,1 say "SALIDA (M/I):"
   @ 07,14 GET XORGA
   READ
   IF LASTKEY()=27
      SELECT AFITITU
      SET ORDER TO AFITITU1
      SELECT AFIAFI
      SET ORDER TO AFIAFI1
      EXIT
   ENDIF
   IF XORGA=SPACE(4)
      LOOP
   ENDIF
   @ 09,14 GET XCEDULA
   READ
   IF LASTKEY()=27
      LOOP
   ENDIF
   store "Monitor" to wop
   do while .t.
      @ 11,15  get wop pict "@*H Monitor   ;Impresora" defa wop
      read
      if lastkey()=13
         exit
      endif
   enddo
   STORE WOP TO WSALIDA
   STORE 0   TO WPAGINA
   STORE 100 TO WLINEA
   IF ALLTRIM(WSALIDA) = "Impresora"
      STORE 55          TO WSALTO
      STORE "IMPRESORA" TO WSALIDES
      STORE "I"         TO WSALIDA
   ELSE
      STORE 22          TO WSALTO
      STORE "MONITOR"   TO WSALIDES
      STORE "M"         TO WSALIDA
   ENDIF
   @ 11,15 SAY SPACE(24)
   @ 11,15 SAY WSALIDES
   store 1 to wop
   do while .t.
      @ 13,8  get wop pict "@*H Aceptar  ;Cancelar" defa wop
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
   IF WSALIDA = "I"
      SET DEVI TO PRINT
   ELSE
      SET DEVI TO SCRE
   ENDIF
   SELECT AFITITU
   DO WHILE .NOT.EOF()
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
      DO WHILE .NOT. EOF() .AND. AFITITU.CEDTITU=AFIAFI.CEDTITU
         STORE WLINEA+1 TO WLINEA
         IF WLINEA >=WSALTO
            STORE WPAGINA + 1 TO WPAGINA
            IF WSALIDA = "M"
               if WPAGINA <> 1
                  STORE "OPRIMA <ENTER> PARA CONTINUAR o <ESC> PARA SALIR" TO WTEXT
                  DO AVISO WITH WTEXT
                  IF LASTKEY()=27
                     EXIT
                  ENDIF
               endif
               @ 0,0 clear
            ENDIF
            IF WSALIDA = "M"
               @ 0,0 CLEAR TO 24,79
               @ 0,0 SAY QQWW
            ELSE
               @ 0,0 SAY CHR(14)+QQWW
            ENDIF
            @ 1,60 SAY "PAGINA:"+STR(WPAGINA,4)
            @ 2,00 SAY "LISTADO DE AFILIADOS (Carga Familiar) DEL TITULAR"
            @ 2,60 SAY "FECHA :"+DTOC(DATE())
            @ 3,00 SAY "ORGANIZACION:"+XORGA

            @ 5,00 SAY "CI.TITULAR"
            @ 5,11 SAY "No"
            @ 5,14 SAY "NOMBRE COMPLETO"
            @ 5,53 SAY "NACIMIENTO"
            @ 5,64 SAY "S"
            @ 5,67 SAY "PARENTESCO"
            @ 6,00 SAY "----------"
            @ 6,11 SAY "--"
            @ 6,14 SAY "-----------------------------------"
            @ 6,53 SAY "----------"
            @ 6,64 SAY "-"
            @ 6,67 SAY "----------"
            STORE 7 TO WLINEA
         ENDIF
         SELECT AFIAFI
         IF PARENTESCO = "00"
            @ WLINEA,00 SAY REPL("*",80)
            STORE WLINEA+1 TO WLINEA
            @ WLINEA,00 SAY CEDTITU
         ENDIF
         @ WLINEA,11 SAY carga
         @ WLINEA,14 SAY rtrim(papellido)+" "+substr(sapellido,1,1)+", "+rtrim(pnombre)
         @ WLINEA,53 SAY dtoc(nacimiento)
         @ WLINEA,64 SAY sexo
         @ WLINEA,67 SAY afiparen.descri
         SELECT AFIAFI
         SKIP
      ENDDO
      IF LASTKEY()=27
         EXIT
      ENDIF
      SELECT AFITITU
      SKIP
   ENDDO
   IF WSALIDA = "M"
      STORE "OPRIMA <ENTER> PARA FINALIZAR" TO WTEXT
      DO AVISO WITH WTEXT
   ELSE
      EJECT
      SET DEVI TO SCRE
   ENDIF
ENDDO
RETURN

