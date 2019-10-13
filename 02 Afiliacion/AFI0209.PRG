do while .t.
   @ 04,00 CLEAR
   @ 05,00 to 22,79
   @ 05,01 SAY "< DATOS PERSONALES TITULARES >"
   @ 07,02 SAY "Cedula              :"
   @ 08,02 SAY "Nacionalidad        :"
   @ 09,02 SAY "Primer  Apellido    :"
   @ 10,02 SAY "Segundo Apellido    :"
   @ 11,02 SAY "Primer  Nombre      :"
   @ 12,02 SAY "Segundo Nombre      :"
   @ 13,02 SAY "Sexo                :"
   @ 14,02 SAY "Nacimiento          :"
   @ 15,02 SAY "Direccion           :"
   @ 16,02 SAY "Estado              :"
   @ 17,02 SAY "Ciudad              :"
   @ 18,02 SAY "Parroquia           :"
   @ 19,02 SAY "Telefono            :"
   @ 20,02 SAY "Fecha 1er ingreso   :"
   @ 21,02 SAY "Porc. de descuento  :"
   @ 07,25 GET WCEDTITU
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   IF WCEDTITU = SPACE(10)
      * DO BRAFI
      LOOP
   ENDIF
   SELECT AFITITU
   SET ORDER TO AFITITU1
   SEEK WCEDTITU
   IF .NOT. FOUND()
      STORE .T.    TO WFLAGING
      SCAT MEMVAR BLANK
      STORE DATE() TO M.INGRESO
      STORE 0      TO M.DESCUENTO
   ELSE
      STORE .F.    TO WFLAGING
      SCAT MEMVAR
   ENDIF
   STORE WCEDTITU  TO M.CEDTITU
   @ 08,25 SAY M.NACION
   @ 09,25 SAY M.PAPELLIDO
   @ 10,25 SAY M.SAPELLIDO
   @ 11,25 SAY M.PNOMBRE
   @ 12,25 SAY M.SNOMBRE
   @ 13,25 SAY M.SEXO
   @ 14,25 SAY M.NACIMIENTO
   @ 15,25 SAY M.DIRECCION
   @ 16,25 SAY M.ESTADO
   @ 17,25 SAY M.CIUDAD
   @ 18,25 SAY M.MUNICIPIO
   @ 19,25 SAY M.TELHAB
   @ 20,25 SAY M.INGRESO
   @ 21,25 SAY M.DESCUENTO PICTURE "999.99"
   store 1 to wop
   do while .t.
      @ 22,22  get wop pict "@*H Actualizar; Eliminar  ; Cancelar  " defa wop
      read
      if lastkey()=13
         @ 22,0
         exit
      endif
   enddo
   if wop=1
      @ 08,25 GET M.NACION         VALID VALNACI()
      @ 09,25 GET M.PAPELLIDO      VALID VALPAPE()
      @ 10,25 GET M.SAPELLIDO
      @ 11,25 GET M.PNOMBRE        VALID VALPNOM()
      @ 12,25 GET M.SNOMBRE
      @ 13,25 GET M.SEXO           VALID VALSEXO()
      @ 14,25 GET M.NACIMIENTO
      @ 15,25 GET M.DIRECCION
      @ 16,25 GET M.ESTADO         VALID VALESTA()
      @ 17,25 GET M.CIUDAD         VALID VALCIUD()
      @ 18,25 GET M.MUNICIPIO      VALID VALMUNI()
      @ 19,25 GET M.TELHAB
      @ 20,25 GET M.INGRESO 
      @ 21,25 GET M.DESCUENTO       PICTURE "999.99" RANGE 0,100
      read
      if lastkey()=27
         loop
      endif
   else
      if wop = 2 .and. .not. wflaging
         do elimina
         loop
      else
         loop
      endif
   endif
   *** aceptar-cancelar modificaciones
   store 1 to wop
   do while .t.
      @ 22,32  get wop pict "@*H Aceptar ;Cancelar " defa wop
      read
      if lastkey()=13
         exit
      endif
   enddo
   *** fin aceptar-cancelar
   if wop=2
      loop
   endif
   select afititu
   if wflaging
      if filloc()
         append blank
         unlock all
         if recloc()
            gath memv
            unlock all
            *** Generar registro del titular en afiafi.dbf
            *** borra posibles registros muertos
            select afiafi
            store .t. to welim
            do while welim
               set order to 1
               seek afititu.cedtitu
               if found()
                  if recloc()
                     delete
                     unlock all
                  endif
               else
                  exit
               endif
            enddo
            *** incluye registro en afiafi.dbf
            select afiafi
            if filloc()
               append blank
               unlock all
               if recloc()
                  store afititu.cedtitu    to m.cedtitu
                  store "   0"             to m.carga
                  store afititu.papellido  to m.papellido
                  store afititu.sapellido  to m.sapellido
                  store afititu.pnombre    to m.pnombre
                  store afititu.snombre    to m.snombre
                  store afititu.cedtitu    to m.cedafi
                  store afititu.sexo       to m.sexo
                  store afititu.nacimiento to m.nacimiento
                  store afititu.ingreso    to m.ingreso   
                  store "00"               to m.parentesco
                  gath memv
                  unlock all
               endif
            endif
            select afititu
         endif
      endif
   else
      if recloc()
         gath memv
         unlock all
         *** actualiza registro del titular en afiafi.dbf
         select afiafi
         set order to 1
         seek afititu.cedtitu
         if .not. found()
            if filloc()
               append blank
               unlock all
            else
               store "OPERACION ABORTADA FAVOR REINTENTAR" to wtext
               do aviso with wtext
               loop
            endif
         endif
         if recloc()
            store afititu.cedtitu    to m.cedtitu
            store "   0"             to m.carga
            store afititu.papellido  to m.papellido
            store afititu.sapellido  to m.sapellido
            store afititu.pnombre    to m.pnombre
            store afititu.snombre    to m.snombre
            store afititu.cedtitu    to m.cedafi
            store afititu.sexo       to m.sexo
            store afititu.nacimiento to m.nacimiento
            store afititu.ingreso    to m.ingreso   
            store "00"               to m.parentesco
            gath memv
            unlock all
         else
            store "OPERACION ABORTADA FAVOR REINTENTAR" to wtext
            do aviso with wtext
            loop
         endif
      else
         store "OPERACION ABORTADA FAVOR REINTENTAR" to wtext
         do aviso with wtext
         loop
      endif
   endif
