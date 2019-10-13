@ 02,08 say "Almacen de medicamentos        "
set proc to ALMPROC

SELECT 1
USE ALMLIN   INDEX ALMLIN
SELECT 2
USE ALMART   INDEX ALMART,ALMART2,ALMART3,ALMART4
SELECT 3
USE ALMTRA   INDEX ALMTRA1,ALMTRA2,ALMTRA3
SELECT 4
USE ALMLOT   INDEX ALMLOT
SELECT 5
USE ALMLOTTR INDEX ALMLOTTR
SELECT 6
USE ALMDATA
SELECT 7
USE BCBENEFI INDEX BCBENEF1,BCBENEF2
SELECT 8
USE SYSPTO INDEX SYSPTO
SELECT 10
USE SYSUSERD INDEX SYSUSERD
*** INI CONTROL DE ACCESO
STORE "ALMMENU" TO WPROGRAMA
STORE SPACE(1)  TO WACCESO
STORE SPACE(1)  TO WFILTRO
DO CHKACC WITH WUSERCODE,WPROGRAMA,WACCESO,WFILTRO
IF WACCESO=" "
   RETURN
ENDIF
*** FIN CONTROL DE ACCESO
***************************************
define menu MENUALM bar at line 3
       define pad PADALM00 of MENUALM prompt "\<Sistema" skip
       define pad PADALM01 of MENUALM prompt "\<Instala" skip
       define pad PADALM02 of MENUALM prompt "\<Modulo " skip
       define pad PADALM03 of MENUALM prompt "\<Tabla  "
       define pad PADALM04 of MENUALM prompt "\<Accion "
       define pad PADALM05 of MENUALM prompt "\<Reporte"
       define pad PADALM06 of MENUALM prompt "\<Proceso"
       define pad PADALM07 of MENUALM prompt "ma\<Ntto."
       define pad PADALM08 of MENUALM prompt "\<Salir  "
       on pad PADALM03 of MENUALM activate popup SUBALM03
       on pad PADALM04 of MENUALM activate popup SUBALM04
       on pad PADALM05 of MENUALM activate popup SUBALM05
       on pad PADALM06 of MENUALM activate popup SUBALM06
       on pad PADALM07 of MENUALM activate popup SUBALM07
       on sele pad PADALM08 of MENUALM return
       DEFINE POPUP SUBALM03 FROM 4,30 shadow
              DEFINE BAR 01 OF SUBALM03 PROMPT "\<Lineas de articulos       "
              DEFINE BAR 02 OF SUBALM03 PROMPT "\<Articulos                 "
              DEFINE BAR 03 OF SUBALM03 PROMPT "\<Vademecum                 "
              ON SELECTION POPUP SUBALM03 DO SUBALM03 WITH BAR()
       DEFINE POPUP SUBALM04 FROM 4,40 shadow
              DEFINE BAR 01 OF SUBALM04 PROMPT "\<Incluir  mov.de articulos "
              DEFINE BAR 02 OF SUBALM04 PROMPT "\<Eliminar mov.de articulos "
              DEFINE BAR 03 OF SUBALM04 PROMPT "\<Modificar mov.de articulos"
              *DEFINE BAR 04 OF SUBALM04 PROMPT "\<Sub Almacenes             "
              *DEFINE BAR 05 OF SUBALM04 PROMPT "\<Movimiento de subalmacenes"
              ON SELECTION POPUP SUBALM04 DO SUBALM04 WITH BAR()
       DEFINE POPUP SUBALM05 FROM 4,50 shadow
              DEFINE BAR 01 OF SUBALM05 PROMPT "\<Lineas                    "
              DEFINE BAR 02 OF SUBALM05 PROMPT "\<Articulos                 "
              DEFINE BAR 03 OF SUBALM05 PROMPT "\<Precios                   "
              DEFINE BAR 04 OF SUBALM05 PROMPT "\<Costos                    "
              DEFINE BAR 05 OF SUBALM05 PROMPT "\<Movimientos               "
              DEFINE BAR 06 OF SUBALM05 PROMPT "\<Existencias               "
              *DEFINE BAR 07 OF SUBALM05 PROMPT "\<Subalmacenes              "
              ON SELECTION POPUP SUBALM05 DO SUBALM05 WITH BAR()
       DEFINE POPUP SUBALM06 FROM 4,60 shadow
              DEFINE BAR 01 OF SUBALM06 PROMPT "\<Reprocesar movimientos    "
              DEFINE BAR 02 OF SUBALM06 PROMPT "\<re\<Costeo                "
              DEFINE BAR 03 OF SUBALM06 PROMPT "\<re\<Preciacion            "
              DEFINE BAR 04 OF SUBALM06 PROMPT "\<Cierre de periodo         "
              ON SELECTION POPUP SUBALM06 DO SUBALM06 WITH BAR()
       DEFINE POPUP SUBALM07 FROM 4,70 shadow
              DEFINE BAR 01 OF SUBALM07 PROMPT "\<Reorganizar indices       "
              DEFINE BAR 02 OF SUBALM07 PROMPT "\<Compactar tablas de datos "
              ON SELECTION POPUP SUBALM07 DO SUBALM07 WITH BAR()
