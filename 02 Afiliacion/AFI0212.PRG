do while .t.
   @ 01,00 CLEAR
   @ 01,00 to 24,79
   @ 01,01 SAY "< ASPECTOS FAMILIARES >"
   @ 02,02 SAY "TITULAR   :                                     "
   @ 03,02 SAY "VIVIENDA  :                      SERVICIOS (S/N)"
   @ 04,02 SAY "TENENCIA  :                      - Electricidad:"
   @ 05,02 SAY "TERRENO   :                      - Agua        :"
   @ 06,02 SAY "C.SANITARIA                      - Aseo Urbano :"
   @ 07,02 SAY "- Techo   :                      - Cloacas     :"
   @ 08,02 SAY "- Paredes :                      - Letrina     :"
   @ 09,02 SAY "- Piso de :                      - Pozo Septico:"
   @ 10,02 SAY "- No.Ambi.:                      - Gas(Bom,Dir):"
   @ 11,02 SAY "- No.Dorm.:                      - No. W.C.    :"
   @ 12,02 SAY "- No.Camas:                      EQUIPOS (S/N)  "
   @ 13,02 SAY "- No.Ba¤os:                      - Nevera      :"
   @ 14,02 SAY "- Ventilac:                      - Cocina      :"
   @ 15,02 SAY "- Iluminac:                      - Lavadora    :"
   @ 16,02 SAY "- Aseo    :                      - Televisor   :"
   @ 17,02 SAY "- Orden   :                      - Radio       :"
   @ 18,02 SAY "- Hacinam?:                      - Maq.cos     :"
   @ 19,02 SAY "- Promisc?:                      - Otros       :"
   @ 20,02 SAY "OBSERVACIONES:"

   @ 02,15 GET WCEDTITU
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
   @ 02,30 SAY RTRIM(PAPELLIDO)+" "+RTRIM(SAPELLIDO)+", "+;
               RTRIM(PNOMBRE)+" "+RTRIM(SNOMBRE)
   SCAT MEMVAR

   @ 03,15 GET m.vivienda valid valviv()
   @ 04,15 GET m.tenencia valid valten()
   @ 05,15 GET m.terreno  valid valter()
   @ 07,15 GET m.techo
   @ 08,15 GET m.pared
   @ 09,15 GET m.piso
   @ 10,15 GET m.ambiente
   @ 11,15 GET m.dormitorio
   @ 12,15 GET m.cama
   @ 13,15 GET m.bano
   @ 14,15 GET m.ventila     valid valven()
   @ 15,15 GET m.ilumina     valid valilu()
   @ 16,15 GET m.aseo        valid valase()
   @ 17,15 GET m.orden       valid valord()
   @ 18,15 GET m.hacinami    valid valhac()
   @ 19,15 GET m.promiscu    valid valpro()

   @ 04,52 GET m.electrici
   @ 05,52 GET m.agua
   @ 06,52 GET m.aseo_urb
   @ 07,52 GET m.cloacas
   @ 08,52 GET m.letrina
   @ 09,52 GET m.pozo
   @ 10,52 GET m.gas
   @ 11,52 GET m.wc
   @ 13,52 GET m.nevera
   @ 14,52 GET m.cocina
   @ 15,52 GET m.lavadora
   @ 16,52 GET m.televisor
   @ 17,52 GET m.radio
   @ 18,52 GET m.maquina
   @ 19,52 GET m.otros_equi
   @ 21,02 GET m.observa1
   @ 22,02 GET m.observa2
   @ 23,02 GET m.observa3
   READ

   @ 03,01 clear to 23,78
   @ 04,02 SAY "INGRESO FAMILIAR MENSUAL         EGRESO FAMILIAR MENSUAL"
   @ 05,02 SAY "NOMINAL                          - Vivienda    :"
   @ 06,02 SAY "-Suel y/o Sal.:                  - Alimentos   :"
   @ 07,02 SAY "-Becas/Subsid.:                  - Serv.Public.:"
   @ 08,02 SAY "-Jubil/Pension:                  - Transporte  :"
   @ 09,02 SAY "-Otros        :                  - Educacion   :"
   @ 10,02 SAY "         TOTAL:                  - Prestamos   :"
   @ 11,02 SAY "REAL          :                  - Ayudas      :"
   @ 12,02 SAY "                                 - Ahorros.    :"
   @ 13,02 SAY "                                 - Salud        "
   @ 14,02 SAY "                                 - Otros       :"
   @ 15,02 SAY "                                          TOTAL:"
   @ 16,02 SAY "PUNTUACION    :                                 "
   @ 17,02 SAY "ESTRATO       :                                 "

   @ 06,18 GET m.ing_sue
   @ 07,18 GET m.ing_bec
   @ 08,18 GET m.ing_jub
   @ 09,18 GET m.ing_otr
   @ 10,19 SAY m.ing_sue+m.ing_bec+m.ing_jub+m.ing_otr  PICT "999999999.99"
   @ 11,18 GET m.ing_real
   @ 05,53 GET m.egr_viv
   @ 06,53 GET m.egr_ali
   @ 07,53 GET m.egr_ser
   @ 08,53 GET m.egr_tra
   @ 09,53 GET m.egr_edu
   @ 10,53 GET m.egr_pre
   @ 11,53 GET m.egr_ayu
   @ 12,53 GET m.egr_aho
   @ 13,53 GET m.egr_sal
   @ 14,53 GET m.egr_otr
   @ 15,54 SAY m.egr_viv+m.egr_ali+m.egr_ser+m.egr_tra+m.egr_edu+m.egr_pre+;
               m.egr_ayu+m.egr_aho+m.egr_sal+m.egr_otr PICTURE "999999999.99"
   @ 16,18 GET m.puntuacion
   @ 17,18 GET m.estrato
   READ

   @ 03,01 clear to 23,78
   @ 05,02 SAY "ANALISIS SOCIAL DE LA FAMILIA                   "
   @ 12,02 SAY "TRATAMIENTO SOCIAL DE LA PROBLEMATICA SOCIAL    "
   @ 06,02 GET m.ANALISIS1
   @ 07,02 GET m.ANALISIS2
   @ 08,02 GET m.ANALISIS3
   @ 09,02 GET m.ANALISIS4
   @ 10,02 GET m.ANALISIS5
   @ 13,02 GET m.tratami1
   @ 14,02 GET m.tratami2
   @ 15,02 GET m.tratami3
   @ 16,02 GET m.tratami4
   @ 17,02 GET m.tratami5
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
************
func valviv
************
do while .t.
   if m.vivienda="C".or.m.vivienda="A".or.m.vivienda="R".or.;
      m.vivienda="H".or.m.vivienda="O"
      exit
   endif
   defi wind wintip  from 04,15 to 11,31
   acti wind wintip
   @ 00,00 clear
   store 1 to wvalop
   do while .t.
      @ 00,01 get wvalop pict "@*V  Casa;Apartamento;Rancho;Habitacion;Otros"  defa wvalop
      read
      if lastkey()=13
         exit
      endif
   enddo
   do case
      case wvalop=1
           store "C" to m.vivienda
      case wvalop=2
           store "A" to m.vivienda
      case wvalop=3
           store "R" to m.vivienda
      case wvalop=4
           store "H" to m.vivienda
      case wvalop=5
           store "O" to m.vivienda
   endcase
   rele wind wintip
