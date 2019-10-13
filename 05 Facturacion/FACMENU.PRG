*** INI CONTROL DE ACCESO
STORE "FACMENU " TO WPROGRAMA
STORE SPACE(1)  TO WACCESO
STORE SPACE(1)  TO WFILTRO
USE SYSUSERD INDEX SYSUSERD
DO CHKACC WITH WUSERCODE,WPROGRAMA,WACCESO,WFILTRO
IF WACCESO=" "
   CLOSE DATA
   CLOSE INDEX
   RETURN
ENDIF
USE
*** FIN CONTROL DE ACCESO
@ 02,08 say "Facturacion                             "
set proc to facproc
close data
close index

select 1
use facdata
select 2
use facgru    index facgru
select 3
use faccli    index faccli
select 4
use facdcge   index facdcge,facdcge2,facdcge3,facdcge4
select 5
use facdcde   index facdcde
select 6 
use facprege  index facpreg1,facpreg2
select 7 
use facprede  index facprede
select 8
use faccxc   index faccxc1,faccxc2,faccxc3
select 9
use faccxctr index faccxct1,faccxct2,faccxct3

select 10
use almdata
select 11
use almart    index almart,almart2,almart3,almart4
select 12
use almtra    index almtra1, almtra2,almtra3
select 13
use almlot    index almlot
select 14
use almlottr  index almlottr

select 15
use syspto    index syspto 
select 16
use sysesp    index sysesp
select 17
use sysservi  index sysservi
select 18
use sysmed    index sysmed1, sysmed2,  sysmed3
select 19
use syspac    index syspac, syspac2, syspac3

select 20
use serdcge   index serdcge,serdcge2,serdcge3,serdcge4
select 21
use serdcde   index serdcde
select 22
use admadm    index admadm1
select 23
use afiafi    index afiafi1
***************************************
define menu menufac bar at line 3
       define pad padfac00 of menufac prompt "\<Sistema" skip
       define pad padfac01 of menufac prompt "\<Instala" skip
       define pad padfac02 of menufac prompt "\<Modulo " skip
       define pad padfac03 of menufac prompt "\<Tabla  "
       define pad padfac04 of menufac prompt "\<Accion "
       define pad padfac05 of menufac prompt "\<Reporte"
       define pad padfac06 of menufac prompt "\<Proceso"
       define pad padfac07 of menufac prompt "ma\<Ntto."
       define pad padfac08 of menufac prompt "\<Salir  "
       on pad padfac03 of menufac activate popup subfac03
       on pad padfac04 of menufac activate popup subfac04
       on pad padfac05 of menufac activate popup subfac05
       on pad padfac06 of menufac activate popup subfac06
       on pad padfac07 of menufac activate popup subfac07
       on sele pad padfac08 of menufac return
       DEFINE POPUP subfac03 FROM 4,30 shadow
              DEFINE BAR 01 OF subfac03 PROMPT "\<Grupos de clientes        "
              DEFINE BAR 02 OF subfac03 PROMPT "\<Clientes                  "
              DEFINE BAR 03 OF subfac03 PROMPT "\<Servicios                 "
              DEFINE BAR 04 OF subfac03 PROMPT "\<Medicamentos y Mat.Med.   " 
              DEFINE BAR 05 OF subfac03 PROMPT "\<Pacientes eventuales      " 
              ON SELECTION POPUP subfac03 DO subfac03 WITH BAR()
       DEFINE POPUP subfac04 FROM 4,40 shadow
              DEFINE BAR 01 OF subfac04 PROMPT "\<Presupuesto            "
              DEFINE BAR 02 OF subfac04 PROMPT "\<Facturacion            "
              DEFINE BAR 03 OF subfac04 PROMPT "\<Cuentas por cobrar     "
              ON SELECTION POPUP subfac04 DO subfac04 WITH BAR()
       DEFINE POPUP subfac05 FROM 4,50 shadow
              DEFINE BAR 01 OF subfac05 PROMPT "\<Grupos de clientes           "
              DEFINE BAR 02 OF subfac05 PROMPT "\<Clientes                     "
              DEFINE BAR 03 OF subfac05 PROMPT "resumen general de \<Facturas  "
              DEFINE BAR 04 OF subfac05 PROMPT "resumen \<Area / autor         "
              DEFINE BAR 05 OF subfac05 PROMPT "resumen au\<Tor/ area          "    
              DEFINE BAR 06 OF subfac05 PROMPT "resumen area / \<Servicio      "
              DEFINE BAR 07 OF subfac05 PROMPT "resumen autor/ ser\<Vicio      "
              DEFINE BAR 08 OF subfac05 PROMPT "resumen I.S.L.R. / \<Medicos   "
              DEFINE BAR 09 OF subfac05 PROMPT "c\<Uentas por cobrar           "
              DEFINE BAR 10 OF subfac05 PROMPT "a\<Bonos a cuentas por cobrar  "
              DEFINE BAR 11 OF subfac05 PROMPT "morbilidad por area            "
              DEFINE BAR 12 OF subfac05 PROMPT "morbilidad por especialidad    "
              ON SELECTION POPUP subfac05 DO subfac05 WITH BAR()
       DEFINE POPUP subfac06 FROM 4,60 shadow
              *DEFINE BAR 02 OF subfac06 PROMPT "\<Reprocesar facturas          "
              *DEFINE BAR 03 OF subfac06 PROMPT "\<Cierre de periodo            "
              *ON SELECTION POPUP subfac06 DO subfac06 WITH BAR()
       DEFINE POPUP subfac07 FROM 4,70 shadow
              DEFINE BAR 01 OF subfac07 PROMPT "\<Reorganizar indices       "
              DEFINE BAR 02 OF subfac07 PROMPT "\<Compactar tablas de datos "
              ON SELECTION POPUP subfac07 DO subfac07 WITH BAR()
