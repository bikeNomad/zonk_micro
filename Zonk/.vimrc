set makeprg=rake
set errorformat=%*[^f]from\ %f:%l:%m
set errorformat+=%f:%l:%m
set errorformat+=%E%*[^F]Failure:,%C%*[^(](%*[^)])\ [%f\:%l]:,%Z%m
set foldlevel=4

autocmd FileType ruby let &l:tags = pathogen#legacyjoin(pathogen#uniq(
      \ pathogen#split(&tags) +
      \ map(split($GEM_PATH,':'),'v:val."/gems/*/tags"')))
