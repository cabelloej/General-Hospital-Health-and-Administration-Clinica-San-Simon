@ 02,08 say "Consulta medica externa            "
set proc to medproc
close data
close index
*** CONTROL DE ACCESO
SELECT 20
USE SYSUSERD INDEX SYSUSERD
STORE "MEDMENU " TO WPROGRAMA
STORE SPACE(1)  TO WACCESO
STORE SPACE(1)  TO WFILTRO
DO CHKACC WITH WUSERCODE,WPROGRAMA,WACCESO,WFILTRO
IF WACCESO=" "
   RETURN
ENDIF
SELECT 20
USE
IF WFLAGMED
   SELECT 20
   USE SYSESP INDEX SYSESP
   SEEK WCODESP
   IF FOUND()
      STORE DESCRI            TO WNOMESP
   ELSE
      STORE "NO REGISTRADA"   TO WNOMESP
   ENDIF
   SELECT 20
   USE
ELSE
   STORE "AUTOR NO ES MEDICO" TO WNOMESP
ENDIF
***
*** DATOS INICIALES DE HISTORIA
STORE SPACE(01)        TO WTIPPAC
STORE SPACE(14)        TO WCODPAC
STORE SPACE(10)        TO WCODPAC1
STORE "0000"           TO WCODPAC2
STORE SPACE(14)        TO WXCODPAC
STORE SPACE(12)        TO WNUMHIS
STORE SPACE(30)        TO WNOMBRE
STORE SPACE(1)         TO WSEXO
STORE CTOD("  -  -  ") TO WNACIMIENTO
*** DATOS INICIALES DE CITAS
STORE SPACE(03)        TO WCONSUL
STORE SPACE(01)        TO WDIA
STORE SPACE(12)        TO WDIADES
STORE CTOD("  -  -  ") TO WFECHA
STORE SPACE(02)        TO WESPECI
STORE SPACE(09)        TO WSERVICIO
STORE SPACE(03)        TO WMEDICO
***

define menu MENUMED bar at line 3
       define pad PADMED00 of MENUMED prompt "\<Sistema" skip
       define pad PADMED01 of MENUMED prompt "\<Instala" skip
       define pad PADMED02 of MENUMED prompt "\<Modulo " skip
       define pad PADMED03 of MENUMED prompt "\<Tabla  "
       define pad PADMED04 of MENUMED prompt "\<Accion "
       define pad PADMED05 of MENUMED prompt "\<Reporte"
       define pad PADMED06 of MENUMED prompt "\<Proceso"
       define pad PADMED07 of MENUMED prompt "ma\<Ntto."
       define pad PADMED08 of MENUMED prompt "\<Salir  "
       on pad PADMED03 of MENUMED activate popup SUBMED03
       on pad PADMED04 of MENUMED activate popup SUBMED04
       on pad PADMED05 of MENUMED activate popup SUBMED05
       on pad PADMED06 of MENUMED activate popup SUBMED06
       on pad PADMED07 of MENUMED activate popup SUBMED07
       on sele pad PADMED08 of MENUMED return
       DEFINE POPUP SUBMED03 FROM 4,30 shadow
              DEFINE BAR 01 OF SUBMED03 PROMPT "lugar en consulta para recipes"
              DEFINE BAR 02 OF SUBMED03 PROMPT "lugar en consulta para indic. "
              DEFINE BAR 03 OF SUBMED03 PROMPT "lugar en consulta para reposos"
              ON SELECTION POPUP SUBMED03 DO SUBMED03 WITH BAR()
       DEFINE POPUP SUBMED04 FROM 4,40 shadow
              DEFINE BAR 01 OF SUBMED04 PROMPT "      BUSCAR AFILIADOS      " SKIP
              DEFINE BAR 02 OF SUBMED04 PROMPT "\<Cedula del titular        "
              DEFINE BAR 03 OF SUBMED04 PROMPT "cedula del \<Afiliado       "
              DEFINE BAR 04 OF SUBMED04 PROMPT "\<Nombre del afiliado       "
              DEFINE BAR 05 OF SUBMED04 PROMPT "numero de \<Historia        "
              DEFINE BAR 06 OF SUBMED04 PROMPT "    BUSCAR NO AFILIADOS     " SKIP
              DEFINE BAR 07 OF SUBMED04 PROMPT "c\<Edula del no afiliado    "
              DEFINE BAR 08 OF SUBMED04 PROMPT "n\<Ombre del no afiliado    "
              DEFINE BAR 09 OF SUBMED04 PROMPT "numero de h\<Istoria        "
              DEFINE BAR 10 OF SUBMED04 PROMPT "  CONSULTA MEDICA EXTERNA   " SKIP
              DEFINE BAR 11 OF SUBMED04 PROMPT "emitir \<Solicitud          "
              DEFINE BAR 12 OF SUBMED04 PROMPT "emitir \<Comprobante        "
              DEFINE BAR 13 OF SUBMED04 PROMPT "ver his\<Toria              "
              DEFINE BAR 14 OF SUBMED04 PROMPT "e\<Fectuar consulta         "
              DEFINE BAR 15 OF SUBMED04 PROMPT "consultar \<Vademecum       "
              DEFINE BAR 16 OF SUBMED04 PROMPT "emitir reci\<Pe medico      "
              DEFINE BAR 17 OF SUBMED04 PROMPT "emitir reposo \<Medico      "
              DEFINE BAR 18 OF SUBMED04 PROMPT "efect\<Uar cita             "
              ON SELECTION POPUP SUBMED04 DO SUBMED04 WITH BAR()
       DEFINE POPUP SUBMED05 FROM 4,50 shadow
              DEFINE BAR 01 OF SUBMED05 PROMPT "\<Historias medicas         "
              DEFINE BAR 02 OF SUBMED05 PROMPT "\<Citas por medico          "
              ON SELECTION POPUP SUBMED05 DO SUBMED05 WITH BAR()
       DEFINE POPUP SUBMED06 FROM 4,60 shadow
       DEFINE POPUP SUBMED07 FROM 4,70 shadow
              DEFINE BAR 01 OF SUBMED07 PROMPT "\<Reorganizar indices       "
              DEFINE BAR 02 OF SUBMED07 PROMPT "\<Compactar tablas de datos "
              ON SELECTION POPUP SUBMED07 DO SUBMED07 WITH BAR()
