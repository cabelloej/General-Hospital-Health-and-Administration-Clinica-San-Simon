defi wind windfac from 5,0 to 15,79   ;
          title " I.S.L.R. POR AUTOR Y AREA " ;
          double nofloat nozoom nogrow shadow color scheme 10
do while .t.
   acti wind windfac
   store date()    to wdesde
   store date()    to whasta
   store space(08) to wcodautor

   *** INICIALIZA TOTALES
   * por autor
   * subtotal cant serv x autor
   store 0         to wscsxau
   * subtotal bolv serv x autor
   store 0         to wsbsxau
   * total    cant serv x autor
   store 0         to wtcsxau
   * total    bolv serv x autor
   store 0         to wtbsxau
   * total    islr serv x autor
   store 0         to wtimxau

   * por area
   * subtotal cant serv x area
   store 0         to wscsxar
   * subtotal bolv serv x area
   store 0         to wsbsxar
   * total    cant serv x area
   store 0         to wtcsxar
   * total    bolv serv x area
   store 0         to wtbsxar
   * total    islr serv x area
   store 0         to wtimxar


   *** CAPTURA PARAMETROS
   @ 0,0 clear
   @ 01,01 say "Desde      :"
   @ 02,01 say "Hasta      :" 
   @ 03,01 say "Autor      :"
   @ 05,01 say "Salida     :"
   @ 06,01 say "Opciones   :"

   @ 08,0
   @ 08,5 say "Indique fecha de inicio de facturacion"
   @ 01,14  get wdesde
   read
   if lastkey()=27
      exit
   endif
   @ 08,0
   @ 08,5 say "Indique fecha de cierre de facturacion"
   @ 02,14  get whasta valid valhas()
   read
   if lastkey()=27
      loop
   endif
   @ 08,0
   @ 08,5 say "Indique codigo del autor de servicios, <ENTER>=Todos, *=Seleccionar"
   @ 03,14  get wcodautor valid valaut()
   read
   *if lastkey()=27
   *   loop
   *endif
   if wcodautor<>space(8)
      store sysmed.nombre to wautordes
   else
      store "Todos"       to wautordes
   endif
   @ 03,30  say wautordes

   @ 08,0
   @ 08,5 say "Indique el medio de visualizacion del reporte"
   store 1 to wop
   do while .t.
      @ 05,14 get wop pict "@*H Monitor  ;Impresora" defa wop
      read
      if lastkey()=13.and.wop=2
         exit
      endif
   enddo
   store wop to wsalida
   ***
   @ 08,0
   @ 08,5 say "Confirme su opcion"
   store 1 to wop
   do while .t.
      @ 06,14 get wop pict "@*H Aceptar  ;Cancelar " defa wop
      read
      if lastkey()=13
         exit
      endif
   enddo
   store wop to wopcion
   if wopcion=2
      loop
   endif


   *** INICIO DE RECOPILACION
   @ 08,0
   @ 08,5 say "Procesando informacion, favor esperar..."
   SELECT 25
   use facami2
   store alltrim(wusercode)+".db1" to wfile01
   store alltrim(wusercode)+".in1" to windex01
   copy stru to &wfile01
   SELECT 25
   use &wfile01
   *** orden autor-area-servicio-fecha
   index on codeje+codare+codser+dtos(fecha) to &windex01
            *str(year(fecha),4)+str(month(fecha),2)+str(day(fecha),2) to &windex01
   select facdcge
   set order to facdcge3
   go top
   *store recno() to wstart
   *if wdesde<>ctod("  -  -    ")
   *   seek str(year(wdesde),4)
   *   if found()
   *      store recno() to wstart
   *      seek str(year(wdesde),4)+str(month(wdesde),2)
   *      if found()
   *         store recno() to wstart
   *         seek str(year(wdesde),4)+str(month(wdesde),2)+str(day(wdesde),2)
   *         if found()
   *            store recno() to wstart
   *         endif
   *      endif
   *   endif
   *endif
   *if .not. eof()
   *   go wstart
   *endif
   do while .not.eof()
      if wdesde<>ctod("  -  -    ").and.elaborado<wdesde
         select facdcge
         skip
         loop
      endif
      if whasta<>ctod("  -  -    ").and.elaborado>whasta
         exit
      endif
      if wcodautor<>space(08).and.wcodautor<>ejecutor
         select facdcge
         skip
         loop
      endif
      do grafac
      select facdcge
      skip
   enddo


   *** INICIO DE IMPRESION
   @ 08,0
   @ 08,5 say "Imprimiendo informacion, favor esperar..."
   store 0   to wpagina
   store 100 to wlinea
   store 0   to wtothon
   store 0   to wtotisr
   if wsalida = 1
      store 20 to wsalto
      @ 0,0 clear
      defi wind windrep from 0,0 to 24,79;
               none nofloat nozoom nogrow shadow color scheme 10
      acti wind  windrep
   else
      set devi to print
      SET PRINT TO EJCM.SCR
      store 55 to wsalto
   endif
   store "*" to wrupautor
   store "*" to wrupareas
   store "*" to wrupservi
   SELECT 25
   go top
   do while .not.eof()
      store .f. to wflagservi
      store .f. to wflagareas
      store .f. to wflagautor
      do chkrup
      do prilin
      do totlin
      SELECT 25
      skip
   enddo
   ***
   do rupservi
   do rupareas
   do rupautor
   do totgen
   ***
   if wsalida = 2
      set devi to scre
      eject
   else
      store "OPRIMA (Ù) PARA FINALIZAR" to tex
      store chr(13) to wch
      do pregunta
      rele wind windrep
   endif
