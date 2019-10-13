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
   **** GRABAR-CONTINUAR
   *DEFI WIND WINDPRIN FROM 12,00 TO 14,73 DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
   *ACTIVATE WIND WINDPRIN
   *store 1 to wop
   *DO WHILE .T.
   *   @ 00,03 SAY "EXAMENES NO HAN SIDO GUARDADOS EN HISTORIA. ";
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
         DO LABIMPEX
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
      DO LABGRAEX
      DO LABOPEEX
   *ELSE
   *   LOOP
   *ENDIF
   ***
   *EXIT
ENDDO

