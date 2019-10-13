defi wind windfac from 5,0 to 15,79   ;
          title " ACTIVIDADES POR AREA Y AUTOR " ;
          double nofloat nozoom nogrow shadow color scheme 10
do while .t.
   acti wind windfac
   store date()    to wdesde
   store date()    to whasta
   store space(03) to wcodarea

   *** INICIALIZA TOTALES
   * por autor
     * subtotal cant serv x autor
     store 0         to wscsxau
     * total    cant serv x autor
     store 0         to wtcsxau

   * por area
     * subtotal cant serv x area
     store 0         to wscsxar
     * total    cant serv x area
     store 0         to wtcsxar


   *** CAPTURA PARAMETROS
   @ 0,0 clear
   @ 01,01 say "Desde      :"
   @ 02,01 say "Hasta      :" 
   @ 03,01 say "Area       :"
   @ 05,01 say "Salida     :"
   @ 06,01 say "Opciones   :"

   @ 08,0
   @ 08,5 say "Indique fecha de inicio"
   @ 01,14  get wdesde
   read
   if lastkey()=27
      exit
   endif
   @ 08,0
   @ 08,5 say "Indique fecha de cierre"
   @ 02,14  get whasta valid valhas()
   read
   if lastkey()=27
      loop
   endif
   @ 08,0
   @ 08,5 say "Indique codigo del area de servicio, <ENTER>=Todas, *=Seleccionar"
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
   select 10
   use hisres1
   store alltrim(wusercode)+".db1" to wfile01
   store alltrim(wusercode)+".in1" to windex01
   copy stru to &wfile01
   select 10
   use &wfile01
   *** orden area-autor-servicio-fecha
   index on codare+coddoc+codact+dtos(fecact) to &windex01
   select hisgen
   *set order to hisgen3
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
   *go wstart
   do while .not.eof()
      if wdesde<>ctod("  -  -    ").and.fecact<wdesde
         select hisgen
         skip
         loop
      endif
      if whasta<>ctod("  -  -    ").and.fecact>whasta
         exit
      endif
      if wcodarea<>space(03).and.wcodarea<>codare
         select hisgen
         skip
         loop
      endif
      select 10
      if filloc()
         append blank
         replace fecact      with hisgen.fecact
         replace codare      with hisgen.codare
         replace coddoc      with hisgen.coddoc
         replace codact      with hisgen.codact
         replace codpac      with hisgen.codpac
         unlock all
      else
        *do procnul
      endif
      select hisgen
      skip
   enddo


   *** INICIO DE IMPRESION
   @ 08,0
   @ 08,5 say "Imprimiendo informacion, favor esperar..."
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
      SET PRINT TO EJCM.SCR
      store 60 to wsalto
   endif
   store "*" to wrupareas
   store "*" to wrupautor
   store "*" to wrupservi
   select 10
   go top
   do while .not.eof()
      store .f. to wflagservi
      store .f. to wflagautor
      store .f. to wflagareas
      do chkrup
      do prilin
      do totlin
      select 10
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
   @ 1,00 say "LISTADO DE ACTIVIDADES POR AREA Y AUTOR"
   @ 2,00 say "DESDE :"+dtoc(wdesde)+" HASTA :"+dtoc(whasta)
   @ 3,00 say "AREA  : "+alltrim(wcodarea)+" "+wareades
   @ 5,00 say chr(15)
   @ 5,00 say replicate("-",80)
   @ 6,00 say "Area"
   @ 6,05 say "Autores"
   @ 6,15 say "Actividad"
   @ 6,25 say "Fecha"
   @ 6,40 say "Paciente"
   @ 6,60 say "Cantidad"
   @ 7,00 say replicate("-",80)
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
   @ wlinea,05 say coddoc
endif
if wflagservi
   @ wlinea,15 say codact
endif
@ wlinea,25 say fecact
@ wlinea,40 say codpac
return
***********
proc totlin
***********
* por autor
store wscsxau + 1        to wscsxau
store wtcsxau + 1        to wtcsxau
* por area
store wscsxar + 1        to wscsxar
store wtcsxar + 1        to wtcsxar
return
***********
proc chkrup
***********
if codare<>wrupareas
   do rupservi
   do rupautor
   do rupareas
else
   if coddoc<>wrupautor
      do rupservi
      do rupautor
   else
      if codact<>wrupservi
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
   *@ wlinea,15 say "Subtotal "+wrupservi
   @ wlinea,15  say "Subtotal"
   @ wlinea,60  say wscsxau    picture "99999.99"
   store 0 to wscsxau
endif
store .t.    to wflagservi
store codact to wrupservi
return
*************
proc rupautor
*************
if wtcsxau>0
   do salto
   *@ wlinea,05 say "Subtotal "+wrupautor
   @ wlinea,05 say "Subtotal "
   @ wlinea,60  say wtcsxau    picture "99999.99"
   do salto
   @ wlinea,05  say replicate("-",80)
   store 0 to wtcsxau
endif
store .t.    to wflagautor
store coddoc to wrupautor
return
*************
proc rupareas
*************
if wscsxar>0
   do salto
   @ wlinea,00 say "Total "+wrupareas
   @ wlinea,60 say wscsxar    picture "99999.99"
   do salto
   @ wlinea,00 say replicate("-",80)
   store 0 to wscsxar
endif
store .t.    to wflagareas
store codare to wrupareas
return
*************
proc totgen
*************
if wtcsxar>0
   @ 61,00 say replicate("-",80)
   @ 62,00 say "Total Reporte"
   @ 62,60 say wtcsxar    picture "99999.99"
   @ 63,00 say replicate("-",80)
   store 0 to wtcsxar
   @ 63,00 say chr(18)
endif
return
******

