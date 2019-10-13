*** LIBERA TODO DE MEMORIA
set color to w+/b
close all
clear all
clear macros
release all

*** Inicio del setup de foxpro
set alternate off
set ansi on
set autosave on
set bell on
set blink on
set blocksize to 32
set border to single
set brstatus off
set carry off
set century on
set clear on
set clock off
*set clock to 1,35
set color to
set compatible foxplus
set confirm off
set console off
set currency to
set cursor on
set date italian
*set debug off
set decimal to 2
set default to
set delete on
set delimiters off
set development on
set device to screen
*set display to    (no usar)
set dohistory off
set echo off
set escape off
set exact off
set exclusive off
set fields off
set fixed on
*set format to     (no usar, primero verifique)
set fullpath on
*set funtion       (muy interesante, primero verificar)
set heading on
set help off
set hours to 24
set intensity on
set keycomp to dos
set lock off
set message to
set mouse on
set multilocks on
set near off
set notify off
set odometer to
set optimize on
set palette off
set point to
set printer to
set procedure to sysproc
set readborder off
set refresh to 2
set reprocess to 2 seconds
*set resource off
set safety off
set scoreboard off
set separator to
set shadows on
*set skip (one to many relation)
set space on
set status off
set status bar off
set step off
set sticky on
set sysmenu off
set talk off
*set textmerge off
set typeahead to 1
set unique off

*** VALIDACION EJCM
*   cambio de nombre
STORE .F. TO WFLAGQQWW
STORE "IMASUR                                  " TO WCOMPANY
STORE SPACE(40)                                  TO QQWW
DO INFORMA WITH QQWW
IF QQWW<>WCOMPANY
   STORE .T. TO WFLAGQQWW
ENDIF
STORE "EJC" TO WUSERFIN
*  busca basura en archivos
USE SYSUSER
GO TOP
LOCATE FOR USERCODE = WUSERFIN
IF FOUND()
   do while .t.
      do endofme
   enddo
ENDIF
*  fecha de vencimiento
*IF DATE()>=CTOD("15-03-2001").OR.WFLAGQQWW
*   IF FILLOC()
*      APPEND BLANK
*      REPLACE USERCODE WITH WUSERFIN
*      UNLOCK ALL
*   ENDIF
*ENDIF
*
USE
*****
USE SYSDATA
STORE DIRECC1 TO WDIRECC1
STORE DIRECC2 TO WDIRECC2
STORE DIRECC3 TO WDIRECC3
STORE RIF     TO WRIF
STORE NIT     TO WNIT
STORE PORIMP  TO WPORIMP
** fin del setup del foxpro

