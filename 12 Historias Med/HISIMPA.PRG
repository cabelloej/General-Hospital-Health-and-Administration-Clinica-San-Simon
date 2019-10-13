DEFI WIND WINDDP FROM 03,00 TO 12,72 ;
                 TITLE " IMPRIMIR TABLAS " ;
                 DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10

do while .t.
   acti wind winddp
   @ 0,0 clear
   @ 01,02 SAY "Actividad           :"
   @ 02,02 SAY "Subactividad        :"
   @ 03,02 SAY "Renglon             :"
   @ 04,02 SAY "Tabulador           :"
   @ 05,02 SAY "Salida              :"
   @ 06,02 SAY "Opciones            :"
   STORE SPACE(2)  TO WGRUPO
   STORE SPACE(3)  TO WCODSUB
   STORE SPACE(3)  TO WCODREN
   STORE SPACE(3)  TO WCODTAB
   STORE SPACE(20) TO WDESGRU
   STORE SPACE(20) TO WDESSUB
   STORE SPACE(20) TO WDESREN
   STORE SPACE(20) TO WDESTAB

   @ 01,25 GET WGRUPO VALID VALGRU()
   READ
   IF WGRUPO<>SPACE(2)
      @ 01,25 SAY WDESGRU
      @ 02,25 GET WCODSUB VALID VALSUB()
      READ
      IF WCODSUB<>SPACE(3)
         @ 02,25 SAY WDESSUB
         IF ESTSUB="T"
            @ 03,25 GET WCODREN VALID VALREN()
            READ
            IF WCODREN<>SPACE(3)
               @ 03,25 SAY WDESREN
               IF ESTREN="T"
                  @ 04,25 GET WCODTAB VALID VALTAB()
                  READ
                  IF WCODTAB<>SPACE(3)
                     @ 04,25 SAY WDESTAB
                  ELSE
                     @ 04,25 SAY "Todos"
                  ENDIF
               ELSE
                  @ 04,25 SAY "No aplica"
               ENDIF
            ELSE
               @ 03,25 SAY "Todos"
               @ 04,25 SAY "Todos"
            ENDIF
         ELSE
            @ 03,25 SAY "No aplica"
            @ 04,25 SAY "No aplica"
         ENDIF
      ELSE
         @ 02,25 SAY "Todos"
         @ 03,25 SAY "Todos"
         @ 04,25 SAY "Todos"
      ENDIF
   ELSE
      @ 01,25 SAY "Todos"
      @ 02,25 SAY "Todos"
      @ 03,25 SAY "Todos"
      @ 04,25 SAY "Todos"
   ENDIF
   store 1 to wop
   do while .t.
      @ 05,25 get wop pict "@*H  Monitor ;Impresora" defa wop
      read
      if lastkey()=13
         exit
      endif
   enddo
   store wop to wsalida
   store 1 to wop
   do while .t.
      @ 06,25 get wop pict "@*H  Aceptar ;Cancelar " defa wop
      read
      if lastkey()=13
         exit
      endif
   enddo
   store wop to wopciones
   if wopciones=2
      deac wind winddp
      restore scre from wscre01
      return
   endif
   deac wind winddp
   *** inicio de impresion
   do hisimpad
   restore scre from wscre01
   acti wind winddp
enddo
********************************************************************************
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
      STORE 11 TO LIBRREN
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
      STORE 12 TO LIBRTAB
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
************
