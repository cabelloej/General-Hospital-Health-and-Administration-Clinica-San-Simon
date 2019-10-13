            DEFI WIND WINGRA FROM 12,20 TO 14,60;
                 DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
            ACTI WIND WINGRA
            @ 0,1 SAY "Actualizando, favor esperar..."

            CLOSE DATA
            CLOSE INDEX
            select 1
            use admhgen index admhgen1, admhgen2 alias hisgent
            select 2
            use admhdet index admhdet  alias hisdett
            select 3
            use hisgen  index hisgen1, hisgen2
            select 4
            use hisdet  index hisdet
            select 5
            use admadm index admadm1,admadm2,admadm3,admadm4,admadm5
            select hisgent
            go top
            do while .not. eof()
               if codpac<>wcodpac
                  skip
                  loop
               endif
               scatt memv
               select hisgen
               if filloc()
                  append blank
                  unlock all
                  if recloc()
                     gath memv
                     unlock all
                  endif
               endif
               select hisgent
               skip
            enddo
            *****
            select hisdett
            go top
            do while .not. eof()
               if codpac<>wcodpac
                  skip
                  loop
               endif
               scatt memv
               select hisdet
               if filloc()
                  append blank
                  unlock all
                  if recloc()
                     gath memv
                     unlock all
                  endif
               endif
               select hisdett
               skip
            enddo
            select admadm
            set order to admadm2
            seek wcodpac
            if .not.found()
               store "ERROR EN LOCALIZACION DE PACIENTE, REINTENTE" to wtext
               do aviso with wtext
            else
               if filloc()
                  delete
                  unlock all
               else
                  store "OPERACION ABORTADA, REINTENTE" TO WTEXT
                  do aviso with wtext
               endif
            endif
            select admadm
            set order to admadm1
            unlock all
            close data
            close index
            RELE WIND WINGRA
            return
