defi wind windfac from 5,0 to 20,79   ;
          title " FACTURACION POR AREA Y AUTOR " ;
          double nofloat nozoom nogrow shadow color scheme 10
do while .t.
   acti wind windfac
   store date()    to wdesde
   store date()    to whasta
   store space(03) to wcodarea
   store wusercode to wcajero
   store space(1)  to wpagofor

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

   * por area
   * subtotal cant serv x area
   store 0         to wscsxar
   * subtotal bolv serv x area
   store 0         to wsbsxar
   * total    cant serv x area
   store 0         to wtcsxar
   * total    bolv serv x area
   store 0         to wtbsxar


   *** CAPTURA PARAMETROS
   @ 0,0 clear
   @ 01,01 say "Desde      :"
   @ 02,01 say "Hasta      :" 
   @ 03,01 say "Area       :"
   @ 04,01 say "Cajero     :"
   @ 05,01 say "Forma pago :"
   @ 06,01 say "Salida     :"
   @ 07,01 say "Opciones   :"
   
   ***
   @ 12,0
   @ 12,5 say "Indique fecha de inicio de facturacion"
   @ 01,14  get wdesde
   read
   if lastkey()=27
      exit
   endif
   
   ***
   @ 12,0
   @ 12,5 say "Indique fecha de cierre de facturacion"
   @ 02,14  get whasta valid valhas()
   read
   if lastkey()=27
      loop
   endif
   
   ***
   @ 12,0
   @ 12,5 say "Indique codigo del area de servicio, <ENTER>=Todas, *=Seleccionar"
   @ 03,14  get wcodarea valid valare()
   read
   *if lastkey()=27
   *   loop
   *endif
   if wcodarea<>space(3)
      store syspto.descri to wareades
   else
      store "Todas"       to wareades
   endif
   @ 03,20  say wareades
   ***
   @ 04,14  get wcajero
   read
   *if lastkey()=27
   *   loop
   *endif
   
   ***
   @ 12,0
   @ 12,5 say "Indique la forma de pago de la factura"
   store 1 to wop
   do while .t.
      @ 05,14 get wop pict "@*H Todas    ;Contado  ;Credito  " defa wop
      read
      if lastkey()=13
         exit
      endif
   enddo
   if wop = 1
      store " " to wpagofor
   else
      if wop = 2
         store "C" to wpagofor
      else
         store "R" to wpagofor
      endif
   endif
   
   ***
   @ 12,0
   @ 12,5 say "Indique el medio de visualizacion del reporte"
   store 1 to wop
   do while .t.
      @ 06,14 get wop pict "@*H Monitor  ;Impresora" defa wop
      read
      if lastkey()=13.and.wop=2
         exit
      endif
   enddo
   store wop to wsalida
   
   ***
   @ 12,0
   @ 12,5 say "Confirme su opcion"
   store 1 to wop
   do while .t.
      @ 07,14 get wop pict "@*H Aceptar  ;Cancelar " defa wop
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
   @ 12,0
   @ 12,5 say "Procesando informacion, favor esperar..."
   SELECT 25
   use facami1
   store alltrim(wusercode)+".db1" to wfile01
   store alltrim(wusercode)+".in1" to windex01
   copy stru to &wfile01
   SELECT 25
   use &wfile01
   *** orden area-autor-servicio-fecha
   index on codare+codeje+codser+dtos(fecha) to &windex01
   *index on codare+codeje+codser+;
   *         str(year(fecha),4)+str(month(fecha),2)+str(day(fecha),2) to &windex01
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
   *if .not.eof()
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
      if wcodarea<>space(03).and.wcodarea<>area
         select facdcge
         skip
         loop
      endif
      if wcajero<>space(08).and.wcajero<>usuario
         select facdcge
         skip
         loop
      endif
      if wpagofor<>space(01).and.wpagofor<>pagofor
         select facdcge
         skip
         loop
      endif
      do grafac
      select facdcge
      skip
   enddo


   *** INICIO DE IMPRESION
   @ 12,0
   @ 12,5 say "Imprimiendo informacion, favor esperar..."
   store 0   to wpagina
   store 100 to wlinea
   store 0   to wtothon
   if wsalida = 1
      store 20 to wsalto
      @ 0,0 clear
      defi wind windrep from 0,0 to 24,79;
               none nofloat nozoom nogrow shadow color scheme 10
      acti wind  windrep
   else
      set devi to print
      *SET PRINT TO EJCM.SCR
      store 55 to wsalto
   endif
   store "*" to wrupareas
   store "*" to wrupautor
   store "*" to wrupservi
   SELECT 25
   go top
   do while .not.eof()
      store .f. to wflagservi
      store .f. to wflagautor
      store .f. to wflagareas
      do chkrup
      do prilin
      do totlin
      SELECT 25
      skip
   enddo
   ***
   do rupservi
   do rupautor
   do rupareas
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
func valare
***********
select syspto
if wcodarea<>space(3)
   seek wcodarea
   if found()
      return .t.
   else
      store 12 to librpto
      store 10 to cibrpto
      defi wind brpto from librpto,cibrpto to librpto+10,cibrpto+60 ;
                      title " AREAS DE SERVICIO " ;
                      footer " ESC = Seleccionar ";
                      double nofloat nozoom nogrow shadow color scheme 10
      acti wind brpto
      browse fields codpto:H="AREA", DESCRI:H="DESCRIPCION";
             noappend nodelete noedit nomenu nooptimize rest save in window brpto
      rele wind brpto
      store codpto to wcodarea
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
   if tipitem="B"
      store "ALMACEN "             to wejecutor
   else
      select sysservi
      seek ALLTRIM(facdcde.item)
      if found()
         if honorario<>"S"
            store "CLINICOS"       to wejecutor
         else
            store facdcde.ejecutor to wejecutor 
         endif
      else
         do procerr
         select facdcde
         skip
         loop
      endif
   endif
   SELECT 25
   if filloc()
      append blank
      replace fecha       with facdcge.elaborado
      replace codare      with facdcde.area
      replace codeje      with wejecutor 
      replace codser      with facdcde.item
      replace canhon      with facdcde.cantidad
      replace prehon      with facdcde.precio
      replace deshon      with facdcde.descuento
      replace nroref      with facdcge.numero
      replace monref      with facdcge.subdoc
      replace staref      with facdcge.pagofor
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
   @ 1,00 say "LISTADO DE FACTURAS POR AREA Y AUTOR DEL SERVICIO"
   @ 2,00 say "DESDE :"+dtoc(wdesde)+" HASTA :"+dtoc(whasta)
   @ 3,00 say "AREA  : "+alltrim(wcodarea)+" "+wareades
   @ 4,00 say "CAJERO: "+wcajero+" - FORMA DE PAGO:"+WPAGOFOR
   @ 5,00 say chr(15)
   @ 5,00 say replicate("-",109)
   @ 6,00 say "Area"
   @ 6,05 say "Autores"
   @ 6,14 say "Servicio"
   @ 6,27 say "Fecha"
   @ 6,38 say "Cantidad"
   @ 6,49 say "    Precio"
   @ 6,60 say "Dscto."
   @ 6,67 say "Monto Serv."
   @ 6,81 say "Factura"
   @ 6,89 say "FP"
   @ 6,97 say " Monto Fact."
   @ 7,00 say replicate("-",109)
   store 8 to wlinea