*** ACTIVACION DEL MENU DE ALMACEN
do while .t.
   ACTIVATE MENU MENUALM 
enddo
RELEASE MENUALM
CLOSE DATA
CLOSE INDEX
SET PROC TO SYSPROC
RETURN
*** 
PROCEDURE SUBALM03
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        SAVE SCRE TO WSCRE01
        do ALM0101
        RESTORE SCRE FROM WSCRE01
   CASE SELBAR = 2
        SAVE SCRE TO WSCRE01
        do ALM0102
        RESTORE SCRE FROM WSCRE01
   CASE SELBAR = 3
        SAVE SCRE TO WSCRE01
        DO MEDCONVA
        RESTORE SCRE FROM WSCRE01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
*** 
PROCEDURE SUBALM04
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        save scre to wscre01
        HIDE MENU MENUALM
        STORE .F. TO WFLAGACT
        STORE .F. TO FLAGASK
        STORE "INV" TO WRESPALDO
        DO ALMTRA
        IF WFLAGACT
           DO ALMREP
        ENDIF
        SELECT ALMTRA
        SET ORDER TO 1
        SHOW MENU MENUALM
        restore scre from wscre01
   CASE SELBAR = 2
        save scre to wscre01
        HIDE MENU MENUALM
        STORE .F. TO WFLAGACT
        STORE .F. TO FLAGASK
        STORE "INV" TO WRESPALDO
        DO ALMTRE
        IF WFLAGACT
           DO ALMREP
        ENDIF
        SELECT ALMTRA
        SET ORDER TO 1
        SHOW MENU MENUALM
        restore scre from wscre01
   CASE SELBAR = 3
        save scre to wscre01
        HIDE MENU MENUALM
        STORE .F. TO WFLAGACT
        STORE .F. TO FLAGASK
        STORE "INV" TO WRESPALDO
        DO ALMTRM
        IF WFLAGACT
           DO ALMREP
        ENDIF
        SELECT ALMTRA
        SET ORDER TO 1
        SHOW MENU MENUALM
        restore scre from wscre01
   CASE SELBAR = 4
        save scre to wscre01
        HIDE MENU MENUALM
        DO ALMLOT
        SHOW MENU MENUALM
        restore scre from wscre01
   CASE SELBAR = 5
        SAVE SCRE TO WSCRE01
        HIDE MENU MENUALM
        DO ALMLOTTR
        SHOW MENU MENUALM
        RESTORE SCRE FROM WSCRE01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE SUBALM05
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        save scre to wscre01
        HIDE MENU MENUALM
        DO ALM0301
        SHOW MENU MENUALM
        restore scre from wscre01
   CASE SELBAR = 2
        save scre to wscre01
        HIDE MENU MENUALM
        DO ALM0302
        SHOW MENU MENUALM
        restore scre from wscre01
   CASE SELBAR = 3
        save scre to wscre01
        HIDE MENU MENUALM
        DO ALM0303
        SHOW MENU MENUALM
        restore scre from wscre01
   CASE SELBAR = 4
        save scre to wscre01
        HIDE MENU MENUALM
        DO ALM0304
        SHOW MENU MENUALM
        restore scre from wscre01
   CASE SELBAR = 5
        save scre to wscre01
        HIDE MENU MENUALM
        DO ALM0305
        SHOW MENU MENUALM
        restore scre from wscre01
   CASE SELBAR = 6
        save scre to wscre01
        HIDE MENU MENUALM
        DO ALM0306
        SHOW MENU MENUALM
        restore scre from wscre01
   CASE SELBAR = 7
        save scre to wscre01
        HIDE MENU MENUALM
        DO ALM0307
        SHOW MENU MENUALM
        restore scre from wscre01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE SUBALM06
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        save scre to wscre01
        STORE .T. TO FLAGASK
        DO ALMREP
        restore scre from wscre01
   CASE SELBAR = 2
        save scre to wscre01
        DO ALMCOS
        restore scre from wscre01
   CASE SELBAR = 3
        save scre to wscre01
        DO ALMPRE
        restore scre from wscre01
   CASE SELBAR = 4
        save scre to wscre01
        DO ALMEND
        restore scre from wscre01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE SUBALM07
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

