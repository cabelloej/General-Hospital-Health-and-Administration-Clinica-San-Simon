SELECT AFITITU
SET ORDER TO AFITITU3
SAVE SCRE TO WSCRREP
DO WHILE .T.
   GO TOP
   STORE SPACE(30) TO WORGADES
   STORE SPACE(30) TO WNIV1DES
   STORE SPACE(30) TO WNIV2DES
   STORE SPACE(30) TO WNIV3DES
   RESTORE SCRE FROM WSCRREP
   SHOW MENU MENUAFI
   @ 5,0 TO 13,40 DOUBLE
   @ 5,5 SAY "< TITULARES POR ORG.-CLIENTE >"
   @ 6,1 CLEAR TO 12,39
   STORE 0 TO WTOTAL
   STORE SPACE(4) TO XORGA
   STORE SPACE(2) TO XNIVEL1
   STORE SPACE(2) TO XNIVEL2
   STORE SPACE(2) TO XNIVEL3
   @ 07,1 say "ORGANIZACION:"
   @ 08,1 say "NIVEL 1     :"
   @ 09,1 say "NIVEL 2     :"
   @ 10,1 say "NIVEL 3     :"
   @ 11,1 say "SALIDA (M/I):"
   @ 07,14 GET XORGA
   READ
   IF LASTKEY()=27
      SELECT AFITITU
      SET ORDER TO AFITITU1
      EXIT
   ENDIF
   IF XORGA<>SPACE(4)
      @ 08,14 GET XNIVEL1
      READ
      IF XNIVEL1<>SPACE(2)
         @ 09,14 GET XNIVEL2
         READ
         IF XNIVEL2<>SPACE(2)
            @ 10,14 GET XNIVEL3
            READ
         ENDIF
      ENDIF
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
      STORE 60          TO WSALTO
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
      @ 12,8  get wop pict "@*H Aceptar  ;Cancelar" defa wop
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
   IF XORGA<>SPACE(4)
      SEEK XORGA
      IF .NOT. FOUND()
         STORE "NO EXISTEN AFILIADOS DE ESTA ORGANIZACION-CLIENTE" TO WTEXT
         DO AVISO WITH WTEXT
         LOOP
      ENDIF
   ELSE
      GO TOP
   ENDIF
   IF WSALIDA = "I"
      SET DEVI TO PRINT
   ELSE
      SET DEVI TO SCRE
   ENDIF
   STORE "****" TO WRUPORGA
   STORE "**"   TO WRUPNIV1
   STORE "**"   TO WRUPNIV2
   STORE "**"   TO WRUPNIV3
   STORE WRUPORGA+WRUPNIV1+WRUPNIV2+WRUPNIV3 TO WRUPTURA
   DO WHILE .NOT.EOF()
      SELECT AFITITU
      *** FILTROS
      IF XORGA <> SPACE(4) .AND. XORGA  <> ORGA
         SKIP
         LOOP
      ENDIF
      IF XNIVEL1 <> SPACE(2) .AND. XNIVEL1  <> NIVORG1
         SKIP
         LOOP
      ENDIF
      IF XNIVEL2 <> SPACE(2) .AND. XNIVEL2  <> NIVORG2
         SKIP
         LOOP
      ENDIF
      IF XNIVEL3 <> SPACE(2) .AND. XNIVEL3  <> NIVORG3
         SKIP
         LOOP
      ENDIF
      STORE ORGA+NIVORG1+NIVORG2+NIVORG3 TO WORGANI
      IF WRUPTURA<>WORGANI
        DO RUPTURA
        STORE .T. TO WFLAGRUP
      ELSE
        STORE .F. TO WFLAGRUP
      ENDIF
      *** FIN FILTROS
      STORE WLINEA+1 TO WLINEA 
      IF (WLINEA>=WSALTO).OR.WFLAGRUP
         STORE .F. TO WFLAGRUP
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
         SELECT AFITITU
         @ 1,60 SAY "PAGINA:"+STR(WPAGINA,4)
         @ 2,00 SAY "TITULARES POR ORGANIZACION CLIENTE"
         @ 2,60 SAY "FECHA :"+DTOC(DATE())
         @ 3,00 SAY "ORGANIZACION:"+ORGA+" "+WORGADES
         @ 4,00 SAY "NIVEL 1     :"+NIVORG1+" "+wniv1des
         @ 5,00 SAY "NIVEL 2     :"+NIVORG2+" "+wniv2des
         @ 6,00 SAY "NIVEL 3     :"+NIVORG3+" "+wniv3des
         @ 8,05 SAY "CEDULA    "
         @ 8,17 SAY "PRIMER APELLIDO"
         @ 8,33 SAY "PRIMER NOMBRE  "
         @ 9,00 SAY "----"
         @ 9,05 SAY "----------"
         @ 9,17 SAY "---------------"
         @ 9,33 SAY "---------------"
         STORE 10 TO WLINEA
      ENDIF
      SELECT AFITITU
      @ WLINEA , 05 SAY CEDTITU
      @ WLINEA , 17 SAY RTRIM(PAPELLIDO)+" "+RTRIM(SAPELLIDO)+" "+RTRIM(PNOMBRE)
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
**************************************
PROCEDURE RUPTURA
STORE ORGA+NIVORG1+NIVORG2+NIVORG3 TO WRUPTURA
SELECT AFIORGA
SEEK SUBSTR(WRUPTURA,1,4)
IF FOUND()
   STORE DESCRI             TO WORGADES
ELSE
   STORE "NO REGISTRADO"    TO WORGADES
ENDIF
SEEK SUBSTR(WRUPTURA,1,6)
IF FOUND()
   STORE DESCRI             TO WNIV1DES
ELSE
   STORE "NO REGISTRADO"    TO WNIV1DES
ENDIF
SEEK SUBSTR(WRUPTURA,1,8)
IF FOUND()
   STORE DESCRI             TO WNIV2DES
ELSE
   STORE "NO REGISTRADO"    TO WNIV2DES
ENDIF
SEEK WRUPTURA
IF FOUND()
   STORE DESCRI             TO WNIV3DES
ELSE
   STORE "NO REGISTRADO"    TO WNIV3DES
ENDIF
RETURN
***************

