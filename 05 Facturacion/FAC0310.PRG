defi wind windfac from 5,0 to 15,79   ;
          title " IMPRIMIR ABONOS A CTAS X COBRAR " ;
          double nofloat nozoom nogrow shadow color scheme 10
do while .t.
   acti wind windfac
   store date()    to wdesde
   store date()    to whasta
   store space(08) to wcoduser
   store space(03) to warea
   store space(15) to wcodcli
   store 0         to wtotfac
   
   @ 0,0 clear
   @ 01,01 say "Desde      :"
   @ 02,01 say "Hasta      :" 
   @ 03,01 say "Operador   :"
   @ 04,01 say "Area de ser:" 
   @ 05,01 say "Cliente    :"  
   @ 06,01 say "Salida     :" 
   @ 07,01 say "Opciones   :" 

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
   @ 03,14  get wcoduser
   read
   if lastkey()=27
      loop
   endif
   @ 04,14  get warea   
   read
   if lastkey()=27
      loop
   endif
   @ 05,14  get wcodcli
   read
   if lastkey()=27
      loop
   endif
   store 1 to wop
   do while .t.
      @ 06,14 get wop pict "@*H Monitor  ;Impresora" defa wop
      read
      if lastkey()=13
         exit
      endif
   enddo
   store wop to wsalida
   ***
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
   select faccxctr
   set order to faccxct3
   go top
   store recno() to wstart
   if wdesde<>ctod("  -  -    ")
      seek str(year(wdesde),4)
      if found()
         store recno() to wstart
         seek str(year(wdesde),4)+str(month(wdesde),2)
         if found()
            store recno() to wstart
            seek str(year(wdesde),4)+str(month(wdesde),2)+str(day(wdesde),2)
            if found()
               store recno() to wstart
            endif
         endif
      endif
   endif
   if .not. eof()
      go wstart
   endif
   do while .not.eof()
      if wdesde<>ctod("  -  -    ").and.fecha<wdesde
         select faccxctr
         skip
         loop
      endif
      if wdesde<>ctod("  -  -    ").and.fecha>whasta
         exit
      endif
      if wcoduser<>space(08).and.wcoduser<>usuario
         select faccxctr
         skip
         loop
      endif
      *
      select faccxc
      set order to faccxc1
      seek faccxctr.codcxc
      if found()
         store codcli to wxcodcli
      else
         store "?"    to wxcodcli
      endif
      select faccxctr
      *
      if wcodcli<>space(15).and.wcodcli<>wxcodcli
         select faccxctr
         skip
         loop
      endif
      *
      store space(10) to wreferencia
      store space(3)  to wxarea
      select faccxc 
      seek faccxctr.codcxc
      if found()
         store referencia to wreferencia 
         select facdcge
         seek faccxc.referencia
         if found()
            store area   to wxarea
         endif
      endif
      select faccxctr
      *
      if warea <> space(03) 
         if warea<>wxarea
            skip
            loop
         endif
      endif
      *
      do printabo
      select faccxctr
      skip
   enddo
   ***
   store wlinea+1 to wlinea
   do salto
   @ wlinea,0 say replicate("-",79)
   store wlinea+1 to wlinea
   do salto
   @ wlinea,00 say "TOTAL ABONADO:"
   @ wlinea,50 say wtotfac picture "999,999,999.99"
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
proc printabo
*************
store wlinea+1 to wlinea
do salto
@ wlinea,00 say codcxc
@ wlinea,10 say wreferencia
@ wlinea,22 say fecha    
@ wlinea,33 say wxcodcli
@ wlinea,50 say monto picture "999,999,999.99"
@ wlinea,65 say usuario
*@ wlinea,75 say area
store wtotfac+monto to wtotfac
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
   @ 2,00 say "LISTADO DE ABONOS A CxC DESDE :"+dtoc(wdesde)+" HASTA :"+dtoc(whasta)
   @ 3,00 say "OPERADOR :"+wcoduser+" AREA :"+warea
   @ 4,00 say "CLIENTE  :"+wcodcli
   @ 5,00 say replicate("-",79)
   @ 6,00 say "Cta.No."
   @ 6,10 say "Referencia"
   @ 6,22 say "Fecha"
   @ 6,33 say "Cliente"
   @ 6,50 say "Monto"
   @ 6,65 say "Usuario"
   *@ 6,75 say "Area"
   @ 7,00 say replicate("-",79)
   store 8 to wlinea
endif
return
************
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


