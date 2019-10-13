*** LIBERA TODO DE MEMORIA
close data
close index
close all
clear all
release all

*** Inicio del setup de foxpro
set alternate off
set ansi on
set autosave on
set bell on
set blink on
set blocksize to 32
set border to single
set brstatus off
set carry off
set century on
set clear on
set clock off
*set clock to 1,35
set color to
set compatible foxplus
set confirm off
set console off
set currency to
set cursor on
set date italian
*set debug off
set decimal to 2
set default to
set delete on
set delimiters off
set development on
set device to print
*set display to    (no usar)
set dohistory off
set echo off
set escape off
set exact off
set exclusive off
set fields off
set fixed on
*set format to     (no usar, primero verifique)
set fullpath on
*set funtion       (muy interesante, primero verificar)
set heading on
set help off
set hours to 24
set intensity on
set keycomp to dos
set lock off
set message to
set mouse on
set multilocks on
set near off
set notify off
set odometer to
set optimize on
set palette off
set point to
set printer to
set procedure to sysproc
set readborder off
set refresh to 0
set reprocess to 2 seconds
*set resource off
set safety off
set scoreboard off
set separator to
set shadows on
*set skip (one to many relation)
set space on
set status off
set status bar off
set step off
set sticky on
set sysmenu off
set talk off
*set textmerge off
set typeahead to 1
set unique off


SELECT 1
USE AFITITU INDEX AFITITU1
*,AFITITU2,AFITITU3,AFITITU4,AFITITU5
SELECT 2
USE AFIAFI INDEX AFIAFI1
*,AFIAFI2,AFIAFI3,AFIAFI4

*** BUSQUEDA EN AFITITU
STORE "**********" TO WRUPCED
STORE 0   TO WNUMCED
STORE 0   TO WNUMAFI
STORE 100 TO WLINE
SELECT AFITITU
GO TOP
DO WHILE .NOT. EOF()
   STORE WNUMAFI+1 TO WNUMAFI
   DO SHOW
   IF WRUPCED<>CEDTITU
      IF WNUMCED>0
         DO REPT
      ENDIF
      STORE 0       TO WNUMCED
      STORE CEDTITU TO WRUPCED
   ELSE
      STORE WNUMCED + 1  TO WNUMCED
   ENDIF
   SELECT AFITITU
   SKIP
ENDDO

*** BUSQUEDA EN AFIAFI
STORE "*"              TO WRUPCED
STORE 0                TO WNUMCED
STORE 0                TO WNUMAFI
STORE 100              TO WLINE
SELECT AFIAFI

DO WHILE .NOT. EOF()
   STORE WNUMAFI+1 TO WNUMAFI
   DO SHOW
   IF WRUPCED<>CEDTITU+CARGA
      IF WNUMCED>0
         DO REPA
      ENDIF
      STORE 0             TO WNUMCED
      STORE CEDTITU+CARGA TO WRUPCED
   ELSE
      STORE WNUMCED + 1  TO WNUMCED
   ENDIF
   SELECT AFIAFI
   SKIP
ENDDO

CLOSE DATA
CLOSE INDEX
RETURN

**************
PROC REPT
**************
STORE WLINE+1 TO WLINE
IF WLINE>55
   DO TITT
ENDIF
@ WLINE,00 SAY WRUPCED
@ WLINE,30 SAY WNUMCED
RETURN
************
PROC TITT
************
@ 0,0 SAY "HCSS"
@ 2,0 SAY "LISTADO DE TITULARES REPETIDOS EN AFITITU"
@ 3,00 SAY "CEDULA    "
@ 3,30 SAY "VECES    "
STORE 5 TO WLINE
RETURN
**************
PROC REPA
**************
STORE WLINE+1 TO WLINE
IF WLINE>55
   DO TITA
ENDIF
@ WLINE,00 SAY WRUPCED
@ WLINE,30 SAY WNUMCED
RETURN
************
PROC TITA
************
@ 0,0 SAY "HCSS"
@ 2,0 SAY "LISTADO DE AFILIADOS REPETIDOS EN AFIAFI"
@ 3,00 SAY "CODIGO    "
@ 3,30 SAY "VECES    "
STORE 5 TO WLINE
RETURN
*********
PROC SHOW
*********
set devi to scre
@ 23,0
@ 23,5 SAY "NOMBRE: "+PAPELLIDO+" "+PNOMBRE+"CODIGO: "+WRUPCED+"No."+STR(WNUMAFI,5)
set devi to print
RETURN


