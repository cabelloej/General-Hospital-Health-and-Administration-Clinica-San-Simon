SELECT AFIACAD
SAVE SCRE TO WSCRREP
DO WHILE .T.
   RESTORE SCRE FROM WSCRREP
   SHOW MENU MENUAFI
   @ 5,0 TO 13,40 DOUBLE
   @ 5,5 SAY "< NIVEL ACADEMICO TITULARES >"
   @ 6,1 CLEAR TO 12,39
   *STORE 0 TO WTOTAL
   STORE SPACE(LEN(AFIACAD.NIVACA)) TO XNIVEL
   @ 07,1 say "NIVEL ACAD. :"
   @ 09,1 say "SALIDA (M/I):"
   @ 07,14 GET XNIVEL
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   IF XNIVEL= SPACE(2)
      STORE "TODOS" TO WNIVELDES
   ELSE
      STORE "  "    TO WNIVELDES
   ENDIF
   @ 07,20 SAY WNIVELDES
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
   HIDE MENU MENUAFI
   SELECT AFIACAD
   GO TOP
   DO WHILE .NOT. EOF()
      *** FILTROS
      IF XNIVEL <> SPACE(2) .AND. XNIVEL <> NIVACA
         SELECT AFIACAD
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
         @ 2,00 SAY "LISTADO DE NIVELES ACADEMICOS DE TITULARES"
         @ 2,60 SAY "FECHA :"+DTOC(DATE())
         @ 4,00 SAY "NIVEL ACADEMICO"
         @ 4,20 SAY "DESCRIPCION"
         @ 5,00 SAY "---------------"
         @ 5,20 SAY "------------------------------"
         STORE 6 TO WLINEA
      ENDIF
      @ WLINEA , 00 SAY NIVACA
      @ WLINEA , 20 SAY DESCRI
      SELECT AFIACAD
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