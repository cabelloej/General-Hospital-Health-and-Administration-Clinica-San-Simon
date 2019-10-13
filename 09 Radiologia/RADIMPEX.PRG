   *** IMPRIMIR-CONTINUAR
   DEFI WIND WINDPRIN FROM 12,12 TO 14,68;
                      DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
   ACTIVATE WIND WINDPRIN
   store 1 to wop
   DO WHILE .T.
      @ 00,00 SAY "EXAMENES NO SE HAN IMPRIMIDO ";
      GET WOP pict "@*H Imprimir ;Continuar" defa wop
      READ
      IF LASTKEY()=13
         EXIT
      ENDIF
   ENDDO
   RELE WIND WINDPRIN
   STORE WOP TO WIMPCON
   IF WOP=2
      RETURN
   ENDIF

   STORE 1                         TO WFORMATO
   STORE 2                         TO WSALIDA
   STORE "T"                       TO WTIPPAC
   STORE "T"                       TO WSEXO
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
   DO HISIMPHD
   RETURN
