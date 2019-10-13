save scre to scre0315
@ 00,00 clear
@ 11,10 clear to 16,70
@ 12,10       to 16,70
@ 11,20 say "ESTADISTICA POR UBICACION GEOGRAFICA"
STORE SPACE(4) TO WORGA
@ 13,15 SAY "ORGANIZACION:" GET WORGA
READ

store "Monitor" to wop
do while .t.
   @ 14,15 SAY "SALIDA      :" get wop pict "@*H Monitor   ;Impresora" defa wop
   read
   if lastkey()=13
      exit
   endif
enddo
STORE WOP TO WSALIDA
IF ALLTRIM(WSALIDA) = "Impresora"
   STORE 60          TO WSALTO
   STORE "IMPRESORA" TO WSALIDES
   STORE "I"         TO WSALIDA
ELSE
   STORE 22          TO WSALTO
   STORE "MONITOR"   TO WSALIDES
   STORE "M"         TO WSALIDA
ENDIF
@ 14,30 SAY SPACE(24)
@ 14,30 SAY WSALIDES
store 1 to wop
do while .t.
   @ 15,15 SAY "OPCIONES    :"  get wop pict "@*H Aceptar  ;Cancelar" defa wop
   read
   if lastkey()=13
      exit
   endif
enddo
IF WOP = 2
   RETURN
ENDIF
IF WSALIDA="I"
   set devi to print
ELSE
   @ 0,0 clear
ENDIF
store "**" to wrupest
store "**" to wrupciu
store 0    to wcontit
store 0    to wconcar
store 0    to wcontottit
store 0    to wcontotcar
store 0    to wpagina
store 100  to wlinea
select afititu
set order to 4
go top
do while .not. eof()
   if worga<>space(4).and.worga<>orga
      skip
      loop
   endif
   if estado<>wrupest.or.ciudad<>wrupciu
      do ruptura
   endif
   store wcontit+1                to wcontit
   store wcontottit+1             to wcontottit
   *** conteo de afiafi
   select afiafi
   set order to afiafi1
   seek afititu.cedtitu
   store 0 to sercar
   do while .not. eof() .and. cedtitu=afititu.cedtitu
      store sercar+1 to sercar
      skip
   enddo
   store wconcar+(sercar-1)    to wconcar
   store wcontotcar+(sercar-1) to wcontotcar
   select afititu
   skip
enddo
do ruptura
store wlinea+2 to wlinea
@ wlinea,00 say "TOTALES GENERALES"
@ wlinea,49 say wcontottit            picture "999,999.99"
@ wlinea,59 say wcontotcar            picture "999,999.99"
@ wlinea,69 say wcontottit+wcontotcar picture "999,999.99"
IF WSALIDA="I"
   eject
   SET DEVI TO SCRE
ELSE
   @ 23,00
   @ 23,00 SAY "OPRIMA <ENTER> PARA FINALIZAR"
   READ
   @ 0,0 CLEAR
ENDIF
set order to 1
RETURN
************
proc ruptura
      select afigeo
      seek wrupest
      if found()
         store descri          to westdes
      else
         store "no registrado" to westdes
      endif
      seek wrupest+wrupciu
      if found()
         store descri          to wciudes
      else
         store "no registrada" to wciudes
      endif
      select afititu
      store wlinea+1 to wlinea
      if wlinea>WSALTO
         do header
      endif
      if wcontit>0.or.wconcar>0
         @ wlinea,00 say substr(westdes,1,22)
         @ wlinea,25 say substr(wciudes,1,22)
         @ wlinea,49 say wcontit         picture "999,999.99"
         @ wlinea,59 say wconcar         picture "999,999.99"
         @ wlinea,69 say wcontit+wconcar picture "999,999.99"
      endif
      store estado to wrupest
      store ciudad to wrupciu
      store 0      to wcontit
      store 0      to wconcar
      return
***********
proc header
         STORE WPAGINA+1 TO WPAGINA
         IF WSALIDA="M"
            IF WPAGINA>1
               @ 23,00
               @ 23,00 SAY "OPRIMA <ENTER> PARA CONTINUAR"
               READ
            ENDIF
            @ 0,0 CLEAR
         ENDIF
         @ 00,00 say CHR(14)+"HOSPITAL DE CLINICAS SAN SIMON"
         @ 02,00 say         "INFORME ESTADISTICO DE TITULALES Y CARGA FAMILIAR POR UBICACION GEOGRAFICA"
         @ 03,60 SAY "Fecha  :"+DTOC(DATE())
         @ 04,60 SAY "Pagina :"+STR(WPAGINA,2)
         @ 06,00 SAY "Estado"
         @ 06,25 SAY "Ciudad"
         @ 06,50 SAY "Titulares"
         @ 06,60 SAY "    Carga"
         @ 06,70 SAY "    Total"
         @ 07,00 SAY "--------------------"
         @ 07,25 SAY "--------------------"
         @ 07,50 SAY "---------"
         @ 07,60 SAY "---------"
         @ 07,70 SAY "---------"
         store 8 to wlinea
         return
***************
