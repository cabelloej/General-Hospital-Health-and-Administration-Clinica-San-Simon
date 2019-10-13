SELECT CITCIT
SAVE SCRE TO WSCRREP
DO WHILE .T.
   RESTORE SCRE FROM WSCRREP
   *SHOW MENU MENUCIT
   @ 5,0 TO 12,40 DOUBLE
   @ 5,5 SAY "< PRE-MORBILIDAD (CITADOS) >"
   @ 6,1 CLEAR TO 11,39
   *STORE 0 TO WTOTAL
   STORE SPACE(LEN(CITCIT.MEDICO)) TO XMEDICO
   STORE DATE()                    TO XDESDE
   @ 07,1 say "MEDICO      :"
   @ 09,1 say "FECHA       :"
   @ 07,14 GET XMEDICO
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   IF XMEDICO=SPACE(LEN(CITCIT.MEDICO))
      STORE "TODOS" TO WMEDICODES
   ELSE
      STORE "  "    TO WMEDICODES
   ENDIF
   @ 07,20 SAY WMEDICODES
   @ 09,15 GET XDESDE
   READ
   IF XDESDE=CTOD("  -  -    ")
      LOOP
   ENDIF
   STORE 0   TO WPAGINA
   STORE 100 TO WLINEA
   STORE 60          TO WSALTO
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
   
   SET DEVI TO PRINT
   *HIDE MENU MENUCIT
   STORE "***" TO WRUPMED
   SELECT CITCIT
   *SET ORDER TO 1
   SET ORDER TO 6
   IF XMEDICO<>SPACE(LEN(CITCIT.MEDICO))
      SEEK XMEDICO
   ELSE
      GO TOP
   ENDIF
   STORE RECNO() TO WRECSTART

   DO WHILE .NOT. EOF()
      *** FILTROS
      IF XMEDICO<>SPACE(LEN(CITCIT.MEDICO)) .AND. XMEDICO <> MEDICO
         EXIT
         *SELECT CITCIT
         *SKIP
         *LOOP
      ENDIF
      IF FECHA<>XDESDE
         SELECT CITCIT
         SKIP
         LOOP
      ENDIF
      IF MEDICO <> WRUPMED
         STORE 100    TO WLINEA
         STORE MEDICO TO WRUPMED
         STORE .T.    TO WFLAGMED
      ELSE
         STORE .F.    TO WFLAGMED
      ENDIF
      *** FIN FILTROS
      STORE WLINEA+1 TO WLINEA
      DO SALTO
      STORE SPACE(30) TO WNOMBRE
      STORE SPACE(30) TO WHISTORIA
      STORE SPACE(30) TO WDIRE
      STORE 0         TO WEDAD
      DO ARMANOM
      STORE SPACE(14) TO WXCODPAC
      DO ARMACOD
      SELECT CITCIT
      @ WLINEA , 00 SAY CHR(15)
      @ WLINEA , 00 SAY OBSERVA
      @ WLINEA , 16 SAY SUBSTR(WNOMBRE,1,30)
      @ WLINEA , 47 SAY SUBSTR(WDIRE,1,39)
      @ WLINEA , 88 SAY CITCIT.TIPCIT 
      IF INT(WEDAD)>0
         @ WLINEA , 92 SAY INT(WEDAD) PICTURE "99"
      ELSE
         @ WLINEA , 97 SAY (WEDAD-INT(WEDAD))*12 PICTURE "99"
      ENDIF
      STORE WLINEA+5 TO WLINEA
      DO SALTO
      @ WLINEA ,00  SAY REPLICATE("-",132)
      SELECT CITCIT
      SKIP
   ENDDO
   EJECT
   SET DEVI TO SCRE
ENDDO
RETURN
***************
PROCEDURE SALTO
***************
      IF WLINEA >=WSALTO
         STORE WPAGINA + 1 TO WPAGINA
         @ 0,0 SAY CHR(18)
         @ 0,0 SAY CHR(14)+QQWW
         @ 1,00 SAY "PRE-MORBILIDAD (CITADOS)"
         @ 1,60 SAY "PAGINA:"+STR(WPAGINA,4)
         @ 2,60 SAY "FECHA :"+DTOC(XDESDE)
         @ 3,00 SAY "CITAS DEL MEDICO: "+ALLTRIM(SYSMED.NOMBRE)
         @ 4,00 SAY "ESPECIALIDAD    : "+ALLTRIM(SYSESP.DESCRI)
         @ 6,00  SAY CHR(15)
         @ 6,00  SAY "OBSERVACION"
         @ 6,16  SAY "PACIENTE"
         @ 6,47  SAY "DIRECCION"
         @ 6,88  SAY "P/C"
         @ 6,92  SAY "A¥OS" 
         @ 6,97  SAY "MESES"
         @ 6,103 SAY "IMPRESION DIAGNOSTICA"
         @ 7,00  SAY "---------------"
         @ 7,16  SAY "------------------------------"
         @ 7,47  SAY "----------------------------------------"
         @ 7,88  SAY "---"
         @ 7,92  SAY "----"
         @ 7,97  SAY "-----"
         @ 7,103 SAY "-----------------------------"
         STORE 8 TO WLINEA
      ENDIF
      RETURN


