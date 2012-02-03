let g:SuperTabDefaultCompletionType = 'context'
let g:sql_type_default = 'mysql'                    " MySQL is the default sql.
let php_sql_query   = 1                             " SQL Highlighting in Strings
let php_htmlInStrings = 1                           " HTML Hightlight in Strings
let php_folding     = 0                             " Fold all { } regions
au BufNewFile,BufRead *.php set ft=php " All is php
au BufNewFile,BufRead *.php set spell

" Match @todo and @fix lines
au BufNewFile,BufRead *.php exec 'match Todo /\c\(\s\|@\)todo\(:\|\s\).*/'
au BufNewFile,BufRead *.php exec '2match Error /\c\(\s\|@\)fix\(:\|\s\).*/'

au BufNewFile *.php call PHP_template()
fun! PHP_template()
    let file = input("File title? ")
    let desc = input("File description? ")
    let date = strftime("%c")
    append
<?php
/**
 * @FILE@
 *
 * @DESC@
 *
 * @author @AUTHOR@ <@AUTHOREMAIL@>
 * @since @DATE@
 */



/* vim:set ft=php ts=4 sw=4 et */
.
execute ":%s/@FILE@/\\=file/"
execute ":%s/@DESC@/\\=desc/"
execute ":%s/@DATE@/\\=date/"
execute ":%s/@AUTHOR@/\\=g:C_AuthorName/"
execute ":%s/@AUTHOREMAIL@/\\=g:C_Email/"
call cursor(11,1)
endfun

nmap <Leader>et :call PHP_UnitTest()<CR>
fun! PHP_UnitTest()
    exe "!ssh rv-atl-dev01 'cd /usr/share/www/base_packages/tests; phpunit --verbose AllTests'"
endfun

nmap <silent> <Leader>ac vip:Align =<CR>vip:!sort<CR>

" search php.net instead of man
" au BufNewFile,BufRead *.htm,*.html,*.php setlocal keywordprg=~/bin/php_doc.sh

" PHPCS stuff
function! RunPhpcs()
    let l:filename=@%
    let l:phpcs_output=system('phpcs --report=csv --standard=YMC '.l:filename)
"    echo l:phpcs_output
    let l:phpcs_list=split(l:phpcs_output, "\n")
    unlet l:phpcs_list[0]
    cexpr l:phpcs_list
    cwindow
endfunction

set errorformat+=\"%f\"\\,%l\\,%c\\,%t%*[a-zA-Z]\\,\"%m\"
command! Phpcs execute RunPhpcs()
