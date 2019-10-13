DEFI WIND WINDDP FROM 03,00 TO 23,72 ;
                 TITLE " IMPRIMIR HISTORIAS " ;
                 DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10

do while .t.
   acti wind winddp
   @ 0,0 clear
   @ 00,02 SAY "Codigo de paciente  :"
   @ 01,02 SAY "Historia            :"
   @ 02,02 SAY " -Nombre            :"
   @ 03,02 SAY " -Tipo              :"
   @ 04,02 SAY " -Sexo              :"
   @ 05,02 SAY " -Nacidos desde     :"
   @ 06,02 SAY " -Nacidos hasta     :"
   @ 07,02 SAY "Actividades desde   :"
   @ 08,02 SAY "Actividades hasta   :"
   @ 09,02 SAY "Doctor              :"
   @ 10,02 SAY "Tipo de actividad   :"
   @ 11,02 SAY " -Numero            :"
   @ 12,02 SAY " -Subactividad      :"
   @ 13,02 SAY " -Renglon           :"
   @ 14,02 SAY " -Tabulador         :"
   @ 15,02 SAY " -Data              :"
   @ 16,02 SAY "Formato             :"
   @ 17,02 SAY "Salida              :"
   STORE SPACE(1)                  TO WTIPPAC
   STORE SPACE(1)                  TO WSEXO
   STORE CTOD("  -  -  ")          TO WNAC1
   STORE CTOD("  -  -  ")          TO WNAC2
   STORE CTOD("  -  -  ")          TO WNACDESDE
   STORE CTOD("  -  -  ")          TO WNACHASTA
   STORE CTOD("  -  -  ")          TO WDESDE
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
   ENDIF
   IF .NOT.WFLAGCOD
      STORE .F. TO WFLAGHIS
      *** numero de historia
      STORE SPACE(12) TO WNUMHIS
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
      @ 03,25 SAY WTIPDES
      @ 04,25 SAY WSEXO
      @ 05,25 SAY WNACIMIENTO
      @ 06,25 SAY WNACIMIENTO
   ELSE
      @ 02,25 SAY "Todos"
      *** FILTRO DE DATOS PERSONALES PARA MULTIPLES HISTORIAS
      DO WHILE WTIPPAC=SPACE(1)
         @ 03,25 GET WTIPPAC VALID VALTIP()
         READ
         @ 03,25 SAY WTIPDES
      ENDDO
      DO WHILE WSEXO=SPACE(1)
         @ 04,25 GET WSEXO   VALID VALSEX()
         READ
         @ 04,25 SAY WSEXDES
      ENDDO
      STORE .F. TO WFLAGNAC
      DO WHILE .T.
         @ 05,25 GET WNAC1
         @ 06,25 GET WNAC2 VALID VALNACI()
         READ
         IF WFLAGNAC
            EXIT
         ENDIF
      ENDDO
   ENDIF
   *** FILTROS DE DATA DE HISTORIA PARA HISTORIA INDIVIDUAL O MULTIPLE
   @ 07,25 GET WDESDE
   READ
   IF WDESDE=CTOD("  -  -  ")
      @ 07,25 SAY "Primera      "
      STORE CTOD("01-01-80") TO WDESDE
   ENDIF
   @ 08,25 GET WHASTA
   READ
   IF WHASTA=CTOD("  -  -  ")
      @ 08,25 SAY "Ultima       "
      STORE CTOD("31-12-5000") TO WHASTA
   ENDIF
   @ 09,25 GET WCODDOC VALID VALDOC()
   READ
   IF WCODDOC=SPACE(3)
      @ 09,25 SAY "Todos"
   ELSE
      @ 09,25 SAY WDESDOC
   ENDIF

   @ 10,25 GET WGRUPO VALID VALGRU()
   READ
   IF WGRUPO<>SPACE(2)
      @ 10,25 SAY WDESGRU
      @ 11,25 GET WNUMACT PICT "9999"
      READ
      IF WNUMACT = 0
         @ 11,25 SAY "Todos"
      ENDIF
      @ 12,25 GET WCODSUB VALID VALSUB()
      READ
      IF WCODSUB<>SPACE(3)
         @ 12,25 SAY WDESSUB
         IF ESTSUB="T"
            @ 13,25 GET WCODREN VALID VALREN()
            READ
            IF WCODREN<>SPACE(3)
               @ 13,25 SAY WDESREN
               IF ESTREN="T"
                  @ 14,25 GET WCODTAB VALID VALTAB()
                  READ
                  IF WCODTAB<>SPACE(3)
                     @ 14,25 SAY WDESTAB
                  ELSE
                     @ 14,25 SAY "Todos"
                  ENDIF
               ENDIF
            ELSE
               @ 13,25 SAY "Todos"
               @ 14,25 SAY "Todos"
               @ 15,25 SAY "Todos"
            ENDIF
         ELSE
            @ 13,25 SAY "No aplica"
         ENDIF
      ELSE
         @ 12,25 SAY "Todos"
         @ 13,25 SAY "Todos"
         @ 14,25 SAY "Todos"
         @ 15,25 SAY "Todos"
      ENDIF
   ELSE
      @ 10,25 SAY "Todos"
      @ 11,25 SAY "Todos"
      @ 12,25 SAY "Todos"
      @ 13,25 SAY "Todos"
      @ 14,25 SAY "Todos"
      @ 15,25 SAY "Todos"
   ENDIF
   @ 15,25 GET WVALDAT
   READ
   *** Formato
   store 1 to wop
   do while .t.
      @ 16,25 get wop pict "@*H Historia ;Informe  " defa wop
      read
      if lastkey()=13
         exit
      endif
   enddo
   store wop to wformato
   store 1 to wop
   do while .t.
      @ 17,25 get wop pict "@*H Monitor  ;Impresora" defa wop
      read
      if lastkey()=13
         exit
      endif
   enddo
   store wop to wsalida
   store 1 to wop
   do while .t.
      @ 18,27 get wop pict "@*H Aceptar;Cancelar" defa wop
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
         STORE "N"                                               TO WTIPPAC
         STORE "No afiliado"                                     TO WTIPDES
         STORE WCODPAC1+WCODPAC2                                 TO WCODPAC
         STORE ALLTRIM(WCODPAC1)+"-"+ALLTRIM(WCODPAC2)           TO WXCODPAC
         STORE RTRIM(PAPELLIDO)+" "+SUBSTR(SAPELLIDO,1,1)+" "+;
               RTRIM(PNOMBRE)+" "+SUBSTR(SNOMBRE,1,1)            TO WNOMBRE
         STORE SEXO                                              TO WSEXO
         STORE NACIMIENTO                                        TO WNACIMIENTO
         STORE HISTORIA                                          TO WNUMHIS
         STORE .T.           TO WFLAGCOD
      ENDIF
   ELSE
      STORE "A"              TO WTIPPAC
      STORE "Afiliado"       TO WTIPDES
      STORE WCODPAC1+WCODPAC2                                 TO WCODPAC
      STORE ALLTRIM(CEDTITU)+"-"+ALLTRIM(CARGA)               TO WXCODPAC
      STORE RTRIM(PAPELLIDO)+" "+SUBSTR(SAPELLIDO,1,1)+" "+;
            RTRIM(PNOMBRE)+" "+SUBSTR(SNOMBRE,1,1)            TO WNOMBRE
      STORE SEXO                                              TO WSEXO
      STORE NACIMIENTO                                        TO WNACIMIENTO
      STORE HISTORIA                                          TO WNUMHIS
      STORE .T.           TO WFLAGCOD
   ENDIF