enddo
return .T.
************
func valten
************
do while .t.
   if m.tenencia="P".or.m.tenencia="A".or.m.tenencia="H".or.;
      m.tenencia="C".or.m.tenencia="O"
      exit
   endif
   defi wind wintip  from 05,15 to 12,35
   acti wind wintip
   @ 00,00 clear
   store 1 to wvalop
   do while .t.
      @ 00,01 get wvalop pict "@*V  Propia;Alquilada;Hipoteca;Opcion compra;Otros"  defa wvalop
      read
      if lastkey()=13
         exit
      endif
   enddo
   do case
      case wvalop=1
           store "P" to m.tenencia
      case wvalop=2
           store "A" to m.tenencia
      case wvalop=3
           store "H" to m.tenencia
      case wvalop=4
           store "C" to m.tenencia
      case wvalop=5
           store "O" to m.tenencia
   endcase
   rele wind wintip
enddo
return .t.
***********
func valter
***********
do while .t.
   if m.terreno="P".or.m.terreno="A".or.m.terreno="H".or.;
      m.terreno="E".or.m.terreno="O"
      exit
   endif
   defi wind wintip  from 06,15 to 13,31
   acti wind wintip
   @ 00,00 clear
   store 1 to wvalop
   do while .t.
      @ 00,01 get wvalop pict "@*V  Propio;Alquilado;Hipotecado;Ejido;Otros"  defa wvalop
      read
      if lastkey()=13
         exit
      endif
   enddo
   do case
      case wvalop=1
           store "P" to m.terreno
      case wvalop=2
           store "A" to m.terreno
      case wvalop=3
           store "H" to m.terreno
      case wvalop=4
           store "E" to m.terreno
      case wvalop=5
           store "O" to m.terreno
   endcase
   rele wind wintip
