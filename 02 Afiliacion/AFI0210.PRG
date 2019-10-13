do while .t.
   @ 04,00 CLEAR
   @ 05,00 to 23,79
   @ 05,01 SAY "< DATOS LABORALES TITULARES >"
   @ 06,02 SAY "Cedula :            :"
   @ 07,02 SAY "Organizacion-Cliente:"
   @ 08,02 SAY "Nivel Org. 1        :"
   @ 09,02 SAY "Nivel Org. 2        :"
   @ 10,02 SAY "Nivel Org. 3        :"
   @ 11,02 SAY "Tipo                :"
   @ 12,02 SAY "Condicion           :"
   @ 13,02 SAY "Estatus             :"
   @ 14,02 SAY "Nivel Academico     :"
   @ 15,02 SAY "Titulo Obtenido     :"
   @ 16,02 SAY "Cargo               :"
   @ 17,02 SAY "Sueldo y otras asig.:"
   @ 18,02 SAY "Deducciones         :"
   @ 19,02 SAY "Telefono            :"
   @ 20,02 SAY "Fecha Ingreso       :"
   @ 21,02 SAY "Fecha Egreso        :"
   @ 06,10 GET WCEDTITU
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   IF WCEDTITU = SPACE(10)
      * DO BRAFI
      LOOP
   ENDIF
   SELECT AFITITU
   SEEK WCEDTITU
   IF .NOT. FOUND()
      STORE "NO EXISTE, VERIFIQUE" TO WTEXT
      DO AVISO WITH WTEXT
      LOOP
   ENDIF
   @ 06,25 SAY RTRIM(PAPELLIDO)+" "+RTRIM(SAPELLIDO)+", "+;
               RTRIM(PNOMBRE)+" "+RTRIM(SNOMBRE)
   SCAT MEMVAR
   @ 07,25 GET M.ORGA           VALID VALORG()
   @ 08,25 GET M.NIVORG1        VALID VALNO1()
   @ 09,25 GET M.NIVORG2        VALID VALNO2()
   @ 10,25 GET M.NIVORG3        VALID VALNO3()
   @ 11,25 GET M.TIPLAB         VALID VALTIP()
   @ 12,25 GET M.CONLAB         VALID VALCON()
   @ 13,25 GET M.ESTLAB         VALID VALEST()
   @ 14,25 GET M.NIVACA         VALID VALACA()
   @ 15,25 GET M.TITULO
   @ 16,25 GET M.CARGO
   @ 17,25 GET M.SUELDO
   @ 18,25 GET M.DEDUCCION
   @ 19,25 GET M.TELLAB
   @ 20,25 GET M.INGLAB
   @ 21,25 GET M.EGRLAB
   READ
   if lastkey()=27
      loop
   endif
   *** aceptar-cancelar
   store 1 to wop
   do while .t.
      @ 22,32  get wop pict "@*H Aceptar;Cancelar" defa wop
      read
      if lastkey()=13
         exit
      endif
   enddo
   *** fin aceptar-cancelar
   if wop=1
      select afititu
      if recloc()
         gath memv
         unlock all
      endif
   endif
enddo
return
***
*** FUNCIONES
***
***********
func valorg
select afiorga
do while .t.
   if m.orga<>space(4)
      store m.orga+space(6) to wclaveorg
      seek wclaveorg
      if found()
         @ 08,30 say afiorga.descri
         exit
      endif
   endif
   store 09 to librorg
   store 09 to cibrorg
   do afi0101
   if afiorga.nivorg1=space(2).and.afiorga.nivorg2=space(2).and.afiorga.nivorg3=space(2)
      store afiorga.orga to m.orga
   endif
enddo
return .T.
************
func valno1
select afiorga
do while .t.
   if m.nivorg1<>space(2)
      store m.orga+m.nivorg1+space(4) to wclaveorg
      seek wclaveorg
      if found()
         @ 09,30 say afiorga.descri
         exit
      endif
   endif
   store 10 To librorg
   store 09 to cibrorg
   store m.orga to wlastorga
   do afi0101
   if afiorga.orga=wlastorga.and.afiorga.nivorg1<>space(2).and.;
      afiorga.nivorg2=space(2).and.afiorga.nivorg3=space(2)
      store afiorga.orga    to m.orga
      store afiorga.nivorg1 to m.nivorg1
   endif
