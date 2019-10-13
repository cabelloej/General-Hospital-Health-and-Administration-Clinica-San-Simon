DO WHILE .T.
   STORE 0   TO WPAGINA
   STORE 100 TO WLINEA
   IF WSALIDA = 1
      STORE 22 TO WSALTO
      @ 0,0 CLEAR
   ELSE
      SET DEVI TO PRINT
      STORE 60 TO WSALTO
   ENDIF
   *************
   SELECT HISGRU
   IF WGRUPO<>SPACE(2)
      SEEK WGRUPO
      IF .NOT.FOUND()
         STORE "NO HAY DATOS EN TABLAS PARA ESTA ACTIVIDAD" TO WTEXT
         DO AVISO WITH WTEXT
         EXIT
      ENDIF
   ELSE
      GO TOP
   ENDIF
   DO WHILE .NOT. EOF()
      IF WGRUPO<>SPACE(2).AND.CODGRU<>WGRUPO
         EXIT
      ENDIF
      STORE WLINEA+1 TO WLINEA
      DO SALTO
      @ WLINEA,00 SAY DESGRU
      *************
      SELECT HISSUB
      IF WCODSUB<>SPACE(3)
         SEEK WGRUPO+WCODSUB
         IF .NOT.FOUND()
            SELECT HISGRU
            SKIP
            LOOP
         ENDIF
      ELSE
         SEEK HISGRU.CODGRU
         IF .NOT.FOUND()
            SELECT HISGRU
            SKIP
            LOOP
         ENDIF
      ENDIF
      DO WHILE .NOT. EOF() .AND. CODGRU = HISGRU.CODGRU
         IF WCODSUB<>SPACE(3).AND.WCODSUB<>CODSUB
            EXIT
         ENDIF
         STORE WLINEA+1 TO WLINEA
         DO SALTO
         @ WLINEA,10 SAY DESSUB+"  ("+ESTSUB+")"
         *************
         SELECT HISREN
         IF WCODREN<>SPACE(3)
            SEEK WGRUPO+WCODSUB+WCODREN
            IF .NOT.FOUND()
               SELECT HISSUB
               SKIP
               LOOP
            ENDIF
         ELSE
            SEEK HISGRU.CODGRU+HISSUB.CODSUB
            IF .NOT.FOUND()
               SELECT HISSUB
               SKIP
               LOOP
            ENDIF
         ENDIF
         DO WHILE.NOT.EOF() .AND. CODGRU=HISGRU.CODGRU.AND.CODSUB=HISSUB.CODSUB
            IF WCODREN<>SPACE(3).AND.CODREN<>WCODREN
               EXIT
            ENDIF
            STORE WLINEA+1 TO WLINEA
            DO SALTO
            @ WLINEA,20 SAY SUBSTR(DESREN,1,25)+"  ("+ESTREN+")"
            *************
            SELECT HISTAB
            IF WCODTAB<>SPACE(3)
               SEEK WGRUPO+WCODSUB+WCODREN+WCODTAB
               IF .NOT.FOUND()
                  SELECT HISREN
                  SKIP
                  LOOP
               ENDIF
            ELSE
               SEEK HISGRU.CODGRU+HISSUB.CODSUB+HISREN.CODREN
               IF .NOT.FOUND()
                  SELECT HISREN
                  SKIP
                  LOOP
               ENDIF
            ENDIF
            DO WHILE.NOT.EOF() .AND. CODGRU=HISGRU.CODGRU.AND.CODSUB=HISSUB.CODSUB.AND.CODREN=HISREN.CODREN
               IF WCODTAB<>SPACE(3).AND.CODTAB<>WCODTAB
                  EXIT
               ENDIF
               STORE WLINEA+1 TO WLINEA
               DO SALTO
               @ WLINEA,30 SAY SUBSTR(DESTAB,1,25)
               SELECT HISTAB
               SKIP
            ENDDO
            SELECT HISREN
            SKIP
         ENDDO
         SELECT HISSUB
         SKIP
      ENDDO
      SELECT HISGRU
      SKIP
   ENDDO
   EXIT
ENDDO
IF WSALIDA=2
   SET DEVI TO SCRE
   EJECT
ELSE
   STORE "OPRIMA (Ù) PARA FINALIZAR" TO TEX
   STORE CHR(13) TO WCH
   DO PREGUNTA
   @ 0,0 CLEAR
ENDIF
RETURN
********************************************************************************
**********
PROC SALTO
**********
IF WLINEA >= WSALTO
   STORE WPAGINA + 1 TO WPAGINA
   IF WSALIDA=1 .AND. WPAGINA<>1
      STORE "OPRIMA (Ù) PARA CONTINUAR" TO TEX
      STORE CHR(13) TO WCH
      DO PREGUNTA
      @ 0,0 CLEAR
   ENDIF
   STORE 1 TO WLINEA
   @ 00,00 SAY CHR(14)+QQWW

   @ 01,00 SAY "INFORME DE TABLAS"
   @ 01,70 SAY "Pag."+ALLTRIM(STR(WPAGINA,3))
   @ 03,00 SAY "ACTIVIDAD/SUBACTIVIDAD/RENGLON/TABULADOR"
   @ 04,00 SAY REPLICATE("-",80)
   STORE 5 TO WLINEA
ENDIF
RETURN
