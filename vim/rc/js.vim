au BufNewFile,BufRead *.js set ft=javascript
au BufNewFile,BufRead *.js set makeprg=rhino\ ~/lib/jslint.js\ %
au BufNewFile,BufRead *.js set efm=%ELint\ at\ line\ %l\ character\ %c:\ %m,%Z%m
