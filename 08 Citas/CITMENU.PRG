@ 02,08 say "Control de Citas               "
set proc to citproc
*** APERTURA DE ARCHIVOS
select 1
use afititu  index afititu1,afititu2,afititu3,afititu4,afititu5
select 2
use afiafi   index afiafi1,afiafi2,afiafi3,afiafi4
select 3
use afiparen index afiparen
select 4
use syscon   index syscon
select 5
use sysesp   index sysesp
select 6
use sysservi index sysservi
select 7
use sysmed   index sysmed1, sysmed2
select 8
use citocu   index citocu1, citocu2
select 9
use citcit   index citcit1,citcit2,citcit3,citcit4,citcit5,citcit6
select 10
use syspac   index syspac,syspac2,syspac3 alias citpac
select 11
use sysuserd index sysuserd

*** INI CONTROL DE ACCESO
STORE "CITMENU" TO WPROGRAMA
STORE SPACE(1)  TO WACCESO
STORE SPACE(1)  TO WFILTRO
DO CHKACC WITH WUSERCODE,WPROGRAMA,WACCESO,WFILTRO
IF WACCESO=" "
   RETURN
ENDIF
*** FIN CONTROL DE ACCESO

*** RELACIONES
SELECT AFIAFI
SET RELA TO PARENTESCO INTO AFIPAREN
SELECT CITCIT
SET RELA TO MEDICO     INTO SYSMED
SELECT SYSMED
SET RELA TO ESPECI     INTO SYSESP
SELECT CITOCU
SET RELA TO MEDICO     INTO SYSMED
*** DECLARACION DE VARIABLES FLOTANTES
STORE SPACE(03)          TO WCONSUL
STORE SPACE(01)          TO WDIA
STORE SPACE(12)          TO WDIADES
STORE CTOD("  -  -    ") TO WFECHA
STORE SPACE(02)          TO WESPECI
STORE SPACE(09)          TO WSERVICIO
STORE SPACE(03)          TO WMEDICO
STORE SPACE(14)          TO WCODPAC
***************************************
*define menu menucit bar at line 3 shadow
define menu menucit bar at line 3
       define pad padafi00 of menucit prompt "\<Sistema" skip
       define pad padafi01 of menucit prompt "\<Instala" skip
       define pad padafi02 of menucit prompt "\<Modulo " skip
       define pad padafi03 of menucit prompt "\<Tabla  "
       define pad padafi04 of menucit prompt "\<Accion "
       define pad padafi05 of menucit prompt "\<Reporte"
       define pad padafi06 of menucit prompt "\<Proceso"
       define pad padafi07 of menucit prompt "ma\<Ntto."
       define pad padafi08 of menucit prompt "\<Salir  "
       on pad padafi03 of menucit activate popup subafi03
       on pad padafi04 of menucit activate popup subafi04
       on pad padafi05 of menucit activate popup subafi05
       on pad padafi06 of menucit activate popup subafi06
       on pad padafi07 of menucit activate popup subafi07
       on sele pad padafi08 of menucit return
       DEFINE POPUP SUBAFI03 FROM 4,30 shadow
              DEFINE BAR 01 OF SUBAFI03 PROMPT "\<Medicos                   "
              DEFINE BAR 02 OF SUBAFI03 PROMPT "\<Consultorios/Pto.de serv. "
              DEFINE BAR 03 OF SUBAFI03 PROMPT "\<Ocupacion de cons/pto.    "
              ON SELECTION POPUP SUBAFI03 DO SUBAFI03 WITH BAR()
       DEFINE POPUP SUBAFI04 FROM 4,40 shadow
              DEFINE BAR 01 OF SUBAFI04 PROMPT "    BUSCAR AFILIADOS    " SKIP
              DEFINE BAR 02 OF SUBAFI04 PROMPT "\<Cedula del titular    "
              DEFINE BAR 03 OF SUBAFI04 PROMPT "cedula del afi\<Liado   "
              DEFINE BAR 04 OF SUBAFI04 PROMPT "\<Nombre del afiliado   "
              DEFINE BAR 05 OF SUBAFI04 PROMPT "numero de \<Historia    "
              DEFINE BAR 06 OF SUBAFI04 PROMPT "  BUSCAR NO AFILIADOS   " SKIP
              DEFINE BAR 07 OF SUBAFI04 PROMPT "c\<Edula del afiliado   "
              DEFINE BAR 08 OF SUBAFI04 PROMPT "n\<Ombre del no afiliado"
              DEFINE BAR 09 OF SUBAFI04 PROMPT "n\<Umero de historia    "
              DEFINE BAR 10 OF SUBAFI04 PROMPT "         CITAS          " SKIP
              DEFINE BAR 11 OF SUBAFI04 PROMPT "h\<Acer                 "
              *DEFINE BAR 12 OF SUBAFI04 PROMPT "solici\<Tud de servicio "
              ON SELECTION POPUP SUBAFI04 DO SUBAFI04 WITH BAR()
       DEFINE POPUP SUBAFI05 FROM 4,50 shadow
              DEFINE BAR 01 OF SUBAFI05 PROMPT "TABLAS DE CODIGOS           " SKIP
              DEFINE BAR 02 OF SUBAFI05 PROMPT "\<Medicos                   "
              DEFINE BAR 03 OF SUBAFI05 PROMPT "\<Horarios medicos          "
              DEFINE BAR 04 OF SUBAFI05 PROMPT "Horarios \<Consultorios     "
              DEFINE BAR 05 OF SUBAFI05 PROMPT "\<Pacientes                 "
              DEFINE BAR 06 OF SUBAFI05 PROMPT "CITAS                       " SKIP
              DEFINE BAR 07 OF SUBAFI05 PROMPT "m\<Edico                    "
              DEFINE BAR 08 OF SUBAFI05 PROMPT "p\<Aciente                  "
              DEFINE BAR 09 OF SUBAFI05 PROMPT "con\<Sultorio               "
              DEFINE BAR 10 OF SUBAFI05 PROMPT "pre-morbilida\<D            "
              ON SELECTION POPUP SUBAFI05 DO SUBAFI05 WITH BAR()
       DEFINE POPUP SUBAFI07 FROM 4,70 shadow
              DEFINE BAR 01 OF SUBAFI07 PROMPT "\<Reorganizar indices       "
              DEFINE BAR 02 OF SUBAFI07 PROMPT "\<Compactar tablas de datos "
              ON SELECTION POPUP SUBAFI07 DO SUBAFI07 WITH BAR()

