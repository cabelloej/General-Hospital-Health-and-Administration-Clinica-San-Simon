              @ 23,10 PROMPT "CANCELAR CTA."
              @ 23,30 PROMPT "ELIMINAR CTA."
              @ 23,50 PROMPT "SALIR        "
              MENU TO W0600
              @ 23,0
              IF W0600 =  2
                 STORE "ESTA USTED SEGURO? (S/N)" TO TEX
                 STORE "NS" TO WCH
                 DO PREGUNTA
                 IF WCH = "S"
                    IF FILLOC()
                       *REPLACE ORIGEN      WITH "CXP"
                       *REPLACE DEPTO       WITH WUSERUBI
                       REPLACE USUARIO     WITH WUSERCODE
                       REPLACE USUARIOF    WITH DATE()
                       DELETE
                       UNLOCK
                       FLUSH
                       SELECT COMCXPTR
                       SET ORDER TO COMCXPT1
                       DO WHILE .T.
                          SEEK COMCXP->CODCXP
                          IF FOUND()
                             IF FILLOC()
                                *REPLACE ORIGEN      WITH "CXP"
                                *REPLACE DEPTO       WITH WUSERUBI
                                REPLACE USUARIO     WITH WUSERCODE
                                REPLACE USUARIOF    WITH DATE()
                                DELETE
                                UNLOCK ALL
                                FLUSH
                             ENDIF
                          ELSE
                             EXIT
                          ENDIF
                       ENDDO
                    ENDIF
                 ENDIF
                 SELECT COMCXP
                 SKIP
                 IF .NOT. EOF()
                    STORE RECNO() TO WINICIO
                    STORE .T. TO FLAGJUMP
                    STORE RECNO() TO WREVERSE
                    STORE RECNO() TO WCLEARREC
                    STORE WLINE   TO WEDILIN
                    STORE WLINE   TO WCLEARLIN
                 ELSE
                    GO TOP
                    STORE RECNO() TO WINICIO
                    STORE .T. TO FLAGJUMP
                    STORE 0 TO WREVERSE
                 ENDIF
              ENDIF

              IF W0600 = 1
                 SAVE SCRE TO SCXC
                 STORE RECNO() TO WWREGI
                 STORE .T. TO CANCELING
                 DO WHILE CANCELING
                    SELECT COMCXP
                    @ 6,0 CLEAR TO 21,79
                    @ 7,0 TO 21,79
                    *@ 6,01  SAY BENEFI
                    *@ 6,17  SAY REFERENCIA
                    *@ 6,28  SAY ELABORADO
                    *@ 6,39  SAY TOTDOC PICTURE "999,999,999.99"
                    *@ 6,54  SAY CANCELADO
                    *@ 6,65  SAY REFERPROVE
                    *@ 6,76  SAY ORIGEN
                    SET COLOR TO B/W+
                    @ 8,01 SAY "LIN"
                    @ 8,05 SAY "FECHA"
                    @ 8,16 SAY "REFERENCIA"
                    @ 8,42 SAY "       DEBE"
                    @ 8,62 SAY "      HABER"
                    SET COLOR TO W+/B
                    @ 9,01 SAY "  0"
                    @ 9,05 SAY DTOC(ELABORADO)
                    @ 9,16 SAY REFERENCIA
                    @ 9,60 SAY TOTDOC PICTURE "999,999,999.99"
                    STORE 0 TO WPAGADO
                    STORE 0 TO WRENG
                    STORE 9 TO WLINE
                    SELECT COMCXPTR
                    SET ORDER TO COMCXPT1
                    SEEK COMCXP->CODCXP
                    DO WHILE .NOT. EOF().AND.CODCXP=COMCXP->CODCXP
                       STORE WRENG+1 TO WRENG
                       STORE WLINE+1 TO WLINE
                       IF WLINE>20
                          STORE "OPRIMA <ENTER> PARA CONTINUAR" TO MES
                          DO AVISO WITH MES
                          @ 6,0 CLEAR TO 21,79
                          @ 7,0 TO 21,79
                          STORE 9 TO WLINE
                       ENDIF
                       @ WLINE,01  SAY STR(WRENG,3)
                       @ WLINE,05  SAY DTOC(FECHA)
                       @ WLINE,16  SAY REFERENCIA
                       @ WLINE,40  SAY MONTO PICTURE "999,999,999.99"
                       STORE WPAGADO + MONTO TO WPAGADO
                       STORE FECHA           TO WLASTPAG
                       SKIP
                    ENDDO
                    *** ACTUALIZAR VALORES EN DOCUMENTO X COBRAR
                    SELECT COMCXP
                    STORE  TOTDOC - WPAGADO TO WSALDO
                    @ 22,50  SAY "SALDO  :"
                    @ 22,60  SAY WSALDO PICTURE "999,999,999.99"
                    IF RECLOC()
                       IF WSALDO > 0
                          REPLACE CANCELADO WITH CTOD("  -  -  ")
                       ELSE
                          REPLACE CANCELADO WITH WLASTPAG
                       ENDIF
                       UNLOCK ALL
                       FLUSH
                    ENDIF
                    STORE WRENG + 1 TO WCHOICEX
                    STORE "INGRESE LA LINEA A PROCESAR " TO MES
                    DO MENSAJE WITH MES
                    @ 23,70 GET WCHOICEX PICTURE "##"
                    READ
                    IF LASTKEY() = 27
                       STORE .F. TO CANCELING
                       LOOP
                    ENDIF
                    *** BUSQUEDA DE LA LINEA SELECCIONADA
                    STORE 0 TO WSEL
                    STORE .F. TO WENCONTRADO
                    SELECT COMCXPTR
                    SET ORDER TO COMCXPT1
                    SEEK COMCXP->CODCXP
                    DO WHILE .NOT. EOF().AND.CODCXP=COMCXP->CODCXP
                       STORE WSEL+1 TO WSEL
                       IF WSEL = WCHOICEX
                          STORE .T. TO WENCONTRADO
                          EXIT
                       ENDIF
                       SKIP
                    ENDDO
                    IF WENCONTRADO
                       STORE "OPCIONES: (M)ODIFICAR, (E)LIMINAR" TO TEX
                       STORE "ME" TO WCH
                       DO PREGUNTA
                       IF WCH = "E"
                          IF FILLOC()
                             DELETE
                             UNLOCK ALL
                             FLUSH
                             LOOP
                          ENDIF
                       ENDIF
                       STORE " "        TO WENTRA
                       STORE FECHA      TO WFECHA
                       STORE MONTO      TO WMONTO
                       STORE MONTO      TO WLASTMONTO
                       STORE REFERENCIA TO WREFERENCIA
                    ELSE
                       STORE "I"        TO WENTRA
                       STORE DATE()     TO WFECHA
                       STORE WSALDO     TO WMONTO
                       STORE 0          TO WLASTMONTO
                       STORE SPACE(10)  TO WREFERENCIA
                    ENDIF
                    @ WLINE+1,01  SAY STR(WCHOICEX,3)
                    @ WLINE+1,05  GET WFECHA
                    @ WLINE+1,16  GET WREFERENCIA
                    @ WLINE+1,40  GET WMONTO PICTURE "999,999,999.99"
                    READ
                    IF WMONTO > WSALDO+WLASTMONTO
                       STORE "MONTO EXEDE SALDO. SERA AJUSTADO A :"+STR((WSALDO+WLASTMONTO),12,2) TO MES
                       DO AVISO WITH MES
                       STORE WSALDO+WLASTMONTO TO WMONTO
                    ENDIF
                    STORE "CONFORME? (S/N)" TO TEX
                    STORE "SN" TO WCH
                    DO PREGUNTA
                    IF WCH = "S"
                       SELECT COMCXPTR
                       IF WENTRA = "I"
                          IF FILLOC()
                             APPEND BLANK
                             REPLACE CODCXP WITH COMCXP->CODCXP
                             UNLOCK ALL
                             FLUSH
                          ENDIF
                       ENDIF
                       IF RECLOC()
                          REPLACE FECHA      WITH WFECHA
                          REPLACE REFERENCIA WITH WREFERENCIA
                          REPLACE MONTO      WITH WMONTO
                          REPLACE ORIGEN      WITH "CXP"
                          REPLACE DEPTO       WITH WUSERUBI
                          REPLACE USUARIO     WITH WUSERCODE
                          REPLACE USUARIOF    WITH DATE()
                          UNLOCK ALL
                          FLUSH
                       ENDIF
                    ENDIF
                    SELECT COMCXP
                 ENDDO
                 SELECT COMCXP
                 GO WWREGI
                 IF .NOT. EOF()
                    STORE RECNO() TO WINICIO
                    STORE .T. TO FLAGJUMP
                    STORE RECNO() TO WREVERSE
                    STORE RECNO() TO WCLEARREC
                    STORE WLINE   TO WEDILIN
                    STORE WLINE   TO WCLEARLIN
                 ELSE
                    GO TOP
                    STORE RECNO() TO WINICIO
                    STORE .T. TO FLAGJUMP
                    STORE 0 TO WREVERSE
                 ENDIF
                 RESTORE SCRE FROM SCXC
                 SELECT COMCXP
              ENDIF
              GO TOP
              STORE RECNO() TO WINICIO
              STORE .T. TO FLAGJUMP
              STORE 0 TO WREVERSE

