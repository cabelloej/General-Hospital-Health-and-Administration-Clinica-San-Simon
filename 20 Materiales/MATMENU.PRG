@ 02,08 say "Materiales                     "
set proc to MATPROC

SELECT 1
USE MATLIN   INDEX MATLIN
SELECT 2
USE MATART   INDEX MATART,MATART2
SELECT 3
USE MATTRA   INDEX MATTRA1,MATTRA2,MATTRA3
SELECT 5
USE BCBENEFI INDEX BCBENEF1,BCBENEF2
SELECT 6
USE MATDATA
SELECT 7
USE MATDCGE  INDEX MATDCGE, MATDCGE2
SELECT 8
USE MATDCDE  INDEX MATDCDE
SELECT 9
USE MATLOT   INDEX MATLOT
SELECT 10
USE MATLOTTR INDEX MATLOTTR
SELECT 11
USE SYSUSERD INDEX SYSUSERD
SELECT 12
USE SYSPTO INDEX SYSPTO
*** INI CONTROL DE ACCESO
STORE "MATMENU" TO WPROGRAMA
STORE SPACE(1)  TO WACCESO
STORE SPACE(1)  TO WFILTRO
DO CHKACC WITH WUSERCODE,WPROGRAMA,WACCESO,WFILTRO
IF WACCESO=" "
   RETURN
ENDIF
*** FIN CONTROL DE ACCESO
***************************************
define menu MENUMAT bar at line 3
       define pad PADMAT00 of MENUMAT prompt "\<Sistema" skip
       define pad PADMAT01 of MENUMAT prompt "\<Instala" skip
       define pad PADMAT02 of MENUMAT prompt "\<Modulo " skip
       define pad PADMAT03 of MENUMAT prompt "\<Tabla  "
       define pad PADMAT04 of MENUMAT prompt "\<Accion "
       define pad PADMAT05 of MENUMAT prompt "\<Reporte"
       define pad PADMAT06 of MENUMAT prompt "\<Proceso"
       define pad PADMAT07 of MENUMAT prompt "ma\<Ntto."
       define pad PADMAT08 of MENUMAT prompt "\<Salir  "
       on pad PADMAT03 of MENUMAT activate popup SUBMAT03
       on pad PADMAT04 of MENUMAT activate popup SUBMAT04
       on pad PADMAT05 of MENUMAT activate popup SUBMAT05
       on pad PADMAT06 of MENUMAT activate popup SUBMAT06
       on pad PADMAT07 of MENUMAT activate popup SUBMAT07
       on sele pad PADMAT08 of MENUMAT return
       DEFINE POPUP SUBMAT03 FROM 4,30 shadow
              DEFINE BAR 01 OF SUBMAT03 PROMPT "\<Lineas de materiales      "
              DEFINE BAR 02 OF SUBMAT03 PROMPT "\<Materiales                "
              DEFINE BAR 03 OF SUBMAT03 PROMPT "\<Receptores de materiales  "
              ON SELECTION POPUP SUBMAT03 DO SUBMAT03 WITH BAR()
       DEFINE POPUP SUBMAT04 FROM 4,40 shadow
              DEFINE BAR 01 OF SUBMAT04 PROMPT "\<Incluir  movimientos      "
              DEFINE BAR 02 OF SUBMAT04 PROMPT "\<Eliminar movimientos      "
              DEFINE BAR 03 OF SUBMAT04 PROMPT "\<Requisicion               "
              DEFINE BAR 04 OF SUBMAT04 PROMPT "\<Despacho                  "
              ON SELECTION POPUP SUBMAT04 DO SUBMAT04 WITH BAR()
       DEFINE POPUP SUBMAT05 FROM 4,50 shadow
              DEFINE BAR 01 OF SUBMAT05 PROMPT "\<Lineas de materiales      "
              DEFINE BAR 02 OF SUBMAT05 PROMPT "\<Materiales                "
              DEFINE BAR 03 OF SUBMAT05 PROMPT "\<Receptores de materiales  "
              DEFINE BAR 04 OF SUBMAT05 PROMPT "\<Costos                    "
              DEFINE BAR 05 OF SUBMAT05 PROMPT "\<Movimientos               "
              DEFINE BAR 06 OF SUBMAT05 PROMPT "\<Existencias               "
              ON SELECTION POPUP SUBMAT05 DO SUBMAT05 WITH BAR()
       DEFINE POPUP SUBMAT06 FROM 4,60 shadow
              DEFINE BAR 01 OF SUBMAT06 PROMPT "\<Reprocesar movimientos    "
              DEFINE BAR 02 OF SUBMAT06 PROMPT "reprocesar \<Despachos      "
              DEFINE BAR 03 OF SUBMAT06 PROMPT "\<re\<Costeo                "
              DEFINE BAR 04 OF SUBMAT06 PROMPT "\<Cierre de periodo         "
              ON SELECTION POPUP SUBMAT06 DO SUBMAT06 WITH BAR()
       DEFINE POPUP SUBMAT07 FROM 4,70 shadow
              DEFINE BAR 01 OF SUBMAT07 PROMPT "\<Reorganizar indices       "
              DEFINE BAR 02 OF SUBMAT07 PROMPT "\<Compactar tablas de datos "
              ON SELECTION POPUP SUBMAT07 DO SUBMAT07 WITH BAR()
