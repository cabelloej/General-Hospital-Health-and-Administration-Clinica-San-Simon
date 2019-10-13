SAVE SCRE TO WSCRREP
DO WHILE .T.
   RESTORE SCRE FROM WSCRREP
   *SHOW MENU MENUCIT
   @ 5,0 TO 12,40 DOUBLE
   @ 5,5 SAY "< MORBILIDAD POR MEDICO >"
   @ 6,1 CLEAR TO 11,39
   *STORE 0 TO WTOTAL
   STORE SPACE(8) TO XMEDICO
   STORE DATE()   TO XDESDE
   @ 07,1 say "MEDICO      :"
   @ 09,1 say "FECHA       :"
   @ 07,15 GET XMEDICO
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   IF XMEDICO=SPACE(8)
      LOOP
   ENDIF
   SELECT SYSMED
   GO TOP
   LOCATE FOR USERCODE = XMEDICO
   IF FOUND()
      STORE NOMBRE TO WDESMED
      SELECT SYSESP
      SEEK SYSMED.ESPECI
      IF FOUND()
         STORE DESCRI    TO WDESESP
      ELSE
         STORE "NO REG." TO WDESESP
      ENDIF
   ELSE
      LOOP
   ENDIF
   @ 07,25 SAY WDESMED+"("+RTRIM(WDESESP)+")"
   @ 09,15 GET XDESDE
   READ
   IF XDESDE=CTOD("  -  -    ")
      LOOP
   ENDIF
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
   
   SET DEVI  TO PRINT
   STORE 0   TO WPAGINA
   STORE 100 TO WLINEA
   STORE 60  TO WSALTO
   STORE 0   TO WCANPAC
   SELECT SERDCGE
   SET ORDER TO SERDCGE
   GO TOP
   DO WHILE .NOT. EOF()
      IF XDESDE<>ELABORADO
         SELECT SERDCGE
         SKIP
         LOOP
      ENDIF
      SELECT SERDCDE
      SEEK SERDCGE.NUMERO
      DO WHILE .NOT. EOF() .AND. SERDCGE.NUMERO=SERDCDE.NUMERO
         IF EJECUTOR<>XMEDICO
            SELECT SERDCDE
            SKIP
            LOOP
         ENDIF
         STORE WLINEA+1 TO WLINEA
         DO SALTO
         STORE SPACE(30)      TO WNOMBRE
         STORE SPACE(30)      TO WHISTORIA
         STORE SPACE(30)      TO WDIRE
         STORE 0              TO WEDAD
         DO ARMANOM
         STORE SERDCGE.CODPAC TO WCODPAC
         STORE SPACE(14)      TO WXCODPAC
         DO ARMACOD
         SELECT SERDCDE
         @ WLINEA , 00 SAY CHR(15)
         @ WLINEA , 00 SAY ITEM
         @ WLINEA , 16 SAY SUBSTR(WNOMBRE,1,30)
         @ WLINEA , 47 SAY SUBSTR(WDIRE,1,39)
         IF INT(WEDAD)>0
            @ WLINEA , 92 SAY INT(WEDAD) PICTURE "99"
         ELSE
            @ WLINEA , 97 SAY (WEDAD-INT(WEDAD))*12 PICTURE "99"
         ENDIF
         STORE WCANPAC + 1 TO WCANPAC
         STORE WLINEA+5 TO WLINEA
         DO SALTO
         @ WLINEA ,00  SAY REPLICATE("-",132)
         SELECT SERDCDE
         SKIP
      ENDDO
      SELECT SERDCGE
      SKIP
   ENDDO
   STORE WLINEA+2 TO WLINEA
   DO SALTO
   @ WLINEA ,00  SAY "No. DE PACIENTES :"+STR(WCANPAC,5)
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
         @ 1,00 SAY "MORBILIDAD POR MEDICO (SOLICITUDES)"
         @ 1,60 SAY "PAGINA:"+STR(WPAGINA,4)
         @ 2,60 SAY "FECHA :"+DTOC(XDESDE)
         @ 3,00 SAY "SERVICIOS MEDICO: "+WDESMED
         @ 4,00 SAY "ESPECIALIDAD    : "+WDESESP
         @ 6,00  SAY CHR(15)
         @ 6,00  SAY "SERVICIO"
         @ 6,16  SAY "PACIENTE"
         @ 6,47  SAY "DIRECCION"
         @ 6,92  SAY "A¥OS" 
         @ 6,97  SAY "MESES"
         @ 6,103 SAY "IMPRESION DIAGNOSTICA"
         @ 7,00  SAY "---------------"
         @ 7,16  SAY "------------------------------"
         @ 7,47  SAY "----------------------------------------"
         @ 7,88  SAY "---"
         @ 7,92  SAY "--"
         @ 7,97  SAY "----"
         @ 7,103 SAY "--------------------------------"
         STORE 8 TO WLINEA
      ENDIF
      RETURN


