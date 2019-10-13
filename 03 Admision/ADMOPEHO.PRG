select 1
use syspac index syspac,syspac2,syspac3
select 2
use afiafi index afiafi1,afiafi2,afiafi3,afiafi4
select 3
use afiparen index afiparen
***
select 4
use hisgru index hisgru
select 5
use hissub index hissub
select 6
use hisren index hisren
select 7
use histab index histab
select 8
use admhgen index admhgen1, admhgen2 alias hisgen
select 9
use admhdet index admhdet            alias hisdet
***
select 10
use sysmed index sysmed1, sysmed2
select 11
use sysesp index sysesp
select 12
use admadm index admadm2
*** RELACIONES
SELECT HISGEN
SET RELA TO CODACT     INTO HISGRU,;
            CODDOC     INTO SYSMED
SELECT AFIAFI
SET RELA TO PARENTESCO INTO AFIPAREN
SELECT SYSMED
SET RELA TO ESPECI     INTO SYSESP
RETURN
