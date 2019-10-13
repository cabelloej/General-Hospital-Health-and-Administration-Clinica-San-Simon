SET TALK OFF
SET ECHO OFF
DEFI WIND WINREPLIS FROM 10,10 TO 16,70; 
          TITLE "IMPRIMIR LISTA";
          DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WINREPLIS

store 1 to wop
do while .t.
   @ 04,20  get wop pict "@*H Aceptar;Cancelar" defa wop
   read
   if lastkey()=13
      exit
   endif
enddo
rele wind winreplis
if lastkey()=27.or.wop=2
   return
endif

STORE 0 TO WPAGE
STORE 0 TO WLINE
STORE RECNO() TO WSTARTREC
SET DEVI TO PRINT
DO SALTO
*SELECT 1
*USE SYSSERVI INDEX SYSSERVI
GO TOP
DO WHILE .NOT. EOF()
   STORE WLINE + 1 TO WLINE
   IF WLINE > 55
      DO SALTO
   ENDIF
   @ WLINE,00     SAY CODPTO  
   @ WLINE,14     SAY DESCRI 
   @ WLINE,55     SAY FIJO
   SKIP
ENDDO
SET DEVI TO SCRE
GO WSTARTREC
RETURN
**********
PROC SALTO
**********
@ 00,00  SAY CHR(18)+CHR(14)+QQWW
@ 01,00  SAY CHR(18)+"Lista de areas de servicio"
@ 03,00  SAY CHR(18)
@ 03,00  SAY "Codigo"
@ 03,14  SAY "Descripcion"
@ 03,55  SAY "Fija?"
@ 04,00  SAY "------------"
@ 04,14  SAY "----------------------------------------"
@ 04,55  SAY "--------"
STORE 5 TO WLINE
RETURN
