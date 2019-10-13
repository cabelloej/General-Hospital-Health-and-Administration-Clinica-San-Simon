DEFI WIND WINDDP FROM 03,00 TO 17,72 ;
                 TITLE " IMPRIMIR HISTORIAS " ;
                 DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
STORE "0" TO WCODPAC2
do while .t.
   acti wind winddp
   @ 0,0 clear
   @ 00,02 SAY "Codigo de paciente  :"
   @ 01,02 SAY "Numero de historia  :"
   @ 02,02 SAY "Nombre              :"
   @ 03,02 SAY "Autor               :"
   @ 04,02 SAY "Desde               :"
   @ 05,02 SAY "Hasta               :"
   @ 06,02 SAY "Tipo de actividad   :"
   @ 07,02 SAY "Numero de actividad :"
   @ 08,02 SAY "Formato             :"
   @ 09,02 SAY "Salida              :"
   @ 10,02 SAY "Opciones            :"
   STORE "T"                       TO WTIPPAC
   STORE "T"                       TO WSEXO
   STORE CTOD("  -  -  ")          TO WNACDESDE
   STORE CTOD("  -  -  ")          TO WNACHASTA
   STORE DATE()                    TO WDESDE
   STORE DATE()                    TO WHASTA
   STORE SPACE(3)                  TO WCODDOC
   STORE SPACE(2)                  TO WGRUPO
   STORE 0                         TO WNUMACT
   STORE SPACE(3)                  TO WCODSUB
   STORE SPACE(3)                  TO WCODREN
   STORE SPACE(3)                  TO WCODTAB
   STORE SPACE(40)                 TO WVALDAT

   STORE SPACE(20)                 TO WTIPDES
   STORE SPACE(20)                 TO WSEXDES
   STORE SPACE(20)                 TO WDESDES
   STORE SPACE(20)                 TO WDESHAS
   STORE SPACE(20)                 TO WDESDOC
   STORE SPACE(20)                 TO WDESGRU
   STORE SPACE(20)                 TO WDESSUB
   STORE SPACE(20)                 TO WDESREN
   STORE SPACE(20)                 TO WDESTAB

   STORE .F.                       TO WREPGEN
   
   *** codigo de paciente
   STORE .F.                       TO WFLAGCOD
   @ 12,0
   @ 12,0 say "<ESC> = salir, <ENTER> = buscar historia"
   @ 00,25 GET WCODPAC1
   READ
   IF LASTKEY()=27
      RELE WIND WINDDP
      RETURN
   ENDIF
   IF WCODPAC1<>SPACE(10)
      @ 00,35 SAY "-"
      STORE VAL(WCODPAC2) TO WCODPAC2
      @ 00,36 GET WCODPAC2 PICTURE "9999"
      READ
      STORE STR(WCODPAC2,4) TO WCODPAC2
      IF LASTKEY()=27
         RELE WIND WINDDP
         RETURN
      ENDIF
      DO VALPAC
   ELSE
      STORE SPACE(14) TO WCODPAC
   ENDIF
   IF .NOT.WFLAGCOD
      STORE .F. TO WFLAGHIS
      *** numero de historia
      STORE SPACE(12) TO WNUMHIS
      @ 12,0
      @ 12,0 say "<ESC> = salir, <ENTER> = todos los pacientes"
      @ 01,25 GET WNUMHIS
      READ
      IF LASTKEY()=27
         RELE WIND WINDDP
         RETURN
      ENDIF
      DO VALHIS
   ENDIF
   IF WFLAGCOD.OR.WFLAGHIS
      @ 00,25 SAY SPACE(30)
      @ 00,25 SAY WXCODPAC
      @ 01,25 SAY WNUMHIS
      @ 02,25 SAY WNOMBRE
   ELSE
      @ 02,25 SAY "Todos"
   ENDIF
   *** FILTROS DE DATA DE HISTORIA PARA HISTORIA INDIVIDUAL O MULTIPLE
   @ 12,0
   @ 12,0 say "<ESC> = todos, <ENTER> = seleccionar"
   STORE .F. TO WFLAGGD
   @ 03,25 GET WCODDOC VALID VALDOC()
   READ
   IF LASTKEY()=27.AND..NOT.WFLAGGD.AND.WCODPAC=SPACE(14).AND.WNUMHIS=SPACE(12)
      RELE WIND WINDDP
      RETURN
   ENDIF
   IF WCODDOC=SPACE(3)
      @ 03,25 SAY "Todos"
   ELSE
      @ 03,25 SAY WDESDOC
   ENDIF
   @ 12,0
   @ 12,0 say "<ENTER> = fecha actual"
   @ 04,25 GET WDESDE
   READ
   IF WDESDE=CTOD("  -  -  ")
      @ 04,25 SAY "Primera      "
      STORE CTOD("01-01-80") TO WDESDE
   ENDIF
   @ 12,0
   @ 12,0 say "<ENTER> = fecha actual"
   @ 05,25 GET WHASTA
   READ
   IF WHASTA=CTOD("  -  -  ")
      @ 05,25 SAY "Ultima       "
      STORE CTOD("31-12-3000") TO WHASTA
   ENDIF
   @ 12,0
   @ 12,0 say "<ESC> = todas, <ENTER> para seleccionar"
   @ 06,25 GET WGRUPO VALID VALGRU()
   READ
   IF WGRUPO<>SPACE(2)
      @ 06,25 SAY WDESGRU
      @ 12,0
      @ 12,0 say "<ENTER> = todas"
      @ 07,25 GET WNUMACT PICT "9999"
      READ
      IF WNUMACT = 0
         @ 07,25 SAY "Todos"
      ENDIF
   ELSE
      @ 06,25 SAY "Todos"
      @ 07,25 SAY "Todos"
   ENDIF
   *** Formato
   store 1 to wop
   do while .t.
      @ 12,0
      @ 08,25 get wop pict "@*H Historia ;Informe  " defa wop
      read
      if lastkey()=13
         exit
      endif
   enddo
   store wop to wformato
   store 1 to wop
   do while .t.
      @ 12,0
      @ 09,25 get wop pict "@*H Monitor  ;Impresora" defa wop
      read
      if lastkey()=13
         exit
      endif
   enddo
   store wop to wsalida
   store 1 to wop
   do while .t.
      @ 12,0
      @ 10,27 get wop pict "@*H Aceptar;Cancelar" defa wop
      read
      if lastkey()=13
         exit
      endif
   enddo
   store wop to wopciones
   if wopciones=1
      deac wind winddp
      do hisimphd
      restore scre from wscre01
      acti wind winddp
   endif
