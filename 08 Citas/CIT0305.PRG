SELECT CITPAC
SAVE SCRE TO WSCRREP
DO WHILE .T.
   RESTORE SCRE FROM WSCRREP
   SHOW MENU MENUCIT
   @ 5,0 TO 13,40 DOUBLE
   @ 5,5 SAY "< PACIENTES NO AFILIADOS >"
   @ 6,1 CLEAR TO 12,39
   *STORE 0 TO WTOTAL
   STORE SPACE(LEN(CITPAC.CODPAC)) TO XCODPAC
   @ 07,1 say "CODIGO      :"
   @ 09,1 say "SALIDA (M/I):"
   @ 07,14 GET XCODPAC
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   IF XCODPAC=SPACE(LEN(CITPAC.CODPAC))
      STORE "TODOS" TO WCODPACDES
   ELSE
      STORE "  "    TO WCODPACDES
   ENDIF
   @ 07,20 SAY WCODPACDES
   store "Monitor" to wop
   do while .t.
      @ 09,15  get wop pict "@*H Monitor   ;Impresora" defa wop
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
   @ 09,15 SAY SPACE(24)
   @ 09,15 SAY WSALIDES
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
   IF WSALIDA = "I"
      SET DEVI TO PRINT
   ELSE
      SET DEVI TO SCRE
   ENDIF
   HIDE MENU MENUCIT
   SELECT CITPAC
   GO TOP
   DO WHILE .NOT. EOF()
      *** FILTROS
      IF XCODPAC<>SPACE(LEN(CITPAC.CODPAC)) .AND. XCODPAC <> CODPAC
         SELECT CITPAC
         SKIP
         LOOP
      ENDIF
      *** FIN FILTROS
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
         @ 2,00 SAY "LISTADO DE PACIENTES NO AFLIADOS"
         @ 2,60 SAY "FECHA :"+DTOC(DATE())
         @ 4,00 SAY "CODIGO"
         @ 4,20 SAY "NOMBRE"
         @ 5,00 SAY "--------------"
         @ 5,20 SAY "------------------------------"
         STORE 6 TO WLINEA
      ENDIF
      @ WLINEA , 00 SAY CODPAC
      @ WLINEA , 20 SAY ALLTRIM(PAPELLIDO)+", "+ALLTRIM(PNOMBRE)
      SELECT CITPAC
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