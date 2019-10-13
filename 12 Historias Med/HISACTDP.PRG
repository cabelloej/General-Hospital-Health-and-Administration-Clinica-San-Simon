*  *** Coloca el shadow de la ventana
*  SET COLOR TO N/N
*  @ 4,02 CLEAR TO 19,67
*  *** Coloca color de fondo interno para la ventana
*  SET COLOR TO GR+/BG+
*  @ 03,00 CLEAR TO 18,65
*  *** Coloca color del marco de la ventana
*  SET COLOR TO GR+/W
*  @ 03,00       TO 18,65 DOUBLE
*  @ 03,22 SAY " DATOS PERSONALES "
*  *** Coloca color de trabajo en la ventana
*  SET COLOR TO W+/BG+


   DEFI WIND WINDDP FROM 03,00 TO 20,72 ;
                    TITLE " PACIENTES " ;
                    DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
   ACTI WIND WINDDP

   @ 01,02 SAY "Codigo              :"
   @ 02,02 SAY "Primer  Apellido    :"
   @ 03,02 SAY "Segundo Apellido    :"
   @ 04,02 SAY "Primer  Nombre      :"
   @ 05,02 SAY "Segundo Nombre      :"
   @ 06,02 SAY "Cedula              :"
   @ 07,02 SAY "Sexo                :"
   @ 08,02 SAY "Nacimiento(Lug.yFec):"
   @ 09,02 SAY "Estado Civil        :"
   @ 10,02 SAY "Direccion           :"
   @ 11,02 SAY "Telefono            :"
   @ 12,02 SAY "Historia            :"
   @ 13,02 SAY "Alergico a          :"
   @ 14,02 SAY "Emergencia:Nom,Telf.:"

   *** INICIALIZA VARIABLES
   STORE SPACE(1)     TO M.PAPELLIDO
   STORE SPACE(1)     TO M.SAPELLIDO
   STORE SPACE(1)     TO M.PNOMBRE
   STORE SPACE(1)     TO M.SNOMBRE
   STORE SPACE(1)     TO M.CEDAFI
   STORE SPACE(1)     TO M.SEXO
   STORE SPACE(20)    TO M.LUGARNAC
   STORE SPACE(1)     TO M.NACIMIENTO
   STORE SPACE(1)     TO M.EDOCIVIL
   STORE SPACE(1)     TO M.DIRECCION
   STORE SPACE(1)     TO M.TELEFONO
   STORE SPACE(1)     TO M.HISTORIA
   STORE SPACE(1)     TO M.ALERGICO
   STORE SPACE(1)     TO M.EMERGENCIA
   STORE SPACE(1)     TO WORGADES
   STORE SPACE(1)     TO WNIV1DES

   STORE SPACE(20)                 TO WTIPDES
  *STORE SPACE(14)                 TO WCODPAC
   STORE SUBSTR(WCODPAC,1,10)      TO WCODPAC1
   STORE SUBSTR(WCODPAC,11,4)      TO WCODPAC2
   STORE VAL(WCODPAC2)             TO WCODPAC2
   @ 01,25 GET WCODPAC1                VALID VALCED()
   @ 01,35 SAY "-"
   @ 01,36 GET WCODPAC2 PICTURE "9999" VALID VALPAC()
   READ
  *STORE STR(WCODPAC2,4)                            TO WCODPAC2
  *STORE WCODPAC1+WCODPAC2                          TO WCODPAC
   STORE RTRIM(WCODPAC1)+"-"+LTRIM(STR(WCODPAC2,4)) TO WXCODPAC
   IF LASTKEY()=27
      RELE WIND WINDDP
      STORE .F. TO WFLAGDP
      RETURN
   ENDIF
   IF WFLAGMED
      @ 01,25 SAY SPACE(30)
      @ 01,25 SAY WXCODPAC+"  Paciente "+wtipdes
      @ 02,25 SAY M.PAPELLIDO
      @ 03,25 SAY M.SAPELLIDO
      @ 04,25 SAY M.PNOMBRE
      @ 05,25 SAY M.SNOMBRE
      @ 06,25 SAY M.CEDAFI
      @ 07,25 SAY M.SEXO         
      @ 08,25 SAY M.LUGARNAC
      @ 08,50 SAY M.NACIMIENTO   
      @ 09,25 SAY M.EDOCIVIL     
      @ 10,25 SAY M.DIRECCION
      @ 11,25 SAY M.TELEFONO
      @ 12,25 SAY M.HISTORIA
   ELSE
      @ 01,25 SAY SPACE(30)
      @ 01,25 SAY WXCODPAC+"  Paciente "+wtipdes
      @ 02,25 GET M.PAPELLIDO
      @ 03,25 GET M.SAPELLIDO
      @ 04,25 GET M.PNOMBRE
      @ 05,25 GET M.SNOMBRE
      IF (WTIPPAC="A".AND.AFIAFI.CARGA<>"   0")
         @ 06,25 GET M.CEDAFI
      ELSE
         @ 06,25 SAY M.CEDAFI
      ENDIF
      @ 07,25 GET M.SEXO         VALID VALSEXO()
      @ 08,25 GET M.LUGARNAC
      @ 08,50 GET M.NACIMIENTO   VALID VALNACI()
      @ 09,25 GET M.EDOCIVIL     VALID VALEDO()
      @ 10,25 GET M.DIRECCION
      @ 11,25 GET M.TELEFONO
      @ 12,25 GET M.HISTORIA     VALID VALHIS()
   ENDIF
   @ 13,25 GET M.ALERGICO
   @ 14,25 GET M.EMERGENCIA
   IF WUSERUBI<>"LAB"
      READ
   ELSE
      CLEAR GETS
   ENDIF
   DO GRABAPAC
   STORE RTRIM(PAPELLIDO)+" "+RTRIM(SAPELLIDO)+" "+RTRIM(PNOMBRE)+" "+RTRIM(SNOMBRE) TO WNOMBRE
   STORE HISTORIA TO WNUMHIS
   *** INICIO RUTINA DE ACEPTAR-CANCELAR
   store 1 to wop
   do while .t.
      @ 15,25 get wop pict "@*H Continuar;Imprimir " defa wop
      read
      if lastkey()=13
         exit
      endif
   enddo
   IF WOP=2
      DO IMPFIC
   ENDIF
   **** FIN  RUTINA ACEPTAR-CANCELAR
   STORE .T. TO WFLAGDP