enddo
********************************************************************************
*****************
PROCEDURE VALPAC
*****************
STORE WCODPAC1+WCODPAC2 TO WCODPAC
IF WCODPAC1<>SPACE(10).AND.WCODPAC2<>SPACE(4)
   SELECT AFIAFI
   SET ORDER TO AFIAFI1
   SEEK WCODPAC
   IF .NOT. FOUND()
      SELECT SYSPAC
      SET ORDER TO SYSPAC
      SEEK WCODPAC
      IF .NOT. FOUND()
         STORE .F.               TO WFLAGCOD
      ELSE
         STORE "No afiliado"                                     TO WTIPDES
         STORE WCODPAC1+WCODPAC2                                 TO WCODPAC
         STORE ALLTRIM(WCODPAC1)+"-"+ALLTRIM(WCODPAC2)           TO WXCODPAC
         STORE RTRIM(PAPELLIDO)+" "+SUBSTR(SAPELLIDO,1,1)+" "+;
               RTRIM(PNOMBRE)+" "+SUBSTR(SNOMBRE,1,1)            TO WNOMBRE
         STORE HISTORIA                                          TO WNUMHIS
         STORE .T.           TO WFLAGCOD
      ENDIF
   ELSE
      STORE "Afiliado"       TO WTIPDES
      STORE WCODPAC1+WCODPAC2                                 TO WCODPAC
      STORE ALLTRIM(CEDTITU)+"-"+ALLTRIM(CARGA)               TO WXCODPAC
      STORE RTRIM(PAPELLIDO)+" "+SUBSTR(SAPELLIDO,1,1)+" "+;
            RTRIM(PNOMBRE)+" "+SUBSTR(SNOMBRE,1,1)            TO WNOMBRE
      STORE HISTORIA                                          TO WNUMHIS
      STORE .T.           TO WFLAGCOD
   ENDIF
