set talk off
set echo off
set dele on
set uniq off
set date ital
set century on

select 1
use afititu 
zap
index on cedtitu                  to afititu
select 2
use afiafi
zap
index on cedtitu+carga            to afiafi
select 3
use sitoso 
index on norden                   to sitoso
select 4
use sosieco
index on norden                   to sosieco
                                     

store 0   to m.norden
select sitoso
go top
do while .not. eof()
   if sitoso.norden <> m.norden
      store 0             to m.carga
      store sitoso.norden to m.norden
      store cedula        to m.cedtitu
   endif
   select afiafi
   append blank
   replace norden      with m.norden
   if m.cedtitu<>space(10)
      replace cedtitu  with m.cedtitu
   else
      replace cedtitu  with "SN-"+alltrim(str(m.norden,10))
   endif
   replace carga       with str(m.carga,4)
   replace papellido   with substr(sitoso.noape,1,15)
   replace sapellido   with substr(sitoso.noape,16,15)
   replace pnombre     with substr(sitoso.noape,31,10)
   replace cedafi      with sitoso.cedula 
   if cedafi=space(10).and.m.carga=0
      replace cedafi  with "SN-"+alltrim(str(m.norden,10))
   endif
   replace sexo        with sitoso.sexo
   replace nacimiento  with ctod("01-01-"+str(95-sitoso.edad,4))
   if m.carga=0
      replace parentesco with "00"
   else
      replace parentesco  with sitoso.parentes
   endif
   store m.carga+1 to m.carga
   select sitoso
   skip
enddo

close data
close index
return


