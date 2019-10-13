@ 02,08 say "Compras                                "
set proc to comproc
close data
close index
select 1
use comdata
select 2
use comgru   index comgru
select 3
use BCBENEFI index BCBENEF1,BCBENEF2 ALIAS compro
select 4
use sysservi index sysservi
select 5
use comdcge  index comdcge,comdcge2
select 6
use comdcde  index comdcde
select 7
use comcxp   index comcxp1,comcxp2,comcxp3
select 8
use comcxptr index comcxpt1,comcxpt2,comcxpt3
SELECT 9
USE SYSUSERD INDEX SYSUSERD

STORE "SELECCIONE ALMACEN: (F)ARMACIA, (M)ATERIALES, (N)INGUNO" TO TEX
STORE "FMN" TO WCH
DO PREGUNTA
IF WCH = "F"
   STORE "ALM" TO WEJCINV
   STORE "C"   TO WFLAGCALL
   SELECT 10
   USE ALMART   INDEX ALMART,ALMART2,ALMART3,ALMART4
   SELECT 11
   USE ALMTRA   INDEX ALMTRA3,ALMTRA2,ALMTRA1
   SELECT 12
   USE ALMLOT   INDEX ALMLOT
   SELECT 13
   USE ALMLOTTR INDEX ALMLOTTR
   SELECT 14
   USE ALMDATA
ELSE
   IF WCH="M"
      STORE "MAT" TO WEJCINV
      STORE "C"   TO WFLAGCALL
      SELECT 10
      USE MATART   INDEX MATART,MATART2          ALIAS ALMART
      SELECT 11
      USE MATTRA   INDEX MATTRA3,MATTRA2,MATTRA1 ALIAS ALMTRA
      SELECT 12
      USE MATLOT   INDEX MATLOT                  ALIAS ALMLOT
      SELECT 13
      USE MATLOTTR INDEX MATLOTTR                ALIAS ALMLOTTR
      SELECT 14
      USE MATDATA                                ALIAS ALMDATA
   ELSE
      STORE "   "  TO WEJCINV
      STORE "C"    TO WFLAGCALL
   ENDIF
ENDIF

*** INI CONTROL DE ACCESO
STORE "COMMENU" TO WPROGRAMA
STORE SPACE(1)  TO WACCESO
STORE SPACE(1)  TO WFILTRO
DO CHKACC WITH WUSERCODE,WPROGRAMA,WACCESO,WFILTRO
IF WACCESO=" "
   RETURN
ENDIF
*** FIN CONTROL DE ACCESO
***************************************
define menu menucom bar at line 3
       define pad padcom00 of menucom prompt "\<Sistema" skip
       define pad padcom01 of menucom prompt "\<Instala" skip
       define pad padcom02 of menucom prompt "\<Modulo " skip
       define pad padcom03 of menucom prompt "\<Tabla  "
       define pad padcom04 of menucom prompt "\<Accion "
       define pad padcom05 of menucom prompt "\<Reporte"
       define pad padcom06 of menucom prompt "\<Proceso"
       define pad padcom07 of menucom prompt "ma\<Ntto."
       define pad padcom08 of menucom prompt "\<Salir  "
       on pad padcom03 of menucom activate popup subcom03
       on pad padcom04 of menucom activate popup subcom04
       on pad padcom05 of menucom activate popup subcom05
       on pad padcom06 of menucom activate popup subcom06
       on pad padcom07 of menucom activate popup subcom07
       on sele pad padcom08 of menucom return
       DEFINE POPUP subcom03 FROM 4,30 shadow
              DEFINE BAR 01 OF subcom03 PROMPT "\<Grupos de proveedores     "
              DEFINE BAR 02 OF subcom03 PROMPT "\<proveedores               "
              ON SELECTION POPUP subcom03 DO subcom03 WITH BAR()
       DEFINE POPUP subcom04 FROM 4,40 shadow
              DEFINE BAR 01 OF subcom04 PROMPT "\<Solicitud de cotizacion"
              DEFINE BAR 02 OF subcom04 PROMPT "\<Orden de compra        "
              DEFINE BAR 03 OF subcom04 PROMPT "\<Recepcion de compras   "
              DEFINE BAR 04 OF subcom04 PROMPT "\<Devolucion de compras  "
              DEFINE BAR 05 OF subcom04 PROMPT "\<Cuentas por cobrar     "
              ON SELECTION POPUP subcom04 DO subcom04 WITH BAR()
       DEFINE POPUP subcom05 FROM 4,50 shadow
              DEFINE BAR 01 OF subcom05 PROMPT "\<Grupos de proveedores        "
              DEFINE BAR 02 OF subcom05 PROMPT "\<Proveedores                  "
              DEFINE BAR 03 OF subcom05 PROMPT "\<Documentos                   "
              DEFINE BAR 04 OF subcom05 PROMPT "estado de \<Ordenes de compra  "
              DEFINE BAR 05 OF subcom05 PROMPT "\<Cuentas por pagar            " 
              ON SELECTION POPUP subcom05 DO subcom05 WITH BAR()
       DEFINE POPUP subcom06 FROM 4,60 shadow
              *DEFINE BAR 01 OF subcom06 PROMPT "\<Reprocesar compras        "
              *DEFINE BAR 02 OF subcom06 PROMPT "\<Cierre de periodo         "
              ON SELECTION POPUP subcom06 DO subcom06 WITH BAR()
       DEFINE POPUP subcom07 FROM 4,70 shadow
              DEFINE BAR 01 OF subcom07 PROMPT "\<Reorganizar indices       "
              DEFINE BAR 02 OF subcom07 PROMPT "\<Compactar tablas de datos "
              ON SELECTION POPUP subcom07 DO subcom07 WITH BAR()
