SELECT SYSCAMA
DEFI WIND BRCAM FROM librcam,cibrcam TO librcam+10,cibrcam+40 ;
                TITLE " CAMAS " ;
                FOOTER " F1=Inc,F2=Mod,F3=Eli,F4=Bus,ESC=Sel ";
                DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND BRCAM
ON KEY LABEL F1 DO BRINC
ON KEY LABEL F2 DO BRMOD
ON KEY LABEL F3 DO BRELI
ON KEY LABEL F4 DO BRBUS
BROWSE FIELDS CAMA:H="CAMA", DESCRI:H="DESCRIPCION";
              NOAPPEND NODELETE NOEDIT NOMENU NOOPTIMIZE REST SAVE IN WINDOW BRCAM
RELEASE WIND BRCAM
RETURN
***********************
***                 ***
***RUTINAS DE BRCAM ***
***                 ***
***********************
PROCEDURE BRINC
DEFI WIND WINCCAM FROM librcam+5,cibrcam+10 TO librcam+10,cibrcam+56;
                  TITLE " INCLUIR CAMA " DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WINCCAM
DO WHILE .T.
   SCAT MEMV BLANK
   @ 00,00 CLEAR
   @ 00,01 SAY "CAMA        :"
   @ 01,01 SAY "DESCRIPCION :"
   @ 00,15 GET M.CAMA
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   IF LEN(ALLTRIM(M.CAMA))=0
      LOOP
   ENDIF
   SEEK M.CAMA
   IF FOUND()
      @ 01,15 SAY DESCRI
      STORE "YA EXISTE, VERIFIQUE" TO WTEXT
      DO AVISO WITH WTEXT
      LOOP
   ELSE
      @ 01,15 GET M.DESCRI
      READ
      *** INICIO RUTINA DE ACEPTAR-CANCELAR
      store 1 to wop
      do while .t.
         @ 03,12  get wop pict "@*H Aceptar;Cancelar" defa wop
         read
         if lastkey()=13
            exit
         endif
      enddo
      *** FIN  RUTINA ACEPTAR-CANCELAR
      if wop=1
         if filloc()
            append blank
            gath memvar
            unlock all
         else
            store "OPERACION CANCELADA, REINTENTE" to wtext
            do aviso with wtext
         endif
      endif
   ENDIF
ENDDO
RELEASE WIND WINCCAM
RETURN
***
PROCEDURE BRMOD
DEFI WIND WMODCAM FROM librcam+5,cibrcam+10 TO librcam+10,cibrcam+56;
                  TITLE " MODIFICAR CAMA " DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WMODCAM
SCAT MEMVAR
@ 00,01 SAY "CAMA        :"
@ 01,01 SAY "DESCRIPCION :"
@ 00,15 SAY M.CAMA
@ 01,15 GET M.DESCRI
READ
*** INICIO RUTINA DE ACEPTAR-CANCELAR
store 1 to wop
do while .t.
   @ 03,12  get wop pict "@*H Aceptar;Cancelar" defa wop
   read
   if lastkey()=13
      exit
   endif
enddo
*** FIN  RUTINA ACEPTAR-CANCELAR
if wop=1
   if recloc()
      gath memvar
      unlock all
   else
      store "OPERACION CANCELADA, REINTENTE" to wtext
      do aviso with wtext
   endif
endif
RELEASE WIND WMODCAM
RETURN
***
PROCEDURE BRELI
DEFI WIND WELICAM FROM librcam+5,cibrcam+10 TO librcam+10,cibrcam+56;
                  TITLE " ELIMINAR CAMA " DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WELICAM
SCAT MEMVAR
@ 00,01 SAY "CAMA        :"
@ 01,01 SAY "DESCRIPCION :"
@ 00,15 SAY M.CAMA
@ 01,15 SAY M.DESCRI
*** INICIO RUTINA DE ACEPTAR-CANCELAR
store 2 to wop
do while .t.
   @ 03,12  get wop pict "@*H Aceptar;Cancelar" defa wop
   read
   if lastkey()=13
      exit
   endif
enddo
*** FIN  RUTINA ACEPTAR-CANCELAR
if wop=1
   if recloc()
      delete
      unlock all
   else
      store "OPERACION CANCELADA, REINTENTE" to wtext
      do aviso with wtext
   endif
endif
RELEASE WIND WELICAM
RETURN
***
PROCEDURE BRBUS
DEFI WIND WBUSCAM FROM librcam+5,cibrcam+10 TO librcam+10,cibrcam+56;
                  TITLE " BUSCAR CAMA " DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WBUSCAM
DO WHILE .T.
   SCAT MEMV BLANK
   @ 00,01 SAY "CAMA        :"
   @ 01,01 SAY "DESCRIPCION :"
   @ 00,15 GET M.CAMA
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   IF LEN(ALLTRIM(M.CAMA))=0
      LOOP
   ENDIF
   SEEK M.CAMA
   IF FOUND()
      EXIT
   ELSE
      STORE "NO REGISTRADO, VERIFIQUE" TO WTEXT
      DO AVISO WITH WTEXT
   ENDIF
ENDDO
RELEASE WIND WBUSCAM
RETURN
***
PROCEDURE BRORD
* SET ORDER TO ??
RETURN

