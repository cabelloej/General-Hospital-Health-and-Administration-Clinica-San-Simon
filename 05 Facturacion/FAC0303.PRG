defi wind windfac from 5,0 to 17,79   ;
          title " RESUMEN GENERAL DE FACTURAS " ;
          double nofloat nozoom nogrow shadow color scheme 10
do while .t.
   acti wind windfac
   store date()    to wdesde
   store date()    to whasta
   store space(08) to wcoduser
   store space(03) to wcodare
   store space(15) to wcodcli
   store space(14) to wcodpac
   store 0         to wtotcon
   store 0         to wtotcre
   store 0         to wtotfac
   @ 0,0 clear
   @ 01,01 say "Desde      :"
   @ 02,01 say "Hasta      :" 
   @ 03,01 say "Area       :"
   @ 04,01 say "Operador   :"
   @ 05,01 say "Cliente    :" 
   @ 06,01 say "Paciente   :"  
   @ 07,01 say "Forma pago :"
   @ 08,01 say "Salida     :" 
   @ 09,01 say "Opciones   :" 

   @ 01,14  get wdesde
   read
   if lastkey()=27
      exit
   endif
   @ 02,14  get whasta valid valhas()
   read
   if lastkey()=27
      loop
   endif
   @ 03,14  get wcodare 
   read
   if lastkey()=27
      loop
   endif
   @ 04,14  get wcoduser
   read
   if lastkey()=27
      loop
   endif
   @ 05,14  get wcodcli
   read
   if lastkey()=27
      loop
   endif
   @ 06,14  get wcodpac
   read
   if lastkey()=27
      loop
   endif


   store 1 to wop
   do while .t.
      @ 07,14 get wop pict "@*H Todas    ;Contado  ;Credito  " defa wop
      read
      if lastkey()=13
         exit
      endif
   enddo
   if wop = 1
      store " "          to wpagofor
      store "Todas"      to wdespago
   else
      if wop = 2
         store "C"       to wpagofor
         store "Contado" to wdespago
      else
         store "R"       to wpagofor
         store "Credito" to wdespago
      endif
   endif
   store 1 to wop
   do while .t.
      @ 08,14 get wop pict "@*H Monitor  ;Impresora" defa wop
      read
      if lastkey()=13
         exit
      endif
   enddo
   store wop to wsalida
   ***
   store 1 to wop
   do while .t.
      @ 09,14 get wop pict "@*H Aceptar  ;Cancelar " defa wop
      read
      if lastkey()=13
         exit
      endif
   enddo
   store wop to wopcion
   if wopcion=2
      loop
   endif
   store 0   to wpagina
   store 100 to wlinea
   if wsalida = 1
      store 20 to wsalto
      @ 0,0 clear
      defi wind windrep from 0,0 to 24,79;
               none nofloat nozoom nogrow shadow color scheme 10
      acti wind  windrep
   else
      set devi to print
      store 60 to wsalto
   endif
   ****************************************************************************
   select facdcge
   set order to facdcge3
   go top
   store recno() to wstart
   if wdesde<>ctod("  -  -    ")
      store str(year(wdesde),4) to wclue
      seek wclue
      if found()
         store recno() to wstart
         store str(year(wdesde),4)+str(month(wdesde),2) to wclue 
         seek wclue
         if found()
            store recno() to wstart
            store str(year(wdesde),4)+str(month(wdesde),2)+str(day(wdesde),2) to wclue
            seek wclue
            if found()
               store recno() to wstart
            endif
         endif
      endif
   endif
   if .not.eof()
      go wstart
   endif
   do while .not.eof()
      if wdesde<>ctod("  -  -    ").and.elaborado<wdesde
         select facdcge
         skip
         loop
      endif
      if wdesde<>ctod("  -  -    ").and.elaborado>whasta
         exit
      endif
      if wcodare<>space(03)
         store 0 to wtotarefac
         select facdcde
         seek facdcge.numero
         do while .not. eof() .and. facdcge.numero=facdcde.numero
            if wcodare=facdcde.area
               STORE FACDCDE.CANTIDAD*(FACDCDE.PRECIO-(FACDCDE.PRECIO*FACDCDE.DESCUENTO/100)) TO WTOTRENG
               store wtotarefac+wtotreng to wtotarefac
            endif
            select facdcde
            skip
         enddo
         select facdcge
         if wtotarefac=0
            select facdcge
            skip
            loop
         endif
      else
         store 0 to wtotarefac
      endif
      if wcoduser<>space(08).and.wcoduser<>usuario
         select facdcge
         skip
         loop
      endif
      if wcodcli<>space(15).and.wcodcli<>codcli
         select facdcge
         skip
         loop
      endif
      if wcodpac<>space(14).and.wcodpac<>codpac
         select facdcge
         skip
         loop
      endif
      if wpagofor<>space(1).and.wpagofor<>pagofor
         select facdcge
         skip
         loop
      endif
      ***
      do printfac
      select facdcge
      skip
   enddo
   ***
   store wlinea+1 to wlinea
   do salto
   @ wlinea,0 say replicate("-",79)
   store wlinea+1 to wlinea
   do salto
   @ wlinea,00 say "TOTAL CONTADO:"
   @ wlinea,55 say wtotcon picture "999,999,999.99"
   store wlinea+1 to wlinea
   do salto
   @ wlinea,00 say "TOTAL CREDITO:"
   @ wlinea,55 say wtotcre picture "999,999,999.99"
   store wlinea+1 to wlinea
   do salto
   @ wlinea,00 say "TOTAL REPORTE:"
   @ wlinea,55 say wtotfac picture "999,999,999.99"
   store wlinea+1 to wlinea
   do salto
   @ wlinea,0 say replicate("-",79)
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
***********
func valhas
***********
if whasta>=wdesde
   return .t.
