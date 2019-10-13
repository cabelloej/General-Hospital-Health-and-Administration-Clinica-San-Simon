SELECT CITOCU
SAVE SCRE TO WSCRREP
DO WHILE .T.
   RESTORE SCRE FROM WSCRREP
   SHOW MENU MENUCIT
   @ 5,0 TO 13,40 DOUBLE
   @ 5,5 SAY "< HORARIO CONSULTORIOS >"
   @ 6,1 CLEAR TO 12,39
   *STORE 0 TO WTOTAL
   STORE SPACE(LEN(SYSCON.CONSUL)) TO XCONSUL
   @ 07,1 say "CONSULTORIO :"
   @ 09,1 say "SALIDA (M/I):"
   @ 07,14 GET XCONSUL
   READ
   IF LASTKEY()=27
      SELECT CITOCU
      EXIT
   ENDIF
   IF XCONSUL=SPACE(LEN(SYSCON.CONSUL))
      STORE "TODOS" TO WCONSULDES
   ELSE
      STORE "  "    TO WCONSULDES
   ENDIF
   @ 07,20 SAY WCONSULDES
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
   SELECT CITOCU
   SET ORDER TO 1
   GO TOP
   DO WHILE .NOT. EOF()
      *** FILTROS
      IF XCONSUL<>SPACE(LEN(CITOCU.CONSUL)) .AND. XCONSUL <> CONSUL
         SELECT CITOCU
         SKIP
         LOOP
      ENDIF
      *** FIN FILTROS
      STORE WLINEA+1 TO WLINEA
      IF WLINEA>=WSALTO
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
         @ 2,00 SAY "LISTADO DE HORARIO DE CONSULTORIOS"
         @ 2,60 SAY "FECHA :"+DTOC(DATE())
         @ 4,00 SAY "CONS."
         @ 4,05 SAY "DESCRIPCION"
         @ 4,37 SAY "DIA"
         @ 4,47 SAY "MED."
         @ 4,57 SAY "DESDE"
         @ 4,67 SAY "HASTA"
         STORE 6 TO WLINEA
      ENDIF
      @ WLINEA , 00 SAY CONSUL
      @ WLINEA , 05 SAY SYSMED.NOMBRE
      @ WLINEA , 37 SAY DIA
      @ WLINEA , 47 SAY MEDICO
      @ WLINEA , 57 SAY STR(DESDEH,2)+":"+STR(DESDEM,2)
      @ WLINEA , 67 SAY STR(HASTAH,2)+":"+STR(HASTAM,2)
      SELECT CITOCU
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
**************
