@ 02,08 say "Radiologia                         "
set proc to radproc
close data
close index
*** CONTROL DE ACCESO
SELECT 20
USE SYSUSERD INDEX SYSUSERD
STORE "RADMENU " TO WPROGRAMA
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
define menu MENULAB bar at line 3
       define pad PADLAB00 of MENULAB prompt "\<Sistema" skip
       define pad PADLAB01 of MENULAB prompt "\<Instala" skip
       define pad PADLAB02 of MENULAB prompt "\<Modulo " skip
       define pad PADLAB03 of MENULAB prompt "\<Tabla  "
       define pad PADLAB04 of MENULAB prompt "\<Accion "
       define pad PADLAB05 of MENULAB prompt "\<Reporte"
       define pad PADLAB06 of MENULAB prompt "\<Proceso"
       define pad PADLAB07 of MENULAB prompt "ma\<Ntto."
       define pad PADLAB08 of MENULAB prompt "\<Salir  "
       on pad PADLAB03 of MENULAB activate popup SUBLAB03
       on pad PADLAB04 of MENULAB activate popup SUBLAB04
       on pad PADLAB05 of MENULAB activate popup SUBLAB05
       on pad PADLAB06 of MENULAB activate popup SUBLAB06
       on pad PADLAB07 of MENULAB activate popup SUBLAB07
       on sele pad PADLAB08 of MENULAB return
       DEFINE POPUP SUBLAB03 FROM 4,30 shadow
             *DEFINE BAR 01 OF SUBLAB03 PROMPT "                            "
             *ON SELECTION POPUP SUBLAB03 DO SUBLAB03 WITH BAR()
       DEFINE POPUP SUBLAB04 FROM 4,40 shadow
              DEFINE BAR 01 OF SUBLAB04 PROMPT "      BUSCAR AFILIADOS      " SKIP
              DEFINE BAR 02 OF SUBLAB04 PROMPT "\<Cedula del titular        "
              DEFINE BAR 03 OF SUBLAB04 PROMPT "cedula del \<Afiliado       "
              DEFINE BAR 04 OF SUBLAB04 PROMPT "\<Nombre del afiliado       "
              DEFINE BAR 05 OF SUBLAB04 PROMPT "numero de \<Historia        "
              DEFINE BAR 06 OF SUBLAB04 PROMPT "    BUSCAR NO AFILIADOS     " SKIP
              DEFINE BAR 07 OF SUBLAB04 PROMPT "c\<Edula del no afiliado    "
              DEFINE BAR 08 OF SUBLAB04 PROMPT "n\<Ombre del no afiliado    "
              DEFINE BAR 09 OF SUBLAB04 PROMPT "numero de h\<Istoria        "
              DEFINE BAR 10 OF SUBLAB04 PROMPT "       RADIOLOGIA           " SKIP
              DEFINE BAR 11 OF SUBLAB04 PROMPT "emitir \<Solicitud          "
              DEFINE BAR 12 OF SUBLAB04 PROMPT "emitir \<Comprobante        "
              DEFINE BAR 13 OF SUBLAB04 PROMPT "ver his\<Toria              "
              DEFINE BAR 14 OF SUBLAB04 PROMPT "resultado de e\<Xamenes     "
              DEFINE BAR 15 OF SUBLAB04 PROMPT "efect\<Uar cita             "
              ON SELECTION POPUP SUBLAB04 DO SUBLAB04 WITH BAR()
       DEFINE POPUP SUBLAB05 FROM 4,50 shadow
              DEFINE BAR 01 OF SUBLAB05 PROMPT "\<Historias medicas         "
              ON SELECTION POPUP SUBLAB05 DO SUBLAB05 WITH BAR()
       DEFINE POPUP SUBLAB06 FROM 4,60 shadow
       DEFINE POPUP SUBLAB07 FROM 4,70 shadow
              DEFINE BAR 01 OF SUBLAB07 PROMPT "\<Reorganizar indices       "
              DEFINE BAR 02 OF SUBLAB07 PROMPT "\<Compactar tablas de datos "
              ON SELECTION POPUP SUBLAB07 DO SUBLAB07 WITH BAR()
*** ACTIVACION DEL MENU DE FACTURACION
do while .t.
   ACTIVATE MENU MENULAB
enddo
RELEASE MENULAB
CLOSE DATA
CLOSE INDEX
SET PROC TO SYSPROC

