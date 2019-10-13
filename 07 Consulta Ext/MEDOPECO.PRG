*** decide que hacer con data existente en apertura de archivos temporales
store .f. to wflagcrea
*hisgen
if file(wdbfhg)
   select 8
   use  &wdbfhg
   if .not.eof()
      store codpac to fcodpac
      use
      if fcodpac<>wcodpac
         *** GUARDAR-ABANDONAR
         DEFI WIND WINDPRIN FROM 12,00 TO 14,79 DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
         ACTIVATE WIND WINDPRIN
         store 1 to wop
         DO WHILE .T.
            @ 00,01 SAY "CONSULTA ANTERIOR NO HA SIDO GUARDADA EN HISTORIA. ";
            GET WOP pict "@*H Guardar  ;Abandonar" defa wop
            READ
            IF LASTKEY()=13
               EXIT
            ENDIF
         ENDDO
         RELE WIND WINDPRIN
         IF WOP=1
            DO MEDGRACO
         ENDIF
         STORE .T. TO WFLAGCREA
      endif
   else
      store .t. to wflagcrea
   endif
else
   store .t. to wflagcrea
endif
***

*** PACIENTES
select 1
use syspac index syspac,syspac2,syspac3
select 2
use afiafi index afiafi1,afiafi2,afiafi3,afiafi4
select 3
use afiparen index afiparen
*** HISTORIA
select 4
use hisgru index hisgru
select 5
use hissub index hissub
select 6
use hisren index hisren
select 7
use histab index histab
if .not.wflagcrea
   *** abre temp general normalmente
   select 8
   use &wdbfhg index &widxhg1, &widxhg1 alias hisgen
   if filloc()
      index on CODPAC+STR(YEAR(FECACT),4)+STR(MONTH(FECACT),2)+;
               STR(DAY(FECACT),2)+CODACT+STR(NUMACT,4) TO &widxhg1
      index on NUMHIS+STR(YEAR(FECACT),4)+STR(MONTH(FECACT),2)+;
               STR(DAY(FECACT),2)+CODACT+STR(NUMACT,4) TO &widxhg2
      unlock all
   else
      store "REORGANIZACION ABORTADA, REINTENTE" to wtext
      do aviso with wtext
   endif
   *** abre temp detallada normalmente
   select 9
   use &wdbfhd index &widxhd alias hisdet
   if filloc()
      index on CODPAC+CODACT+STR(NUMACT,4)+CODDAT to &widxhd
      unlock all
   else
      store "REORGANIZACION RECHAZADA, REINTENTE" to wtext
      do aviso with wtext
   endif
else
   *** crea copia de hisgen
   select 8
   use hisgen
   copy stru to &wdbfhg
   use &wdbfhg
   if filloc()
      index on CODPAC+STR(YEAR(FECACT),4)+STR(MONTH(FECACT),2)+;
               STR(DAY(FECACT),2)+CODACT+STR(NUMACT,4) TO &widxhg1
      index on NUMHIS+STR(YEAR(FECACT),4)+STR(MONTH(FECACT),2)+;
               STR(DAY(FECACT),2)+CODACT+STR(NUMACT,4) TO &widxhg2
      unlock all
   else
      store "OPERACION RECHAZADA, REINTENTE" to wtext
      do aviso with wtext
   endif
   use &wdbfhg index &widxhg1, &widxhg1 alias hisgen
   ***
   *** crea copia de hisdet
   ***
   select 9
   use hisdet
   copy stru to &wdbfhd
   use &wdbfhd
   if filloc()
      index on CODPAC+CODACT+STR(NUMACT,4)+CODDAT to &widxhd
      unlock all
   else
      store "OPERACION RECHAZADA, REINTENTE" to wtext
      do aviso with wtext
   endif
   use &wdbfhd index &widxhd alias hisdet
endif
***
*** MEDICOS
select 10
use sysmed index sysmed1, sysmed2
select 11
use sysesp index sysesp
*** RELACIONES
SELECT HISGEN
SET RELA TO CODACT     INTO HISGRU,;
            CODDOC     INTO SYSMED
SELECT AFIAFI
SET RELA TO PARENTESCO INTO AFIPAREN
SELECT SYSMED
SET RELA TO ESPECI     INTO SYSESP
RETURN
