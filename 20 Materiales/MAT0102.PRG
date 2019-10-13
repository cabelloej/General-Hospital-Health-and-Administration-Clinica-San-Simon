STORE .T. TO ACT
DO WHILE ACT
   DO INVFIC1
   @ 4,20 SAY  "F I C H A    D E      M A T E R I A L E S"
   DO INVFIC2
   STORE SPACE(20) TO WCODIGO
   STORE "INDIQUE EL CODIGO DESEADO, <ENTER> o <ESC> PARA SALIR" to mes
   do mensaje with mes
   @ 08,1 get wcodigo
   read
   IF READKEY() = 12 .OR READKEY() = 268
      RETURN
   ENDIF
   store upper(wcodigo) to wcodigo
   IF WCODIGO=SPACE(20)
      SAVE SCRE TO QWS1
      STORE 08 TO LIBRART
      STORE 00 TO CIBRART
      DO MATWINAR
      STORE CODIGO TO WCODIGO
      RESTORE SCRE FROM QWS1
      @ 08,01 SAY WCODIGO
   ENDIF
   SELECT MATART
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
      store 0         to wminimo
      store 0         to wmaximo
      store "INGRESE LA INFORMACION SOLICITADA" TO MES
      do mensaje with mes
      save scre to wejc1
      @ 07,26 clear to 12,67
      @ 07,26 to 12,67
      @ 08,27 get wdescri
      @ 09,27 get wdescri2
      @ 10,27 get wdescri3
      @ 11,27 get wdescri4
      read
      restore scre from wejc1
      @ 08,27 SAY wdescri
      @ 08,68 get WUNIMED
      STORE "UNIDAD DE DESPACHO DEL MATERIAL" TO MES
      DO MENSAJE WITH MES
      READ
      @ 12,01 get WPRESUND
      STORE "UNIDAD DE COMPRAS DEL MATERIAL" TO MES
      DO MENSAJE WITH MES
      READ
      @ 12,14 get WPRESCAP PICTURE "9999.99"
      STORE "CANTIDAD DE UNIDADES DE DESPACHO QUE VIENEN EN CADA UNIDAD DE COMPRA" TO MES
      DO MENSAJE WITH MES
      READ
      @ 12,29 get wminimo picture "#######.##"
      STORE "EXISTENCIA MINIMA EN UNIDADES DE DESPACHO QUE DEBE EXISTIR EN INVENTARIO" TO MES
      DO MENSAJE WITH MES
      READ
      @ 12,42 get wmaximo picture "#######.##"
      STORE "EXISTENCIA MAXIMA EN UNIDADES DE DESPACHO QUE DEBE EXISTIR EN INVENTARIO" TO MES
      DO MENSAJE WITH MES
      READ
      @ 12,53 get wubicacion
      STORE "UBICACION FISICA EN ALMACEN PARA ESTE ARTICULO" TO MES
      DO MENSAJE WITH MES
      READ
      @ 12,68 GET WLINEA
      STORE "LINEA A LA CUAL PERTENECE EL ARTICULO" TO MES
      DO MENSAJE WITH MES
      READ
      @ 16,01 GET WMARCA
      STORE "MARCA DEL ARTICULO" TO MES
      DO MENSAJE WITH MES
      READ
      @ 16,14 GET WMODELO
      STORE "MODELO DEL ARTICULO" TO MES
      DO MENSAJE WITH MES
      READ
      read
      IF WLINEA <> SPACE(3)
         SELECT MATLIN
         FIND &WLINEA
         IF EOF()
            STORE "LINEA DEL ARTICULO NO DEFINIDA, FAVOR INGRESAR." TO MES
            DO AVISO WITH MES
            STORE SPACE(3) TO WLINEA
         ENDIF
         SELECT MATART
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
         replace unimed    with wunimed
         replace minimo    with wminimo
         replace maximo    with wmaximo
         REPLACE LOTE      WITH "N"
         REPLACE LOTEVEN   WITH 0
         REPLACE ORIGEN    WITH "INV"
         REPLACE USUARIO   WITH WUSERCODE
         REPLACE USUARIOF  WITH DATE()
         UNLOCK ALL
         FLUSH
      endif
   else
      @ 08,27 say DESCRI
      @ 08,68 say UNIMED
      @ 12,01 say PRESUND
      @ 12,14 say PRESCAP PICTURE "9999.99"
      @ 12,29 say minimo picture "#######.##"
      @ 12,42 say maximo picture "#######.##"
      @ 12,53 say ubicacion
      @ 12,68 SAY LINEA
      @ 16,01 SAY MARCA
      @ 16,14 SAY MODELO
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
      store "OPCIONES: (M)ODIFICAR, (E)LIMINAR, (S)ALIR" to TEX
      STORE "SME" TO WCH
      DO PREGUNTA
      STORE WCH TO CONDICION
      if condicion = "S"
         loop
      endif
      if condicion = "M"
         save scre to wejc1
         @ 07,26 clear to 12,67
         @ 07,26 to 12,67
         @ 08,27 get wdescri
         @ 09,27 get wdescri2
         @ 10,27 get wdescri3
         @ 11,27 get wdescri4
         read
         restore scre from wejc1
         @ 08,68 get WUNIMED
         READ
         STORE "UNIDAD DE DESPACHO DEL MATERIAL" TO MES
         DO MENSAJE WITH MES
         @ 12,01 get WPRESUND
         READ
         STORE "UNIDAD DE COMPRAS DEL MATERIAL" TO MES
         DO MENSAJE WITH MES
         @ 12,14 get WPRESCAP PICTURE "9999.99"
         READ
         STORE "CANTIDAD DE UNIDADES DE DESPACHO QUE VIENEN EN CADA UNIDAD DE COMPRA" TO MES
         DO MENSAJE WITH MES
         @ 12,29 get wminimo picture "#######.##"
         READ
         STORE "EXISTENCIA MINIMA EN UNIDADES DE DESPACHO QUE DEBE EXISTIR EN INVENTARIO" TO MES
         DO MENSAJE WITH MES
         @ 12,42 get wmaximo picture "#######.##"
         READ
         STORE "EXISTENCIA MAXIMA EN UNIDADES DE DESPACHO QUE DEBE EXISTIR EN INVENTARIO" TO MES
         DO MENSAJE WITH MES
         @ 12,53 get wubicacion
         STORE "UBICACION FISICA EN ALMACEN PARA ESTE ARTICULO" TO MES
         DO MENSAJE WITH MES
         READ
         @ 12,68 GET WLINEA
         READ
         STORE "LINEA A LA CUAL PERTENECE EL ARTICULO" TO MES
         DO MENSAJE WITH MES
         @ 16,01 GET WMARCA
         READ
         STORE "MARCA DEL ARTICULO" TO MES
         DO MENSAJE WITH MES
         @ 16,14 GET WMODELO
         READ
         STORE "MODELO DEL ARTICULO" TO MES
         DO MENSAJE WITH MES
         read
         IF WLINEA <> SPACE(3)
            SELECT MATLIN
            FIND &WLINEA
            IF EOF()
               STORE "LINEA DEL ARTICULO NO DEFINIDA, FAVOR INGRESAR." TO MES
               DO AVISO WITH MES
               STORE SPACE(3) TO WLINEA
            ENDIF
            SELECT MATART
         ENDIF
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
            REPLACE LINEA WITH WLINEA
            REPLACE USUARIO   WITH WUSERCODE
            REPLACE USUARIOF  WITH DATE()
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
                   select MATTRA
                   IF FILLOC()
                      delete all for codigo = wcodigo
                      UNLOCK ALL
                      FLUSH
                   ENDIF
                   select MATART
                ENDIF
            endif
         ENDIF
       endif
   endif
enddo

