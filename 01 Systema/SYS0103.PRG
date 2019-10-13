PUSH KEY CLEAR
SELECT SYSPAC
DEFI WIND BRPAC FROM LIBRPAC,CIBRPAC TO LIBRPAC+10,CIBRPAC+79 ;
                TITLE " PACIENTES NO AFILIADOS " ;
                FOOTER " F1=Inc,F2=Mod,F3=Eli,F4=Bus,F6=Lis, Tab=Mover,ESC=Sel ";
                DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND BRPAC
ON KEY LABEL F1 DO BRINCPAC
ON KEY LABEL F2 DO BRMODPAC
ON KEY LABEL F3 DO BRELIPAC
ON KEY LABEL F4 DO BRBUSPAC
ON KEY LABEL F6 DO SYS0103R
BROWSE FIELDS CODPAC:H="Codigo paciente",;
              PAPELLIDO:H="Apellido",;
              PNOMBRE:H="Nombre",;
              SEXO:H="Sexo",;
              NACIMIENTO:H="Nacido",;
              NIVEL:H="Nivel",;
              HISTORIA:h="Historia";
              NOAPPEND NODELETE NOEDIT NOMENU NOOPTIMIZE REST SAVE IN WINDOW BRPAC
RELEASE WIND BRPAC
POP KEY
RETURN
************************
***                  ***
*** RUTINAS DE BRPAC ***
***                  ***
************************
***
PROCEDURE BRINCPAC
PUSH KEY CLEAR
STORE .T. TO WINC
DEFI WIND WINC FROM LIBRPAC+5,CIBRPAC+10 TO LIBRPAC+17,CIBRPAC+74;
               TITLE " INCLUIR PACIENTES NO AFILIADOS " ;
               FOOTER " ESC=Salir";
               DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WINC
DO WHILE WINC
   STORE M.CODPAC TO WCODPAC
   SCAT MEMV BLANK
   STORE "M"      TO M.SEXO
   STORE "S"      TO M.EDOCIVIL
   STORE "A"      TO M.NIVEL
   STORE DATE()   TO M.INGRESO
   STORE WCODPAC  TO M.CODPAC
   @ 00,00 CLEAR
   @ 00,01 SAY "Codigo    :"
   @ 01,01 SAY "Apellidos :"
   @ 02,01 SAY "Nombres   :"
   @ 03,01 SAY "Sexo      :"
   @ 04,01 SAY "Nacimiento:"
   @ 05,01 SAY "Edo. Civil:"
   @ 06,01 SAY "Direccion :"
   @ 07,01 SAY "Telefonos :"
   @ 08,01 SAY "Nivel prec:"
   @ 09,01 SAY "% de desc.:"
   @ 10,01 SAY "Fec.de.ing:"    
   STORE SUBSTR(M.CODPAC,1,10)      TO WCODPAC1
   STORE VAL(SUBSTR(M.CODPAC,11,4)) TO WCODPAC2
   @ 00,12 GET WCODPAC1
   @ 00,22 SAY "-"
   @ 00,23 GET WCODPAC2 PICTURE "9999" 
   READ
   STORE WCODPAC1+STR(WCODPAC2,4)              TO M.CODPAC
   STORE ALLTRIM(WCODPAC1+"-"+STR(WCODPAC2,4)) TO WXCODPAC
   @ 00,12 SAY WXCODPAC
   IF LASTKEY()=27
      RELEASE WIND WINC
      EXIT
   ENDIF
   IF LEN(TRIM(M.CODPAC))=0
      LOOP
   ENDIF
   SEEK M.CODPAC
   IF FOUND()
      @ 00,28 SAY RTRIM(PAPELLIDO)+", "+PNOMBRE
      STORE "YA REGISTRADO, VERIFIQUE" TO WTEXT
      DO AVISO WITH WTEXT
      LOOP
   ELSE
      @ 01,12 GET M.PAPELLIDO
      @ 02,12 GET M.PNOMBRE
      @ 03,12 GET M.SEXO         VALID VALSEXO()
      @ 04,12 GET M.NACIMIENTO   VALID VALNACI()
      @ 05,12 GET M.EDOCIVIL     VALID VALEDO()
      @ 06,12 GET M.DIRECCION
      @ 07,12 GET M.TELEFONO
      @ 08,12 GET M.NIVEL        VALID VALNIVEL()
      @ 09,12 GET M.DESCUENTO    PICTURE "999.99" RANGE 0,100
      @ 10,12 GET M.INGRESO
      READ
      *** INICIO RUTINA DE ACEPTAR-CANCELAR
      store 1 to wop
      do while .t.
         @ 08,20  get wop pict "@*H Aceptar;Cancelar" defa wop
         read
         if lastkey()=13
            exit
         endif
      enddo
      *** FIN  RUTINA ACEPTAR-CANCELAR
      if wop=1
         if filloc()
            append blank
            gath memvar
            unlock all
         endif
      endif
   ENDIF
   RELEASE WIND WINC
   EXIT