*** ACTIVACION DEL MENU DE FACTURACION
do while .t.
   ACTIVATE MENU menufac 
enddo
RELEASE menufac
CLOSE DATA
CLOSE INDEX
SET PROC TO SYSPROC

*******************
*** RUTINAS
***
PROCEDURE subfac03
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        SAVE SCRE TO WSCRE01
        do FAC0101
        RESTORE SCRE FROM WSCRE01
   CASE SELBAR = 2
        SAVE SCRE TO WSCRE01
        do FAC0102
        RESTORE SCRE FROM WSCRE01
   CASE SELBAR = 3
        SAVE SCRE TO WSCRE01
        STORE 5 TO LIBRSER
        STORE 0 TO CIBRSER
        do SYS0106
        RESTORE SCRE FROM WSCRE01
   CASE SELBAR = 4
        SAVE SCRE TO WSCRE01
        DO MEDCONVA
        RESTORE SCRE FROM WSCRE01
   CASE SELBAR = 5
        SAVE SCRE TO WSCRE01
        STORE 05 TO LIBRPAC
        STORE 00 TO CIBRPAC
        DO SYS0103
        RESTORE SCRE FROM WSCRE01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
*** 
PROCEDURE subfac04
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        save scre to wscre01
        HIDE MENU menufac
        DO FAC0201
        SHOW MENU menufac
        restore scre from wscre01
   CASE SELBAR = 2
        save scre to wscre01
        HIDE MENU menufac
        DO FAC0202
        SHOW MENU menufac
        restore scre from wscre01
   CASE SELBAR = 3
        save scre to wscre01
        HIDE MENU menufac
        DO FAC0203
        SHOW MENU menufac
        restore scre from wscre01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE subfac05
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        save scre to wscre01
        DO FAC0301
        restore scre from wscre01
   CASE SELBAR = 2
        save scre to wscre01
        DO FAC0302
        restore scre from wscre01
   CASE SELBAR = 3
        save scre to wscre01
        DO FAC0303
        restore scre from wscre01
   CASE SELBAR = 4
        save scre to wscre01
        DO FAC0304
        restore scre from wscre01
   CASE SELBAR = 5
        save scre to wscre01
        DO FAC0305
        restore scre from wscre01
   CASE SELBAR = 6
        save scre to wscre01
        DO FAC0306
        restore scre from wscre01
   CASE SELBAR = 7
        save scre to wscre01
        DO FAC0307
        restore scre from wscre01
   CASE SELBAR = 8
        save scre to wscre01
        DO FAC0308
        restore scre from wscre01
   CASE SELBAR = 9
        save scre to wscre01
        DO FAC0309
        restore scre from wscre01
   CASE SELBAR = 10
        save scre to wscre01
        DO FAC0310
        restore scre from wscre01
   CASE SELBAR = 11
        save scre to wscre01
        DO FAC0311
        restore scre from wscre01
   CASE SELBAR = 12
        save scre to wscre01
        DO FAC0312
        restore scre from wscre01

ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE subfac06
PARAMETERS SELBAR
DO CASE
   CASE SELBAR = 1
        save scre to wscre01
        *DO FAC0401
        restore scre from wscre01
   CASE SELBAR = 2
        save scre to wscre01
        *DO FAC0402
        restore scre from wscre01
   CASE SELBAR = 3
        save scre to wscre01
        *DO FAC0403
        restore scre from wscre01
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
RETURN
***
PROCEDURE subfac07
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

