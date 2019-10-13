set talk off
set echo off
SET EXCL OFF
*
SELECT 1
use afiafi index afiafi4
SELECT 2
use syspac index syspac3
*
store 0 to wnumhis
linea=0
*set devi to print
do while .t.
   store str(wnumhis,6)                            to wnumhisc
   store 6-len(alltrim(wnumhisc))                  to wnumcero
   store replicate("0",wnumcero)+alltrim(wnumhisc) to wnumhisc
   store substr(wnumhisc,1,2)+"-"+substr(wnumhisc,3,2)+"-"+substr(wnumhisc,5,2) to wclave
   select 1
   seek wclave
   if .not. found()
      select 2
      seek wclave
      if .not. found()
         linea=linea+1
         @ linea,0 say  wclave
      endif
   endif
   wnumhis=wnumhis+1
   if wnumhis>9880
      exit
   endif
enddo
close all
set devi to scre
eject
