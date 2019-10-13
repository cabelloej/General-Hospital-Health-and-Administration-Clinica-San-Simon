@ 02,08 say "Servicios internos                      "
set proc to SERPROC
close data
close index
DO SEROPSER
***************************************
*** INI CONTROL DE ACCESO
STORE "SERMENU" TO WPROGRAMA
STORE SPACE(1)  TO WACCESO
STORE SPACE(1)  TO WFILTRO
DO CHKACC WITH WUSERCODE,WPROGRAMA,WACCESO,WFILTRO
IF WACCESO=" "
   RETURN
ENDIF
*** FIN CONTROL DE ACCESO

*** INICIALIZACION DE VARIABLES
STORE SPACE(1)         TO WTIPPAC
STORE SPACE(14)        TO WCODPAC

define menu menuord bar at line 3
       define pad padord00 of menuord prompt "\<Sistema" skip
       define pad padord01 of menuord prompt "\<Instala" skip
       define pad padord02 of menuord prompt "\<Modulo " skip
       define pad padord03 of menuord prompt "\<Tabla  "
       define pad padord04 of menuord prompt "\<Accion "
       define pad padord05 of menuord prompt "\<Reporte"
       define pad padord06 of menuord prompt "\<Proceso"
       define pad padord07 of menuord prompt "ma\<Ntto."
       define pad padord08 of menuord prompt "\<Salir  "
       on pad padord03 of menuord activate popup subord03
       on pad padord04 of menuord activate popup subord04
       on pad padord05 of menuord activate popup subord05
       on pad padord06 of menuord activate popup subord06
       on pad padord07 of menuord activate popup subord07
       on sele pad padord08 of menuord return
       DEFINE POPUP subord03 FROM 4,30 shadow
              DEFINE BAR 01 OF subord03 PROMPT "\<Servicios                 "
              ON SELECTION POPUP subord03 DO subord03 WITH BAR()
       DEFINE POPUP subord04 FROM 4,40 shadow
              DEFINE BAR 01 OF subord04 PROMPT "emitir \<Solicitud          "
              DEFINE BAR 02 OF subord04 PROMPT "emitir \<Comprobante        "
              ON SELECTION POPUP subord04 DO subord04 WITH BAR()
       DEFINE POPUP subord05 FROM 4,50 shadow
              DEFINE BAR 01 OF subord05 PROMPT "\<Solicitudes                "
              DEFINE BAR 02 OF subord05 PROMPT "\<Comprobantes               "
              DEFINE BAR 03 OF subord05 PROMPT "morbilidad por \<Area        "
              DEFINE BAR 04 OF subord05 PROMPT "morbilidad por \<Especialidad"
              DEFINE BAR 05 OF subord05 PROMPT "morbilidad por \<Medico      "
              DEFINE BAR 06 OF subord05 PROMPT "e\<Xoneraciones              "
              DEFINE BAR 07 OF subord05 PROMPT "\<Listado de servicios       "
              ON SELECTION POPUP subord05 DO subord05 WITH BAR()
       DEFINE POPUP subord06 FROM 4,60 shadow
             *DEFINE BAR 01 OF subord06 PROMPT "\<Reprocesar servicios      "
             *DEFINE BAR 02 OF subord06 PROMPT "\<Cierre de periodo         "
              ON SELECTION POPUP subord06 DO subord06 WITH BAR()
       DEFINE POPUP subord07 FROM 4,70 shadow
              DEFINE BAR 01 OF subord07 PROMPT "\<Reorganizar indices       "
              DEFINE BAR 02 OF subord07 PROMPT "\<Compactar tablas de datos "
              ON SELECTION POPUP subord07 DO subord07 WITH BAR()
*** ACTIVACION DEL MENU DE ORDENES
do while .t.
   ACTIVATE MENU menuord 
enddo
RELEASE menuord
CLOSE DATA
CLOSE INDEX
SET PROC TO SYSPROC

*******************
*** RUTINAS
*******************
PROCEDURE subord03
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        SAVE SCRE TO WSCRE01
        STORE 5 TO LIBRSER
        STORE 0 TO CIBRSER
        do SYS0106
        RESTORE SCRE FROM WSCRE01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
*** 
PROCEDURE subord04
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        save scre to wscre01
        HIDE MENU menuord
        STORE "SOL"         TO WTIPODOC
        STORE "SOLICITUD"   TO WNOMDOC
        DO SERELADC
        SHOW MENU menuord
        restore scre from wscre01
   CASE SELBAR = 2
        save scre to wscre01
        HIDE MENU menuord
        STORE "COM"         TO WTIPODOC
        STORE "COMPROBANTE" TO WNOMDOC
        DO SERELADC
        SHOW MENU menuord
        restore scre from wscre01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE subord05
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        save scre to wscre01
        DO SER0301
        restore scre from wscre01
   CASE SELBAR = 2
        save scre to wscre01
        DO SER0302
        restore scre from wscre01
   CASE SELBAR = 3
        save scre to wscre01
        DO SER0303
        restore scre from wscre01
   CASE SELBAR = 4
        save scre to wscre01
        DO SER0304
        restore scre from wscre01
   CASE SELBAR = 5
        save scre to wscre01
        DO SER0305
        restore scre from wscre01
   CASE SELBAR = 6
        save scre to wscre01
        DO SER0306
        restore scre from wscre01
   CASE SELBAR = 7
        save scre to wscre01
        DO SYS0106R
        restore scre from wscre01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE subord06
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        save scre to wscre01
        *DO SER0401
        restore scre from wscre01
   CASE SELBAR = 2
        save scre to wscre01
        *DO SER0402
        restore scre from wscre01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE subord07
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
   CASE SELBAR = 3
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***

