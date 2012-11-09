exe 'setlocal equalprg=tidy\ -i\ -quiet\ -f\ '.&errorfile 
setlocal makeprg=tidy\ -quiet\ -e\ \% 
setlocal errorformat=line\ %l\ column\ %c\ -\ %m