*** ACTIVACION DEL MENU DE FACTURACION
do while .t.
   ACTIVATE MENU MENUMED
enddo
RELEASE MENUMED
CLOSE DATA
CLOSE INDEX
SET PROC TO SYSPROC

*******************
*** RUTINAS
***
PROCEDURE SUBMED03
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
   CASE SELBAR = 2
   CASE SELBAR = 3
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
*** 
PROCEDURE SUBMED04
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 2
        DO OPENPAC
        save scre to wscre01
        HIDE MENU MENUMED
        DO HIS0202
        SHOW MENU MENUMED
        restore scre from wscre01
        CLOSE DATA
        CLOSE INDEX
   CASE SELBAR = 3
        DO OPENPAC
        save scre to wscre01
        HIDE MENU MENUMED
        DO HIS0203
        SHOW MENU MENUMED
        restore scre from wscre01
        CLOSE DATA
        CLOSE INDEX
   CASE SELBAR = 4
        DO OPENPAC
        save scre to wscre01
        HIDE MENU MENUMED
        DO HIS0204
        SHOW MENU MENUMED
        restore scre from wscre01
        CLOSE DATA
        CLOSE INDEX
   CASE SELBAR = 5
        DO OPENPAC
        save scre to wscre01
        HIDE MENU MENUMED
        DO HIS0205
        SHOW MENU MENUMED
        restore scre from wscre01
        CLOSE DATA
        CLOSE INDEX
   CASE SELBAR = 7
        DO OPENPAC
        save scre to wscre01
        HIDE MENU MENUMED
        DO HIS0207
        SHOW MENU MENUMED
        restore scre from wscre01
        CLOSE DATA
        CLOSE INDEX
   CASE SELBAR = 8
        DO OPENPAC
        save scre to wscre01
        HIDE MENU MENUMED
        DO HIS0208
        SHOW MENU MENUMED
        restore scre from wscre01
        CLOSE DATA
        CLOSE INDEX
   CASE SELBAR = 9
        SET PROC TO HISPROC
        DO OPENPAC
        save scre to wscre01
        HIDE MENU MENUMED
        DO HIS0209
        SHOW MENU MENUMED
        restore scre from wscre01
        CLOSE DATA
        CLOSE INDEX
        SET PROC TO MEDPROC
   CASE SELBAR = 11
        SET PROC TO SERPROC
        DO SEROPSER
        save scre to wscre01
        HIDE MENU MENUMED
        STORE "SOL"         TO WTIPODOC
        STORE "SOLICITUD"   TO WNOMDOC
        DO SERELADC
        restore scre from wscre01
        SHOW MENU MENUMED
        CLOSE DATA
        CLOSE INDEX
        SET PROC TO MEDPROC
   CASE SELBAR = 12
        SET PROC TO SERPROC
        DO SEROPSER
        save scre to wscre01
        HIDE MENU MENUMED
        STORE "COM"         TO WTIPODOC
        STORE "COMPROBANTE" TO WNOMDOC
        DO SERELADC
        restore scre from wscre01
        SHOW MENU MENUMED
        CLOSE DATA
        CLOSE INDEX
        SET PROC TO MEDPROC
   CASE SELBAR = 13
        SET PROC TO HISPROC
        DO OPENHIS
        save scre to wscre01
        HIDE MENU MENUMED
        DO WHILE .T.
           *** DATOS PERSONALES
           STORE .F. TO WFLAGDP
           DO HISACTDP
           IF .NOT. WFLAGDP
              RETURN
           ENDIF
           *** HISTORIA GENERAL
           STORE "H" TO WFLAGHIST
           DO HISACTHG
        ENDDO
        SHOW MENU MENUMED
        restore scre from wscre01
        CLOSE DATA
        CLOSE INDEX
        SET PROC TO MEDPROC
   CASE SELBAR = 14
        SET PROC TO MEDPROC
        *** declaracion de archivos temporales
        * hisgen.dbf
        store alltrim(wusercode)+".dg1" to wdbfhg
        * hisgen1.idx
        store alltrim(wusercode)+".ig1" to widxhg1
        * hisgen2.idx
        store alltrim(wusercode)+".ig2" to widxhg2
        * hisdet.dbf
        store alltrim(wusercode)+".dd1" to wdbfhd
        * hisdet.idx
        store alltrim(wusercode)+".id1" to widxhd
        ***
        DO MEDOPECO
        save scre to wscre01
        HIDE MENU MENUMED
        STORE "C" TO WFLAGHIST
        DO MEDELACO
        save scre to wscre01
        HIDE MENU MENUMED
        SET PROC TO MEDPROC
        CLOSE DATA
        CLOSE INDEX
   CASE SELBAR = 15
        SET PROC TO MEDPROC
        USE ALMART INDEX ALMART,ALMART2,ALMART3,ALMART4
        DO MEDCONVA
        CLOSE DATA
        CLOSE INDEX
        SET PROC TO MEDPROC
   CASE SELBAR = 16
        SET PROC TO MEDPROC
        DO OPENREC
        SAVE SCRE TO WSCRE01
        HIDE MENU MENUMED
        DO MEDELARE
        RESTORE SCRE FROM WSCRE01
        SHOW MENU MENUMED
        CLOSE DATA
        CLOSE INDEX
        SET PROC TO MEDPROC
   CASE SELBAR = 17
        SET PROC TO MEDPROC
        DO OPENREP
        SAVE SCRE TO WSCRE01
        HIDE MENU MENUMED
        DO MEDELARP
        RESTORE SCRE FROM WSCRE01
        SHOW MENU MENUMED
        CLOSE DATA
        CLOSE INDEX
        SET PROC TO MEDPROC
   CASE SELBAR = 18
        SET PROC TO CITPROC
        DO OPENCIT
        save scre to wscre01
        HIDE MENU MENUMED
        DO CIT0211
        restore scre from wscre01
        SHOW MENU MENUMED
        CLOSE DATA
        CLOSE INDEX
        SET PROC TO MEDPROC
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE SUBMED05
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        DO OPENHIS
        save scre to wscre01
        HIDE MENU MENUMED
        STORE "H" TO WFLAGHIST
        DO HISIMPH
        SHOW MENU MENUMED
        restore scre from wscre01
        CLOSE DATA
        CLOSE INDEX
   CASE SELBAR = 2
        SET PROC TO CITPROC
        DO OPENCIT
        save scre to wscre01
        HIDE MENU MENUMED
        DO CIT0307
        restore scre from wscre01
        SHOW MENU MENUMED
        CLOSE DATA
        CLOSE INDEX
        SET PROC TO MEDPROC
   ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE SUBMED06
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
   CASE SELBAR = 2
   CASE SELBAR = 3
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE SUBMED07
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
*****************
PROCEDURE OPENPAC
*****************
CLOSE DATA
CLOSE INDEX
*** PACIENTES
select 1
use syspac index syspac,syspac2,syspac3
select 2
use afiafi index afiafi1,afiafi2,afiafi3,afiafi4
select 3
use afiparen index afiparen
SELECT AFIAFI
SET RELA TO PARENTESCO INTO AFIPAREN
RETURN
*****************
PROCEDURE OPENHIS
*****************
CLOSE DATA
CLOSE INDEX
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
select 8
use hisgen index hisgen1,hisgen2
select 9
use hisdet index hisdet
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
************
PROC OPENCIT
************
CLOSE DATA
CLOSE INDEX
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
* RELACIONES
SELECT AFIAFI
SET RELA TO PARENTESCO INTO AFIPAREN
SELECT CITCIT
SET RELA TO MEDICO     INTO SYSMED
SELECT SYSMED
SET RELA TO ESPECI     INTO SYSESP
SELECT CITOCU
SET RELA TO MEDICO     INTO SYSMED
RETURN
************
PROC OPENREC
************
CLOSE DATA
CLOSE INDEX
*** PACIENTES
select 1
use syspac index syspac
select 2
use afiafi index afiafi1
select 3
use sysmed index sysmed1
select 4
use sysesp index sysesp
select 5
use almart index almart,almart3,almart4
select 6
use medrec
store alltrim(wusercode)+".dr1" to wfile
copy stru to &wfile
use &wfile alias medrec
select 8
use hisdet index hisdet
************
PROC OPENREP
************
CLOSE DATA
CLOSE INDEX
*** PACIENTES
select 1
use syspac index syspac
select 2
use afiafi index afiafi1
select 3
use sysmed index sysmed1
select 4
use sysesp index sysesp
select 5
use hisdet index hisdet
RETURN
*******
