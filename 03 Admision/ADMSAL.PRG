   DEFI WIND WINDPA FROM 03,00 TO 07,79 ;
                    TITLE  " PACIENTE " ;
                    FOOTER " ESC=Salir ";
                    DOUBLE NOFLOAT NOZOOM NOGROW COLOR SCHEME 10
   ACTI WIND WINDPA
   @ 00,02 SAY "Codigo de paciente  :"
   @ 01,02 SAY "Codigo de cuenta    :"
   @ 02,02 SAY "Numero de factura   :"
   *@ 03,02 SAY "Fecha de salida     :"
   *@ 04,02 SAY "Hora de salida      :"
   *** INICIALIZA VARIABLES
   STORE SPACE(30)                 TO WNOMBRE
   STORE SPACE(20)                 TO WTIPDES
   STORE SUBSTR(WCODPAC,1,10)      TO WCODPAC1
   STORE SUBSTR(WCODPAC,11,4)      TO WCODPAC2

   STORE VAL(WCODPAC2)             TO WCODPAC2
   @ 00,25 GET WCODPAC1
   @ 00,35 SAY "-"
   @ 00,36 GET WCODPAC2 PICTURE "9999" VALID VALPAC()
   READ
   STORE STR(WCODPAC2,4)                     TO WCODPAC2
   STORE WCODPAC1+WCODPAC2                   TO WCODPAC
   STORE RTRIM(WCODPAC1)+"-"+LTRIM(WCODPAC2) TO WXCODPAC
   IF LASTKEY()=27
      RELE WIND WINDPA
      RETURN
   ENDIF
   @ 00,25 SAY SPACE(40)
   @ 00,25 SAY WXCODPAC+" "+WNOMBRE+" ("+wtipdes+")"
   @ 01,25 SAY ADMADM.CUENTA
   *store date() to wfechasal
   *store time() to whorasal
   IF ADMADM.TIPPAC="A"
      @ 02,25 SAY "NO APLICA"
      DO ASKSAL
   ELSE
      IF ADMADM.FACTURA=SPACE(10)
         @ 02,25 SAY "F A C T U R A R !"
         STORE "PACIENTE NO AFILIADO, FAVOR PASAR POR CAJA PARA FACTURACION DE SERVICIOS" TO WTEXT
         DO AVISO WITH WTEXT
      ELSE
         @ 02,25 SAY ADMADM.FACTURA
         DO ASKSAL
      ENDIF
   ENDIF
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
   RELEASE WIND WINDPA
   RETURN
   **************************************************************************
   ****************
   PROCEDURE VALPAC
   ****************
   STORE WCODPAC1+STR(WCODPAC2,4) TO WCODPAC
   SELECT ADMADM
   SET ORDER TO ADMADM2
   SEEK WCODPAC
   IF .NOT. FOUND()
      STORE "PACIENTE NO REGISTRADO EN INGRESOS HOSPITALARIOS" TO WTEXT
      DO AVISO WITH WTEXT
      RETURN .F.
   ELSE
      IF TIPPAC = "A"
         STORE "AFILIADO"    TO WTIPDES
      ELSE
         STORE "NO AFILIADO" TO WTIPDES
      ENDIF
      STORE RTRIM(PAPELLIDO)+" "+SUBSTR(SAPELLIDO,1,1)+" "+RTRIM(PNOMBRE)+" "+SUBSTR(SNOMBRE,1,1) TO WNOMBRE
      STORE CUENTA           TO WCUENTA
      RETURN .T.
   ENDIF
   RETURN .T.
   ***********
   PROC ASKSAL
   ***********
   *@ 03,25 GET WFECHASAL
   *@ 04,25 GET WHORASAL
   *READ
   *** PREGUNTA PARA DAR DE ALTA
   DEFI WIND WINDASK FROM 12,17 TO 14,62;
                     DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
   ACTIVATE WIND WINDASK
   store 1 to wop
   do while .t.
      @ 00,10 get wop pict "@*H Regresar ;Dar alta " defa wop
      read
      if lastkey()=13
         exit
      endif
   enddo
   RELE WIND WINDASK
   IF WOP=2
      DO ADMGRAHO
   ENDIF
   RETURN

