*** INI CONTROL DE ACCESO
STORE "AFI0313" TO WPROGRAMA
STORE SPACE(1)  TO WACCESO
STORE SPACE(1)  TO WFILTRO
DO CHKACC WITH WUSERCODE,WPROGRAMA,WACCESO,WFILTRO
IF WACCESO=" "
   RETURN
ENDIF
*** FIN CONTROL DE ACCESO
DEFI WIND WINDPRIN FROM 12,04 TO 14,72 DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTIVATE WIND WINDPRIN
store 1 to wop
DO WHILE .T.
   @ 00,02 SAY " SELECCIONE EL MODELO DE CARNET DESEADO ";
   GET WOP pict "@*H Resumido ;Detallado" defa wop
   READ
   IF LASTKEY()=13
      EXIT
   ENDIF
ENDDO
RELE WIND WINDPRIN
IF WOP=1
   DO AFI0313A
ELSE
   DO AFI0313B
ENDIF
RETURN