*** ACTIVACION DEL MENU DE AFILIACION
do while .t.
   ACTIVATE MENU menucit 
enddo
RELEASE menucit
CLOSE DATA
CLOSE INDEX

*********************************
*** RUTINAS
***
PROCEDURE SALIR
RELEASE MENU menucit
CLOSE ALL
@ 0,0 CLEAR
SET PROC TO SYSPROC
RETURN
*** 
PROCEDURE SUBAFI03
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        librmed=5
        cibrmed=0
        do cit0101
   CASE SELBAR = 2
        librcon=5
        cibrcon=0
        SAVE SCRE TO WSCRE01
        do sys0104
        RESTORE SCRE FROM WSCRE01
   CASE SELBAR = 3
        librocu=5
        cibrocu=0
        SAVE SCRE TO WSCRE01
        do cit0102
        RESTORE SCRE FROM WSCRE01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
*** 
PROCEDURE SUBAFI04
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 2
        save scre to wscre01
        DO CIT0202
        restore scre from wscre01
   CASE SELBAR = 3
        save scre to wscre01
        DO CIT0203
        restore scre from wscre01
   CASE SELBAR = 4
        save scre to wscre01
        DO CIT0204
        restore scre from wscre01
   CASE SELBAR = 5
        save scre to wscre01
        DO CIT0205
        restore scre from wscre01
   CASE SELBAR = 7
        save scre to wscre01
        DO CIT0207
        restore scre from wscre01
   CASE SELBAR = 8
        save scre to wscre01
        DO CIT0208
        restore scre from wscre01
   CASE SELBAR = 9
        save scre to wscre01
        DO CIT0209
        restore scre from wscre01
   CASE SELBAR = 11
        save scre to wscre01
        DO CIT0211
        restore scre from wscre01
   CASE SELBAR = 12
        save scre to wscre01
        DO CIT0212
        restore scre from wscre01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE SUBAFI05
PARAMETERS SELBAR
HIDE MENU MENUCIT
DO CASE
   CASE SELBAR = 2
        save scre to wscre01
        DO CIT0302
        restore scre from wscre01
   CASE SELBAR = 3
        save scre to wscre01
        DO CIT0303
        restore scre from wscre01
   CASE SELBAR = 4
        save scre to wscre01
        DO CIT0304
        restore scre from wscre01
   CASE SELBAR = 5
        save scre to wscre01
        DO CIT0305
        restore scre from wscre01
   CASE SELBAR = 7
        save scre to wscre01
        DO CIT0307
        restore scre from wscre01
   CASE SELBAR = 8
        save scre to wscre01
        DO CIT0308
        restore scre from wscre01
   CASE SELBAR = 9
        save scre to wscre01
        DO CIT0309
        restore scre from wscre01
   CASE SELBAR = 10
        save scre to wscre01
        DO CIT0310
        restore scre from wscre01
ENDCASE
SHOW MENU MENUCIT
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE SUBAFI07
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

