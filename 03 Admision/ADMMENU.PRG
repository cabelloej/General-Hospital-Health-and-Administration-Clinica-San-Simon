@ 02,08 say "Ingresos hospitalarios             "
set proc to admproc
close data
close index
*** CONTROL DE ACCESO
SELECT 20
USE SYSUSERD INDEX SYSUSERD
STORE "ADMMENU " TO WPROGRAMA
STORE SPACE(1)   TO WACCESO
STORE SPACE(1)   TO WFILTRO
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
STORE SPACE(03)        TO M.CODDOC
*STORE SPACE(03)       TO WCODMED
STORE SPACE(01)        TO WTIPPAC
STORE SPACE(01)        TO WTIPDES
STORE SPACE(14)        TO WCODPAC
STORE SPACE(10)        TO WCODPAC1
STORE "   0"           TO WCODPAC2
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
STORE 0                TO M.NUMACT
***
STORE SPACE(10)        TO WCUENTA
define menu menuadm bar at line 3
       define pad padadm00 of menuadm prompt "\<Sistema" skip
       define pad padadm01 of menuadm prompt "\<Instala" skip
       define pad padadm02 of menuadm prompt "\<Modulo " skip
       define pad padadm03 of menuadm prompt "\<Tabla  "
       define pad padadm04 of menuadm prompt "\<Accion "
       define pad padadm05 of menuadm prompt "\<Reporte"
       define pad padadm06 of menuadm prompt "\<Proceso"
       define pad padadm07 of menuadm prompt "ma\<Ntto."
       define pad padadm08 of menuadm prompt "\<Salir  "
       on pad padadm03 of menuadm activate popup subadm03
       on pad padadm04 of menuadm activate popup subadm04
       on pad padadm05 of menuadm activate popup subadm05
       on pad padadm06 of menuadm activate popup subadm06
       on pad padadm07 of menuadm activate popup subadm07
       on sele pad padadm08 of menuadm return
       DEFINE POPUP subadm03 FROM 4,30 shadow
              DEFINE BAR 01 OF subadm03 PROMPT "\<Camas                     "
              ON SELECTION POPUP subadm03 DO subadm03 WITH BAR()
       DEFINE POPUP subadm04 FROM 4,40 shadow
              DEFINE BAR 01 OF subadm04 PROMPT "      BUSCAR AFILIADOS      " SKIP
              DEFINE BAR 02 OF subadm04 PROMPT "\<Cedula del titular        "
              DEFINE BAR 03 OF subadm04 PROMPT "cedula del \<Afiliado       "
              DEFINE BAR 04 OF subadm04 PROMPT "\<Nombre del afiliado       "
              DEFINE BAR 05 OF subadm04 PROMPT "numero de \<Historia        "
              DEFINE BAR 06 OF subadm04 PROMPT "    BUSCAR NO AFILIADOS     " SKIP
              DEFINE BAR 07 OF subadm04 PROMPT "c\<Edula del no afiliado    "
              DEFINE BAR 08 OF subadm04 PROMPT "n\<Ombre del no afiliado    "
              DEFINE BAR 09 OF subadm04 PROMPT "n\<Umero de historia        "
              DEFINE BAR 10 OF subadm04 PROMPT " ACTIVIDADES HOSPITALARIAS  " SKIP
              DEFINE BAR 11 OF subadm04 PROMPT "\<Ingresos hospitalarios    "
              DEFINE BAR 12 OF subadm04 PROMPT "emitir \<Solicitud          "
              DEFINE BAR 13 OF subadm04 PROMPT "emitir \<Comprobante        "
              DEFINE BAR 14 OF subadm04 PROMPT "\<Revisar estado de cuenta  "
              DEFINE BAR 15 OF subadm04 PROMPT "re\<Gistros medicos         "
              DEFINE BAR 16 OF subadm04 PROMPT "his\<Toria  medica          "
              DEFINE BAR 17 OF subadm04 PROMPT "consultar \<Vademecum       "
              DEFINE BAR 18 OF subadm04 PROMPT "emitir reci\<Pe medico      "
              DEFINE BAR 19 OF subadm04 PROMPT "emitir reposo \<Medico      "
              DEFINE BAR 20 OF subadm04 PROMPT "sali\<Da del paciente       "
              DEFINE BAR 21 OF subadm04 PROMPT "efect\<Uar cita             "
              ON SELECTION POPUP subadm04 DO subadm04 WITH BAR()
       DEFINE POPUP subadm05 FROM 4,50 shadow
              DEFINE BAR 01 OF subadm05 PROMPT "\<Historias medicas         "
              ON SELECTION POPUP subadm05 DO subadm05 WITH BAR()
       DEFINE POPUP subadm06 FROM 4,60 shadow
       DEFINE POPUP subadm07 FROM 4,70 shadow
              DEFINE BAR 01 OF subadm07 PROMPT "\<Reorganizar indices       "
              DEFINE BAR 02 OF subadm07 PROMPT "\<Compactar tablas de datos "
              ON SELECTION POPUP subadm07 DO subadm07 WITH BAR()
