@ 02,08 say "Pacientes regulares            "
set proc to afiproc
*** APERTURA DE ARCHIVOS
select 1
use afititu index afititu1,afititu2,afititu3,afititu4,afititu5
select 2
use afiafi  index afiafi1,afiafi2,afiafi3,afiafi4
select 3
use afigeo  index afigeo
select 4
use afiorga index afiorga
select 5
use afiacad index afiacad
select 6
use afiplang index afiplang
select 7
use afipland index afipland
select 8
use afiparen index afiparen
select 9
use syspto   index syspto  
select 10
use afidata
select 11
use sysuserd index sysuserd
*** RELACIONES
SELECT AFITITU
SET RELA TO CEDTITU INTO AFIAFI
*SET SKIP TO  AFIAFI
SELECT AFIAFI
SET RELA TO PARENTESCO INTO AFIPAREN
SELECT AFIPLANG
SET RELA TO PLAN INTO AFIPLAND
SELECT AFIPLAND
SET RELA TO CODPTO INTO SYSPTO

*** INI CONTROL DE ACCESO
STORE "AFIMENU" TO WPROGRAMA
STORE SPACE(1)  TO WACCESO
STORE SPACE(1)  TO WFILTRO
DO CHKACC WITH WUSERCODE,WPROGRAMA,WACCESO,WFILTRO
IF WACCESO=" "
   RETURN
ENDIF
*** FIN CONTROL DE ACCESO

*** DECLARACION DE VARIABLES FLOTANTES
STORE SPACE(10) TO WCEDTITU
STORE SPACE(02) TO WCARGA
STORE SPACE(02) TO WESTADO
STORE SPACE(02) TO WCIUDAD
STORE SPACE(02) TO WMUNICIPIO
STORE SPACE(04) TO WORGA
STORE SPACE(02) TO WNIVORG1
STORE SPACE(02) TO WNIVORG2
STORE SPACE(02) TO WNIVORG3
STORE SPACE(15) TO WCONTRATO
STORE SPACE(4)  TO WPLAN
***************************************
*define menu menuafi bar at line 3 shadow
define menu menuafi bar at line 3
*      define pad padafi00 of menuafi prompt "\<Sistema" skip
       define pad padafi01 of menuafi prompt "\<Instala" skip
       define pad padafi02 of menuafi prompt "\<Modulo " skip
       define pad padafi03 of menuafi prompt "\<Tabla  "
       define pad padafi04 of menuafi prompt "\<Accion "
       define pad padafi05 of menuafi prompt "\<Reporte"
       define pad padafi06 of menuafi prompt "\<Proceso"
       define pad padafi07 of menuafi prompt "ma\<Ntto."
       define pad padafi08 of menuafi prompt "\<Salir  "
       on pad padafi03 of menuafi activate popup subafi03
       on pad padafi04 of menuafi activate popup subafi04
       on pad padafi05 of menuafi activate popup subafi05
       on pad padafi06 of menuafi activate popup subafi06
       on pad padafi07 of menuafi activate popup subafi07
       on sele pad padafi08 of menuafi return
       DEFINE POPUP SUBAFI03 FROM 4,30 shadow
              DEFINE BAR 01 OF SUBAFI03 PROMPT "\<Organizaciones Afiliadas  "
              DEFINE BAR 02 OF SUBAFI03 PROMPT "\<Planes de afiliacion      "
              DEFINE BAR 03 OF SUBAFI03 PROMPT "\<Nivel academico pacientes "
              DEFINE BAR 04 OF SUBAFI03 PROMPT "P\<arentescos               "
              DEFINE BAR 05 OF SUBAFI03 PROMPT "\<Localidad geografica      "
              ON SELECTION POPUP SUBAFI03 DO SUBAFI03 WITH BAR()
       DEFINE POPUP SUBAFI04 FROM 4,40 shadow
              DEFINE BAR 01 OF SUBAFI04 PROMPT "BUSCAR PACIENTE       " SKIP
              DEFINE BAR 02 OF SUBAFI04 PROMPT "cedula \<Titular      "
              DEFINE BAR 03 OF SUBAFI04 PROMPT "cedula pac\<Iente     "
              DEFINE BAR 04 OF SUBAFI04 PROMPT "\<Nombre paciente     "
              DEFINE BAR 05 OF SUBAFI04 PROMPT "localidad \<Geografica"
              DEFINE BAR 06 OF SUBAFI04 PROMPT "\<Organiz.-cliente    "
              DEFINE BAR 07 OF SUBAFI04 PROMPT "numero de cont\<Rato  "
              DEFINE BAR 08 OF SUBAFI04 PROMPT "REGISTRAR PACIENTE    " SKIP
              DEFINE BAR 09 OF SUBAFI04 PROMPT "datos \<Pers.Titular  "
              DEFINE BAR 10 OF SUBAFI04 PROMPT "datos \<Lab. Titular  "
              DEFINE BAR 11 OF SUBAFI04 PROMPT "datos \<Carga familiar"
              DEFINE BAR 12 OF SUBAFI04 PROMPT "datos otr.a\<Spec.Fam."
              DEFINE BAR 13 OF SUBAFI04 PROMPT "datos \<Afiliacion    "
              ON SELECTION POPUP SUBAFI04 DO SUBAFI04 WITH BAR()
       DEFINE POPUP SUBAFI05 FROM 4,50 shadow
              DEFINE BAR 01 OF SUBAFI05 PROMPT "TABLAS DE CODIGOS           " SKIP
              DEFINE BAR 02 OF SUBAFI05 PROMPT "\<Organizaciones Afiliadas  "
              DEFINE BAR 03 OF SUBAFI05 PROMPT "plan\<Es de afiliacion      "
              DEFINE BAR 04 OF SUBAFI05 PROMPT "\<Nivel academico titulares "
              DEFINE BAR 05 OF SUBAFI05 PROMPT "parentescos \<Carga familiar"
              DEFINE BAR 06 OF SUBAFI05 PROMPT "localidad \<Geografica      "
              DEFINE BAR 07 OF SUBAFI05 PROMPT "PACIENTES                   " SKIP
              DEFINE BAR 08 OF SUBAFI05 PROMPT "datos \<Personales          "
              DEFINE BAR 09 OF SUBAFI05 PROMPT "datos \<Laborales           "
              DEFINE BAR 10 OF SUBAFI05 PROMPT "datos carga \<Familiar      "
              DEFINE BAR 11 OF SUBAFI05 PROMPT "\<Datos Afiliacion          "
              DEFINE BAR 12 OF SUBAFI05 PROMPT "OTROS                       " SKIP
              DEFINE BAR 13 OF SUBAFI05 PROMPT "carne\<T de afiliacion      "
              DEFINE BAR 14 OF SUBAFI05 PROMPT "\<Inf.titulares por org-clte"
              DEFINE BAR 15 OF SUBAFI05 PROMPT "e\<Stadistica X  ubic-geog. "
              DEFINE BAR 16 OF SUBAFI05 PROMPT "est\<Adistica X  org./clte. "
              ON SELECTION POPUP SUBAFI05 DO SUBAFI05 WITH BAR()
       DEFINE POPUP SUBAFI07 FROM 4,70 shadow
              DEFINE BAR 01 OF SUBAFI07 PROMPT "\<Reorganizar indices       "
              DEFINE BAR 02 OF SUBAFI07 PROMPT "\<Compactar tablas de datos "
              ON SELECTION POPUP SUBAFI07 DO SUBAFI07 WITH BAR()
