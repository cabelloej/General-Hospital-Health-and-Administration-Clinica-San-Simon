DO WHILE .T.
   *** DATOS PERSONALES
   STORE .F. TO WFLAGDP
   DO HISACTDP
   RELE WIND WINDDP
   IF .NOT. WFLAGDP
      RETURN
   ENDIF
   SELECT ADMADM
   SET ORDER TO ADMADM2
   SEEK WCODPAC
   IF .NOT. FOUND()
      STORE "PACIENTE NO REGISTRADO EN INGRESOS HOSPITALARIOS" TO WTEXT
      DO AVISO WITH WTEXT
      RETURN
   ENDIF
   *** HISTORIA GENERAL
   DO HISACTHG

   ****************************************************************************
   * *** GRABAR-CONTINUAR
   *DEFI WIND WINDPRIN FROM 12,00 TO 14,72 DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
   *ACTIVATE WIND WINDPRIN
   *store 1 to wop
   *DO WHILE .T.
   *   @ 00,03 SAY "INFORM.  NO HA SIDO GUARDADA EN HISTORIA. ";
   *   GET WOP pict "@*H Guardar  ;Continuar" defa wop
   *   READ
   *   IF LASTKEY()=13
   *      EXIT
   *   ENDIF
   *ENDDO
   *RELE WIND WINDPRIN

   *IF WOP=1
      STORE .F. TO WFLAGREP
      DO WHILE .T.
         DO ADMIMPHO
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
         ELSE
            STORE .T. TO WFLAGREP
         ENDIF
      ENDDO
   *   DO ADMGRAHO
   *   DO ADMOPEHO
   *ENDIF
   ***
   EXIT
ENDDO

