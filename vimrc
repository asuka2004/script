map <F2> :call TitleDet()<cr>
 function AddTitle()
     call append(0,"\#!/bin/sh")
     call append(1,"# **************************************************")
     call append(2,"# Description  :  ")
     call append(3,"# Build        : ".strftime("%Y-%m-%d %H:%M"))
     call append(4,"# Author       : Kung")
     call append(5,"# Filename     : ".expand("%:t"))")
     call append(6,"# Version      :     ")
     call append(7,"#              :     ")
     call append(8,"# *************************************************")
     call append(9,"export PATH=$PATH")
     call append(10,". /etc/init.d/functions")
     echohl WarningMsg | echo "Successful in adding copyright." | echohl None
 endf
 
 function UpdateTitle()
      normal m'
      execute '/# Last modified/s@:.*$@\=strftime(":\t%Y-%m-%d %H:%M")@'
      normal ''
      normal mk
      execute '/# Filename/s@:.*$@\=":\t".expand("%:t")@'
      execute "noh"
      normal 'k
      echohl WarningMsg | echo "Successful in updating the copyright." | echohl None
 endfunction
 
 function TitleDet()
     let n=1 
     while n < 10
         let line = getline(n)
         if line =~ '^\#\s*\S*Last\smodified\S*.*$'
             call UpdateTitle()
             return
         endif
         let n = n + 1
     endwhile
     call AddTitle()
 endfunction