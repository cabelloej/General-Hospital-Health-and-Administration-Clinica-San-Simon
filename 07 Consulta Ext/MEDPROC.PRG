*********************************************************************************
PROCEDURE INDICES
DEFI WIND WININD FROM 05,50 TO 07,72 ;
                 TITLE " REORGANIZAR " ;
                 DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WININD
@ 0,0 CLEAR
store 2 to wop
do while .t.
   store space(10) to wclaveind
   @ 00,00  say "Clave:" get wclaveind
   read
   if UPPER(wclaveind)<>"EJCM      "
      exit
   endif
   @ 00,00  get wop pict "@*H Aceptar ;Cancelar" defa wop
   read
   if lastkey()=13
      exit
   endif
enddo
if wop=1
   @ 00,00 
   @ 00,00 SAY "Favor esperar..."
else
   RELE WIND WININD
   RETURN
endif
***
STORE "EL SISTEMA SE REINICIARA, OPRIMA <ENTER> PARA CONTINUAR." TO WTEXT
DO AVISO WITH WTEXT
RELE WIND WININD
CLOSE DATA
CLOSE INDEX
SET PROC TO SYSPROC
RETURN TO MASTER
*****************
PROCEDURE COMPACTA
DEFI WIND WINCOM FROM 05,50 TO 07,72 ;
                 TITLE " COMPACTAR " ;
                 DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WINCOM
@ 0,0 CLEAR
store 2 to wop
do while .t.
   store space(10) to wclaveind
   @ 00,00  say "Clave:" get wclaveind
   read
   if UPPER(wclaveind)<>"EJCM      "
      exit
   endif
   @ 00,00  get wop pict "@*H Aceptar ;Cancelar" defa wop
   read
   if lastkey()=13
      exit
   endif
enddo
if wop=1
   @ 00,00 
   @ 00,00 SAY "Favor esperar..."
else
   RELE WIND WINCOM
   RETURN
endif
***
***
STORE "EL SISTEMA SE REINICIARA, OPRIMA <ENTER> PARA CONTINUAR." TO WTEXT
DO AVISO WITH WTEXT
RELE WIND WINCOM
CLOSE DATA
CLOSE INDEX
SET PROCEDURE TO SYSPROC
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
****************************************************************************
PROCEDURE PREGUNTA
STORE .T. TO WPREG
DO WHILE WPREG
   @ 24,0
   STORE SUBSTR(WCH,1,1) TO WCHOICE
   @ 24,40- (LEN(TEX)/2) SAY TEX GET WCHOICE
   READ
   STORE UPPER(WCHOICE) TO WCHOICE
   IF AT(WCHOICE,WCH) > 0
      STORE .F. TO WPREG
      EXIT
   ENDIF
ENDDO
@ 24,0
STORE WCHOICE TO WCH
RETURN
*************************
PROCEDURE MENSAJE
PARAMETERS WTEXT
DEFI WIND WINMES FROM 22,0 TO 24,79 DOUBLE  NOFLOAT;
                 NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WINMES
@ 0,40-(LEN(WTEXT)/2) SAY WTEXT
RELE WIND WINMES
RETURN
*************************
PROCEDURE AVISO
PARAMETERS WTEXT
DEFI WIND WINAVI FROM 22,0 TO 24,79; 
                 DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 07
ACTI WIND WINAVI
?? CHR(7)
@ 0,40-(LEN(WTEXT)/2) SAY WTEXT
READ
RELE WIND WINAVI
RETURN
*************************
PROCEDURE CHKPRINT
PARAMETERS SALTAR
store .t. to wprinting
do while wprinting
   store "Prepare la impresora y oprima <ENTTER> para continuar o (R)echazar" to Qmes
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
*************************
PROCEDURE ARMACOD
STORE LEN(WCODPAC)                              TO WLEN
STORE AT(" ",WCODPAC)                           TO WPOS
STORE SUBSTR(WCODPAC,1,(WPOS-1))                TO WPART1
STORE LTRIM(SUBSTR(WCODPAC,WPOS,(WLEN-WPOS)+1)) TO WPART2
STORE WPART1+"-"+WPART2                         TO WXCODPAC
RETURN
******************