*** ACTIVACION DEL MENU DE compras
do while .t.
   ACTIVATE MENU menucom 
enddo
RELEASE menucom
CLOSE DATA
CLOSE INDEX
SET PROC TO SYSPROC

*******************
*** RUTINAS
***
PROCEDURE SALIR
RELEASE MENU menucom
CLOSE ALL
@ 0,0 CLEAR
SET PROC TO SYSPROC
RETURN
*** 
PROCEDURE subcom03
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        SAVE SCRE TO WSCRE01
        do COM0101
        RESTORE SCRE FROM WSCRE01
   CASE SELBAR = 2
        SAVE SCRE TO WSCRE01
        do COM0102
        RESTORE SCRE FROM WSCRE01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
*** 
PROCEDURE subcom04
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        save scre to wscre01
        HIDE MENU MENUCOM
        DO COM0201
        SHOW MENU MENUCOM
        restore scre from wscre01
   CASE SELBAR = 2
        save scre to wscre01
        HIDE MENU MENUCOM
        DO COM0202
        SHOW MENU MENUCOM
        restore scre from wscre01
   CASE SELBAR = 3
        save scre to wscre01
        HIDE MENU MENUCOM
        DO COM0203
        SHOW MENU MENUCOM
        restore scre from wscre01
   CASE SELBAR = 4
        save scre to wscre01
        HIDE MENU MENUCOM
        DO COM0204
        SHOW MENU MENUCOM
        restore scre from wscre01
   CASE SELBAR = 5
        save scre to wscre01
        HIDE MENU MENUCOM
        DO COM0205
        SHOW MENU MENUCOM
        restore scre from wscre01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE subcom05
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        save scre to wscre01
        HIDE MENU MENUCOM
        DO COM0301
        SHOW MENU MENUCOM
        restore scre from wscre01
   CASE SELBAR = 2
        HIDE MENU MENUCOM
        save scre to wscre01
        SHOW MENU MENUCOM
        DO COM0302
        restore scre from wscre01
   CASE SELBAR = 3
        HIDE MENU MENUCOM
        save scre to wscre01
        DO COM0303
        restore scre from wscre01
        SHOW MENU MENUCOM
   CASE SELBAR = 4
        save scre to wscre01
        HIDE MENU MENUCOM
        DO COM0304
        SHOW MENU MENUCOM
        restore scre from wscre01
   CASE SELBAR = 5
        save scre to wscre01
        HIDE MENU MENUCOM
        DO COM0305
        SHOW MENU MENUCOM
        restore scre from wscre01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE subcom06
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        save scre to wscre01
        *DO COM0401
        restore scre from wscre01
   CASE SELBAR = 2
        save scre to wscre01
        *DO COM0402
        restore scre from wscre01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE subcom07
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        save scre to wscre01
        DO INDICES
        restore scre from wscre01
   CASE SELBAR = 2
        save scre to wscre01
        DO COMPACTA
        restore scre from wscre01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***

******************
PROCEDURE SYSERROR
PARAMETERS WFECHA,WUSERCODE,WERROR,WMENSAJE0,WMENSAJE1,WLINENO,WPROGRAM
CLOSE DATA
CLOSE INDEX
STORE 0 TO WCONT
USE SYSERROR
DO WHILE .T.
   IF FLOCK()
      APPEND BLANK
      REPLACE FECHA      WITH WFECHA
      REPLACE USUARIO    WITH WUSERCODE
      REPLACE ERROR      WITH WERROR
      REPLACE MENSAJE    WITH WMENSAJE0
      REPLACE TEXTO      WITH WMENSAJE1
      REPLACE LINEA      WITH WLINENO
      REPLACE PROGRAMA   WITH WPROGRAM
      EXIT
   ELSE
      STORE WCONT+1 TO WCONT
   ENDIF
   IF WCONT>300
      EXIT
   ENDIF
ENDDO
UNLOCK ALL
CLOSE DATA
CLOSE INDEX
DEACT WIND ALL
RELEASE ALL
CLEAR ALL
RETURN TO MASTER
*****************