ELSE
   STORE SPACE(14)           TO WCODPAC
   STORE SPACE(14)           TO WXCODPAC
   STORE SPACE(12)           TO WNUMHIS
   STORE SPACE(30)           TO WNOMBRE
   STORE SPACE(1)            TO WSEXO
   STORE CTOD("  -  -  ")    TO WNACIMIENTO
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
         STORE "N"                                               TO WTIPPAC
         STORE "No afiliado"                                     TO WTIPDES
         STORE CODPAC                                            TO WCODPAC
         STORE ALLTRIM(SUBSTR(CODPAC,1,10))+"-"+ALLTRIM(SUBSTR(CODPAC,11,4)) TO WXCODPAC
         STORE RTRIM(PAPELLIDO)+" "+SUBSTR(SAPELLIDO,1,1)+" "+;
               RTRIM(PNOMBRE)+" "+SUBSTR(SNOMBRE,1,1)            TO WNOMBRE
         STORE SEXO                                              TO WSEXO
         STORE NACIMIENTO                                        TO WNACIMIENTO
         STORE HISTORIA                                          TO WNUMHIS
         STORE .T.                                               TO WFLAGHIS
      ENDIF
   ELSE
      STORE "A"           TO WTIPPAC
      STORE "Afiliado"    TO WTIPDES
      STORE CEDTITU+CARGA TO WCODPAC
      STORE ALLTRIM(CEDTITU)+"-"+ALLTRIM(CARGA)                  TO WXCODPAC
      STORE RTRIM(PAPELLIDO)+" "+SUBSTR(SAPELLIDO,1,1)+" "+;
            RTRIM(PNOMBRE)+" "+SUBSTR(SNOMBRE,1,1)               TO WNOMBRE
      STORE SEXO                                                 TO WSEXO
      STORE NACIMIENTO                                           TO WNACIMIENTO
      STORE HISTORIA                                             TO WNUMHIS
      STORE .T.                                                  TO WFLAGHIS
   ENDIF
