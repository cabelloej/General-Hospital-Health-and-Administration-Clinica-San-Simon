SET TALK OFF
SET ECHO OFF
DEFI WIND WINREPLIS FROM 10,10 TO 16,70; 
          TITLE "IMPRIMIR LISTA PACIENTES EVENTUALES";
          DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WINREPLIS

STORE SPACE(1) TO WCODFILPRE
@ 00,01 SAY "NIVEL DE PRECIO:" 
@ 00,20 GET WCODFILPRE 
READ
IF LASTKEY()=27
   RELE WIND WINREPLIS
   RETURN
ENDIF

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
SELECT SYSPAC
STORE RECNO() TO WSTARTREC
SET DEVI TO PRINT
DO SALTO
GO TOP
DO WHILE .NOT. EOF()
   IF WCODFILPRE<>SPACE(1).AND.WCODFILPRE<>SYSPAC.NIVEL 
      SELECT SYSPAC
      SKIP
      LOOP
   ENDIF
   STORE WLINE + 1 TO WLINE
   IF WLINE > 55
      DO SALTO
   ENDIF
   @ WLINE,00     SAY CODPAC  
   @ WLINE,15     SAY RTRIM(PAPELLIDO)+" "+RTRIM(SAPELLIDO)+RTRIM(PNOMBRE)+RTRIM(SNOMBRE)
   @ WLINE,55     SAY SEXO   
   @ WLINE,60     SAY NACIMIENTO
   @ WLINE,72     SAY NIVEL
   @ WLINE,78     SAY DIRECCION
   SKIP
ENDDO
SET DEVI TO SCRE
GO WSTARTREC
RETURN
**********
PROC SALTO
**********
@ 00,00  SAY CHR(18)+CHR(14)+QQWW
@ 01,00  SAY CHR(18)+"Lista de pacientes eventuales"
@ 03,00  SAY CHR(15)
@ 03,00  SAY "Codigo"
@ 03,15  SAY "Nombre"
@ 03,55  SAY "Sexo"         
@ 03,60  SAY "Nacimiento"
@ 03,72  SAY "Nivel"
@ 03,78  SAY "Direccion"
@ 04,00  SAY "--------------"
@ 04,05  SAY "----------------------------------------"
@ 04,55  SAY "-"  
@ 04,60  SAY "----------"
@ 04,72  SAY "-"  
@ 04,78  SAY "----------------------------------------"

STORE 5 TO WLINE
RETURN
