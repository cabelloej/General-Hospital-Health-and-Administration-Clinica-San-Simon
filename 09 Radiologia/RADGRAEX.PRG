
            DEFI WIND WINGRA FROM 12,20 TO 14,60;
                 DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
            ACTI WIND WINGRA
            @ 0,1 SAY "Actualizando, favor esperar..."

            CLOSE DATA
            CLOSE INDEX
            select 1
            use &wdbfhg index &widxhg1, &widxhg1 alias hisgent
            select 2
            use &wdbfhd index &widxhd  alias hisdett
            select 3
            use hisgen  index hisgen1, hisgen2
            select 4
            use hisdet  index hisdet
            select hisgent
            go top
            do while .not. eof()
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
            close data
            close index
            delete file &wdbfhg
            delete file &widxhg1
            delete file &widxhg1
            delete file &wdbfhd
            delete file &widxhd
            RELE WIND WINGRA
            return