else
   return .f.
endif
return
*************
proc printfac
*************
store tippac to xtippac
store codpac to xcodpac
store " "    to xnompac
do buspac
store wlinea+1 to wlinea
do salto
@ wlinea,00 say substr(numero,4,7)
@ wlinea,08 say area
@ wlinea,12 say substr(str(serialespe,7),3,5)
@ wlinea,18 say elaborado
@ wlinea,29 say substr(xnompac,1,25)
if wcodare=space(03)
   store wtotfac+monto        to wtotfac
   @ wlinea,56 say monto      picture "99,999,999.99"
else
   store wtotfac+wtotarefac   to wtotfac
   @ wlinea,56 say wtotarefac picture "99,999,999.99"
endif
@ wlinea,70 say pagofor
@ wlinea,72 say usuario
if pagofor="C"
   if wcodare=space(03)
      store wtotcon+monto      to wtotcon
   else
      store wtotcon+wtotarefac to wtotcon
   endif
else
   if wcodare=space(03)
      store wtotcre+monto      to wtotcre
   else
      store wtotcre+wtotarefac to wtotcre
   endif
endif
return
**********
proc salto
**********
if wlinea >= wsalto
   store wpagina + 1 to wpagina
   if wsalida=1 .and. wpagina<>1
      store "OPRIMA (Ù) PARA CONTINUAR" to tex
      store chr(13) to wch
      do pregunta
      @ 0,0 clear
   endif
   @ 0,00 say chr(14)+qqww
   @ 2,00 say "LISTADO DE FACTURAS DESDE :"+dtoc(wdesde)+" HASTA :"+dtoc(whasta)
   @ 3,00 say "PAGO     :"+wdespago
   @ 3,00 say "OPERADOR :"+wcoduser
   @ 4,00 say "CLIENTE  :"+wcodcli
   @ 5,00 say replicate("-",79)
   @ 6,00 say "Factura"
   @ 6,08 say "Area"
   @ 6,13 say "Sral"
   @ 6,18 say "Fecha"
   @ 6,29 say "Paciente"
   @ 6,56 say "        Monto"
   @ 6,70 say "P"
   @ 6,72 say " Usuario"
   @ 7,00 say replicate("-",79)
   store 8 to wlinea
endif
return
****************
PROCEDURE BUSPAC
****************
IF XTIPPAC="A"
   SELECT AFIAFI
   SET ORDER TO AFIAFI1
   SEEK XCODPAC
   IF .NOT. FOUND()
      STORE "" TO XNOMPAC
   ELSE
      STORE ALLTRIM(AFIAFI.PAPELLIDO)+", "+;
            ALLTRIM(AFIAFI.PNOMBRE)          TO XNOMPAC
   ENDIF
ELSE
   SELECT SYSPAC
   SEEK XCODPAC
   IF .NOT. FOUND()
      STORE "" TO XNOMPAC    
   ELSE
      STORE ALLTRIM(SYSPAC.PAPELLIDO)+", "+;
            ALLTRIM(SYSPAC.PNOMBRE)          TO XNOMPAC
   ENDIF
ENDIF
SELECT FACDCGE
RETURN 