enddo
return .t.
***********
func valven
***********
do while .t.
   if m.ventila="B".or.m.ventila="R".or.m.ventila="M"
      exit
   endif
   defi wind wintip  from 15,15 to 19,31
   acti wind wintip
   @ 00,00 clear
   store 1 to wvalop
   do while .t.
      @ 00,01 get wvalop pict "@*V  Bueno;Regular;Malo"  defa wvalop
      read
      if lastkey()=13
         exit
      endif
   enddo
   do case
      case wvalop=1
           store "B" to m.ventila
      case wvalop=2
           store "R" to m.ventila
      case wvalop=3
           store "M" to m.ventila
   endcase
   rele wind wintip
enddo
return .t.
***********
func valilu
***********
do while .t.
   if m.ilumina="B".or.m.ilumina="R".or.m.ilumina="M"
      exit
   endif
   defi wind wintip  from 16,15 to 20,31
   acti wind wintip
   @ 00,00 clear
   store 1 to wvalop
   do while .t.
      @ 00,01 get wvalop pict "@*V  Bueno;Regular;Malo"  defa wvalop
      read
      if lastkey()=13
         exit
      endif
   enddo
   do case
      case wvalop=1
           store "B" to m.ilumina
      case wvalop=2
           store "R" to m.ilumina
      case wvalop=3
           store "M" to m.ilumina
   endcase
   rele wind wintip
enddo
return .t.
***********
func valase
***********
do while .t.
   if m.aseo="B".or.m.aseo="R".or.m.aseo="M"
      exit
   endif
   defi wind wintip  from 17,15 to 21,31
   acti wind wintip
   @ 00,00 clear
   store 1 to wvalop
   do while .t.
      @ 00,01 get wvalop pict "@*V  Bueno;Regular;Malo"  defa wvalop
      read
      if lastkey()=13
         exit
      endif
   enddo
   do case
      case wvalop=1
           store "B" to m.aseo
      case wvalop=2
           store "R" to m.aseo
      case wvalop=3
           store "M" to m.aseo
   endcase
   rele wind wintip
enddo
return .t.
***********
func valord
***********
do while .t.
   if m.orden="B".or.m.orden="R".or.m.orden="M"
      exit
   endif
   defi wind wintip  from 18,15 to 22,31
   acti wind wintip
   @ 00,00 clear
   store 1 to wvalop
   do while .t.
      @ 00,01 get wvalop pict "@*V  Bueno;Regular;Malo"  defa wvalop
      read
      if lastkey()=13
         exit
      endif
   enddo
   do case
      case wvalop=1
           store "B" to m.orden
      case wvalop=2
           store "R" to m.orden
      case wvalop=3
           store "M" to m.orden
   endcase
   rele wind wintip
enddo
return .t.
***********
func valhac
***********
do while .t.
   if m.hacinami="S".or.m.hacinami="N"
      return .t.
   else
      return .f.
   endif
enddo
***********
func valpro
***********
do while .t.
   if m.promiscu="S".or.m.promiscu="N"
      return .t.
   else
      return .f.
   endif
enddo

