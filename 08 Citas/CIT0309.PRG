SELECT CITCIT
SAVE SCRE TO WSCRREP
DO WHILE .T.
   RESTORE SCRE FROM WSCRREP
   *SHOW MENU MENUCIT
   @ 5,0 TO 16,40 DOUBLE
   @ 5,5 SAY "< CITAS POR CONSULTORIO >"
   @ 6,1 CLEAR TO 15,39
   *STORE 0 TO WTOTAL
   STORE SPACE(LEN(CITCIT.CONSUL)) TO XCONSUL
   STORE CTOD("  -  -    ")        TO XDESDE
   STORE CTOD("  -  -    ")        TO XHASTA
   @ 07,1 say "CONSULTORIO :"
   @ 09,1 say "DESDE       :"
   @ 11,1 say "HASTA       :"
   @ 13,1 say "SALIDA (M/I):"
   @ 07,14 GET XCONSUL
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   IF XCONSUL=SPACE(LEN(CITCIT.CONSUL))
      STORE "TODOS" TO WCONSULDES
   ELSE
      STORE "  "    TO WCONSULDES
   ENDIF
   @ 07,20 SAY WCONSULDES
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

   STORE "***" TO WRUPCON
   SELECT CITCIT
   SET ORDER TO 3
   IF XCONSUL<>SPACE(LEN(CITCIT.CONSUL))
      SEEK XCONSUL
   ELSE
      GO TOP
   ENDIF
   DO WHILE .NOT. EOF()
      *** FILTROS
      IF XCONSUL<>SPACE(LEN(CITCIT.CONSUL)) .AND. XCONSUL <> CONSUL
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
      IF CONSUL <> WRUPCON
         STORE 100    TO WLINEA
         STORE CONSUL TO WRUPCON
         STORE .T.    TO WFLAGCON
      ELSE
         STORE .F.    TO WFLAGCON
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
         @ 2,00 SAY "CITAS CONSULTORIO: "+CITCIT.CONSUL
         @ 2,60 SAY "FECHA :"+DTOC(DATE())
         @ 4,00 SAY "FECHA"
         @ 4,12 SAY "HORA"
         @ 4,20 SAY "T.C."
         @ 4,25 SAY "T.P."
         @ 4,30 SAY "PACIENTE"
         @ 4,77 SAY "MED"
         @ 5,00 SAY "----------"
         @ 5,12 SAY "-----"
         @ 5,20 SAY "----"
         @ 5,25 SAY "----"
         @ 5,30 SAY "--------------------------------------------"
         @ 5,77 SAY "---"
         STORE 6 TO WLINEA
      ENDIF
      STORE SPACE(30) TO WNOMBRE
      DO ARMANOM
      STORE SPACE(14) TO WXCODPAC
      DO ARMACOD
      SELECT CITCIT
      @ WLINEA , 00 SAY CITCIT.FECHA
      @ WLINEA , 12 SAY STR(CITCIT.HORA,2)+":"+STR(CITCIT.MINUTO,2)
      @ WLINEA , 20 SAY CITCIT.TIPCIT
      @ WLINEA , 25 SAY CITCIT.TIPPAC
      @ WLINEA , 30 SAY WXCODPAC
      @ WLINEA , 45 SAY SUBSTR(WNOMBRE,1,30)
      @ WLINEA , 77 SAY CITCIT.MEDICO
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