RETURN
****************
PROCEDURE VALCED
IF WCODPAC1<>SPACE(10)
   RETURN .T.
ELSE
   RETURN .F.
ENDIF
****************
PROCEDURE VALPAC
****************
STORE WCODPAC1+STR(WCODPAC2,4) TO WCODPAC
IF SUBSTR(WCODPAC,1,1)="*"
   SELECT AFIAFI
   SET ORDER TO AFIAFI4
   SEEK SUBSTR(WCODPAC,2,8)+SPACE(3)
   IF FOUND()
      STORE CEDTITU                     TO WCODPAC1
      STORE VAL(CARGA)                  TO WCODPAC2
      STORE CEDTITU+CARGA               TO WCODPAC
   ELSE
      SELECT SYSPAC
      SET ORDER TO SYSPAC3
      SEEK SUBSTR(WCODPAC,2,8)+SPACE(3)
      IF FOUND()
         STORE SUBSTR(CODPAC,1,10)      TO WCODPAC1
         STORE VAL(SUBSTR(CODPAC,11,4)) TO WCODPAC2
         STORE CODPAC                   TO WCODPAC
      ELSE
         STORE "PACIENTE NO REGISTRADO COMO AFILIADO NI COMO NO-AFILIADO" TO WTEXT
         DO AVISO WITH WTEXT
         RETURN .F.
         *STORE SPACE(10)                TO WCODPAC1
         *STORE 0                        TO WCODPAC1
         *STORE SPACE(14)                TO WCODPAC
      ENDIF
   ENDIF
ELSE
   STORE WCODPAC1+STR(WCODPAC2,4) TO WCODPAC