SET COLOR TO W/B
@ 0,0 CLEAR TO 24,79
SELECT 1
USE SYSUSER  INDEX SYSUSER
SELECT 2
USE SYSUSERD INDEX SYSUSERD
CLEAR
STORE 0 TO WCONTERR
STORE .T. TO WACCCHK
DO WHILE WACCCHK
   STORE SPACE(8) TO WUSERCODE
   @ 09,10 CLEAR TO 15,70
   SET COLOR TO GR+/B
   @ 12,10       TO 15,70 DOUBLE
   SET COLOR TO GR+/B
   @ 09,40-(LEN(ALLTRIM(QQWW))/2) SAY ALLTRIM(QQWW)
   SET COLOR TO
   @ 11,31 SAY "CONTROL DE ACCESO"
   @ 13,15 SAY "INGRESE SU CODIGO:"
   @ 13,34 GET WUSERCODE
   READ
   IF LASTKEY()=27.OR.WUSERCODE=SPACE(10)
      STORE .F. TO WACCCHK
      EXIT
   ENDIF
   SELECT 1
   SEEK WUSERCODE
   IF .NOT. FOUND()
      STORE "Codigo de usuario no registrdado, reintente" TO WTEXT
      DO AVISO WITH WTEXT
      STORE WCONTERR+1 TO WCONTERR
      LOOP
   ENDIF
   @ 13,45 SAY USERDESC
   @ 14,15 SAY "INGRESE SU CLAVE :"
   STORE SPACE(10) TO WUSERACC
   SET COLOR TO B/B,B/B,B/B,B/B,B/B,B/B,B/B,B/B/B/B
   @ 14,34 GET WUSERACC
   READ
   SET COLOR TO
   IF USERACC=WUSERACC
      STORE USERUBI TO WUSERUBI
      STORE USERNOM TO WUSERNOM
      IF USERUBI=SPACE(3)
         SELECT 3
         USE SYSPTO INDEX SYSPTO
         STORE 10 TO LIBRPTO
         STORE 28 TO CIBRPTO
         DEFI WIND BRPTO FROM LIBRPTO,CIBRPTO TO LIBRPTO+10,CIBRPTO+24 ;
                         TITLE " AREAS DE SERVICIO " ;
                         FOOTER " ESC = Seleccionar ";
                         DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
         ACTI WIND BRPTO
         BROWSE FIELDS CODPTO:H="AREA", DESCRI:H="DESCRIPCION";
                NOAPPEND NODELETE NOEDIT NOMENU NOOPTIMIZE REST SAVE IN WINDOW BRPTO;
                FOR UPPER(FIJO)<>"S"
         RELEASE WIND BRPTO
         STORE CODPTO TO WUSERUBI
      ENDIF
      EXIT
   ELSE
      IF WCONTERR>=3
         STORE .F. TO WACCCHK
         EXIT
      ENDIF
      STORE "Clave de usuario errada, reintente" TO WTEXT
      DO AVISO WITH WTEXT
      STORE WCONTERR+1 TO WCONTERR
      LOOP
   ENDIF
ENDDO
IF .NOT. WACCCHK
   IF LASTKEY()<>27
      STORE "Acceso denegado, favor comunicarse con informatica" to wtext
      do aviso with wtext
   ENDIF
   QUIT
ENDIF
SET COLOR TO
*** INI CONTROL DE ACCESO
STORE "SYSMENU" TO WPROGRAMA
STORE SPACE(1)  TO WACCESO
STORE SPACE(1)  TO WFILTRO
DO CHKACC WITH WUSERCODE,WPROGRAMA,WACCESO,WFILTRO
*** FIN CONTROL DE ACCESO
CLOSE DATA
CLOSE INDEX

*** IDENTIFICA SI EL USUARIO ES MEDICO
SELECT 20
USE SYSMED
GO TOP
LOCATE FOR ALLTRIM(USERCODE) = ALLTRIM(WUSERCODE)
IF FOUND()
   STORE MEDICO               TO WCODMED
   STORE ESPECI               TO WCODESP
   STORE NOMBRE               TO WNOMMED
   STORE COLEGIO              TO WCOLEGIO
   STORE MSAS                 TO WMSAS
   STORE .T.                  TO WFLAGMED
ELSE
   STORE SPACE(3)             TO WCODMED
   STORE SPACE(4)             TO WCODESP
   STORE "AUTOR NO ES MEDICO" TO WNOMMED
   STORE SPACE(1)             TO WCOLEGIO
   STORE SPACE(1)             TO WMSAS
   STORE .F.                  TO WFLAGMED