*******************
*** RUTINAS
***
PROCEDURE SUBLAB03
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
PROCEDURE SUBLAB04
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 2
        DO OPENPAC
        save scre to wscre01
        HIDE MENU MENULAB
        DO HIS0202
        SHOW MENU MENULAB
        restore scre from wscre01
        CLOSE DATA
        CLOSE INDEX
   CASE SELBAR = 3
        DO OPENPAC
        save scre to wscre01
        HIDE MENU MENULAB
        DO HIS0203
        SHOW MENU MENULAB
        restore scre from wscre01
        CLOSE DATA
        CLOSE INDEX
   CASE SELBAR = 4
        DO OPENPAC
        save scre to wscre01
        HIDE MENU MENULAB
        DO HIS0204
        SHOW MENU MENULAB
        restore scre from wscre01
        CLOSE DATA
        CLOSE INDEX
   CASE SELBAR = 5
        DO OPENPAC
        save scre to wscre01
        HIDE MENU MENULAB
        DO HIS0205
        SHOW MENU MENULAB
        restore scre from wscre01
        CLOSE DATA
        CLOSE INDEX
   CASE SELBAR = 7
        DO OPENPAC
        save scre to wscre01
        HIDE MENU MENULAB
        DO HIS0207
        SHOW MENU MENULAB
        restore scre from wscre01
        CLOSE DATA
        CLOSE INDEX
   CASE SELBAR = 8
        DO OPENPAC
        save scre to wscre01
        HIDE MENU MENULAB
        DO HIS0208
        SHOW MENU MENULAB
        restore scre from wscre01
        CLOSE DATA
        CLOSE INDEX
   CASE SELBAR = 9
        SET PROC TO HISPROC
        DO OPENPAC
        save scre to wscre01
        HIDE MENU MENULAB
        DO HIS0209
        SHOW MENU MENULAB
        restore scre from wscre01
        CLOSE DATA
        CLOSE INDEX
        SET PROC TO LABPROC
   CASE SELBAR = 11
        SET PROC TO SERPROC
        DO OPENSER
        save scre to wscre01
        HIDE MENU MENULAB
        STORE "SOL"         TO WTIPODOC
        STORE "SOLICITUD"   TO WNOMDOC
        DO SERELADC
        restore scre from wscre01
        SHOW MENU MENULAB
        CLOSE DATA
        CLOSE INDEX
        SET PROC TO LABPROC
   CASE SELBAR = 12
        SET PROC TO SERPROC
        DO OPENSER
        save scre to wscre01
        HIDE MENU MENULAB
        STORE "COM"         TO WTIPODOC
        STORE "COMPROBANTE" TO WNOMDOC
        DO SERELADC
        restore scre from wscre01
        SHOW MENU MENULAB
        CLOSE DATA
        CLOSE INDEX
        SET PROC TO LABPROC
   CASE SELBAR = 13
        SET PROC TO HISPROC
        DO OPENHIS
        save scre to wscre01
        HIDE MENU MENULAB
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
        SHOW MENU MENULAB
        restore scre from wscre01
        CLOSE DATA
        CLOSE INDEX
        SET PROC TO LABPROC
   CASE SELBAR = 14
        SET PROC TO LABPROC
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
        DO LABOPEEX
        save scre to wscre01
        HIDE MENU MENULAB
        STORE "L" TO WFLAGHIST
        DO LABELAEX
        save scre to wscre01
        HIDE MENU MENULAB
        SET PROC TO LABPROC
        CLOSE DATA
        CLOSE INDEX
   CASE SELBAR = 15
        SET PROC TO CITPROC
        DO OPENCIT
        save scre to wscre01
        HIDE MENU MENULAB
        DO CIT0211
        restore scre from wscre01
        SHOW MENU MENULAB
        CLOSE DATA
        CLOSE INDEX
        SET PROC TO LABPROC

ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE SUBLAB05
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        DO OPENHIS
        save scre to wscre01
        HIDE MENU MENULAB
        STORE "H" TO WFLAGHIST
        DO HISIMPH
        SHOW MENU MENULAB
        restore scre from wscre01
        CLOSE DATA
        CLOSE INDEX
   ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE SUBLAB06
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
PROCEDURE SUBLAB07
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
PROC OPENSER
************
CLOSE DATA
CLOSE INDEX
select 1
use afiafi   index afiafi1,afiafi2,afiafi3
select 4
use syspac   index syspac, syspac2, syspac3

select 5
use serdata
select 6
use serdcge  index serdcge,serdcge2,serdcge3,serdcge4,serdcge5
select 7
use serdcde  index serdcde

select 8
use almart   index almart,ALMART2
select 9
use almtra   index almtra1,almtra2,almtra3
select 10
use almlot   index almlot
select 11
use almlottr index almlottr
select 12
use almdata

select 13
use syspto   index syspto
select 14
use sysservi index sysservi
select 15
use admadm   index admadm1,admadm2,admadm3
select 16
use sysuserd index sysuserd
select 17
use sysmed   index sysmed1,sysmed2,sysmed3
select 18
use sysesp   index sysesp
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

