set talk off
set echo off
set dele on
set uniq off
set date ital
set century on



select 1
use afiafi  index afiafi
select 2
use sitoso  index sitoso
select 3
use sosieco index sosieco
select 4                                     
use afititu index afititu
zap

store "**" to wrupced
select afiafi
go top
do while .not. eof()
   if afiafi.cedtitu<> wrupced
      store afiafi.cedtitu to wrupced
      select sitoso  
      seek afiafi.norden
      if .not. found()
         @ 0,0 clear
         @ 0,0 say "no encontre datos en sitoso de "+afiafi.cedtitu
         read
      endif
      select sosieco
      seek afiafi.norden
      if found()
         select afititu
         append blank
         replace nacion           with sitoso.naciona
         replace cedtitu          with afiafi.cedtitu
         replace pnombre          with afiafi.pnombre
         replace snombre          with afiafi.snombre
         replace papellido        with afiafi.papellido
         replace sapellido        with afiafi.sapellido
         replace sexo             with sitoso.sexo
         replace nacimiento       with ctod("01-01-"+str(95-sitoso.edad,4))
         replace edocivil         with sitoso.edoc
         replace direccion        with sitoso.direccion
         replace estado           with "01"
         replace ciudad           with "02"
         replace municipio        with "00"
         replace orga             with "0002"
         replace nivorg1          with "00"
         replace nivorg2          with "00"
         replace nivorg3          with "00"
         if sosieco.periocidad ="S".or. sosieco.periocidad="SL"
            replace tiplab        with "O"
         else
            replace tiplab        with "E"
         endif
         replace conlab           with "R"
         replace estlab           with "A"
         replace nivaca           with sitoso.nivel
         replace cargo            with sosieco.profesion
         replace sueldo           with sosieco.ingreso
         replace contrato         with str(afiafi.norden,10)
         replace plan             with "02"
         replace respag           with "T"
         replace ingcon           with ctod("01-09-95")
         replace valdes           with ctod("01-09-95")
         replace valhas           with ctod("01-09-96")
         replace sercar           with 40
      else
         @ 0,0 clear
         @ 0,0 say "no encontre datos en sosieco de "+afiafi.cedtitu
         select afititu
         append blank
         replace nacion           with sitoso.naciona
         replace cedtitu          with afiafi.cedtitu
         replace pnombre          with afiafi.pnombre
         replace snombre          with afiafi.snombre
         replace papellido        with afiafi.papellido
         replace sapellido        with afiafi.sapellido
         replace sexo             with sitoso.sexo
         replace nacimiento       with ctod("01-01-"+str(95-sitoso.edad,4))
         replace edocivil         with sitoso.edoc
         replace direccion        with sitoso.direccion
         replace estado           with "01"
         replace ciudad           with "02"
         replace municipio        with "00"
         replace orga             with "0002"
         replace nivorg1          with "00"
         replace nivorg2          with "00"
         replace nivorg3          with "00"
         *if sosieco.periocidad ="S".or. sosieco.periocidad="SL"
         *   replace tiplab        with "O"
         *else
         *   replace tiplab        with "E"
         *endif
         replace conlab           with "R"
         replace estlab           with "A"
         replace nivaca           with sitoso.nivel
         *replace cargo            with sosieco.profesion
         *replace sueldo           with sosieco.ingreso
         replace contrato         with str(afiafi.norden,10)
         replace plan             with "02"
         replace respag           with "T"
         replace ingcon           with ctod("01-09-95")
         replace valdes           with ctod("01-09-95")
         replace valhas           with ctod("01-09-96")
         replace sercar           with 40
      endif
   endif
   select afiafi
   skip
enddo
close data
close index
return


