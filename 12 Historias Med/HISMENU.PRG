@ 02,08 say "Historias medicas                  "
set proc to hisproc
close data
close index

SELECT 20
USE SYSUSERD INDEX SYSUSERD
*** INI CONTROL DE ACCESO
STORE "HISMENU " TO WPROGRAMA
STORE SPACE(1)  TO WACCESO
STORE SPACE(1)  TO WFILTRO
DO CHKACC WITH WUSERCODE,WPROGRAMA,WACCESO,WFILTRO
IF WACCESO=" "
   RETURN
ENDIF
SELECT 20
USE
*** FIN CONTROL DE ACCESO

*** IDENTIFICA SI EL USUARIO ES MEDICO O NO
*** OJO ESTA FUNCION YA ESTA EN EL MENU PRINCIPAL Y NO SE PORQUE ESTA AQUI.
SELECT 20
USE SYSMED
GO TOP
LOCATE FOR USERCODE = WUSERCODE
IF FOUND()
   STORE MEDICO   TO WCODMED
   STORE .T.      TO WFLAGMED
ELSE
   STORE SPACE(3) TO WCODMED
   STORE .F.      TO WFLAGMED
ENDIF
SELECT 20
USE
*** FIN IDENTIFICACION

select 1
use syspac index syspac,syspac2,syspac3
select 2
use afiafi index afiafi1,afiafi2,afiafi3,afiafi4
select 3
use afiparen index afiparen
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
select 10
use sysmed index sysmed1, sysmed2
select 11
use sysesp index sysesp
select 12
use syspto index syspto
SELECT HISGEN
SET RELA TO CODACT     INTO HISGRU,;
            CODDOC     INTO SYSMED
SELECT AFIAFI
SET RELA TO PARENTESCO INTO AFIPAREN
SELECT SYSMED
SET RELA TO ESPECI     INTO SYSESP

STORE SPACE(01)        TO WTIPPAC
STORE SPACE(14)        TO WCODPAC
STORE SPACE(10)        TO WCODPAC1
STORE "0000"           TO WCODPAC2
STORE SPACE(14)        TO WXCODPAC
STORE SPACE(12)        TO WNUMHIS
STORE SPACE(30)        TO WNOMBRE
STORE SPACE(1)         TO WSEXO
STORE CTOD("  -  -  ") TO WNACIMIENTO
STORE SPACE(4)         TO WCODDOC
STORE "H"              TO WFLAGHIST

define menu MENUHIS bar at line 3
       define pad PADHIS00 of MENUHIS prompt "\<Sistema" skip
       define pad PADHIS01 of MENUHIS prompt "\<Instala" skip
       define pad PADHIS02 of MENUHIS prompt "\<Modulo " skip
       define pad PADHIS03 of MENUHIS prompt "\<Tabla  "
       define pad PADHIS04 of MENUHIS prompt "\<Accion "
       define pad PADHIS05 of MENUHIS prompt "\<Reporte"
       define pad PADHIS06 of MENUHIS prompt "\<Proceso"
       define pad PADHIS07 of MENUHIS prompt "ma\<Ntto."
       define pad PADHIS08 of MENUHIS prompt "\<Salir  "
       on pad PADHIS03 of MENUHIS activate popup SUBHIS03
       on pad PADHIS04 of MENUHIS activate popup SUBHIS04
       on pad PADHIS05 of MENUHIS activate popup SUBHIS05
       on pad PADHIS06 of MENUHIS activate popup SUBHIS06
       on pad PADHIS07 of MENUHIS activate popup SUBHIS07
       on sele pad PADHIS08 of MENUHIS return
       DEFINE POPUP SUBHIS03 FROM 4,30 shadow
              DEFINE BAR 01 OF SUBHIS03 PROMPT "\<Actividades               "
              DEFINE BAR 02 OF SUBHIS03 PROMPT "\<Subactividades            "
              DEFINE BAR 03 OF SUBHIS03 PROMPT "\<Renglones                 "
              DEFINE BAR 04 OF SUBHIS03 PROMPT "\<Tabuladores               "
              ON SELECTION POPUP SUBHIS03 DO SUBHIS03 WITH BAR()
       DEFINE POPUP SUBHIS04 FROM 4,40 shadow
              DEFINE BAR 01 OF SUBHIS04 PROMPT "      BUSCAR AFILIADOS      " SKIP
              DEFINE BAR 02 OF SUBHIS04 PROMPT "\<Cedula del titular        "
              DEFINE BAR 03 OF SUBHIS04 PROMPT "cedula del \<Afiliado       "
              DEFINE BAR 04 OF SUBHIS04 PROMPT "\<Nombre del afiliado       "
              DEFINE BAR 05 OF SUBHIS04 PROMPT "numero de \<Historia        "
              DEFINE BAR 06 OF SUBHIS04 PROMPT "    BUSCAR NO AFILIADOS     " SKIP
              DEFINE BAR 07 OF SUBHIS04 PROMPT "c\<Edula del no afiliado    "
              DEFINE BAR 08 OF SUBHIS04 PROMPT "n\<Ombre del no afiliado    "
              DEFINE BAR 09 OF SUBHIS04 PROMPT "numero de h\<Istoria        "
              DEFINE BAR 10 OF SUBHIS04 PROMPT "         HISTORIA           " SKIP
              DEFINE BAR 11 OF SUBHIS04 PROMPT "ac\<Tualizar                "
              ON SELECTION POPUP SUBHIS04 DO SUBHIS04 WITH BAR()
       DEFINE POPUP SUBHIS05 FROM 4,50 shadow
              DEFINE BAR 01 OF SUBHIS05 PROMPT "\<Activ./subac./reng./tab.  "
              DEFINE BAR 02 OF SUBHIS05 PROMPT "\<Historias                 "
              DEFINE BAR 03 OF SUBHIS05 PROMPT "actividades x \<Medico      "
              DEFINE BAR 04 OF SUBHIS05 PROMPT "actividades x a\<Rea de ser."
              ON SELECTION POPUP SUBHIS05 DO SUBHIS05 WITH BAR()
       DEFINE POPUP SUBHIS06 FROM 4,60 shadow
       DEFINE POPUP SUBHIS07 FROM 4,70 shadow
              DEFINE BAR 01 OF SUBHIS07 PROMPT "\<Reorganizar indices       "
              DEFINE BAR 02 OF SUBHIS07 PROMPT "\<Compactar tablas de datos "
              ON SELECTION POPUP SUBHIS07 DO SUBHIS07 WITH BAR()