enddo
return
************
func valnaci
do while .t.
   if m.nacion="V".or.m.nacion="E"
      exit
   endif
   defi wind winnaci from 08,25 to 11,41
   acti wind winnaci
   @ 00,00 clear
   store 1 to wvalop
   do while .t.
      @ 00,01 get wvalop pict "@*V  Venezolana ; Extranjera" defa wvalop
      read
      if lastkey()=13
         exit
      endif
   enddo
   if wvalop=1
      store "V" to m.nacion
   else
      store "E" to m.nacion
   endif
   rele wind winnaci
enddo
return .t.
************
func valpape
do while .t.
   if len(alltrim(m.papellido))>0
      return .t.
   else
      return .f.
   endif
enddo
*************
func valpnom
do while .t.
   if len(alltrim(m.pnombre))>0
      return .t.
   else
      return .f.
   endif
enddo
*************
func valsexo
do while .t.
   if m.sexo="M".or.m.sexo="F"
      exit
   endif
   defi wind winsexo from 13,25 to 16,41
   acti wind winsexo
   @ 00,00 clear
   store 1 to wvalop
   do while .t.
      @ 00,01 get wvalop pict "@*V  Masculino ; Femenino" defa wvalop
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
   rele wind winsexo
enddo
return .t.
************
func valesta
select afigeo
do while .t.
   if m.estado<>space(2)
      store m.estado+space(4) to wclavegeo
      seek wclavegeo
      if found()
         @ 16,30 say afigeo.descri
         exit
      endif
   endif
   store 05 to librgeo
   store 20 to cibrgeo
   do afi0105
   if afigeo.ciudad=space(2).and.afigeo.municipio=space(2)
      store afigeo.estado to m.estado
   endif
enddo
return .T.
************
func valciud
select afigeo
do while .t.
   if m.ciudad<>space(2)
      store m.estado+m.ciudad+space(2) to wclavegeo
      seek wclavegeo
      if found()
         @ 17,30 say afigeo.descri
         exit
      else
         store "est:"+m.estado+" ciu:"+m.ciudad+" mun:"+m.municipio to wtext
         do aviso with wtext
      endif
   endif
   store 05 to librgeo
   store 20 to cibrgeo
   store m.estado to wlastest
   do afi0105
   if afigeo.estado=wlastest.and.afigeo.municipio=space(2)
      store afigeo.estado to m.estado
      store afigeo.ciudad to m.ciudad
      store space(2)      to m.municipio
   endif
enddo
return .T.
************
func valmuni
select afigeo
do while .t.
   if m.municipio<>space(2)
      store m.estado+m.ciudad+m.municipio to wclavegeo
      seek wclavegeo
      if found()
         @ 18,30 say afigeo.descri
         exit
      endif
   endif
   store 05 to librgeo
   store 20 to cibrgeo
   store m.estado to wlastest
   store m.ciudad to wlastciu
   do afi0105
   if afigeo.estado=wlastest.and.afigeo.ciudad=wlastciu.and.afigeo.municipio<>space(2)
      store afigeo.estado    to m.estado
      store afigeo.ciudad    to m.ciudad
      store afigeo.municipio to m.municipio
   endif
enddo
return .T.
************
PROCEDURE ELIMINA
store 1 to wop
do while .t.
   @ 22,22  say "Favor confirmar opcion:" get wop pict "@*H Cancelar ; Aceptar " defa wop
   read
   if lastkey()=13
      exit
   endif
enddo
*** fin aceptar-cancelar
if wop=1
   return
endif
select afititu
if filloc()
   select afiafi
   if filloc()
      do while .t.
         seek wcedtitu
         if found()
            delete
         else
            exit
         endif
      enddo
   else
      store "OPERACION ABORTADA, REINTENTE" to wtext
      do aviso with wtext
   endif
   select afiafi
   unlock all
   select afititu
   delete
   unlock all
else
   store "OPERACION ABORTADA, REINTENTE" to wtext
   do aviso with wtext
endif
RETURN