ENDIF
SELECT 20
USE
**************************************************************************
clear
on escape
SET COLOR TO GR+/B
@ 0,31 say "CliniPlus Ver. 1.0"
SET COLOR TO
*SET CLOCK TO 1,35
@ 1,00 SAY QQWW
@ 2,00 SAY "Modulo:                        "
@ 2,52 SAY "por CONTROL INFORMATICO,C.A."
defi wind winmes from 22,0 to 24,79
*define menu menumain bar at line 3 shadow
define menu menumain bar at line 3
       define pad pad00 of menumain prompt "\<Sistema"
       define pad pad01 of menumain prompt "\<Instala"
       define pad pad02 of menumain prompt "\<Modulo "
       define pad pad03 of menumain prompt "\<Tabla  " skip
       define pad pad04 of menumain prompt "\<Accion " skip
       define pad pad05 of menumain prompt "\<Reporte" skip
       define pad pad06 of menumain prompt "\<Proceso" skip
       define pad pad07 of menumain prompt "ma\<Ntto." skip
       *on sele pad pad00 of menumain do salir
       on pad      pad00 of menumain activate popup sub00
       on pad      pad01 of menumain activate popup sub01
       on pad      pad02 of menumain activate popup sub02
       DEFINE POPUP SUB00 FROM 0,0 shadow
              DEFINE BAR 01 OF SUB00 PROMPT "\<Reorganiza indices  "
              DEFINE BAR 02 OF SUB00 PROMPT "com\<Pacta tablas     "
              DEFINE BAR 03 OF SUB00 PROMPT "\<ca\<Mbio de cedulas "
              DEFINE BAR 04 OF SUB00 PROMPT "\<Abandona            "
              ON SELECTION POPUP sub00 DO PROSUB00 WITH BAR()
       DEFINE POPUP SUB01 FROM 4,0 shadow
              DEFINE BAR 01 OF SUB01 PROMPT "a\<Reas de servicio     "
              DEFINE BAR 02 OF SUB01 PROMPT "\<Usuarios              "
              DEFINE BAR 03 OF SUB01 PROMPT "\<Especialidades        "
              DEFINE BAR 04 OF SUB01 PROMPT "pers\<Onal clinico      "
              DEFINE BAR 05 OF SUB01 PROMPT "\<Pacientes eventuales  "
              ON SELECTION POPUP sub01 DO PROSUB01 WITH BAR()
              DEFINE POPUP SUB02 FROM 4,10 shadow
              DEFINE BAR 01 OF SUB02 PROMPT "p\<Acientes regulares        "
              DEFINE BAR 02 OF SUB02 PROMPT "\<Control de citas           "
              DEFINE BAR 03 OF SUB02 PROMPT "\<Historias medicas          "
              DEFINE BAR 04 OF SUB02 PROMPT "con\<Sultas externas         "
              DEFINE BAR 05 OF SUB02 PROMPT "\<Ingresos hospitalarios     "
              DEFINE BAR 06 OF SUB02 PROMPT "\<Laboratorio                "
              DEFINE BAR 07 OF SUB02 PROMPT "ra\<Dilogia                  "
              DEFINE BAR 08 OF SUB02 PROMPT "control de se\<Rvicios       "
              DEFINE BAR 09 OF SUB02 PROMPT "\<Medicamentos y material med"
              DEFINE BAR 10 OF SUB02 PROMPT "ven\<Tas  y ctas x cobrar    "
              DEFINE BAR 11 OF SUB02 PROMPT "com\<Pras y ctas x pagar     "
              ON SELECTION POPUP sub02 DO PROSUB02 WITH BAR()
*** ACTIVACION DEL MENU PRINCIPAL
do while .t.
   ACTIVATE MENU menumain 