ENDIF
***
SELECT AFIAFI
SET ORDER TO AFIAFI1
SEEK WCODPAC
IF .NOT. FOUND()
   SELECT SYSPAC
   SET ORDER TO SYSPAC
   SEEK WCODPAC
   IF .NOT. FOUND()
      STORE "PACIENTE NO REGISTRADO COMO AFILIADO NI COMO NO-AFILIADO" TO WTEXT
      DO AVISO WITH WTEXT
      RETURN .F.
   ELSE
      STORE "N"           TO WTIPPAC
      STORE "No afiliado" TO WTIPDES
      STORE PAPELLIDO     TO M.PAPELLIDO
      STORE SAPELLIDO     TO M.SAPELLIDO
      STORE PNOMBRE       TO M.PNOMBRE
      STORE SNOMBRE       TO M.SNOMBRE
      STORE CEDAFI        TO M.CEDAFI
      STORE SEXO          TO M.SEXO
      STORE NACIMIENTO    TO M.NACIMIENTO
      STORE EDOCIVIL      TO M.EDOCIVIL
      STORE DIRECCION     TO M.DIRECCION
      STORE TELEFONO      TO M.TELEFONO
      STORE HISTORIA      TO M.HISTORIA
      STORE ALERGICO      TO M.ALERGICO
      STORE EMERGENCIA    TO M.EMERGENCIA
      STORE SPACE(1)      TO WORGADES
      STORE SPACE(1)      TO WNIV1DES
      RETURN .T.
   ENDIF
ELSE
   STORE "A"          TO WTIPPAC
   IF VAL(SUBSTR(WCODPAC,11,4))=0
      STORE "Afiliado-Titular   "   TO WTIPDES
   ELSE
      STORE "Afiliado-Carga Fam."   TO WTIPDES
   ENDIF
   STORE PAPELLIDO    TO M.PAPELLIDO
   STORE SAPELLIDO    TO M.SAPELLIDO
   STORE PNOMBRE      TO M.PNOMBRE
   STORE SNOMBRE      TO M.SNOMBRE
   STORE CEDAFI       TO M.CEDAFI
   STORE SEXO         TO M.SEXO
   STORE NACIMIENTO   TO M.NACIMIENTO
   STORE EDOCIVIL     TO M.EDOCIVIL
   STORE DIRECCION    TO M.DIRECCION
   STORE TELEFONO     TO M.TELEFONO 
   STORE HISTORIA     TO M.HISTORIA
   STORE ALERGICO     TO M.ALERGICO
   STORE EMERGENCIA   TO M.EMERGENCIA
   SELECT 24
   USE AFITITU INDEX AFITITU1
   SEEK SUBSTR(WCODPAC,1,10)
   IF FOUND()
      STORE ORGA     TO WORGA
      STORE NIVORG1  TO WNIV1
   ELSE
      STORE SPACE(1) TO WORGA
      STORE SPACE(1) TO WNIV1
   ENDIF
   SELECT 25
   USE AFIORGA INDEX AFIORGA
   SEEK WORGA
   IF FOUND()
      STORE DESCRI TO WORGADES
   ENDIF
   SEEK WORGA+WNIV1
   IF FOUND()
      STORE DESCRI TO WNIV1DES
   ENDIF
   SELECT 24
   USE
   SELECT 25
   USE
   RETURN .T.
ENDIF
RETURN .T.
***********
PROC IMPFIC
SET DEVI TO PRINT
@ 01,00 SAY CHR(14)+QQWW
@ 01,00 SAY CHR(14)+QQWW
@ 04,55 SAY "HISTORIA No. "+ALLTRIM(WNUMHIS)
@ 05,00 SAY REPLICATE("-",80)
@ 06,22 SAY CHR(14)+"HISTORIA MEDICA"
@ 07,00 SAY REPLICATE("-",80)
@ 08,00 SAY "DATOS GENERALES DEL PACIENTE"
@ 08,00 SAY "DATOS GENERALES DEL PACIENTE"
@ 10,00 SAY "Codigo ..............: "+WXCODPAC+"  "+WTIPDES
@ 11,00 SAY "Organismo-Cliente ...: "+SUBSTR(WORGADES,1,20)+"-"+SUBSTR(WNIV1DES,1,20)
@ 12,00 SAY "Nombre ..............: "+WNOMBRE
@ 13,00 SAY "Cedula ..............: "+M.CEDAFI
@ 14,00 SAY "Sexo ................: "+M.SEXO
@ 15,00 SAY "Nacimiento(Lug.y Fec): "+M.LUGARNAC+" "+DTOC(M.NACIMIENTO)
@ 16,00 SAY "Edad ................: "+STR(INT((DATE()-M.NACIMIENTO)/365),2)
@ 17,00 SAY "Estado civil ........: "+M.EDOCIVIL
@ 18,00 SAY "Direccion ...........: "+M.DIRECCION
@ 19,00 SAY "Telefono ............: "+M.TELEFONO
@ 20,00 SAY "Alergico a ..........: "+M.ALERGICO
@ 21,00 SAY "Emergencias Nom,Telf.: "+M.EMERGENCIA
EJECT
SET DEVI TO SCRE
RETURN
************
FUNC VALSEXO
do while .t.
   if m.sexo="M".or.m.sexo="F"
      exit
   endif
   defi wind winsex  from 07,25 to 10,40
   acti wind winsex
   @ 00,00 clear
   if m.sexo="M"
      store 1 to wvalop
   else
      store 2 to wvalop
   endif
   do while .t.
      @ 00,00 get wvalop pict "@*V  Masculino ; Femenino" defa wvalop
      read
      if lastkey()=13
         exit
      endif
   enddo
   if wvalop=1
      store "M" to m.sexo
   else
      store "F" to m.sexo
   endif
   rele wind winsex
