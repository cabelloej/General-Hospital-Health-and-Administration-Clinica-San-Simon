SAVE SCRE TO WSCRREP
DO WHILE .T.
   RESTORE SCRE FROM WSCRREP
   *SHOW MENU MENUCIT
   @ 5,0 TO 14,40 DOUBLE
   @ 5,5 SAY "< MORBILIDAD POR AREA >"
   @ 6,1 CLEAR TO 11,39
   *STORE 0 TO WTOTAL
   STORE SPACE(3) TO XAREA   
   STORE DATE()   TO XDESDE
   STORE DATE()   TO XHASTA
   @ 07,1 say "AREA        :"
   @ 09,1 say "DESDE       :"
   @ 11,1 say "HASTA       :"  
   @ 07,15 GET XAREA   
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   IF XAREA=SPACE(3)
      LOOP
   ENDIF
   SELECT SYSPTO
   SEEK XAREA
   IF FOUND()
      STORE DESCRI TO WDESAREA
   ELSE
      LOOP
   ENDIF
   @ 07,20 SAY WDESAREA
   @ 09,15 GET XDESDE
   READ
   IF XDESDE=CTOD("  -  -    ")
      LOOP
   ENDIF
   @ 11,15 GET XHASTA
   READ
   IF XHASTA=CTOD("  -  -    ")
      LOOP
   ENDIF
   IF XDESDE>XHASTA
      LOOP
   ENDIF

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
   
   SET DEVI  TO PRINT
   STORE 0   TO WPAGINA
   STORE 100 TO WLINEA
   STORE 60  TO WSALTO
   STORE 0   TO WCANPAC
   SELECT SERDCGE
   SET ORDER TO SERDCGE
   GO TOP
   DO WHILE .NOT. EOF()
      IF ELABORADO<XDESDE
         SELECT SERDCGE
         SKIP
         LOOP
      ENDIF
      IF ELABORADO>XHASTA
         SELECT SERDCGE
         EXIT
      ENDIF
      IF PROVEEDOR<>XAREA
         SELECT SERDCGE
         SKIP
         LOOP
      ENDIF

      STORE SPACE(30)      TO WNOMBRE
      STORE SPACE(30)      TO WHISTORIA
      STORE SPACE(30)      TO WDIRE
      STORE 0              TO WEDAD
      DO ARMANOM
      STORE SERDCGE.CODPAC TO WCODPAC
      STORE SPACE(14)      TO WXCODPAC
      DO ARMACOD

      STORE WLINEA+1 TO WLINEA
      DO SALTO
      @ WLINEA , 00 SAY CHR(15)
      @ WLINEA , 00 SAY SUBSTR(WNOMBRE,1,30)
      @ WLINEA , 31 SAY SUBSTR(WDIRE,1,39)
      IF INT(WEDAD)>0
         @ WLINEA , 76 SAY INT(WEDAD) PICTURE "99"
      ELSE
         @ WLINEA , 81 SAY (WEDAD-INT(WEDAD))*12 PICTURE "99"
      ENDIF
      STORE WCANPAC + 1 TO WCANPAC
      SELECT SERDCDE
      SEEK SERDCGE.NUMERO
      DO WHILE .NOT. EOF() .AND. SERDCGE.NUMERO=SERDCDE.NUMERO
         IF TIPITEM="S"
            SELECT SYSSERVI
            SEEK SUBSTR(SERDCDE.ITEM,1,12)
            IF FOUND()
               @ WLINEA , 88 SAY SYSSERVI.DESCRI
            ELSE
               @ WLINEA , 88 SAY SERDCDE.ITEM
            ENDIF
            STORE WLINEA+1 TO WLINEA
            DO SALTO
         ENDIF
         SELECT SERDCDE
         SKIP
      ENDDO
      *STORE WLINEA+1 TO WLINEA  
      *DO SALTO
      *@ WLINEA ,00  SAY REPLICATE("-",132)
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
         @ 1,00 SAY "MORBILIDAD POR AREA (SOLICITUDES)"
         @ 1,60 SAY "PAGINA:"+STR(WPAGINA,4)
         @ 2,60 SAY "DESDE :"+DTOC(XDESDE)
         @ 3,00 SAY "SERVICIOS DEL AREA: "+WDESAREA 
         @ 3,60 SAY "HASTA :"+DTOC(XHASTA) 
         @ 6,00  SAY CHR(15)
         @ 6,00  SAY "PACIENTE"
         @ 6,31  SAY "DIRECCION"
         @ 6,76  SAY "A¥OS" 
         @ 6,81  SAY "MESES"
         @ 6,88  SAY "SERVICIO PRESTADO"
         @ 7,00  SAY "------------------------------"
         @ 7,31  SAY "----------------------------------------"
         @ 7,76  SAY "--"
         @ 7,81  SAY "----"
         @ 7,88  SAY "--------------------------------"
         STORE 8 TO WLINEA
      ENDIF
      RETURN


