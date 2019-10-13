DO WHILE .T.
   *** DATOS PERSONALES
   STORE .F. TO WFLAGDP
   DO HISACTDP
   RELE WIND WINDDP
   IF .NOT. WFLAGDP
      RETURN
   ENDIF
   *** HISTORIA GENERAL
   DO HISACTHG

   *** GRABAR-CONTINUAR
   *DEFI WIND WINDPRIN FROM 12,04 TO 14,72 DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
   *ACTIVATE WIND WINDPRIN
   *store 1 to wop
   *DO WHILE .T.
   *   @ 00,02 SAY "CONSULTA NO HA SIDO GUARDADA EN HISTORIA.";
   *   GET WOP pict "@*H Guardar  ;Continuar" defa wop
   *   READ
   *   IF LASTKEY()=13
   *      EXIT
   *   ENDIF
   *ENDDO
   *RELE WIND WINDPRIN
   *IF WOP=1

      STORE 0 TO WIMPCON
      DO WHILE .T.
         DO MEDIMPCO
         IF WIMPCON=2
            EXIT
         ENDIF
         *** CONTROL DE IMPRESION
         DEFI WIND WINDCON FROM 12,12 TO 14,55 DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
         ACTIVATE WIND WINDCON
         store 1 to wop
         DO WHILE .T.
            @ 00,03 SAY "CONFORME CON IMPRESION ? ";
            GET WOP pict "@*H SI ;NO " defa wop
            READ
            IF LASTKEY()=13
               EXIT
            ENDIF
         ENDDO
         RELE WIND WINDCON
         IF WOP=1
            EXIT
         ENDIF
      ENDDO
      DO MEDGRACO
      DO MEDOPECO
   *ELSE
   *   LOOP
   *ENDIF
   ***
   *EXIT
ENDDO