endif
return
************
proc prilin
************
do salto
if wflagareas
   @ wlinea,00 say codare
endif
if wflagautor
   @ wlinea,05 say codeje
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
@ wlinea,81 say substr(nroref,4,7)
@ wlinea,89 say staref
@ wlinea,96 say monref picture "999999999.99"
return
***********
proc totlin
***********
* por autor
store wscsxau + canhon   to wscsxau
store wsbsxau + wtothon  to wsbsxau
store wtcsxau + canhon   to wtcsxau
store wtbsxau + wtothon  to wtbsxau
* por area
store wscsxar + canhon   to wscsxar
store wsbsxar + wtothon  to wsbsxar
store wtcsxar + canhon   to wtcsxar
store wtbsxar + wtothon  to wtbsxar
return
***********
proc chkrup
***********
if codare<>wrupareas
   do rupservi
   do rupautor
   do rupareas
else
   if codeje<>wrupautor
      do rupservi
      do rupautor
   else
      if codser<>wrupservi
         do rupservi
      endif
   endif
endif
return
*************
proc rupservi
*************
if wscsxau>0
   do salto
   *@ wlinea,14 say "Subtotal "+wrupservi
   @ wlinea,14  say "Subtotal"
   @ wlinea,38  say wscsxau    picture "99999.99"
   @ wlinea,67  say wsbsxau    picture "99999999.99"
   store 0 to wscsxau
   store 0 to wsbsxau
endif
store .t.    to wflagservi
store codser to wrupservi
return
*************
proc rupautor
*************
if wtcsxau>0
   do salto
   *@ wlinea,05 say "Subtotal "+wrupautor
   @ wlinea,05 say "Subtotal "
   @ wlinea,38  say wtcsxau    picture "99999.99"
   @ wlinea,67  say wtbsxau    picture "99999999.99"
   do salto
   @ wlinea,05  say replicate("-",103)
   store 0 to wtcsxau
   store 0 to wtbsxau
endif
store .t.    to wflagautor
store codeje to wrupautor
return
*************
proc rupareas
*************
if wscsxar>0
   *do salto
   *@ wlinea,00 say replicate("-",108)
   do salto
   @ wlinea,00 say "Total "+wrupareas
   @ wlinea,38 say wscsxar    picture "99999.99"
   @ wlinea,67 say wsbsxar    picture "99999999.99"
   do salto
   @ wlinea,00 say replicate("-",108)
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
   @ 58,00 say replicate("-",108)
   store 0 to wtcsxar
   store 0 to wtbsxar
   @ 58,00 say chr(18)
endif
return
************
proc procerr
************
set devi to scre
store "SERVICIO: "+FACDCDE.ITEM+" EN FACTURA :"+FACDCGE.NUMERO+" NO EXISTE EN SERVICIOS" to wtext
do aviso with wtext
if wsalida=2
   set devi to print
endif
return