ENDDO
POP KEY
RETURN
***
PROCEDURE BRMODPAC
DEFI WIND WMOD FROM LIBRPAC+5,CIBRPAC+10 TO LIBRPAC+17,CIBRPAC+74;
               TITLE " MODIFICAR PACIENTE NO AFILIADO " DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WMOD
SCAT MEMVAR
@ 00,01 SAY "Codigo    :"
@ 01,01 SAY "Apellidos :"
@ 02,01 SAY "Nombres   :"
@ 03,01 SAY "Sexo      :"
@ 04,01 SAY "Nacimiento:"
@ 05,01 SAY "Edo. Civil:"
@ 06,01 SAY "Direccion :"
@ 07,01 SAY "Telefonos :"
@ 08,01 SAY "Nivel prec:"
@ 09,01 SAY "% de desc.:"    
@ 10,01 SAY "Fec.de.ing:"  
@ 01,12 GET M.PAPELLIDO
@ 02,12 GET M.PNOMBRE
@ 03,12 GET M.SEXO         VALID VALSEXO()
@ 04,12 GET M.NACIMIENTO   VALID VALNACI()
@ 05,12 GET M.EDOCIVIL     VALID VALEDO()
@ 06,12 GET M.DIRECCION
@ 07,12 GET M.TELEFONO
@ 08,12 GET M.NIVEL        VALID VALNIVEL()
@ 09,12 GET M.DESCUENTO    PICTURE "999.99" RANGE 0,100
@ 10,12 GET M.INGRESO 
READ
*** INICIO RUTINA DE ACEPTAR-CANCELAR
store 1 to wop
do while .t.
   @ 08,22  get wop pict "@*H Aceptar;Cancelar" defa wop
   read
   if lastkey()=13
      exit
   endif
enddo
*** FIN  RUTINA ACEPTAR-CANCELAR
if wop=1
   if recloc()
      gath memvar
      unlock all
   else
      store "OPERACION CANCELADA, REINTENTE" to wtext
      do aviso with wtext
   endif
endif
RELEASE WIND WMOD
RETURN
***
PROCEDURE BRELIPAC
DEFI WIND WELI FROM LIBRPAC+5,CIBRPAC+10 TO LIBRPAC+17,CIBRPAC+74;
               TITLE " ELIMINAR PACIENTE NO AFILIADO " DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WELI
SCAT MEMVAR
      @ 00,01 SAY "Codigo    :"
      @ 01,01 SAY "Apellidos :"
      @ 02,01 SAY "Nombres   :"
      @ 03,01 SAY "Sexo      :"
      @ 04,01 SAY "Nacimiento:"
      @ 05,01 SAY "Edo. Civil:"
      @ 06,01 SAY "Direccion :"
      @ 07,01 SAY "Telefonos :"
      @ 08,01 SAY "Nivel prec:"   
      @ 09,01 SAY "% de desc.:"    
      @ 10,01 SAY "Fec.de.ing:"  
      @ 01,12 SAY M.PAPELLIDO
      @ 02,12 SAY M.PNOMBRE
      @ 03,12 SAY M.SEXO
      @ 04,12 SAY M.NACIMIENTO
      @ 05,12 SAY M.EDOCIVIL
      @ 06,12 SAY M.DIRECCION
      @ 07,12 SAY M.TELEFONO
      @ 08,12 SAY M.NIVEL
      @ 09,12 SAY M.DESCUENTO  PICTURE "999.99"
      @ 10,12 SAY M.INGRESO 
*** INICIO RUTINA DE ACEPTAR-CANCELAR
store 2 to wop
do while .t.
   @ 08,22  get wop pict "@*H Aceptar;Cancelar" defa wop
   read
   if lastkey()=13
      exit
   endif
