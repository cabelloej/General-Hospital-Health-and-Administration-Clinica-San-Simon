STORE .T. TO ACT
DO WHILE ACT
   DO INVFIC1
   @ 4,20 SAY  "F I C H A    D E      A R T I C U L O S"
   DO INVFIC2
   STORE SPACE(20) TO WCODIGO
   STORE "INDIQUE EL CODIGO DESEADO, <ENTER> o <ESC> PARA SALIR" to mes
   do mensaje with mes
   @ 08,1 get wcodigo
   read
   IF LASTKEY()=27
      RETURN
   ENDIF
   store upper(wcodigo) to wcodigo
   IF WCODIGO=SPACE(20)
      SAVE SCRE TO QWS1
      STORE 08 TO LIBRART
      STORE 00 TO CIBRART
      DO MEDCONVA
      SET ORDER TO ALMART
      STORE CODIGO TO WCODIGO
      RESTORE SCRE FROM QWS1
      @ 08,01 SAY WCODIGO
   ENDIF
   SELECT ALMART
   find &wcodigo
   if eof()
      store "CODIGO DE ARTICULO NO REGISTRADO, INGRESAR (S/N)" to TEX
      STORE "SN" TO WCH
      DO PREGUNTA
      STORE WCH TO CONDICION
      if condicion = "N"
         loop
      endif
      store space(40) to wdescri
      store space(40) to wdescri2
      store space(40) to wdescri3
      store space(40) to wdescri4
      store space(5)  to wunimed
      store space(10) to wMARCA
      STORE SPACE(10) TO WMODELO
      store space(4)  to WPRESUND
      store 0         to WPRESCAP
      store space(11) to wubicacion
      STORE SPACE(3)  TO WLINEA
      *STORE WUSERUBI TO WALM
      STORE 0         TO WPRECIOA
      STORE 0         TO WPRECIOB
      STORE 0         TO WPRECIOC
      STORE 0         TO WPRECIOD
      STORE 0         TO WPRECIOE
      store 0         to wminimo
      store 0         to wmaximo
      STORE "S"       TO WVAC
      STORE "S"       TO WLOTE
      STORE 0         TO WLOTEVEN

      *** datos vademecum
      STORE SPACE(35) TO WNOMBREGEN
      STORE SPACE(35) TO WLABORATOR
      STORE SPACE(10) TO WCONCENTRA
      STORE SPACE(10) TO WCONTENIDO
      STORE SPACE(10) TO WPRESENTAC
      STORE SPACE(60) TO WINDICACI1
      STORE SPACE(60) TO WINDICACI2
      STORE SPACE(60) TO WPOSOLOGI1
      STORE SPACE(60) TO WPOSOLOGI2
      STORE SPACE(60) TO WTIPIFICAC
      ***
      save scre to wejc1
      @ 07,26 clear to 12,67
      @ 07,26 to 12,67
      store "DESCRIPCION DEL ARTICULO" TO MES
      do mensaje with mes
      @ 08,27 get wdescri
      @ 09,27 get wdescri2
      @ 10,27 get wdescri3
      @ 11,27 get wdescri4
      read
      restore scre from wejc1
      @ 08,27 SAY wdescri
      @ 08,68 get wMARCA
      store "MARCA DEL ARTICULO" TO MES
      do mensaje with mes
      READ
      @ 12,01 get wunimed
      store "UNIDAD DE MEDIDA DE DESPACHO DEL ARTICULO" TO MES
      do mensaje with mes
      READ
      @ 12,14 get WPRESUND
      store "UNIDAD DE MEDIDA DE COMPRAS DEL ARTICULO" TO MES
      do mensaje with mes
      READ
      @ 12,19 get WPRESCAP PICTURE "9999.99"
      store "CANTIDAD DE UNIDADES DE DESPACHO POR CADA UNIDAD DE COMPRA" TO MES
      do mensaje with mes
      READ
      @ 12,29 get wminimo picture "#######.##"
      store "CANTIDAD DE UNIDADES DE DESPACHO ESTIMADAS" TO MES
      do mensaje with mes
      READ
      @ 12,42 get wmaximo picture "#######.##"
      store "CANTIDAD DE UNIDADES DE DESPACHO ESTIMADAS" TO MES
      do mensaje with mes
      READ
      @ 12,53 get wubicacion
      store "LOCALIZACION DEL ARTICULO EN ALMACEN. EJM. F01:E05:P10" TO MES
      do mensaje with mes
      READ
      *@ 12,68 SAY WALM
      @ 12,72 GET WLINEA
      store "CODIGO DE CLASIFICACION DEL ARTICULO" TO MES
      do mensaje with mes
      READ
      @ 16,6 GET WVAC
      store "INDIQUE SI o NO PARA MANEJO DE VADEMECUM PARA EL ARTICULO" TO MES
      do mensaje with mes
      READ
      STORE UPPER(WVAC) TO WVAC
      IF WVAC="S"
         DO GETVAC
      ENDIF
     * @ 16,06 GET WLOTE
     * store "INDIQUE SI o NO PARA MANEJO DE LOTES EN ARTICULOS PERECEDEROS" TO MES
     * do mensaje with mes
     * READ
     * @ 16,9 GET WLOTEVEN PICTURE "####"
     * store "VIDA UTIL EN DIAS PARA LOTES" TO MES
     * do mensaje with mes
     * READ

      save scre to wejc1
      @ 15,13 clear to 21,26
      @ 15,13 TO 21,26
      store "LISTA DE PRECIOS" TO MES
      do mensaje with mes
      @ 16,14 get wprecioa        picture "9,999,999.99"
      @ 17,14 get wpreciob        picture "9,999,999.99"
      @ 18,14 get wprecioc        picture "9,999,999.99"
      @ 19,14 get wpreciod        picture "9,999,999.99"
      @ 20,14 get wprecioe        picture "9,999,999.99"
      read
      restore scre from wejc1
      @ 16,14 SAY wprecioa

      IF WLINEA <> SPACE(3)
         SELECT ALMLIN
         FIND &WLINEA
         IF EOF()
            STORE "LINEA DEL ARTICULO NO DEFINIDA, FAVOR INGRESAR." TO MES
            DO AVISO WITH MES
            STORE SPACE(3) TO WLINEA
         ENDIF
         SELECT ALMART
      ENDIF
      STORE "CONFORME? (S/N)" TO TEX
      STORE "SN" TO WCH
      DO PREGUNTA
      STORE WCH TO RESP
      if resp = "S" .AND. FILLOC()
         append blank
         replace codigo    with wcodigo
         replace descri    with wdescri
         replace descri2   with wdescri2
         replace descri3   with wdescri3
         replace descri4   with wdescri4
         replace MARCA     with wMARCA
         replace MODELO    with wMODELO
         replace presund   with wpresund
         replace prescap   with wprescap
         replace ubicacion with wubicacion
         REPLACE LINEA     WITH WLINEA
         REPLACE ALMACEN   WITH WUSERUBI
         REPLACE PRECIOA   WITH WPRECIOA
         REPLACE PRECIOB   WITH WPRECIOB
         REPLACE PRECIOC   WITH WPRECIOC
         REPLACE PRECIOD   WITH WPRECIOD
         REPLACE PRECIOE   WITH WPRECIOE
         replace unimed    with wunimed
         replace minimo    with wminimo
         replace maximo    with wmaximo
         REPLACE VADEMECUM WITH WVAC
         REPLACE LOTE      WITH WLOTE
         REPLACE LOTEVEN   WITH WLOTEVEN
         REPLACE ORIGEN    WITH "INV"
         REPLACE USUARIO   WITH WUSERCODE
         REPLACE USUARIOF  WITH DATE()
         *** datos vademecum
         replace NOMBREGEN WITH WNOMBREGEN
         replace LABORATOR WITH WLABORATOR
         replace CONCENTRA WITH WCONCENTRA
         replace CONTENIDO WITH WCONTENIDO
         replace PRESENTAC WITH WPRESENTAC
         replace INDICACI1 WITH WINDICACI1
         replace INDICACI2 WITH WINDICACI2
         replace POSOLOGI1 WITH WPOSOLOGI1
         replace POSOLOGI2 WITH WPOSOLOGI2
         replace TIPIFICAC WITH WTIPIFICAC
         UNLOCK ALL
         FLUSH
      endif
   else
      @ 08,27 say descri
      @ 08,68 say MARCA
      @ 12,01 say unimed
      @ 12,14 say PRESUND
      @ 12,19 say PRESCAP PICTURE "9999.99"
      @ 12,29 say minimo picture "#######.##"
      @ 12,42 say maximo picture "#######.##"
      @ 12,53 say ubicacion
      *@ 12,68 SAY ALMACEN
      @ 12,72 SAY LINEA
      @ 16,06 SAY VADEMECUM
      *@ 16,06 SAY LOTE
      *@ 16,9  SAY LOTEVEN PICTURE "####"
      @ 16,14 SAY PRECIOA PICTURE "9,999,999.99"
      @ 16,27 SAY UNIAPE     PICTURE "#######.##"
      @ 16,40 SAY COSAPE     PICTURE "#######.##"
      @ 16,53 SAY UNIEXI     PICTURE "#######.##"
      @ 16,68 SAY COSEXI     PICTURE "#######.##"
      @ 20,01 SAY ULTCOMPRA
      @ 20,14 SAY SUBSTR(ULTREFEREN,1,12)
      @ 20,27 SAY SUBSTR(ULTPROVE,1,12)
      @ 20,42 SAY ULTCANTI          PICTURE "#######.##"
      @ 20,55 SAY ULTCOSTO          PICTURE "#########.##"
      IF ULTCANTI>0
         STORE ULTCOSTO/ULTCANTI TO WULTCOSUND
      ELSE
         STORE 0                 TO WULTCOSUND
      ENDIF
      @ 20,68 SAY WULTCOSUND PICTURE "########.##"
      store descri to wdescri
      store descri2 to wdescri2
      store descri3 to wdescri3
      store descri4 to wdescri4
      store unimed to wunimed
      store MARCA to wMARCA
      store MODELO  to wMODELO
      store presund to wpresund
      store prescap to wprescap
      store minimo to wminimo
      store maximo to wmaximo
      store ubicacion to wubicacion
      STORE LINEA TO WLINEA
      STORE ALMACEN TO WALM
      STORE PRECIOA TO WPRECIOA
      STORE PRECIOB TO WPRECIOB
      STORE PRECIOC TO WPRECIOC
      STORE PRECIOD TO WPRECIOD
      STORE PRECIOE TO WPRECIOE
      STORE VADEMECUM TO WVAC
      STORE LOTE TO WLOTE
      STORE LOTEVEN TO WLOTEVEN
      *** DATOS VADEMECUM
      STORE LABORATOR TO WLABORATOR
      STORE NOMBREGEN TO WNOMBREGEN
      STORE CONCENTRA TO WCONCENTRA
      STORE CONTENIDO TO WCONTENIDO
      STORE PRESENTAC TO WPRESENTAC
      STORE INDICACI1 TO WINDICACI1
      STORE INDICACI2 TO WINDICACI2
      STORE POSOLOGI1 TO WPOSOLOGI1
      STORE POSOLOGI2 TO WPOSOLOGI2
      STORE TIPIFICAC TO WTIPIFICAC
      store "OPCIONES: (M)ODIFICAR, (E)LIMINAR, (S)ALIR" to TEX
      IF ALMACEN=WUSERUBI
         STORE "SME" TO WCH
      ELSE
         STORE "S"   TO WCH
      ENDIF
      DO PREGUNTA
      STORE WCH TO CONDICION
      if condicion = "S"
         loop
      endif
      if condicion = "M"
         save scre to wejc1
         @ 07,26 clear to 12,67
         @ 07,26 to 12,67
         store "DESCRIPCION DEL ARTICULO" TO MES
         do mensaje with mes
         @ 08,27 get wdescri
         @ 09,27 get wdescri2
         @ 10,27 get wdescri3
         @ 11,27 get wdescri4
         read
         restore scre from wejc1
         @ 08,27 SAY wdescri
         @ 08,68 get wMARCA
         store "MARCA DEL ARTICULO" TO MES
         do mensaje with mes
         READ
         @ 12,01 get wunimed
         store "UNIDAD DE MEDIDA DE DESPACHO DEL ARTICULO" TO MES
         do mensaje with mes
         READ
         @ 12,14 get WPRESUND
         store "UNIDAD DE MEDIDA DE COMPRAS DEL ARTICULO" TO MES
         do mensaje with mes
         READ
         @ 12,19 get WPRESCAP PICTURE "9999.99"
         store "CANTIDAD DE UNIDADES DE DESPACHO POR CADA UNIDAD DE COMPRA" TO MES
         do mensaje with mes
         READ
         @ 12,29 get wminimo picture "#######.##"
         store "CANTIDAD DE UNIDADES DE DESPACHO ESTIMADAS" TO MES
         do mensaje with mes
         READ
         @ 12,42 get wmaximo picture "#######.##"
         store "CANTIDAD DE UNIDADES DE DESPACHO ESTIMADAS" TO MES
         do mensaje with mes
         READ
         @ 12,53 get wubicacion
         store "LOCALIZACION DEL ARTICULO EN ALMACEN. EJM. F01:E05:P10" TO MES
         do mensaje with mes
         READ
         *@ 12,68 SAY WALM
         @ 12,72 GET WLINEA
         store "CODIGO DE CLASIFICACION DEL ARTICULO" TO MES
         do mensaje with mes
         READ
         @ 16,6 GET WVAC
         store "INDIQUE SI o NO PARA MANEJO DE VADEMECUM PARA EL ARTICULO" TO MES
         do mensaje with mes
         READ
         STORE UPPER(WVAC) TO WVAC
         IF WVAC="S"
            DO GETVAC
         ENDIF
         *@ 16,06 GET WLOTE
         *store "INDIQUE SI o NO PARA MANEJO DE LOTES EN ARTICULOS PERECEDEROS" TO MES
         *do mensaje with mes
         *READ
         *@ 16,9 GET WLOTEVEN PICTURE "####"
         *store "VIDA UTIL EN DIAS PARA LOTES" TO MES
         *do mensaje with mes
         *READ

         save scre to wejc1
         @ 15,13 clear to 21,26
         @ 15,13 TO 21,26
         store "LISTA DE PRECIOS" TO MES
         do mensaje with mes
         @ 16,14 get wprecioa        picture "9,999,999.99"
         @ 17,14 get wpreciob        picture "9,999,999.99"
         @ 18,14 get wprecioc        picture "9,999,999.99"
         @ 19,14 get wpreciod        picture "9,999,999.99"
         @ 20,14 get wprecioe        picture "9,999,999.99"
         read
         restore scre from wejc1
         @ 16,14 SAY wprecioa

         STORE "CONFORME? (S/N)" TO TEX
         STORE "SN" TO WCH
         DO PREGUNTA
         STORE WCH TO RESP
         if resp = "S" .AND. RECLOC()
            replace codigo with wcodigo
            replace descri with wdescri
            replace descri2 with wdescri2
            replace descri3 with wdescri3
            replace descri4 with wdescri4
            replace MARCA with wMARCA
            replace MODELO  with wMODELO
            replace presund with wpresund
            replace prescap with wprescap
            replace unimed with wunimed
            replace minimo with wminimo
            replace maximo with wmaximo
            replace ubicacion with wubicacion
            *REPLACE ALMACEN WITH WALM
            REPLACE PRECIOA  WITH WPRECIOA
            REPLACE PRECIOB  WITH WPRECIOB
            REPLACE PRECIOC  WITH WPRECIOC
            REPLACE PRECIOD  WITH WPRECIOD
            REPLACE PRECIOE  WITH WPRECIOE
            REPLACE LINEA WITH WLINEA
            REPLACE VADEMECUM  WITH WVAC
            REPLACE LOTE WITH WLOTE
            REPLACE LOTEVEN WITH WLOTEVEN
            REPLACE USUARIO   WITH WUSERCODE
            REPLACE USUARIOF  WITH DATE()
            *** datos vademecum
            replace NOMBREGEN WITH WNOMBREGEN
            replace LABORATOR WITH WLABORATOR
            replace CONCENTRA WITH WCONCENTRA
            replace CONTENIDO WITH WCONTENIDO
            replace PRESENTAC WITH WPRESENTAC
            replace INDICACI1 WITH WINDICACI1
            replace INDICACI2 WITH WINDICACI2
            replace POSOLOGI1 WITH WPOSOLOGI1
            replace POSOLOGI2 WITH WPOSOLOGI2
            replace TIPIFICAC WITH WTIPIFICAC
            UNLOCK ALL
            FLUSH
         endif
      endif
      *** OJO NO SE PUEDEN BORRAN ARTICULOS CON COSTO O EXISTENCIA MAYOR 0
       if CONDICION = "E"
          IF UNIEXI > 0 .OR. COSEXI > 0
             STORE "ESTE ARTICULO TIENE EXISTENCIA/COSTO, OPERACION RECHAZADA (Ù)" TO MES
             DO AVISO WITH MES
             LOOP
          ELSE
            store "SOLO DEBE ELIMINAR ARTICULOS CON TRANSACCIONES EN 0. ESTA SEGURO? (S/N)" to TEX
            STORE "NS" TO WCH
            DO PREGUNTA
            STORE WCH TO RESP
            if resp = "S"
                store "ELIMINANDO,  FAVOR ESPERAR..." to mes
                do mensaje with mes
                IF FILLOC()
                   delete
                   UNLOCK ALL
                   FLUSH
                   select ALMTRA
                   IF FILLOC()
                      delete all for codigo = wcodigo
                      UNLOCK ALL
                      FLUSH
                   ENDIF
                   select ALMART
                ENDIF
            endif
         ENDIF
       endif
   endif
enddo
***********
PROC GETVAC
***********
SAVE SCRE TO SCREVAC
@ 09,00 CLEAR TO 20,79
@ 09,00       TO 20,79
@ 09,33 SAY "< VADEMECUM >"
@ 10,01 SAY "Nombre gener.:" get wnombregen
@ 11,01 SAY "Laboratorio  :" get wlaborator
@ 12,01 SAY "Tipificacion :" get wtipificac
@ 13,01 SAY "Posologia    :" get wposologi1
@ 14,01 SAY "             :" get wposologi2
@ 15,01 SAY "Presentacion :" get wpresentac
@ 16,01 SAY "Concentracion:" get wconcentra
@ 17,01 SAY "Contenido    :" get wcontenido
@ 18,01 SAY "Indicaciones :" get windicaci1
@ 19,01 SAY "             :" get windicaci2
read
RESTORE SCRE FROM SCREVAC
RETURN

