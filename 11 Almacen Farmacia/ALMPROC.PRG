PROCEDURE INDICES
store "DESEA REORGANIZAR LOS INDICES (S/N)" TO TEX
STORE "SN" TO WCH
DO PREGUNTA
IF WCH = "N"
   RETURN
ENDIF
@ 0,0 CLEAR
@ 08,5 SAY "REORGANIZANDO INDICES DEBIDO A INTERRUPCION DEL SISTEMA, FAVOR ESPERAR"
CLOSE DATA
CLOSE INDEX

USE ALMLIN
INDEX ON CODIGO TO ALMLIN

USE ALMART
INDEX ON CODIGO       TO ALMART
INDEX ON LINEA+DESCRI TO ALMART2
INDEX ON DESCRI       TO ALMART3
INDEX ON TIPIFICAC    TO ALMART4

USE ALMTRA
INDEX ON CODIGO+SUBS(DTOC(FECHA),7,2)+SUBS(DTOC(FECHA),4,2)+SUBS(DTOC(FECHA),1,2);
        +STR(SERIAL,10)       TO ALMTRA1
INDEX ON SUBS(DTOC(FECHA),7,2)+SUBS(DTOC(FECHA),4,2)+SUBS(DTOC(FECHA),1,2);
        +STR(SERIAL,10)       TO ALMTRA2
INDEX ON REFERENCIA+CODIGO    TO ALMTRA3

USE ALMLOT
INDEX ON CODART+CODLOT TO ALMLOT

USE ALMLOTTR
INDEX ON CODART+CODLOT TO ALMLOTTR

CLOSE DATA
CLOSE INDEX
SET PROC TO SYSPROC
RETURN TO MASTER
****************
PROCEDURE RECLOC
DEFI WIND WINRLOCK FROM 12,05 TO 18,75 DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
STORE .F. TO WFLAGRL
STORE .F. TO WRECMES
STORE .T. TO WRECLOC
DO WHILE WRECLOC
   IF RLOCK()
      STORE .T. TO WFLAGRL
      EXIT
   ELSE
      IF .NOT. WRECMES
         ACTI WIND WINRLOCK
         @ 02,15 SAY "REGISTRO OCUPADO POR OTRO USUARIO, REINTENTANDO ..."
         @ 03,15 SAY "          OPRIMA [ESC] PARA ABANDONAR              "
         STORE .T. TO WRECMES
      ENDIF
      WVALUE = INKEY()
      IF WVALUE = 27
         EXIT
      ENDIF
   ENDIF
ENDDO
RELEASE WIND WINRLOCK
RETURN WFLAGRL
******************************************************************************
PROCEDURE FILLOC
DEFI WIND WINFLOCK FROM 12,05 TO 18,75 DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
STORE .F. TO WFLAGFL
STORE .F. TO WFILMES
STORE .T. TO WFILLOC
DO WHILE WFILLOC
   IF FLOCK()
      STORE .T. TO WFLAGFL
      EXIT
   ELSE
      IF .NOT. WFILMES
         ACTI WIND WINFLOCK
         @ 02,15 SAY "ARCHIVO  OCUPADO POR OTRO USUARIO, REINTENTANDO ..."
         @ 03,15 SAY "          OPRIMA [ESC] PARA ABANDONAR              "
         STORE .T. TO WFILMES
      ENDIF
      WVALUE = INKEY()
      IF WVALUE = 27
         EXIT
      ENDIF
   ENDIF
ENDDO
RELEASE WIND WINFLOCK
RETURN WFLAGFL
***********************
PROCEDURE PREGUNTA
STORE .T. TO WPREG
DO WHILE WPREG
   @ 23,0
   STORE SUBSTR(WCH,1,1) TO WCHOICE
   @ 23,40- (LEN(TEX)/2) SAY TEX GET WCHOICE
   READ
   IF AT(WCHOICE,WCH) > 0
      STORE .F. TO WPREG
      EXIT
   ENDIF
ENDDO
@ 23,0
STORE WCHOICE TO WCH
RETURN
*************************
 PROCEDURE MENSAJE
 PARAMETERS MES
 @ 23,1
 @ 23,40-(LEN(MES)/2) SAY MES
 RETURN
 **************************************************
 PROCEDURE AVISO
 PARAMETERS MES
 STORE " " TO X
 ?? CHR(7)
 @ 23,1 SAY SPACE(78)
 @ 23,40-(LEN(MES)/2) SAY MES GET X
 READ
 @ 23,1
 RETURN
 *****************
 PROCEDURE CHKPRINT
 PARAMETERS SALTAR
 store .t. to wprinting
 do while wprinting
    store "Prepare la impresora y oprima (Ù) para continuar o (R)echazar" to Qmes
    @ 23,1 
    @ 23,40-(len(Qmes)/2) say Qmes
    store " " to wstat
    @ 23,78 get wstat
    read
    if upper(wstat) = "R"
       store 1 to saltar
       store .f. to wprinting
    else
       store 0 to saltar
       if sys(13) = "READY"
          store .f. to wprinting
       endif
    endif
    @ 23,1
 enddo
 RETURN
 ******************************************************************
 ***********************
 PROCEDURE INVFIC1
   set color to W+/B
   @ 4,0 clear
   @ 5,0 say  "+-------------------------+----------------------------------------+-----------+"
   @ 6,0 SAY  "|CODIGO DEL ARTICULO      |DESCRIPCION                             |MARCA      |"
   @ 7,0 say  "|-------------------------|----------------------------------------|-----------|"
   @ 08,0 SAY "|                         |                                        |           |"
   @ 09,0 say "|-------------------------|----------------------------------------|-----+-----|"