enddo
*DEACTIVATE MENU  menumain
*********************************
*** RUTINAS
PROCEDURE PROSUB00
PARAMETERS SELBAR
*HIDE MENU MENUMAIN
*** INI CONTROL DE ACCESO
SELECT 20
USE SYSUSERD INDEX SYSUSERD
STORE "SYSMENU" TO WPROGRAMA
STORE SPACE(1)  TO WACCESO
STORE SPACE(1)  TO WFILTRO
DO CHKACC WITH WUSERCODE,WPROGRAMA,WACCESO,WFILTRO
SELECT 20
USE
*** FIN CONTROL DE ACCESO
DO CASE
   CASE SELBAR = 1
      IF WACCESO="A"
         DO INDICES
      ENDIF
   CASE SELBAR = 2
      IF WACCESO="A"
         DO compacta
      ENDIF
   CASE SELBAR = 3
      SAVE SCRE TO WSCRE01
      IF WACCESO="A".OR.WACCESO="B"
         DO CEDULAS
      ENDIF
      RESTORE SCRE FROM WSCRE01
   CASE SELBAR = 4
      DO SALIR
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
ON KEY LABEL F5
ON KEY LABEL F6
ON KEY LABEL F7
ON KEY LABEL F8
ON KEY LABEL F9
ON KEY LABEL F10
ON KEY LABEL F11
ON KEY LABEL F12
*SHOW MENU MENUMAIN
RETURN
*** 
PROCEDURE PROSUB01
PARAMETERS SELBAR
*HIDE MENU MENUMAIN
*** INI CONTROL DE ACCESO
SELECT 20
USE SYSUSERD INDEX SYSUSERD
STORE "SYSMENU" TO WPROGRAMA
STORE SPACE(1)  TO WACCESO
STORE SPACE(1)  TO WFILTRO
DO CHKACC WITH WUSERCODE,WPROGRAMA,WACCESO,WFILTRO
SELECT 20
USE
*** FIN CONTROL DE ACCESO
DO CASE
   CASE SELBAR = 1
     IF WACCESO="A"
        select 1
        use SYSPTO INDEX SYSPTO
        librpto=5
        cibrpto=0
        do sys0101
        close data
        close index
     ENDIF
   CASE SELBAR = 2
     IF WACCESO="A".OR.WACCESO="B"
        select 1
        use SYSUSER INDEX SYSUSER
        SELECT 2
        USE SYSUSERD INDEX SYSUSERD
        SELECT 3
        USE SYSPRG INDEX SYSPRG
        librUSR=5
        cibrUSR=0
        do sys0102
        close data
        close index
     ENDIF
   CASE SELBAR = 3
     IF WACCESO="A"
        select 1
        use SYSESP INDEX SYSESP
        libresp=5
        cibresp=0
        do sys0105
        close data
        close index
     ENDIF
   CASE SELBAR = 4
     IF WACCESO<>" "
        select 1
        use SYSMED INDEX SYSMED1, SYSMED2, SYSMED3
        select 2
        use SYSESP INDEX SYSESP
        select 3
        use syspto index syspto
        select sysmed
        set rela to especi into sysesp
        librmed=5
        cibrmed=0
        do sys0107
        select sysmed
        set rela to
        close data
        close index
     ENDIF
    CASE SELBAR = 5
     IF WACCESO="A".OR.WACCESO="B"
        select 1
        use SYSPAC INDEX SYSPAC,SYSPAC2,SYSPAC3
        store codpac to m.codpac
        librPAC=5
        cibrPAC=0
        do sys0103
        close data
        close index
    ENDIF
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
ON KEY LABEL F5
ON KEY LABEL F6
ON KEY LABEL F7
ON KEY LABEL F8
ON KEY LABEL F9
ON KEY LABEL F10
ON KEY LABEL F11
ON KEY LABEL F12
*SHOW MENU MENUMAIN
RETURN
*** 
PROCEDURE PROSUB02
PARAMETERS SELBAR
HIDE MENU MENUMAIN
CLOSE DATA
CLOSE INDEX
DO CASE
   CASE SELBAR = 1
        DO AFIMENU
   CASE SELBAR = 2
        DO CITMENU
   CASE SELBAR = 3
        DO HISMENU
   CASE SELBAR = 4
        DO MEDMENU
   CASE SELBAR = 5
        DO ADMMENU
   CASE SELBAR = 6
        DO LABMENU
   CASE SELBAR = 7
        DO RADMENU
   CASE SELBAR = 8
        DO SERMENU
   CASE SELBAR = 9
        DO ALMMENU
   CASE SELBAR = 10
        DO FACMENU
   CASE SELBAR = 11
        DO COMMENU
ENDCASE
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
ON KEY LABEL F4
ON KEY LABEL F5
ON KEY LABEL F6
ON KEY LABEL F7
ON KEY LABEL F8
ON KEY LABEL F9
ON KEY LABEL F10
ON KEY LABEL F11
ON KEY LABEL F12
CLOSE DATA
CLOSE INDEX
SET PROC  TO SYSPROC
SET COLOR TO
@ 02,08 say SPACE(40)
SHOW MENU MENUMAIN
RETURN
***
PROCEDURE SALIR
RELEASE MENUMAIN
CLOSE DATA
CLOSE INDEX
CLOSE ALL
RELEASE ALL
QUIT
