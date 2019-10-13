DO while .t.
   @ 04,00 CLEAR
   @ 05,00 to 17,79
   @ 05,01 SAY "< CONTRATO DE AFILIACION CON TITULAR >"
   @ 07,02 SAY "Cedula :            :"
   @ 08,02 SAY "Plan de Afiliacion  :"
   @ 09,02 SAY "Ingreso             :"
   @ 10,02 SAY "Egreso              :"
   @ 11,02 SAY "Valido Desde        :"
   @ 12,02 SAY "Valido Hasta        :"
   @ 13,02 SAY "Monto Afiliacion    :"
   @ 14,02 SAY "Responsable del Pago:"
   @ 15,02 SAY "Nivel socioeconomico:"
   @ 16,02 SAY "Contrato            :"
   @ 07,10 GET WCEDTITU
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
   @ 07,25 SAY RTRIM(PAPELLIDO)+" "+RTRIM(SAPELLIDO)+", "+;
               RTRIM(PNOMBRE)+" "+RTRIM(SNOMBRE)
   SCAT MEMVAR
   @ 08,25 GET M.PLAN               VALID VALPLA()
   @ 09,25 GET M.INGCON             VALID VALING()
   @ 10,25 GET M.EGRCON
   @ 11,25 GET M.VALDES             VALID VALDES()
   @ 12,25 GET M.VALHAS             VALID VALHAS()
   @ 13,25 GET M.MONCON
   @ 14,25 GET M.RESPAG             VALID VALPAG()
   @ 15,25 GET M.NIVEL              VALID VALNIV()
   @ 16,25 SAY M.CONTRATO        
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
         if contrato=space(10)
            *** Generar numero de contrato desde afidata
            select afidata
            if recloc()
               replace contrato with contrato+1
               unlock all
               select afititu
               replace contrato with alltrim(str(afidata.contrato,10))
               unlock all
            endif
         endif
         *****
         select afiafi
         seek afititu.cedtitu
         do while .not. eof() .and. afiafi.cedtitu=afititu.cedtitu
            if recloc()
               replace nivel with afititu.nivel
               unlock
            endif
            skip
         enddo
         select afititu
         unlock all
      endif
   endif
enddo
return
***
*** FUNCIONES
***
func valpla
select afiplang
do while .t.
   if m.plan<>space(4)
      seek m.plan
      if found()
         @ 08,30 say afiplang.descri
         exit
      endif
   endif
   store 05 to librpla
   store 20 to cibrpla
   DEFI WIND BRPLANG FROM LIBRPLA,CIBRPLA TO LIBRPLA+10,CIBRPLA+33 ;
                     TITLE " PLANES DE AFILIACION " ;
                     FOOTER " ESC = Seleccionar ";
                     DOUBLE NOZOOM NOGROW COLOR SCHEME 10
   ACTI WIND BRPLANG
   BROWSE FIELDS PLAN:H="PLAN", DESCRI:H="DESCRIPCION";
                 NOAPPEND NODELETE NOEDIT NOMENU NOOPTIMIZE NOCLEAR;
                 REST SAVE IN WINDOW BRPLANG
   RELE WIND BRPLANG
   store afiplang.plan to m.plan
enddo
return .T.
************
func valing
do while .t.
   if m.ingcon<>ctod("  -  -    ")
      return .t.
   else
      return .f.
   endif
enddo
***********
func valdes
do while .t.
   if m.valdes<>ctod("  -  -    ").and.m.valdes>=m.ingcon
      return .t.
   else
      return .f.
   endif
enddo
***********
func valhas
do while .t.
   if m.valhas<>ctod("  -  -    ").and.m.valhas>=m.valdes
      return .t.
   else
      return .f.
   endif
enddo
return .t.
***********
func valpag
do while .t.
   if m.respag="T".or.m.respag="E"
      exit
   endif
   defi wind winpag  from 15,25 to 18,41
   acti wind winpag
   @ 00,00 clear
   if afititu.respag="T"
      store 1 to wvalop
   else
      store 2 to wvalop
   endif
   do while .t.
      @ 00,01 get wvalop pict "@*V  Titular ; Empresa" defa wvalop
      read
      if lastkey()=13
         exit
      endif
   enddo
   if wvalop=1
      store "T" to m.respag
   else
      store "E" to m.respag
   endif
   rele wind winpag
enddo
return .t.
***********
func valniv
do while .t.
   if m.nivel="A".or.m.nivel="B".or.m.nivel="C".or.m.nivel="D".or.m.nivel="E"
      exit
   endif
   defi wind winniv  from 17,25 to 23,31
   acti wind winniv
   @ 00,00 clear
   store m.nivel to wvalop
   do while .t.
      @ 00,01 get wvalop pict "@*V  A;B;C;D;E" defa wvalop
      read
      if lastkey()=13
         exit
      endif
   enddo
   store wvalop to m.nivel
   rele wind winniv
enddo
return .t.
************