RETURN
************************
PROCEDURE INVFIC2
   SET COLOR TO W+/B
   @ 10,0 SAY "|UND. DE MED.|PRESENTACION|   MINIMO   |   MAXIMO   |  UBICACION   |  LINEA    |"
   @ 11,0 SAY "|------------|Emp. UndxEmp|------------|------------|--------------|-----------|"
   @ 12,0 SAY "|            |            |            |            |              |           |"
   @ 13,0 SAY "|------------+------------|------------|------------|--------------+-----------+"
   @ 14,0 SAY "| VADEMECUM? |PRECIO VENTA|UND.APERTURA|COS.APERTURA|UND.EXISTENCIA|COS.PROxUND|"
   @ 15,0 SAY "|------------|------------|------------|------------|--------------+-----------+"
   @ 16,0 SAY "|            |            |            |            |              |           |"
   @ 17,0 SAY "+------------+------------+------------+------------+--------------+-----------+"
   @ 18,0 SAY "|ULT.COMPRA  |ULT.REFEREN.|ULT.PROVEE. |ULT.CANTIDAD|ULT.COSTO TOT |ULT.COS.UND|"
   @ 19,0 SAY "+------------+------------+------------+------------+--------------+-----------+"
   @ 20,0 SAY "|            |            |            |            |              |           |"
   @ 21,0 SAY "+------------+------------+------------+------------+--------------+-----------+"
************************
PROCEDURE DADI0301
@ WSCRELIN,1  SAY FECHA
@ WSCRELIN,10 SAY CODIGO
@ WSCRELIN,31 SAY OPERACION
@ WSCRELIN,34 SAY REFERENCIA
@ WSCRELIN,47 SAY UNIDADES PICTURE "#######.##"
@ WSCRELIN,58 SAY COSTO PICTURE "########.##"
@ WSCRELIN,70 SAY PROCLI
@ WSCRELIN,76 SAY ORIGEN
RETURN
******************
PROCEDURE DAGE0301
@ WSCRELIN,1  GET WFECHA
@ WSCRELIN,10 GET WCODIGO
@ WSCRELIN,31 GET WOPERA
@ WSCRELIN,34 GET WREFEREN
@ WSCRELIN,47 GET WUNIDADES PICTURE "#######.##"
@ WSCRELIN,58 GET WCOSTO PICTURE "########.##"
READ
RETURN
********************
PROCEDURE DARE0301
REPLACE FECHA WITH WFECHA
REPLACE CODIGO WITH WCODIGO
REPLACE OPERACION WITH WOPERA
REPLACE REFERENCIA WITH WREFEREN
REPLACE UNIDADES WITH WUNIDADES
REPLACE COSTO WITH WCOSTO
REPLACE ORIGEN WITH WORIGEN
FLUSH
RETURN
**********************
PROCEDURE ERRCON
STORE "ERROR IRRECUPERABLE, EL SISTEMA FINALIZARA. <ENTER>" TO MES
DO AVISO WITH MES
SELECT 10
USE SYSERR
APPEND BLANK
REPLACE NUMERO WITH ERROR()
REPLACE MENSAJE WITH MESSAGE()
REPLACE PROGRAMA WITH SYS(16,4)
REPLACE FECHA WITH WFECACT
REPLACE HORA WITH TIME()
CLOSE ALL
QUIT
RETURN
*************************
PROCEDURE CHKACC
PARAMETERS WUSERCODE,WPROGRAMA,WACCESO,WFILTRO
SELECT SYSUSERD
STORE WUSERCODE+WPROGRAMA TO WCLAVEACC
SEEK WCLAVEACC
IF FOUND()
   STORE ACCESO TO WACCESO
   STORE FILTRO TO WFILTRO
ENDIF
RETURN
******************
PROCEDURE SYSERROR
PARAMETERS WFECHA,WUSERCODE,WERROR,WMENSAJE0,WMENSAJE1,WLINENO,WPROGRAM
CLOSE DATA
CLOSE INDEX
STORE 0 TO WCONT
USE SYSERROR
DO WHILE .T.
   IF FLOCK()
      APPEND BLANK
      REPLACE FECHA      WITH WFECHA
      REPLACE USUARIO    WITH WUSERCODE
      REPLACE ERROR      WITH WERROR
      REPLACE MENSAJE    WITH WMENSAJE0
      REPLACE TEXTO      WITH WMENSAJE1
      REPLACE LINEA      WITH WLINENO
      REPLACE PROGRAMA   WITH WPROGRAM
      EXIT
   ELSE
      STORE WCONT+1 TO WCONT
   ENDIF
   IF WCONT>300
      EXIT
   ENDIF
ENDDO
UNLOCK ALL
CLOSE DATA
CLOSE INDEX
DEACT WIND ALL
RELEASE ALL
CLEAR ALL
RETURN TO MASTER
*****************