ELSE
   STORE SPACE(14)           TO WCODPAC
   STORE SPACE(14)           TO WXCODPAC
   STORE SPACE(12)           TO WNUMHIS
   STORE SPACE(30)           TO WNOMBRE
   STORE SPACE(1)            TO WSEXO
   STORE CTOD("  -  -  ")    TO WNACIMIENTO
   STORE .F.                 TO WFLAGHIS
ENDIF
RETURN
***********
FUNC VALTIP
***********
DO CASE
   CASE WTIPPAC="T"
        STORE "Todos"        TO WTIPDES
   CASE WTIPPAC="A"
        STORE "Afiliados"    TO WTIPDES
   CASE WTIPPAC="N"
        STORE "No-afiliados" TO WTIPDES
   CASE WTIPPAC<>"T".AND.WTIPPAC<>"A".AND.WTIPPAC<>"N"
        defi wind wintipo from 09,25 to 13,43
        acti wind wintipo
        @ 00,00 clear
        store " " to wvalop
        do while .t.
           @ 00,01 get wvalop pict "@*V Todos;Afiliados;No-afiliados" defa wvalop
           read
           if lastkey()=13
              RELE WIND WINTIPO
              STORE SUBSTR(WVALOP,1,1) TO WTIPPAC
              STORE WVALOP             TO WTIPDES
              exit
           endif
        enddo
ENDCASE
@ 04,25 SAY WTIPDES
return .t.
***********
FUNC VALSEX
***********
DO CASE
   CASE WSEXO="T"
        STORE "Todos"        TO WSEXDES
   CASE WSEXO="M"
        STORE "Masculino"    TO WSEXDES
   CASE WSEXO="F"
        STORE "Femenino"     TO WSEXDES
   CASE WSEXO<>"T".AND.WSEXO<>"M".AND.WSEXO<>"F"
        defi wind winsexo from 10,25 to 14,43
        acti wind winsexo
        @ 00,00 clear
        store " " to wvalop
        do while .t.
           @ 00,01 get wvalop pict "@*V Todos;Masculino;Femenino" defa wvalop
           read
           if lastkey()=13
              RELE WIND WINSEXO
              STORE SUBSTR(WVALOP,1,1) TO WSEXO
              STORE WVALOP             TO WSEXDES
              exit
           endif
        enddo
ENDCASE
@ 05,25 SAY WSEXDES
return .t.
************
FUNC VALNACI
************
IF WNAC1=CTOD("  -  -  ")
   STORE CTOD("01-01-1800") TO WNACDESDE
ENDIF
IF WNAC2=CTOD("  -  -  ")
   STORE CTOD("31-12-3000") TO WNACHASTA
ENDIF
if WNAC2>=WNAC1
   STORE CTOD("01-01-1800") TO WNACDESDE
   STORE CTOD("31-12-3000") TO WNACHASTA
   STORE .T. TO WFLAGNAC
   RETURN WFLAGNAC
else
   STORE .F. TO WFLAGNAC
   RETURN WFLAGNAC
endif
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
PROC VALSUB
***********
SELECT HISSUB
DO WHILE .T.
   STORE WGRUPO+WCODSUB TO WCLAVESUB
   SEEK WCLAVESUB
   IF .NOT. FOUND()
      STORE 10 TO LIBRSUB
      STORE 25 TO CIBRSUB
      DO HISWINSU
      RELE WIND BRSUB
      STORE CODSUB TO WCODSUB
      LOOP
   ELSE
      STORE CODSUB TO WCODSUB
      STORE DESSUB TO WDESSUB
      EXIT
   ENDIF
ENDDO
RETURN
***********
PROC VALREN
***********
SELECT HISREN
DO WHILE .T.
   STORE WGRUPO+WCODSUB+WCODREN TO WCLAVEREN
   SEEK WCLAVEREN
   IF .NOT. FOUND()
      STORE 10 TO LIBRREN
      STORE 25 TO CIBRREN
      DO HISWINRE
      RELE WIND BRREN
      STORE CODREN TO WCODREN
      LOOP
   ELSE
      STORE CODREN TO WCODREN
      STORE DESREN TO WDESREN
      EXIT
   ENDIF
ENDDO
RETURN
***********
PROC VALTAB
***********
SELECT HISTAB
DO WHILE .T.
   STORE WGRUPO+WCODSUB+WCODREN+WCODTAB TO WCLAVETAB
   SEEK WCLAVETAB
   IF .NOT. FOUND()
      STORE 11 TO LIBRTAB
      STORE 25 TO CIBRTAB
      DO HISWINTA
      RELE WIND BRTAB
      STORE CODTAB TO WCODTAB
      LOOP
   ELSE
      STORE CODTAB TO WCODTAB
      STORE DESTAB TO WDESTAB
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