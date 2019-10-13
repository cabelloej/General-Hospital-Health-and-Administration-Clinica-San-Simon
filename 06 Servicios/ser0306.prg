defi wind windfac from 5,0 to 16,79   ;
          title " RESUMEN GENERAL DE EXONERACIONES " ;
          double nofloat nozoom nogrow shadow color scheme 10
do while .t.
   acti wind windfac
   store date()    to wdesde
   store date()    to whasta
   store space(08) to wcoduser
   store space(03) to wcodare
   store space(14) to wcodpac
   store 0         to wtotgenexo
   @ 0,0 clear
   @ 01,01 say "Desde      :"
   @ 02,01 say "Hasta      :" 
   @ 03,01 say "Area       :"
   @ 04,01 say "Operador   :"
   @ 05,01 say "Paciente   :" 
   @ 06,01 say "Salida     :" 
   @ 07,01 say "Opciones   :" 
   ***
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
   @ 05,14  get wcodpac
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
   ***
   store 0   to wpagina
   store 100 to wlinea
   store 0   to wcanpac
   if wsalida = 1
      store 20 to wsalto
      @ 0,0 clear
      defi wind windrep from 0,0 to 24,79;
               none nofloat nozoom nogrow shadow color scheme 10
      acti wind  windrep
   else
      set devi to print
      store 55 to wsalto
   endif
   ***
   select serdcge
   set order to serdcge
   go top
   do while .not.eof()
      if wdesde<>ctod("  -  -    ").and.elaborado<wdesde
         select serdcge
         skip
         loop
      endif
      if wdesde<>ctod("  -  -    ").and.elaborado>whasta
         exit
      endif
      if wcodare<>space(03).and.wcodare<>proveedor
         select serdcge
         skip
         loop
      endif
      if wcoduser<>space(08).and.wcoduser<>usuario
         select serdcge
         skip
         loop
      endif
      if wcodpac<>space(14).and.wcodpac<>codpac
         select serdcge
         skip
         loop
      endif
      ***
      store serdcge.tippac    to xtippac
      store serdcge.codpac    to xcodpac
      store space(1)          to xnompac
      store space(1)          to xnivel
      store 0                 to wtotsolexo
      do procpac
      if xnivel>"B"
         do calexo
         if wtotsolexo > 0
            do printser
         endif
      else
         if serdcge.monto>0.and.serdcge.factura=space(10)
            store serdcge.monto to wtotsolexo
            store wtotgenexo+wtotsolexo to wtotgenexo
            do printser
         endif
      endif
      ***
      select serdcge
      skip
   enddo
   if wtotgenexo>0
      do printtot
   endif
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
proc printser
*************
store wlinea+1                        to wlinea
do salto
@ wlinea,00 say substr(serdcge.numero,4,7)
@ wlinea,08 say serdcge.elaborado
@ wlinea,19 say substr(xnompac,1,30)
@ wlinea,50 say wtotsolexo picture "999,999,999.99"
@ wlinea,65 say usuario
@ wlinea,75 say proveedor
store wcanpac + 1 to wcanpac
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
   @ 1,00 say "EXONERACIONES DESDE :"+dtoc(wdesde)+" HASTA :"+dtoc(whasta)
   @ 2,00 say "AREA     :"+wcodare
   @ 3,00 say "OPERADOR :"+wcoduser
   @ 4,00 say "PACIENTE :"+wcodpac
   @ 5,00 say replicate("-",79)
   @ 6,00 say "Solic. "
   @ 6,08 say "Fecha"
   @ 6,19 say "Paciente"
   @ 6,50 say "Monto"
   @ 6,65 say "Usuario"
   @ 6,75 say "Area"
   @ 7,00 say replicate("-",79)
   store 8 to wlinea
endif
return
*************   
proc printtot
*************
store wlinea+1 to wlinea
do salto
@ wlinea,0 say replicate("-",79)
store wlinea+1 to wlinea
do salto

store wlinea+2 to wlinea
do salto
@ wlinea,00 say "No.DE PACIENTES :"+STR(WCANPAC,5)
@ wlinea,35 say "TOTAL REPORTE:"
@ wlinea,50 say wtotgenexo picture "999,999,999.99"
store wlinea+1 to wlinea
do salto
@ wlinea,0 say replicate("-",79)
return
************
proc procpac
************
IF XTIPPAC="A"
   SELECT AFIAFI
   SET ORDER TO AFIAFI1
   SEEK XCODPAC
   IF .NOT. FOUND()
      STORE "" TO XNOMPAC
      STORE "" TO XNIVPRE
   ELSE
      STORE ALLTRIM(AFIAFI.PAPELLIDO)+", "+ALLTRIM(AFIAFI.PNOMBRE) TO XNOMPAC
      STORE NIVEL                                                  TO XNIVVEL
      STORE .T. TO WFLAGPAC
   ENDIF
ELSE
   SELECT SYSPAC
   SEEK XCODPAC
   IF .NOT. FOUND()
      STORE "" TO XNOMPAC    
      STORE "" TO XNIVPRE
   ELSE
      STORE ALLTRIM(SYSPAC.PAPELLIDO)+", "+ALLTRIM(SYSPAC.PNOMBRE) TO XNOMPAC
      STORE NIVEL                                                  TO XNIVEL
      STORE .T. TO WFLAGPAC
   ENDIF
ENDIF
SELECT SERDCGE
RETURN 
***********
PROC CALEXO
***********
SELECT SERDCDE
SEEK SERDCGE.NUMERO
DO WHILE .NOT. EOF() .AND. SERDCGE.NUMERO=SERDCDE.NUMERO
   STORE 0 TO WRENGEXO
   IF TIPITEM="B"
      SELECT ALMART
      SEEK SERDCDE.ITEM
      IF FOUND()
         SELECT SERDCDE
         STORE (ALMART.PRECIOB)-(CANTIDAD*(PRECIO-(PRECIO*DESCUENTO/100))) TO WRENGEXO
      ENDIF
   ELSE
      STORE SUBSTR(SERDCDE.ITEM,1,12) TO WCLUE
      SELECT SYSSERVI
      SEEK WCLUE
      IF FOUND()
         SELECT SERDCDE
         STORE (SYSSERVI.PRECIOB)-(CANTIDAD*(PRECIO-(PRECIO*DESCUENTO/100))) TO WRENGEXO
      ENDIF
   ENDIF
   IF WRENGEXO<0
      STORE 0 TO WRENGEXO
   ENDIF
   STORE WTOTSOLEXO+WRENGEXO TO WTOTSOLEXO
   SELECT SERDCDE
   SKIP
ENDDO
IF WTOTSOLEXO>0
   STORE WTOTGENEXO+WTOTSOLEXO TO WTOTGENEXO
ENDIF
SELECT SERDCGE
RETURN
