SELECT AFIAFI
DEFI WIND BRCAR FROM LIBRCAR,CIBRCAR TO LIBRCAR+15,CIBRCAR+79;
                TITLE " GRUPO AFILIADO ";
                FOOTER " F1=Inc,F2=Mod,F3=Eli,Tab=Mover,ESC=Salir ";
                DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND BRCAR
ON KEY LABEL F1 DO BRINC
ON KEY LABEL F2 DO BRMOD
ON KEY LABEL F3 DO BRELI
ON KEY LABEL F4
BROWSE FIELDS CARGA:H="No",AFIPAREN.DESCRI:H="PARENTESCO",;
              PAPELLIDO:H="PRIMER APELLIDO", SAPELLIDO:H="SEGUNDO APELLIDO",;
              PNOMBRE:H="PRIMER NOMBRE", SNOMBRE:H="SEGUNDO NOMBRE",;
              CEDAFI:H="CEDULA", SEXO:H="S", NACIMIENTO:H="FECHA NAC.",;
              EDOCIVIL,OCUPACION,HISTORIA;
              KEY WCEDTITU;
              NOAPPEND NODELETE NOEDIT NOMENU NOOPTIMIZE REST SAVE IN WINDOW BRCAR
ON KEY LABEL F1
ON KEY LABEL F2
ON KEY LABEL F3
RELEASE WIND BRCAR
RETURN
***********************
***                 ***
***RUTINAS DE BRCAR ***
***                 ***
***********************
PROCEDURE BRINC
DEFI WIND WINCCAR FROM LIBRCAR,CIBRCAR+10 TO LIBRCAR+15,CIBRCAR+70;
                  TITLE " INCLUIR AFILIADOS " DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WINCCAR
DO WHILE .T.
   SCAT MEMV BLANK
   STORE WCEDTITU          TO M.CEDTITU
   STORE AFITITU.PAPELLIDO TO MAPELLIDO
   STORE DATE()            TO M.INGRESO
   STORE .F.               TO WFLAGPARE
   @ 00,00 CLEAR
   @ 00,01 SAY "PRIMER  APELLIDO:"
   @ 01,01 SAY "SEGUNDO APELLIDO:"
   @ 02,01 SAY "PRIMER  NOMBRE  :"
   @ 03,01 SAY "SEGUNDO NOMBRE  :"
   @ 04,01 SAY "CEDULA          :"
   @ 05,01 SAY "SEXO            :"
   @ 06,01 SAY "FECHA NACIMIENTO:"
   @ 07,01 SAY "PARENTESCO      :"
   @ 08,01 SAY "EDO.CIVIL       :"
   @ 09,01 SAY "DIRECCION       :"
   @ 10,01 SAY "TELEFONO        :"
   @ 11,01 SAY "OCUPACION       :"
   @ 12,01 SAY "OBSERVACIONES   :"
   @ 13,01 SAY "FEC. 1er INGRESO:"        
   @ 00,19 GET M.PAPELLIDO     VALID VALPAPE()
   @ 01,19 GET M.SAPELLIDO
   @ 02,19 GET M.PNOMBRE       VALID VALPNOM()
   @ 03,19 GET M.SNOMBRE
   @ 04,19 GET M.CEDAFI
   @ 05,19 GET M.SEXO          VALID VALSEXO()
   @ 06,19 GET M.NACIMIENTO
   @ 07,19 GET M.PARENTESCO    VALID VALPARE()
   @ 08,19 GET M.EDOCIVIL      VALID VALEDO()
   @ 09,19 GET M.DIRECCION
   @ 10,19 GET M.TELEFONO
   @ 11,19 GET M.OCUPACION
   @ 12,19 GET M.OBSERVA
   @ 13,19 GET M.INGRESO
   READ
   IF .NOT.WFLAGPARE.AND.LASTKEY()=27
      RELEASE WIND WINCCAR
      EXIT
   ENDIF
   *** INICIO RUTINA DE ACEPTAR-CANCELAR
   store 1 to wop
   do while .t.
      @ 11,20  get wop pict "@*H Aceptar;Cancelar" defa wop
      read
      if lastkey()=13
         exit
      endif
   enddo
   *** FIN  RUTINA ACEPTAR-CANCELAR
   if wop=1
      select afiafi
      if filloc()
         append blank
         gath memvar
         replace nivel     with afititu.nivel
         replace descuento with afititu.descuento
         unlock all
         if recloc()
            select afititu
            if recloc()
               replace sercar with sercar+1
               unlock all
               select afiafi
               replace carga with str(afititu.sercar,4)
               unlock all
            else
               select afiafi
               delete
               unlock all
            endif
            select afititu
            unlock all
            select afiafi
            unlock all
         else
            select afiafi
            delete
            unlock all
         endif
      endif
   endif