enddo
*** FIN  RUTINA ACEPTAR-CANCELAR
if wop=1
   if recloc()
      delete
      unlock all
   endif
endif
RELEASE WIND WELI
RETURN
***
PROCEDURE BRBUSPAC
DEFI WIND WBUS FROM LIBRPAC+5,CIBRPAC+10 TO LIBRPAC+12,CIBRPAC+74;
               TITLE " BUSCAR PACIENTE NO AFILIADO " DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WBUS
DO WHILE .T.
   SCAT MEMV BLANK
   @ 00,01 SAY "Codigo       :"
   STORE SUBSTR(M.CODPAC,1,10)      TO WCODPAC1
   STORE VAL(SUBSTR(M.CODPAC,11,4)) TO WCODPAC2
   @ 00,12 GET WCODPAC1
   @ 00,22 SAY "-"
   @ 00,23 GET WCODPAC2 PICTURE "9999" 
   READ
   STORE WCODPAC1+STR(WCODPAC2,4)              TO M.CODPAC
   STORE ALLTRIM(WCODPAC1+"-"+STR(WCODPAC2,4)) TO WXCODPAC
   @ 00,12 SAY WXCODPAC
   IF LASTKEY()=27
      RELEASE WIND WBUS
      EXIT
   ENDIF
   IF LEN(TRIM(M.CODPAC))=0
      LOOP
   ENDIF
   SEEK M.CODPAC
   IF FOUND()
      EXIT
   ELSE
      STORE "NO REGISTRADO, VERIFIQUE" TO WTEXT
      DO AVISO WITH WTEXT
   ENDIF
ENDDO
RELEASE WIND WBUS
RETURN
***
FUNC VALSEXO
do while .t.
   if m.sexo="M".or.m.sexo="F"
      exit
   endif
   defi wind winsex  from librpac+11,32 to librpac+14,46
   acti wind winsex
   @ 00,00 clear
   if M.sexo="M"
      store 1 to wvalop
   else
      store 2 to wvalop
   endif
   do while .t.
      @ 00,00 get wvalop pict "@*V  Masculino ; Femenino" defa wvalop
      read
      if lastkey()=13
         exit
      endif
   enddo
   if wvalop=1
      store "M" to m.sexo
   else
      store "F" to m.sexo
   endif
   rele wind winsex
enddo
return .t.
************
FUNC VALNACI
do while .t.
   if m.nacimiento<>ctod("  -  -    ")
      return .t.
   else
      return .f.
   endif
enddo
***********
FUNC VALEDO
do while .t.
   if M.EDOCIVIL="S".or.M.EDOCIVIL="C".OR.M.EDOCIVIL="V".or.;
      M.EDOCIVIL="D".OR.M.EDOCIVIL="N"
      exit
   endif
   defi wind winsex  from 21,00 to 23,79
   acti wind winsex
   @ 00,00 clear
   if M.EDOCIVIL="S"
      store 1 to wvalop
   else
      IF M.EDOCIVIL="C"
         store 2 to wvalop
      ELSE
         IF M.EDOCIVIL="V"
            store 3 to wvalop
         ELSE
            IF M.EDOCIVIL="D"
               store 4 to wvalop
            ELSE
               STORE 5 TO WVALOP
            ENDIF
         ENDIF
      ENDIF
   endif
   do while .t.
      @ 00,05 get wvalop pict "@*H  Soltero  ; Casadado ; Viudo    ; Divorciado ; coNcubino" defa wvalop
      read
      if lastkey()=13
         exit
      endif
   enddo
   do case
      case wvalop=1
           store "S" to m.edocivil
      case wvalop=2
           store "C" to m.edocivil
      case wvalop=3
           store "V" to m.edocivil
      case wvalop=4
           store "D" to m.edocivil
      case wvalop=5
           store "N" to m.edocivil
   endcase
   rele wind winsex
enddo
return .t.
*************
FUNC VALNIVEL
*************
STORE M.NIVEL TO WLASTNIVEL
IF M.NIVEL="A".OR.M.NIVEL="B".OR.M.NIVEL="C"
   RETURN .T.
ELSE
   STORE WLASTNIVEL TO M.NIVEL
   RETURN .F.
ENDIF
RETURN