*** ACTIVACION DEL MENU DE FACTURACION
do while .t.
   ACTIVATE MENU menuadm
enddo
RELEASE menuadm
CLOSE DATA
CLOSE INDEX
SET PROC TO SYSPROC

*******************
*** RUTINAS
***
PROCEDURE subadm03
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        select 1
        use SYSCAMA  index SYSCAMA
        librcam=5
        cibrcam=0
        do adm0101
        close data
        close index
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
*** 
PROCEDURE subadm04
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 2
        DO OPENPAC
        save scre to wscre01
        HIDE MENU menuadm
        DO HIS0202
        SHOW MENU menuadm
        restore scre from wscre01
        CLOSE DATA
        CLOSE INDEX
   CASE SELBAR = 3
        DO OPENPAC
        save scre to wscre01
        HIDE MENU menuadm
        DO HIS0203
        SHOW MENU menuadm
        restore scre from wscre01
        CLOSE DATA
        CLOSE INDEX
   CASE SELBAR = 4
        DO OPENPAC
        save scre to wscre01
        HIDE MENU menuadm
        DO HIS0204
        SHOW MENU menuadm
        restore scre from wscre01
        CLOSE DATA
        CLOSE INDEX
   CASE SELBAR = 5
        DO OPENPAC
        save scre to wscre01
        HIDE MENU menuadm
        DO HIS0205
        SHOW MENU menuadm
        restore scre from wscre01
        CLOSE DATA
        CLOSE INDEX
   CASE SELBAR = 7
        DO OPENPAC
        save scre to wscre01
        HIDE MENU menuadm
        DO HIS0207
        SHOW MENU menuadm
        restore scre from wscre01
        CLOSE DATA
        CLOSE INDEX
   CASE SELBAR = 8
        DO OPENPAC
        save scre to wscre01
        HIDE MENU menuadm
        DO HIS0208
        SHOW MENU menuadm
        restore scre from wscre01
        CLOSE DATA
        CLOSE INDEX
   CASE SELBAR = 9
        SET PROC TO HISPROC
        DO OPENPAC
        save scre to wscre01
        HIDE MENU menuadm
        DO HIS0209
        SHOW MENU menuadm
        restore scre from wscre01
        CLOSE DATA
        CLOSE INDEX
        SET PROC TO ADMPROC
   CASE SELBAR = 11
        SET PROC TO ADMPROC
        DO OPENING
        save scre to wscre01
        HIDE MENU menuadm
        DO ADMADM
        restore scre from wscre01
        SHOW MENU menuadm
        CLOSE DATA
        CLOSE INDEX
        SET PROC TO ADMPROC
   CASE SELBAR = 12
        SET PROC TO SERPROC
        DO SEROPSER
        save scre to wscre01
        HIDE MENU MENUADM
        STORE "SOL"         TO WTIPODOC
        STORE "SOLICITUD"   TO WNOMDOC
        DO SERELADC
        restore scre from wscre01
        SHOW MENU MENUADM
        CLOSE DATA
        CLOSE INDEX
        SET PROC TO ADMPROC
   CASE SELBAR = 13
        SET PROC TO SERPROC
        DO SEROPSER
        save scre to wscre01
        HIDE MENU MENUADM
        STORE "COM"         TO WTIPODOC
        STORE "COMPROBANTE" TO WNOMDOC
        DO SERELADC
        restore scre from wscre01
        SHOW MENU MENUADM
        CLOSE DATA
        CLOSE INDEX
        SET PROC TO ADMPROC
   CASE SELBAR = 14
        SET PROC TO ADMPROC
        DO SEROPSER
        save scre to wscre01
        HIDE MENU MENUADM
        DO ADMCAR
        restore scre from wscre01
        SHOW MENU MENUADM
        CLOSE DATA
        CLOSE INDEX
        SET PROC TO ADMPROC
   CASE SELBAR = 15
        SET PROC TO ADMPROC
        DO ADMOPEHO
        save scre to wscre01
        HIDE MENU menuadm
        STORE "I" TO WFLAGHIST
        DO ADMREG
        save scre to wscre01
        HIDE MENU menuadm
        SET PROC TO ADMPROC
        CLOSE DATA
        CLOSE INDEX
   CASE SELBAR = 16
        SET PROC TO HISPROC
        DO OPENHIS
        save scre to wscre01
        HIDE MENU menuadm
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
        SHOW MENU menuadm
        restore scre from wscre01
        CLOSE DATA
        CLOSE INDEX
        SET PROC TO ADMPROC

   CASE SELBAR = 17
        SET PROC TO ADMPROC
        USE ALMART INDEX ALMART,ALMART2,ALMART3,ALMART4
        DO MEDCONVA
        CLOSE DATA
        CLOSE INDEX
        SET PROC TO ADMPROC
   CASE SELBAR = 18
        SET PROC TO ADMPROC
        DO OPENREC
        SAVE SCRE TO WSCRE01
        HIDE MENU menuadm
        DO MEDELARE
        RESTORE SCRE FROM WSCRE01
        SHOW MENU menuadm
        CLOSE DATA
        CLOSE INDEX
        SET PROC TO ADMPROC
   CASE SELBAR = 19
        SET PROC TO ADMPROC
        DO OPENREP
        SAVE SCRE TO WSCRE01
        HIDE MENU menuadm
        DO MEDELARP
        RESTORE SCRE FROM WSCRE01
        SHOW MENU menuadm
        CLOSE DATA
        CLOSE INDEX
        SET PROC TO ADMPROC
   CASE SELBAR = 20
        SET PROC TO ADMPROC
        DO ADMOPEHO
        save scre to wscre01
        HIDE MENU menuadm
        DO ADMSAL
        save scre to wscre01
        HIDE MENU menuadm
        SET PROC TO ADMPROC
        CLOSE DATA
        CLOSE INDEX
   CASE SELBAR = 21
        SET PROC TO CITPROC
        DO OPENCIT
        save scre to wscre01
        HIDE MENU menuadm
        DO CIT0211
        restore scre from wscre01
        SHOW MENU menuadm
        CLOSE DATA
        CLOSE INDEX
        SET PROC TO ADMPROC
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE subadm05
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        DO OPENHIS
        save scre to wscre01
        HIDE MENU menuadm
        STORE "H" TO WFLAGHIST
        DO HISIMPH
        SHOW MENU menuadm
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
PROCEDURE subadm06
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
PROCEDURE subadm07
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
*** CITAS
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
*** RECIPES
select 1
use syspac index syspac, syspac2, syspac3
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
*** REPOSOS
select 1
use syspac index syspac, syspac2, syspac3
select 2
use afiafi index afiafi1
select 3
use sysmed index sysmed1
select 4
use sysesp index sysesp
select 5
use hisdet index hisdet
RETURN
************
PROC OPENING
************
CLOSE DATA
CLOSE INDEX
select 1
use syspac index syspac,syspac2,syspac3
select 2
use afiafi index afiafi1,afiafi2,afiafi3,afiafi4
select 3
use afiparen index afiparen
*** HISTORIA
*select 4
*use hisgru index hisgru
*select 5
*use hissub index hissub
*select 6
*use hisren index hisren
*select 7
*use histab index histab

select 8
use admhgen index admhgen1,admhgen2
select 9
use admhdet index admhdet
select 10
use sysmed index sysmed1, sysmed2
select 11
use sysesp index sysesp
select 12
use admadm index admadm1,admadm2,admadm3,admadm4,admadm5
select 13
use syscama index syscama
select 14
use admdata
select 15
use facprege index facpreg1, facpreg2
*** Miguel: 087 211497   Bco. Caroni cta ahorro 21-02903-30-5
*** RELACIONES

*SELECT HISGEN
*SET RELA TO CODACT     INTO HISGRU,;
*            CODDOC     INTO SYSMED

SELECT AFIAFI
SET RELA TO PARENTESCO INTO AFIPAREN
SELECT SYSMED
SET RELA TO ESPECI     INTO SYSESP
SELECT ADMADM
SET RELA TO MEDICO     INTO SYSMED
RETURN
******