*** ACTIVACION DEL MENU DE MATERIALES
do while .t.
   ACTIVATE MENU MENUMAT 
enddo
RELEASE MENUMAT
CLOSE DATA
CLOSE INDEX
SET PROC TO SYSPROC
RETURN
*** 
PROCEDURE SUBMAT03
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        SAVE SCRE TO WSCRE01
        do MAT0101
        RESTORE SCRE FROM WSCRE01
   CASE SELBAR = 2
        SAVE SCRE TO WSCRE01
        do MAT0102
        RESTORE SCRE FROM WSCRE01
   CASE SELBAR = 3
        SAVE SCRE TO WSCRE01
        do MAT0103
        RESTORE SCRE FROM WSCRE01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
*** 
PROCEDURE SUBMAT04
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        save scre to wscre01
        HIDE MENU MENUMAT
        STORE .F. TO WFLAGACT
        STORE .F. TO FLAGASK
        STORE "INV" TO WRESPALDO
        DO MATTRA
        IF WFLAGACT
           DO MATREP
        ENDIF
        SELECT MATTRA
        SET ORDER TO 1
        SHOW MENU MENUMAT
        restore scre from wscre01
   CASE SELBAR = 2
        SAVE SCRE TO WSCRE01
        HIDE MENU MENUMAT
        STORE .F. TO WFLAGACT
        STORE .F. TO FLAGASK
        STORE "INV" TO WRESPALDO
        DO MATTRE
        IF WFLAGACT
           DO MATREP
        ENDIF
        SELECT MATTRA
        SET ORDER TO 1
        SHOW MENU MENUMAT
        restore scre from wscre01
   CASE SELBAR = 3
        SAVE SCRE TO WSCRE01
        HIDE MENU MENUMAT
        DO MATREQ
        SHOW MENU MENUMAT
        RESTORE SCRE FROM WSCRE01
   CASE SELBAR = 4
        SAVE SCRE TO WSCRE01
        HIDE MENU MENUMAT
        DO MATNOT
        SHOW MENU MENUMAT
        RESTORE SCRE FROM WSCRE01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE SUBMAT05
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        save scre to wscre01
        HIDE MENU MENUMAT
        DO MAT0301
        SHOW MENU MENUMAT
        restore scre from wscre01
   CASE SELBAR = 2
        save scre to wscre01
        HIDE MENU MENUMAT
        DO MAT0302
        SHOW MENU MENUMAT
        restore scre from wscre01
   CASE SELBAR = 3
        save scre to wscre01
        HIDE MENU MENUMAT
        DO MAT0303
        SHOW MENU MENUMAT
        restore scre from wscre01
   CASE SELBAR = 4
        save scre to wscre01
        HIDE MENU MENUMAT
        DO MAT0304
        SHOW MENU MENUMAT
        restore scre from wscre01
   CASE SELBAR = 5
        save scre to wscre01
        HIDE MENU MENUMAT
        DO MAT0305
        SHOW MENU MENUMAT
        restore scre from wscre01
   CASE SELBAR = 6
        save scre to wscre01
        HIDE MENU MENUMAT
        DO MAT0306
        SHOW MENU MENUMAT
        restore scre from wscre01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE SUBMAT06
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        save scre to wscre01
        STORE .T. TO FLAGASK
        DO MATREP
        restore scre from wscre01
   CASE SELBAR = 2
        save scre to wscre01
        DO MATREPDC
        restore scre from wscre01
   CASE SELBAR = 3
        save scre to wscre01
        DO MATCOS
        restore scre from wscre01
   CASE SELBAR = 4
        save scre to wscre01
        DO MATEND
        restore scre from wscre01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE SUBMAT07
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