enddo
return .T.
************
func valno2
select afiorga
do while .t.
   if m.nivorg2<>space(2)
      store m.orga+m.nivorg1+m.nivorg2+space(2) to wclaveorg
      seek wclaveorg
      if found()
         @ 10,30 say afiorga.descri
         exit
      endif
   endif
   store 11 to librorg
   store 09 to cibrorg
   store m.orga    to wlastorga
   store m.nivorg1 to wlastniv1
   do afi0101
   if afiorga.orga=wlastorga.and.afiorga.nivorg1=wlastniv1.and.;
      afiorga.nivorg2<>space(2).and.afiorga.nivorg3=space(2)
      store afiorga.orga    to m.orga
      store afiorga.nivorg1 to m.nivorg1
      store afiorga.nivorg2 to m.nivorg2
   endif
enddo
return .T.
************
func valno3
select afiorga
do while .t.
   if m.nivorg3<>space(2)
      store m.orga+m.nivorg1+m.nivorg2+m.nivorg3 to wclaveorg
      seek wclaveorg
      if found()
         @ 11,30 say afiorga.descri
         exit
      endif
   endif
   store 12 to librorg
   store 09 to cibrorg
   store m.orga    to wlastorga
   store m.nivorg1 to wlastniv1
   store m.nivorg2 to wlastniv2
   do afi0101
   if afiorga.orga=wlastorga.and.afiorga.nivorg1=wlastniv1.and.;
      afiorga.nivorg2=wlastniv2.and.afiorga.nivorg3<>space(2)
      store afiorga.orga    to m.orga
      store afiorga.nivorg1 to m.nivorg1
      store afiorga.nivorg2 to m.nivorg2
      store afiorga.nivorg3 to m.nivorg3
   endif
enddo
return .T.
************
func valtip
do while .t.
   if m.tiplab="O".or.m.tiplab="E".or.m.tiplab="X"
      exit
   endif
   defi wind wintip  from 12,25 to 16,41
   acti wind wintip
   @ 00,00 clear
   store 1 to wvalop
   do while .t.
      @ 00,01 get wvalop pict "@*V  Obrero   ;Empleado ;Otros    "  defa wvalop
      read
      if lastkey()=13
         exit
      endif
   enddo
   if wvalop=1
      store "O" to m.tiplab
   else
      if wvalop=2
         store "E" to m.tiplab
      else
         store "X" to m.tiplab
      endif
   endif
   rele wind wintip
enddo
return .t.
************
func valcon
do while .t.
   if m.conlab="R".or.m.conlab="C".or.m.conlab="X"
      exit
   endif
   defi wind wincon  from 13,25 to 17,42
   acti wind wincon
   @ 00,00 clear
   store 1 to wvalop
   do while .t.
      @ 00,01 get wvalop pict "@*V  Regular    ; Contratado; Otros   " defa wvalop
      read
      if lastkey()=13
         exit
      endif
   enddo
   if wvalop=1
      store "R" to m.conlab
   else
      if wvalop=2
         store "C" to m.conlab
      else
         store "X" to m.conlab
      endif
   endif
   rele wind wincon
enddo
return .t.
************
func valest
do while .t.
   if m.estlab="A".or.m.estlab="I"
      exit
   endif
   defi wind winest  from 14,25 to 17,41
   acti wind winest
   @ 00,00 clear
   store 1 to wvalop
   do while .t.
      @ 00,01 get wvalop pict "@*V  Activo   ; Inactivo" defa wvalop
      read
      if lastkey()=13
         exit
      endif
   enddo
   if wvalop=1
      store "A" to m.estlab
   else
      store "I" to m.estlab
   endif
   rele wind winest
enddo
return .t.
************
func valaca
select afiacad
do while .t.
   if m.nivaca<>space(2)
      seek m.nivaca
      if found()
         @ 15,30 say afiacad.descri
         exit
      endif
   endif
   store 05 to libraca
   store 20 to cibraca
   do afi0103
   store afiacad.nivaca to m.nivaca
enddo
return .T.