*** ACTIVACION DEL MENU DE FACTURACION
do while .t.
   ACTIVATE MENU MENUHIS 
enddo
RELEASE MENUHIS
CLOSE DATA
CLOSE INDEX
SET PROC TO SYSPROC

*******************
*** RUTINAS
***
PROCEDURE SUBHIS03
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        SAVE SCRE TO WSCRE01
        STORE 5 TO LIBRGRU
        STORE 5 TO CIBRGRU
        do HISACTG
        RESTORE SCRE FROM WSCRE01
   CASE SELBAR = 2
        SAVE SCRE TO WSCRE01
        STORE 5  TO LIBRGRU
        STORE 5  TO CIBRGRU
        STORE 6  TO LIBRSUB
        STORE 5  TO CIBRSUB
        do HISACTS
        RESTORE SCRE FROM WSCRE01
   CASE SELBAR = 3
        SAVE SCRE TO WSCRE01
        do HISACTR
        RESTORE SCRE FROM WSCRE01
   CASE SELBAR = 4
        SAVE SCRE TO WSCRE01
        do HISACTT
        RESTORE SCRE FROM WSCRE01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
*** 
PROCEDURE SUBHIS04
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 2
        save scre to wscre01
        HIDE MENU MENUHIS
        DO HIS0202
        SHOW MENU MENUHIS
        restore scre from wscre01
   CASE SELBAR = 3
        save scre to wscre01
        HIDE MENU MENUHIS
        DO HIS0203
        SHOW MENU MENUHIS
        restore scre from wscre01
   CASE SELBAR = 4
        save scre to wscre01
        HIDE MENU MENUHIS
        DO HIS0204
        SHOW MENU MENUHIS
        restore scre from wscre01
   CASE SELBAR = 5
        save scre to wscre01
        HIDE MENU MENUHIS
        DO HIS0205
        SHOW MENU MENUHIS
        restore scre from wscre01
   CASE SELBAR = 7
        save scre to wscre01
        HIDE MENU MENUHIS
        DO HIS0207
        SHOW MENU MENUHIS
        restore scre from wscre01
   CASE SELBAR = 8
        save scre to wscre01
        HIDE MENU MENUHIS
        DO HIS0208
        SHOW MENU MENUHIS
        restore scre from wscre01
   CASE SELBAR = 9
        save scre to wscre01
        HIDE MENU MENUHIS
        DO HIS0209
        SHOW MENU MENUHIS
        restore scre from wscre01
   CASE SELBAR = 11
        save scre to wscre01
        HIDE MENU MENUHIS
        DO WHILE .T.
           *** DATOS PERSONALES
           STORE .F. TO WFLAGDP
           DO HISACTDP
           IF .NOT. WFLAGDP
              RETURN
           ENDIF
           IF WACCESO="A"
              *** HISTORIA GENERAL
              DO HISACTHG
           ENDIF
        ENDDO
        SHOW MENU MENUHIS
        restore scre from wscre01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE SUBHIS05
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        save scre to wscre01
        HIDE MENU MENUHIS
        DO HISIMPA
        SHOW MENU MENUHIS
        restore scre from wscre01
   CASE SELBAR = 2
        save scre to wscre01
        HIDE MENU MENUHIS
        STORE "H" TO WFLAGHIST
        DO HISIMPH
        SHOW MENU MENUHIS
        restore scre from wscre01
   CASE SELBAR = 3
        save scre to wscre01
        HIDE MENU MENUHIS
        DO HISIMPE
        SHOW MENU MENUHIS
        restore scre from wscre01
   CASE SELBAR = 4
        save scre to wscre01
        HIDE MENU MENUHIS
        DO HIS0304
        SHOW MENU MENUHIS
        restore scre from wscre01
   ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE SUBHIS06
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
PROCEDURE SUBHIS07
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

