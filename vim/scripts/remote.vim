function! s:RemoteTree ()
    vertical topleft 40vsplit scp://dev/Projects/
endfunction
command! RemoteTree call <SID>RemoteTree()
map <silent> <Leader>rt :RemoteTree<CR>