enddo
rele wind windfac
return

*****************************************************************************
*****************************************************************************
***********
func valhas
***********
if whasta>=wdesde
   return .t.
else
   return .f.
endif
return
***********
func valaut
***********
select sysmed
if wcodautor<>space(8)
   seek wcodautor
   if found()
      return .t.
   else
      store 12 to librmed
      store 10 to cibrmed
      defi wind brmed from librmed,cibrmed to librmed+10,cibrmed+60 ;
                      title " PERSONAL MEDICO " ;
                      footer " ESC = Seleccionar ";
                      double nofloat nozoom nogrow shadow color scheme 10
      acti wind brmed
      browse fields codpto:H="MEDICO", DESCRI:H="DESCRIPCION";
             noappend nodelete noedit nomenu nooptimize rest save in window brpto
      rele wind brmed
      store medico to wcodautor
      return .t.
   endif
endif
return
***********
proc grafac
***********
select facdcde
seek facdcge.numero
do while .not.eof().and.numero=facdcge.numero
   if tipitem<>"S"
      select facdcde
      skip
      loop
   endif
   select sysservi
   seek ALLTRIM(facdcde.item)
   if found()
      if honorario<>"S"
         select facdcde
         skip
         loop
      endif
   else
      set devi to scre
      store "SERVICIO: "+FACDCDE.ITEM+" EN FACTURA :"+FACDCGE.NUMERO+" NO EXISTE EN SERVICIOS" to wtext
      do aviso with wtext
      if wsalida=2
         set devi to print
      endif
   endif
   select sysmed
   seek SUBSTR(facdcde.ejecutor,6,3)
   if .not.found()
      set devi to scre
      store "AUTOR : "+FACDCDE.EJECUTOR+" EN FACTURA :"+FACDCGE.NUMERO+" NO EXISTE EN PER. MEDICO" to wtext
      do aviso with wtext
      if wsalida=2
         set devi to print
      endif
      select facdcde
      skip
      loop
   endif
   SELECT 25
   if filloc()
      append blank
      replace fecha       with facdcge.elaborado
      replace codare      with facdcde.area
      replace codeje      with facdcde.ejecutor
      replace codser      with facdcde.item
      replace canhon      with facdcde.cantidad
      replace prehon      with facdcde.precio
      replace deshon      with facdcde.descuento
      replace porislr     with sysmed.islr
      replace nroref      with facdcge.numero
      replace monref      with facdcge.subdoc
      if facdcge.vence>facdcge.elaborado
         replace staref   with "R"
      else
         replace staref   with "C"
      endif
      unlock all
   else
     *do procnul
  endif
  ***
  select facdcde
  skip