ENDDO
RETURN
***
PROCEDURE BRMOD
IF EOF()
   RETURN
ENDIF
if afiafi.parentesco = "00"
   store "ERROR, ACTUALICE TITULARES DESDE ACTUALIZACION DE CONTRATOS." to wtext
   do aviso with wtext
   return
endif
DEFI WIND WMODCAR FROM LIBRCAR,CIBRCAR+10 TO LIBRCAR+15,CIBRCAR+70;
                  TITLE " MODIFICAR AFILIADOS " DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WMODCAR
SCAT MEMV
@ 00,00 CLEAR

@ 00,01 SAY "PRIMER  APELLIDO:"
@ 01,01 SAY "SEGUNDO APELLIDO:"
@ 02,01 SAY "PRIMER  NOMBRE  :"
@ 03,01 SAY "SEGUNDO NOMBRE  :"
@ 04,01 SAY "CEDULA CARGA    :"
@ 05,01 SAY "SEXO            :"
@ 06,01 SAY "FECHA NACIMIENTO:"
@ 07,01 SAY "PARENTESCO      :"
@ 08,01 SAY "EDO.CIVIL       :"
@ 09,01 SAY "DIRECCION       :"
@ 10,01 SAY "TELEFONO        :"
@ 11,01 SAY "OCUPACION       :"
@ 12,01 SAY "OBSERVACIONES   :"
@ 13,01 SAY "FEC. 1er INGRESO:"
@ 00,19 GET M.PAPELLIDO     VALID VALPAPE()
@ 01,19 GET M.SAPELLIDO
@ 02,19 GET M.PNOMBRE       VALID VALPNOM()
@ 03,19 GET M.SNOMBRE
@ 04,19 GET M.CEDAFI
@ 05,19 GET M.SEXO          VALID VALSEXO()
@ 06,19 GET M.NACIMIENTO
@ 07,19 GET M.PARENTESCO    VALID VALPARE()
@ 08,19 GET M.EDOCIVIL      VALID VALEDO()
@ 09,19 GET M.DIRECCION
@ 10,19 GET M.TELEFONO
@ 11,19 GET M.OCUPACION
@ 12,19 GET M.OBSERVA
@ 13,19 GET M.INGRESO
READ
*** RUTINA ACEPTAR-CANCELAR
store 1 to wop
do while .t.
   @ 11,20  get wop pict "@*H Aceptar;Cancelar" defa wop
   read
   if lastkey()=13
      exit
   endif
enddo
*** FIN  RUTINA ACEPTAR-CANCELAR
if wop=1
   select afiafi
   if recloc()
      gath memvar
      unlock all
   endif
endif
RELEASE WIND WMODCAR
RETURN
***
PROCEDURE BRELI
IF EOF()
   RETURN
ENDIF
*if afiafi.parentesco = "00"
*   store "ERROR, ACTUALICE TITULARES DESDE ACTUALIZACION DE CONTRATOS." to wtext
*   do aviso with wtext
*   return
*endif
DEFI WIND WELICAR FROM LIBRCAR,CIBRCAR+10 TO LIBRCAR+13,CIBRCAR+70;
                  TITLE " ELIMINAR AFILIADOS " DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WELICAR
