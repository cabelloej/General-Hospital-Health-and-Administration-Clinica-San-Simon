SELECT CITCIT
SAVE SCRE TO WSCRREP
DO WHILE .T.
   RESTORE SCRE FROM WSCRREP
   *SHOW MENU MENUCIT
   @ 5,0 TO 16,40 DOUBLE
   @ 5,5 SAY "< CITAS POR PACIENTE >"
   @ 6,1 CLEAR TO 15,39
   *STORE 0 TO WTOTAL
   STORE SPACE(10)                 TO XCODPAC1
   STORE 0                         TO XCODPAC2
   STORE SPACE(14)                 TO WCODPAC
   STORE CTOD("  -  -    ")        TO XDESDE
   STORE CTOD("  -  -    ")        TO XHASTA
   @ 07,1 say "PACIENTE    :          -    "
   @ 09,1 say "DESDE       :"
   @ 11,1 say "HASTA       :"
   @ 13,1 say "SALIDA (M/I):"
   @ 07,14 GET XCODPAC1
   READ
   IF XCODPAC1<>SPACE(10)
      @ 07,25 GET XCODPAC2 PICTURE "9999" VALID VALPAC()
      READ
   ENDIF
   STORE WCODPAC TO XCODPAC
   IF LASTKEY()=27
      SELECT CITCIT
      SET ORDER TO 1
      EXIT
   ENDIF
   IF XCODPAC=SPACE(LEN(CITCIT.CODPAC))
      STORE "TODOS" TO WCODPACDES
   ELSE
      STORE "  "    TO WCODPACDES
   ENDIF
   @ 07,20 SAY WCODPACDES
   @ 09,15 GET XDESDE
   @ 11,15 GET XHASTA
   READ
   IF XDESDE>XHASTA
      STORE "ERROR EN FECHAS, VERIFIQUE." TO WTEXT
      DO AVISO WITH WTEXT
      LOOP
   ENDIF
   store "Monitor" to wop
   do while .t.
      @ 13,15  get wop pict "@*H Monitor   ;Impresora" defa wop
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
   @ 13,15 SAY SPACE(24)
   @ 13,15 SAY WSALIDES
   store 1 to wop
   do while .t.
      @ 15,8  get wop pict "@*H Aceptar  ;Cancelar" defa wop
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
   *HIDE MENU MENUCIT

   STORE "***" TO WRUPPAC
   SELECT CITCIT
   SET ORDER TO 2
   IF XCODPAC<>SPACE(LEN(CITCIT.CODPAC))
      SEEK XCODPAC
   ELSE
      GO TOP
   ENDIF
   DO WHILE .NOT. EOF()
      *** FILTROS
      IF XCODPAC<>SPACE(LEN(CITCIT.CODPAC)) .AND. XCODPAC <> CODPAC
         EXIT
         *SELECT CITCIT
         *SKIP
         *LOOP
      ENDIF
      IF XDESDE<>CTOD("  -  -    ").AND.(FECHA<XDESDE.OR.FECHA>XHASTA)
         SELECT CITCIT
         SKIP
         LOOP
      ENDIF
      IF CODPAC <> WRUPPAC
         STORE 100    TO WLINEA
         STORE CODPAC TO WRUPPAC
         STORE .T.    TO WFLAGMED
      ELSE
         STORE .F.    TO WFLAGMED
      ENDIF
      *** FIN FILTROS
      STORE SPACE(30) TO WNOMBRE
      DO ARMANOM
      STORE SPACE(14) TO WXCODPAC
      DO ARMACOD
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
         @ 2,00 SAY "CITAS PACIENTE: "+ALLTRIM(CITCIT.CODPAC)+" - "+WNOMBRE
         @ 2,60 SAY "FECHA :"+DTOC(DATE())
         @ 4,00 SAY "FECHA"
         @ 4,12 SAY "HORA"
         @ 4,20 SAY "T.C."
         @ 4,25 SAY "DOCTOR"
         @ 4,55 SAY "CONSULTORIO"
         @ 5,00 SAY REPLICATE ("-",80)
         STORE 6 TO WLINEA
      ENDIF
      SELECT CITCIT
      @ WLINEA , 00 SAY CITCIT.FECHA
      @ WLINEA , 12 SAY STR(CITCIT.HORA,2)+":"+STR(CITCIT.MINUTO,2)
      @ WLINEA , 20 SAY CITCIT.TIPCIT
      @ WLINEA , 25 SAY SYSMED.NOMBRE
      @ WLINEA , 55 SAY CITCIT.CONSUL
      SELECT CITCIT
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
****************
PROCEDURE VALPAC
IF XCODPAC1<>SPACE(10)
   STORE XCODPAC1+STR(XCODPAC2,4) TO WCODPAC
   SELECT AFIAFI
   SEEK WCODPAC
   IF .NOT. FOUND()
      STORE "N" TO WTIPPAC
      SELECT CITPAC
      SEEK WCODPAC
      IF .NOT. FOUND()
         STORE "PACIENTE NO REGISTRADO, FAVOR REINTENTE" TO WTEXT
         DO AVISO WITH WTEXT
         RETURN .F.
      ELSE
         STORE ALLTRIM(PAPELLIDO)+", "+ALLTRIM(PNOMBRE)   TO WNOMBRE
      ENDIF
   ELSE
      STORE "A" TO WTIPPAC
      STORE ALLTRIM(PAPELLIDO)+", "+ALLTRIM(PNOMBRE) TO WNOMBRE
   ENDIF
   RETURN .T.
ELSE
   RETURN .T.
ENDIF
**************
