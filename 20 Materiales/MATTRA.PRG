*** ALMACEN TRANSACCIONES
STORE 100 TO WLINE
STORE .T. TO ACT
STORE "INV" TO WORIGEN
DO WHILE ACT
   STORE WLINE + 1 TO WLINE
   IF WLINE >19
      @ 4,0 CLEAR
      @ 04,0 SAY "FECHA :"
      @ 04,50 SAY "INCLUIR MOVIMIENTO DE ARTICULOS"
      @ 05,0 say "+--------------------+--+------------+----------+-----------+---------------+---"
      @ 06,0 SAY "|NUMERO DEL ARTICULO |TP|DOCUMENTO No| CANTIDAD |COSTO TOTAL|PROVEE./RECEPT.|ORG"
      @ 07,0 SAY "|--------------------|--|------------|----------|-----------|---------------|---"
      @ 08,0 SAY "|                    |  |            |          |           |               |   "
      @ 09,0 SAY "|                    |  |            |          |           |               |   "
      @ 10,0 SAY "|                    |  |            |          |           |               |   "
      @ 11,0 SAY "|                    |  |            |          |           |               |   "
      @ 12,0 SAY "|                    |  |            |          |           |               |   "
      @ 13,0 SAY "|                    |  |            |          |           |               |   "
      @ 14,0 SAY "|                    |  |            |          |           |               |   "
      @ 15,0 SAY "|                    |  |            |          |           |               |   "
      @ 16,0 SAY "|                    |  |            |          |           |               |   "
      @ 17,0 SAY "|                    |  |            |          |           |               |   "
      @ 18,0 SAY "|                    |  |            |          |           |               |   "
      @ 19,0 SAY "|                    |  |            |          |           |               |   "
      @ 20,0 SAY "+--------------------|--|------------|----------|-----------|---------------|---"
      STORE 8 TO WLINE
   ENDIF
   @ WLINE,77 SAY WORIGEN

   STORE "INDIQUE LA FECHA DE LA OPERACION. <ESC>=SALIR" to mes
   DO MENSAJE WITH MES
   STORE DATE() TO WFECHAOP
   @ 04,08 GET wfechaop
   READ
   IF LASTKEY()=27
      RETURN
   ENDIF
   IF WFECHAOP < DATE()
      STORE "ADVERTENCIA LA FECHA DE LA OPERACION ES MENOR A LA FECHA ACTUAL" TO MES
      DO AVISO WITH MES
      STORE .T. TO WFLAGACT
      STORE .T. TO WFLAGART
   ENDIF
   STORE SPACE(20) TO WCODIGO
   @ WLINE,01 get wcodigo
   STORE "INDIQUE EL CODIGO DESEADO. <ENTER>=VER" to mes
   do mensaje with mes
   read
   store upper(wcodigo) to wcodigo
   IF LASTKEY()=27
      LOOP
   ENDIF
   IF WCODIGO=SPACE(20)
      STORE WLINE TO WLASTLINE
      SAVE SCRE TO QWS1
      STORE 08 TO LIBRART
      STORE 00 TO CIBRART
      DO MATWINAR
      STORE CODIGO TO WCODIGO
      RESTORE SCRE FROM QWS1
      STORE WLASTLINE TO WLINE
      @ WLINE,01 SAY WCODIGO
   ENDIF
   SELECT MATART
   find &wcodigo
   if eof()
      store "CODIGO NO REGISTRADO, (Ù)" to mes
      do AVISO WITH MES
      store wline - 1 to wline
      LOOP
   endif
   @ 21,1  say "DESCRIPCION:"+descri
   @ 22,1  say "UNID/MEDIDA:"+unimed
   @ 21,57 say "EXISTENCIA:"+STR(UNIEXI,12,2)
   @ 22,57 say "COSTO PROM:"+STR(COSEXI,12,2)
   STORE .T. TO VERTIP
   DO WHILE VERTIP
      STORE SPACE(2) TO WOPE
      @ 23,0
      @ 23,01 PROMPT "ENTRADA---"
      @ 23,12 PROMPT "DEV.ENT---"
      @ 23,23 PROMPT "SALIDA ---"
      @ 23,34 PROMPT "DEV.SAL---"
      @ 23,45 PROMPT "AJU.ENT---"
      @ 23,56 PROMPT "AJU.SAL---"
      @ 23,67 PROMPT "AJU.COS---"
      MENU TO WOPE
      IF WOPE>=1.AND.WOPE<=7
         STORE .F. TO VERTIP
      ENDIF
      DO CASE
         CASE WOPE=1
              STORE "EN" TO WOPE
         CASE WOPE=2
              STORE "DE" TO WOPE
         CASE WOPE=3
              STORE "SA" TO WOPE
         CASE WOPE=4
              STORE "DS" TO WOPE
         CASE WOPE=5
              STORE "AE" TO WOPE
         CASE WOPE=6
              STORE "AS" TO WOPE
         CASE WOPE=7
              STORE "AC" TO WOPE
         CASE WOPE=0
              RETURN
      ENDCASE
   ENDDO
   @ WLINE,22 SAY WOPE

   STORE SPACE(10) TO WNUMERO
   STORE .T. TO WVERNUMERO
   do while wvernumero
      store "NUMERO DEL DOCUMENTO QUE RESPALDA LA OPERACION" to mes
      do mensaje with mes
      @ WLINE,25 GET Wnumero
      READ
      IF READKEY()=12.OR.READKEY()=268
         RETURN
      ENDIF
      IF WNUMERO = SPACE(10)
         LOOP
      ENDIF
      IF WOPE="DE".OR.WOPE="DS"
         SELECT MATTRA
         SET ORDER TO 3
         STORE WNUMERO+WCODIGO TO WCLAVEREF
         FIND &WCLAVEREF
         IF EOF()
            STORE "DOCUMENTO NO REGISTRADO PARA ESTE ARTICULO, VERIFIQUE" TO MES
            DO AVISO WITH MES
            LOOP
         ELSE
            IF (WOPE="DE".AND.OPERACION<>"EN").OR.(WOPE="DS".AND.OPERACION<>"SA")
               STORE "EL TIPO DE OPERACION DE LA REFERENCIA NO SE AJUSTA CON ESTA OPERACION" TO MES
               DO AVISO WITH MES
               LOOP
            ENDIF
            STORE SERIAL    TO QWSERIAL
            STORE CODIGO    TO QWCODIGO
            STORE FECHA     TO QWFECHA
            STORE OPERACION TO QWOPERA
            STORE ORIGEN    TO QWORIGEN
            STORE PROCLI    TO QWPROCLI
            STORE UNIDADES  TO QWUNIDADES
            STORE COSTO     TO QWCOSTO
            EXIT
         ENDIF
      ELSE
         EXIT
      ENDIF
   ENDDO

   STORE 0.00 TO WUNIDADES
   IF WOPE="DS".OR.WOPE="DE"
      STORE QWUNIDADES TO WUNIDADES
   ENDIF
   STORE .T. TO VERUN
   DO WHILE VERUN
      IF WOPE = "AC"
         STORE .F. TO VERUN
         LOOP
      ENDIF
      STORE "NUMERO DE UNIDADES DE LA OPERACION" to mes
      do mensaje with mes
      @ WLINE,38 GET WUNIDADES PICTURE "#######.##"
      READ
      IF WUNIDADES=0
         STORE "DEBEN EXISTIR UNIDADES EN ESTA OPERACION (Ù)" TO MES
         DO AVISO WITH MES
         LOOP
      ENDIF
      IF WOPE = "SA" .AND. WUNIDADES > MATART->UNIEXI
         STORE "ERROR, EXISTENCIAS NO CUBREN EL MONTO DE LA OPERACION" TO MES
         DO AVISO WITH MES
         LOOP
      ENDIF
      IF (WOPE="DS".OR.WOPE="DE").AND.WUNIDADES>QWUNIDADES
         STORE "ERROR, UNIDADES DE OPERACION EXEDEN UNIDADES DE REFERENCIA ("+RTRIM(STR(QWUNIDADES))+")" TO MES
         DO AVISO WITH MES
         LOOP
      ENDIF
      STORE .F. TO VERUN
   ENDDO

   STORE 0.00 TO WCOSTO
   IF WOPE="EN".OR. WOPE="AC"
      STORE "Costo TOTAL de la operacion" to mes
      do mensaje with mes
      @ WLINE,49 GET WCOSTO PICTURE "########.##"
      READ
      IF WCOSTO = 0
         STORE "DEBE EXISTIR COSTO EN LA OPERACION (Ù)" TO MES
         DO AVISO WITH MES
         LOOP
      ENDIF
   ELSE
      IF WOPE="DS".OR.WOPE="DE"
         STORE (QWCOSTO/QWUNIDADES)*WUNIDADES TO WCOSTO
      ELSE
         IF WOPE = "AE" .OR. WOPE = "AS"
            STORE 0.00 TO WCOSTO
         ELSE
            STORE COSEXI*WUNIDADES TO WCOSTO
         ENDIF
      ENDIF
      @ WLINE,49 SAY WCOSTO PICTURE "########.##"
   ENDIF

   STORE .F.      TO WVERPROCLI
   STORE SPACE(12) TO WPROCLI
   IF WOPE="EN".OR.WOPE="SA"
      STORE .T. TO WVERPROCLI
   ELSE
      IF WOPE="DE".OR.WOPE="DS"
         STORE QWPROCLI TO WPROCLI
         STORE .F. TO WVERPROCLI
         @ WLINE,61 SAY WPROCLI
      ENDIF
   ENDIF
   DO WHILE WVERPROCLI
      @ WLINE,61 GET WPROCLI
      READ
      IF READKEY()=12.OR.READKEY()=268
         RETURN
      ENDIF
      IF WOPE = "EN"
         IF WPROCLI = SPACE(12)
            SAVE SCRE TO QWS1
            STORE 08 TO LIBRPRO
            STORE 00 TO CIBRPRO
            DO MATWINPR
            STORE CODIGO TO WPROCLI
            RESTORE SCRE FROM QWS1
            @ WLINE,61 SAY WPROCLI
         ENDIF
         SELECT BCBENEFI
         FIND &WPROCLI
         IF EOF()
            STORE "PROVEEDOR NO REGISTRADO, VERIFIQUE" TO MES
            DO AVISO WITH MES
            LOOP
         ENDIF
         STORE "CONFIRME "+RTRIM(DESCRI)+" ? (S/N)" TO TEX
         STORE "SN" TO WCH
         DO PREGUNTA
         IF WCH = "N"
            LOOP
         ELSE
            EXIT
         ENDIF
      ENDIF
      IF WOPE = "SA"
         IF WPROCLI = SPACE(12)
            SAVE SCRE TO QWS1
            STORE 08 TO LIBRREC
            STORE 00 TO CIBRREC
            DO MATWINRE
            STORE CODIGO TO WPROCLI
            RESTORE SCRE FROM QWS1
            @ WLINE,61 SAY WPROCLI
         ENDIF
         SELECT SYSPTO
         FIND &WPROCLI
         IF EOF()
            STORE "RECEPTOR NO REGISTRADO, VERIFIQUE" TO MES
            DO AVISO WITH MES
            LOOP
         ENDIF
         STORE "CONFIRME "+RTRIM(DESCRI)+" ? (S/N)" TO TEX
         STORE "SN" TO WCH
         DO PREGUNTA
         IF WCH = "N"
            LOOP
         ELSE
            EXIT
         ENDIF
      ENDIF
   ENDDO

   STORE "CONFORME CON DATOS DEL MOVIMIENTO ? (S/N)" TO TEX
   STORE "SN" TO WCH
   DO PREGUNTA
   STORE WCH TO RESP
   if resp = "N"
      STORE WLINE - 1 TO WLINE
      loop
   endif
   SELECT MATTRA
   IF FILLOC()
      append blank
      REPLACE SERIAL     WITH MATDATA->SERIAL+1
      replace codigo     with wcodigo
      replace fecha      with wfechaop
      replace operacion  with wope
      replace referencia with wnumero
      replace origen     with WORIGEN
      REPLACE UNIDADES   WITH WUNIDADES
      REPLACE COSTO      WITH WCOSTO
      REPLACE PROCLI     WITH WPROCLI
      REPLACE DEPTO      WITH WUSERUBI
      REPLACE USUARIO    WITH WUSERCODE
      REPLACE USUARIOF   WITH DATE()
      UNLOCK ALL
      FLUSH
   ENDIF
   SELECT MATDATA
   IF FILLOC()
      REPLACE SERIAL WITH SERIAL+1
      FLUSH
   ENDIF
   SELECT MATTRA
   IF .NOT. RECLOC()
      LOOP
   ENDIF
   DO CASE
      CASE WOPE = "EN"
           SELECT MATART
           REPLACE COSEXI WITH ((COSEXI*UNIEXI)+(WCOSTO)) / (UNIEXI+WUNIDADES)
           REPLACE UNIEXI WITH UNIEXI + WUNIDADES

           REPLACE ULTCOMPRA    WITH WFECHAOP
           REPLACE ULTCANTI     WITH WUNIDADES
           REPLACE ULTCOSTO     WITH WCOSTO
           REPLACE ULTREFEREN   WITH WNUMERO
           REPLACE ULTPROVE     WITH WPROCLI
           FLUSH
      CASE WOPE = "DS"
           SELECT MATART
           REPLACE COSEXI WITH ((COSEXI*UNIEXI)+(WCOSTO)) / (UNIEXI+WUNIDADES)
           REPLACE UNIEXI WITH UNIEXI + WUNIDADES
      CASE WOPE = "SA"
           SELECT MATART
           REPLACE UNIEXI WITH UNIEXI - WUNIDADES
           FLUSH
      CASE WOPE = "DE"
           SELECT MATART
           REPLACE COSEXI WITH ((COSEXI*UNIEXI)-(WCOSTO)) / (UNIEXI-WUNIDADES)
           REPLACE UNIEXI WITH UNIEXI - WUNIDADES
      CASE WOPE = "AE"
           SELECT MATART
           REPLACE UNIEXI WITH UNIEXI + WUNIDADES
           FLUSH
      CASE WOPE = "AS"
           SELECT MATART
           REPLACE UNIEXI WITH UNIEXI - WUNIDADES
           FLUSH
      CASE WOPE = "AC"
           SELECT MATART
           REPLACE COSEXI WITH ((COSEXI*UNIEXI)+(WCOSTO)) / (UNIEXI)
           FLUSH
   ENDCASE
   UNLOCK ALL
enddo

