SELECT SYSMED
SAVE SCRE TO WSCRREP
DO WHILE .T.
   RESTORE SCRE FROM WSCRREP
   SHOW MENU MENUCIT
   @ 5,0 TO 13,40 DOUBLE
   @ 5,5 SAY "< MEDICOS ACTIVOS>"
   @ 6,1 CLEAR TO 12,39
   *STORE 0 TO WTOTAL
   STORE SPACE(LEN(SYSMED.MEDICO)) TO XMEDICO
   @ 07,1 say "MEDICO      :"
   @ 09,1 say "SALIDA (M/I):"
   @ 07,14 GET XMEDICO
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   IF XMEDICO=SPACE(LEN(SYSMED.MEDICO))
      STORE "TODOS" TO WMEDICODES
   ELSE
      STORE "  "    TO WMEDICODES
   ENDIF
   @ 07,20 SAY WMEDICODES
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
   SELECT SYSMED
   GO TOP
   DO WHILE .NOT. EOF()
      *** FILTROS
      IF XMEDICO<>SPACE(LEN(SYSMED.MEDICO)) .AND. XMEDICO <> MEDICO
         SELECT SYSMED
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
         @ 2,00 SAY "LISTADO DE MEDICOS ACTIVOS"
         @ 2,60 SAY "FECHA :"+DTOC(DATE())
         @ 4,00 SAY "MED."
         @ 4,04 SAY "NOMBRE"
         @ 4,36 SAY "ESP."
         @ 4,41 SAY "1ra.C."
         @ 4,48 SAY "2da.C."
         @ 4,55 SAY "Bs. CITA"
         @ 4,67 SAY "COD.SER."

         @ 5,00 SAY "---"
         @ 5,04 SAY "------------------------------"
         @ 5,36 SAY "--"
         @ 5,41 SAY "---"
         @ 5,48 SAY "---"
         @ 5,55 SAY "----------"
         @ 5,67 SAY "---------"
         STORE 6 TO WLINEA
      ENDIF
      @ WLINEA , 00 SAY MEDICO
      @ WLINEA , 04 SAY NOMBRE
      @ WLINEA , 36 SAY ESPECI
      @ WLINEA , 41 SAY CON1MIN PICTURE "999"
      @ WLINEA , 48 SAY CON2MIN PICTURE "999"
      *@ WLINEA , 55 SAY CONPRE  PICTURE "9999999.99"
      *@ WLINEA , 67 SAY SERVICIO
      SELECT SYSMED
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