enddo
select facdcge
return
**********
proc salto
**********
store wlinea+1 to wlinea
if wlinea >= wsalto
   store wpagina + 1 to wpagina
   if wsalida=1 .and. wpagina<>1
      store "OPRIMA (Ù) PARA CONTINUAR" to tex
      store chr(13) to wch
      do pregunta
      @ 0,0 clear
   endif
   @ 0,00 say chr(14)+qqww
   @ 1,00 say "LISTADO DE I.S.L.R. DE HONORARIOS POR AUTOR AREA"
   @ 2,00 say "DESDE :"+dtoc(wdesde)+" HASTA :"+dtoc(whasta)
   @ 3,00 say "AUTOR : "+alltrim(wcodautor)+" "+wautordes
   @ 5,00 say chr(15)
   @ 5,00 say replicate("-",109)
   @ 6,00 say "Autor"
   @ 6,09 say "Area"
   @ 6,14 say "Servicio"
   @ 6,27 say "Fecha"
   @ 6,38 say "Cantidad"
   @ 6,49 say "    Precio"
   @ 6,60 say "Dscto."
   @ 6,67 say "Monto Serv."
   @ 6,81 say "% ISLR "
   @ 6,97 say " Monto ISLR."
   @ 7,00 say replicate("-",109)
   store 8 to wlinea
endif
return
************
proc prilin
************
do salto
if wflagautor
   @ wlinea,00 say codeje
endif
if wflagareas
   @ wlinea,09 say codare
endif
if wflagservi
   @ wlinea,14 say codser
endif
@ wlinea,27 say fecha
@ wlinea,38 say canhon picture     "99999.99"
@ wlinea,49 say prehon picture   "9999999.99"
@ wlinea,60 say deshon picture       "999.99"
store canhon*(prehon-((prehon*deshon)/100)) to wtothon
@ wlinea,67 say wtothon picture "99999999.99"
@ wlinea,81 say porislr picture "999.99"
store ((wtothon*porislr)/100)               to wtotisr
@ wlinea,96 say wtotisr picture "999999999.99"
return
***********
proc totlin
***********
* por autor
store wscsxau + canhon   to wscsxau
store wsbsxau + wtothon  to wsbsxau
store wtcsxau + canhon   to wtcsxau
store wtbsxau + wtothon  to wtbsxau
store wtimxau + wtotisr  to wtimxau
* por area
store wscsxar + canhon   to wscsxar
store wsbsxar + wtothon  to wsbsxar
store wtcsxar + canhon   to wtcsxar
store wtbsxar + wtothon  to wtbsxar
store wtimxar + wtotisr  to wtimxar
return
***********
proc chkrup
***********
if codeje<>wrupautor
   do rupservi
   do rupareas
   do rupautor
else
   if codare<>wrupareas
      do rupservi
      do rupareas
   else
      if codser<>wrupservi
         do rupservi
      endif
   endif
endif
return
*************
proc rupautor
*************
if wtcsxau>0
   do salto
   *@ wlinea,00 say "Total "+wrupautor
   @ wlinea,00 say "Total "+wrupautor
   @ wlinea,38  say wtcsxau    picture "99999.99"
   @ wlinea,67  say wtbsxau    picture "99999999.99"
   @ wlinea,96  say wtimxau    picture "999999999.99"
   do salto
   @ wlinea,00  say replicate("-",108)
   store 0 to wtcsxau
   store 0 to wtbsxau
   store 0 to wtimxau
endif
store .t.    to wflagautor
store codeje to wrupautor
return
*************
proc rupservi
*************
if wscsxau>0
   do salto
   *@ wlinea,14 say "Subtotal "+wrupservi
   @ wlinea,14  say "Subtotal "
   @ wlinea,38  say wscsxau    picture "99999.99"
   @ wlinea,67  say wsbsxau    picture "99999999.99"
   store 0 to wscsxau
   store 0 to wsbsxau
endif
store .t.    to wflagservi
store codser to wrupservi
return
*************
proc rupareas
*************
if wscsxar>0
   do salto
   *@ wlinea,09 say "Subtotal "+wrupareas
   @ wlinea,09  say "Subtotal "
   @ wlinea,38  say wscsxar    picture "99999.99"
   @ wlinea,67  say wsbsxar    picture "99999999.99"
   store 0 to wscsxar
   store 0 to wsbsxar
endif
store .t.    to wflagareas
store codare to wrupareas
return
*************
proc totgen
*************
if wtcsxar>0
   @ 56,00 say replicate("-",108)
   @ 57,00 say "Total Reporte"
   @ 57,38 say wtcsxar    picture "99999.99"
   @ 57,67 say wtbsxar    picture "99999999.99"
   @ 57,96 say wtimxar    picture "999999999.99"
   @ 58,00 say replicate("-",108)
   store 0 to wtcsxar
   store 0 to wtbsxar
   store 0 to wtimxar
   @ 58,00 say chr(18)
endif
return
******