SCAT MEMV
@ 00,00 CLEAR
@ 00,01 SAY "PRIMER  APELLIDO:"
@ 01,01 SAY "SEGUNDO APELLIDO:"
@ 02,01 SAY "PRIMER  NOMBRE  :"
@ 03,01 SAY "SEGUNDO NOMBRE  :"
@ 04,01 SAY "CEDULA CARGA    :"
@ 05,01 SAY "SEXO            :"
@ 06,01 SAY "FECHA NACIMIENTO:"
@ 07,01 SAY "PARENTESCO      :"
@ 08,01 SAY "EDO.CIVIL       :"
@ 09,01 SAY "DIRECCION       :"
@ 10,01 SAY "TELEFONO        :"
@ 00,19 GET M.PAPELLIDO     VALID VALPAPE()
@ 01,19 GET M.SAPELLIDO
@ 02,19 GET M.PNOMBRE       VALID VALPNOM()
@ 03,19 GET M.SNOMBRE
@ 04,19 GET M.CEDAFI
@ 05,19 GET M.SEXO          VALID VALSEXO()
@ 06,19 GET M.NACIMIENTO
@ 07,19 GET M.PARENTESCO    VALID VALPARE()
@ 08,19 GET M.EDOCIVIL      VALID VALEDO()
@ 09,19 GET M.DIRECCION
@ 10,19 GET M.TELEFONO
CLEAR GETS
*** RUTINA ACEPTAR-CANCELAR
store 1 to wop
do while .t.
   @ 11,20  get wop pict "@*H Aceptar;Cancelar" defa wop
   read
   if lastkey()=13
      exit
   endif
enddo
*** FIN  RUTINA ACEPTAR-CANCELAR
if wop=1
   if recloc()
      select afiafi
      delete
      unlock all
   endif
endif
RELEASE WIND WELICAR
RETURN
***
FUNC VALAPE
do while .t.
   if len(alltrim(m.papellido))>0
      return .t.
   else
      return .f.
   endif
enddo
*************
FUNC VALPAPE
do while .t.
   if len(alltrim(m.papellido))>0
      return .t.
   else
      return .f.
   endif
enddo
*************
FUNC VALPNOM
do while .t.
   if len(alltrim(m.pnombre))>0
      return .t.
   else
      return .f.
   endif
enddo
*************
FUNC VALSEXO
do while .t.
   if m.sexo="M".or.m.sexo="F"
      exit
   endif
   defi wind winsex  from librcar+11,32 to librcar+14,46
   acti wind winsex
   @ 00,00 clear
   if afiafi.sexo="M"
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
FUNC VALPARE
select afiparen
do while .t.
   if m.parentesco<>space(2)
      if m.parentesco="00"
         store "ERROR, CODIGO ASIGNADO SOLO A TITULARES, REINTENTE." to wtext
         do aviso with wtext
         return .f.
      endif
      seek m.parentesco
      if found()
         @ 07,30 say afiparen.descri
         exit
      endif
   endif
   store librcar+06 to librpar
   store cibrcar+30 to cibrpar
   do afi0104
   on key label f1 do brinc
   on key label f2 do brmod
   on key label f3 do breli
   store .t. to wflagpare
   store afiparen.parentesco to m.parentesco
enddo
return .T.
************
FUNC VALEDO
do while .t.
   if M.EDOCIVIL="S".or.M.EDOCIVIL="C".OR.M.EDOCIVIL="V".or.;
      M.EDOCIVIL="D".OR.M.EDOCIVIL="N"
      exit
   endif
   defi wind winsex  from 21,00 to 23,79
   acti wind winsex
   @ 00,00 clear
   if AFIAFI.EDOCIVIL="S"
      store 1 to wvalop
   else
      IF AFIAFI.EDOCIVIL="C"
         store 2 to wvalop
      ELSE
         IF AFIAFI.EDOCIVIL="V"
            store 3 to wvalop
         ELSE
            IF AFIAFI.EDOCIVIL="D"
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
************