enddo
return .t.
************
FUNC VALNACI
do while .t.
   if m.nacimiento<>ctod("  -  -    ")
      return .t.
   else
      return .f.
   endif
enddo
***********
FUNC VALEDO
do while .t.
   if M.EDOCIVIL="S".or.M.EDOCIVIL="C".OR.M.EDOCIVIL="V".or.;
      M.EDOCIVIL="D".OR.M.EDOCIVIL="N"
      exit
   endif
   defi wind winsex  from 21,00 to 23,79
   acti wind winsex
   @ 00,00 clear
   if M.EDOCIVIL="S"
      store 1 to wvalop
   else
      IF M.EDOCIVIL="C"
         store 2 to wvalop
      ELSE
         IF M.EDOCIVIL="V"
            store 3 to wvalop
         ELSE
            IF M.EDOCIVIL="D"
               store 4 to wvalop
            ELSE
               STORE 5 TO WVALOP
            ENDIF
         ENDIF
      ENDIF
   endif
   do while .t.
      @ 00,05 get wvalop pict "@*H  Soltero  ; Casadado ; Viudo    ; Divorciado ; coNcubino" defa wvalop
      read
      if lastkey()=13
         exit
      endif
   enddo
   do case
      case wvalop=1
           STORE "S" TO M.edocivil
      case wvalop=2
           STORE "C" TO M.edocivil
      case wvalop=3
           STORE "V" TO M.edocivil
      case wvalop=4
           STORE "D" TO M.edocivil
      case wvalop=5
           STORE "N" TO M.edocivil
   endcase
   rele wind winsex
enddo
return .t.
*************
PROC GRABAPAC
*************
IF WTIPPAC="A"
   SELECT AFIAFI
   IF RECLOC()
      GATH MEMV
      UNLOCK ALL
   ENDIF
ELSE
   SELECT SYSPAC
   IF RECLOC()
      GATH MEMV
      UNLOCK ALL
   ENDIF
ENDIF
***********
FUNC VALHIS
***********
STORE .T. TO WRESHIS
IF M.HISTORIA=SPACE(12)
   RETURN WRESHIS
ENDIF
***
IF WTIPPAC="A"
   SELECT AFIAFI
   STORE RECNO() TO WRECHIS
ELSE
   IF WTIPPAC="N"
      SELECT SYSPAC
      STORE RECNO() TO WRECHIS
   ELSE
      RETURN WRESHIS
   ENDIF
ENDIF
***
SELECT AFIAFI
SET ORDER TO AFIAFI4
SEEK M.HISTORIA
IF FOUND().AND.CEDTITU+CARGA<>WCODPAC
   STORE "No. DE HISTORIA YA REGISTRADA" TO WTEXT
   DO AVISO WITH WTEXT
   STORE .F. TO WRESHIS
ENDIF
SELECT SYSPAC
SET ORDER TO SYSPAC3
SEEK M.HISTORIA
IF FOUND().AND.CODPAC<>WCODPAC
   STORE "No. DE HISTORIA YA REGISTRADA" TO WTEXT
   DO AVISO WITH WTEXT
   STORE .F. TO WRESHIS
ENDIF
IF WTIPPAC="A"
   SELECT AFIAFI
   SET ORDER TO AFIAFI1
   GO WRECHIS
ELSE
   SELECT SYSPAC
   SET ORDER TO SYSPAC
   GO WRECHIS
ENDIF
RETURN WRESHIS
***********
