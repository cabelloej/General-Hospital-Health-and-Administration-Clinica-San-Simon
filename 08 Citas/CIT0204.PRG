SELECT AFIAFI
STORE 05 TO LIBRCAR
STORE 00 TO CIBRCAR
on key label f4 do winbus
DEFI WIND BRCAR FROM LIBRCAR,CIBRCAR TO LIBRCAR+19,CIBRCAR+79;
                TITLE " BUSQUEDA DE AFILIADOS POR NOMBRE DEL AFILIADO ";
                FOOTER " F4=Buscar Nombre, ESC=Seleccionar ";
                DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND BRCAR
SET ORDER TO AFIAFI2
BROWSE FIELDS CEDTITU:H="C.I.TITULAR",CARGA:H="No.",AFIPAREN.DESCRI:H="PARENTESCO",;
              PAPELLIDO:H="PRIMER APELLIDO", SAPELLIDO:H="SEGUNDO APELLIDO",;
              PNOMBRE:H="PRIMER NOMBRE", SNOMBRE:H="SEGUNDO NOMBRE", CEDAFI:H="CED. CARGA",;
              SEXO:H="S", NACIMIENTO:H="FECHA NAC."; 
              NOAPPEND NODELETE NOEDIT NOMENU NOOPTIMIZE REST SAVE IN WINDOW BRCAR
RELEASE WIND BRCAR
STORE AFIAFI.CEDTITU+AFIAFI.CARGA TO WCODPAC
SELECT AFIAFI
SET ORDER TO AFIAFI1
RETURN
procedure winbus
DEFI WIND winbus FROM LIBRCAR+3,CIBRCAR TO LIBRCAR+6,CIBRCAR+79;
                TITLE " BUSQUEDA DE AFILIADOS POR PRIMER APELLIDO... ";
                DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
acti wind winbus
@ 00,00 clear
store space(15) to m.papellido
store space(15) to m.sapellido
store space(15) to m.pnombre
store space(15) to m.snombre
@ 00,00 SAY "PRIMER APELLIDO"
@ 00,16 SAY "SEGIND.APELLIDO"
@ 00,32 SAY "PRIMER NOMBRE  "
@ 00,48 SAY "SEGUNDO NOMBRE "
@ 01,00 get m.papellido
@ 01,16 get m.sapellido
@ 01,32 get m.pnombre
@ 01,48 get m.snombre
read
if lastkey()=27
   rele wind winbus
   return
endif
select afiafi
set order to afiafi2
store m.papellido+m.sapellido+m.pnombre+m.snombre to wname
seek ALLTRIM(wname)
if .not. found()
   store "NO EXISTE, VERIFIQUE" to wtext
   do aviso with wtext
endif
rele wind winbus
return