ELSE
   STORE SPACE(14)           TO WCODPAC
   STORE SPACE(14)           TO WXCODPAC
   STORE SPACE(12)           TO WNUMHIS
   STORE SPACE(30)           TO WNOMBRE
   STORE .F.                 TO WFLAGHIS
ENDIF
RETURN
*****************
*****************
PROCEDURE VALHIS
*****************
IF WNUMHIS<>SPACE(12)
   SELECT AFIAFI
   SET ORDER TO AFIAFI4
   SEEK WNUMHIS
   IF .NOT. FOUND()
      SELECT SYSPAC
      SET ORDER TO SYSPAC3
      SEEK WNUMHIS
      IF .NOT. FOUND()
         STORE .F.           TO WFLAGHIS
      ELSE
         STORE CODPAC                                            TO WCODPAC
         STORE ALLTRIM(SUBSTR(CODPAC,1,10))+"-"+ALLTRIM(SUBSTR(CODPAC,11,4)) TO WXCODPAC
         STORE RTRIM(PAPELLIDO)+" "+SUBSTR(SAPELLIDO,1,1)+" "+;
               RTRIM(PNOMBRE)+" "+SUBSTR(SNOMBRE,1,1)            TO WNOMBRE
         STORE HISTORIA                                          TO WNUMHIS
         STORE .T.                                               TO WFLAGHIS
      ENDIF
   ELSE
      STORE CEDTITU+CARGA                                        TO WCODPAC
      STORE ALLTRIM(CEDTITU)+"-"+ALLTRIM(CARGA)                  TO WXCODPAC
      STORE RTRIM(PAPELLIDO)+" "+SUBSTR(SAPELLIDO,1,1)+" "+;
            RTRIM(PNOMBRE)+" "+SUBSTR(SNOMBRE,1,1)               TO WNOMBRE
      STORE HISTORIA                                             TO WNUMHIS
      STORE .T.                                                  TO WFLAGHIS
   ENDIF
ELSE
   STORE SPACE(14)           TO WCODPAC
   STORE SPACE(14)           TO WXCODPAC
   STORE SPACE(12)           TO WNUMHIS
   STORE SPACE(30)           TO WNOMBRE
   STORE .F.                 TO WFLAGHIS
ENDIF
RETURN
***********
PROC VALGRU
***********
SELECT HISGRU
DO WHILE .T.
   SEEK WGRUPO
   IF .NOT. FOUND()
      STORE 09 TO LIBRGRU
      STORE 25 TO CIBRGRU
      DO HISWINGR
      RELE WIND BRGRU
      STORE CODGRU TO WGRUPO
      LOOP
   ELSE
      STORE CODGRU TO WGRUPO
      STORE DESGRU TO WDESGRU
      EXIT
   ENDIF
ENDDO
RETURN
***********
FUNC VALDOC
***********
SELECT SYSMED
DO WHILE .T.
   SEEK WCODDOC
   IF FOUND()
      STORE NOMBRE TO WDESDOC
      STORE  .T.   TO WFLAGGD
      RETURN .T.
   ELSE
      STORE 10 TO LIBRMED
      STORE 25 TO CIBRMED
      DO HISWINMD
      RELE WIND BRMED
      STORE MEDICO TO WCODDOC
      LOOP
   ENDIF
ENDDO
RETURN .T.