*** ACTIVACION DEL MENU DE AFILIACION
do while .t.
   ACTIVATE MENU menuafi 
enddo
*RELEASE MENUAFI
CLOSE DATA
CLOSE INDEX
SET PROC TO SYSPROC
RETURN
*********************************
*** RUTINAS
***
PROCEDURE SUBAFI03
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        librorg=5
        cibrorg=0
        do afi0101
   CASE SELBAR = 2
        librpla=5
        cibrpla=0
        do afi0102
   CASE SELBAR = 3
        libraca=5
        cibraca=0
        do afi0103
   CASE SELBAR = 4
        librpar=5
        cibrpar=0
        do afi0104
   CASE SELBAR = 5
        librgeo=5
        cibrgeo=0
        do afi0105
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
        DO AFI0202
        restore scre from wscre01
   CASE SELBAR = 3
        save scre to wscre01
        DO AFI0203
        restore scre from wscre01
   CASE SELBAR = 4
        save scre to wscre01
        DO AFI0204
        restore scre from wscre01
   CASE SELBAR = 5
        save scre to wscre01
        DO AFI0205
        restore scre from wscre01
   CASE SELBAR = 6
        save scre to wscre01
        DO AFI0206
        restore scre from wscre01
   CASE SELBAR = 7
        save scre to wscre01
        DO AFI0207
        restore scre from wscre01
   CASE SELBAR = 9
        save scre to wscre01
        DO AFI0209
        restore scre from wscre01
   CASE SELBAR = 10
        save scre to wscre01
        DO AFI0210
        restore scre from wscre01
   CASE SELBAR = 11
        save scre to wscre01
        DO AFI0211
        restore scre from wscre01
   CASE SELBAR = 12
        save scre to wscre01
        hide menu menuafi
        DO AFI0212
        show menu menuafi
        restore scre from wscre01
   CASE SELBAR = 13
        save scre to wscre01
        DO AFI0213
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
DO CASE
   CASE SELBAR = 2
        save scre to wscre01
        DO AFI0302
        restore scre from wscre01
   CASE SELBAR = 3
        save scre to wscre01
        DO AFI0303
        restore scre from wscre01
   CASE SELBAR = 4
        save scre to wscre01
        DO AFI0304
        restore scre from wscre01
   CASE SELBAR = 5
        save scre to wscre01
        DO AFI0305
        restore scre from wscre01
   CASE SELBAR = 6
        save scre to wscre01
        DO AFI0306
        restore scre from wscre01
   CASE SELBAR = 8
        save scre to wscre01
        DO AFI0308
        restore scre from wscre01
   CASE SELBAR = 9
        save scre to wscre01
        DO AFI0309
        restore scre from wscre01
   CASE SELBAR = 10
        save scre to wscre01
        DO AFI0310
        restore scre from wscre01
   CASE SELBAR = 11
        save scre to wscre01
        DO AFI0311
        restore scre from wscre01
   CASE SELBAR = 13
        save scre to wscre01
        DO AFI0313
        restore scre from wscre01
   CASE SELBAR = 13
        save scre to wscre01
        DO AFI0313
        restore scre from wscre01
   CASE SELBAR = 14
        save scre to wscre01
        DO AFI0314
        restore scre from wscre01
   CASE SELBAR = 15
        save scre to wscre01
        DO AFI0315
        restore scre from wscre01
   CASE SELBAR = 16
        save scre to wscre01
        DO AFI0316
        restore scre from wscre01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
*PROCEDURE SUBAFI06
*PARAMETERS SELBAR
*DO CASE
*   CASE SELBAR = 1
*        save scre to wscre01
*        DO AFI04??
*        restore scre from wscre01
*ENDCASE
*ON KEY LABEL F1
*ON KEY LABEL F2
*ON KEY LABEL F3
*ON KEY LABEL F4
*RETURN
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

