" Notes {
"   vim: set foldmarker={,} foldlevel=0 spell:
"
"   Kenny Parnell <k.parnell@gmail.com>
" }

" General {
    " Load Pathogen
    call pathogen#runtime_append_all_bundles('bundles')

    set background=dark
    set cmdheight=2
    set expandtab
    set hlsearch
    set incsearch
    set laststatus=2
    set lazyredraw
    set listchars=eol:$,tab:>-,trail:.,extends:<,precedes:>
    set mouse=a
    set number
    set ruler
    set rulerformat=%25(%n%m%r:\ %Y\ [%l,%v]\ %p%%%)
    set shiftwidth=4
    set showtabline=2
    set smartindent
    set smarttab
    set ignorecase
    set smartcase
    set tabstop=4
    set title titlestring=%<%t%m%=%l/%L-%P titlelen=70
    set ttyfast  " As fast as you can
    set vb t_vb= " No beep or flash
    set wildmenu
    set wildmode=list:longest,full
    set nocursorline
    set hidden
    if v:version >= 703
        set undofile
        set undodir=~/.vim/undo
    endif
    let g:solarized_underline=0
    let g:solarized_style="dark"
    colorscheme vividchalk
" }

" Memory {
    set history=1000
    set maxmem=2000000
    set maxmempattern=2000000
    set maxmemtot=2000000
" }

" Programming {
    set nocompatible    " We're running Vim no Vi!
    syntax on           " Enable syntax highlighting
    filetype on         " Enable filetype detection
    filetype indent on  " Enable filetype-specific indenting
    filetype plugin on  " Enable filetype-specific plugins
" }

" Folding {
    set foldcolumn=3
    set foldenable
    set foldlevel=3
    set foldminlines=2
" }

" Plugins {
    " SQL Settings
    let g:sql_type_default = 'tsql'
" }

" Externals {
    " Load php stuff
    source ~/.vim/rc/php.vim

    " Load js stuff
    source ~/.vim/rc/js.vim
" }

" Autocommands {
    " Load mutt stuff
    au BufRead,BufNewFile /tmp/mutt* source ~/.vim/rc/mutt.vim

    " Set file type for sql stuff
    au BufRead,BufNewFile /tmp/sql* set ft=sql

    " Set Vala stuff
    au BufRead *.vala set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
    au BufRead *.vapi set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
    au BufRead,BufNewFile *.vala setfiletype vala
    au BufRead,BufNewFile *.vapi setfiletype vala

    " Load config files as such
    au BufRead,BufNewFile */config set ft=config

    " Change foldmethod for vim files
    au BufRead,BufNewFile .vimrc set foldmethod=marker
    au BufRead,BufNewFile *.vim set foldmethod=marker

    " Set highlighting for smarty templates
    au BufRead,BufNewFile */phoenix*/templates/*.html set ft=smarty
    au BufRead,BufNewFile */phx-*/templates/*.html set ft=smarty

    " Set highlighting for slim templates
    au BufRead,BufNewFile *.slim set ft=slim

    " Ruby options
    au FileType ruby,eruby,rspec set sw=2 ts=2 et

    " Auto-compile coffee scripts
    au BufWritePost,FileWritePost *.coffee :silent !coffee -c <afile>

    if v:version >= 703
        au FileType vim,javascript,c,python,java,ruby set cc=80
        au FileType vim,javascript,c,python,java,ruby hi ColorColumn ctermbg=darkgray guibg=#222222
    endif
" }

" Functions {
    " Convenient command to see the difference between the current buffer and the
    " file it was loaded from, thus the changes you made.
    command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis

    function! s:JSLint ()
        cclose
        let out = system('jslint', join(getline(1, '$'), "\n"))
        if out != "jslint: No problems found.\n"
            let errors = split(out, '[^\n]\n[^\n]\zs')
            let error_list = []
            for e in errors
                let thise = split(e, '|||')
                let error_list += [{'filename': expand("%"), 'lnum': thise[0], 'col': thise[1], 'text': thise[2]}]
            endfor
            call setqflist(error_list, 'r')
            copen
        else
            echo "No Problems."
        endif
    endfunction
    command! JSLint call <SID>JSLint()
    map <Leader>js :JSLint<CR>

    function! RedirToClipboardFunction(cmd, ...)
        let cmd = a:cmd . " " . join(a:000, " ")
        redir @*>
        exe cmd
        redir END
    endfunction
    command! -complete=command -nargs=+ RedirToClipboard
                \ silent! call RedirToClipboardFunction(<f -args>)

    function! ExtractVariable()
        let name = input("Variable name: ")
        if name == ''
            return
        endif
        normal! gv
        exec "normal c" . name
        if &filetype == 'sh'
            exec "normal O" . name . "="
        else
            exec "normal O" . name . " = "
        endif
        normal! $p
    endfunction
    vmap <leader>ev :call ExtractVariable()<cr>

    function! InlineVariable()
        normal! "ayiw
        if &filetype == 'sh'
            normal! df=
        else
            normal! 4diw
        endif
        normal! "bd$
        normal! dd
        normal! k$
        exec ':%s/\<' . @a . '\>/' . escape(@b, '\/~') . '/gc'
    endfunction
    nmap <leader>iv :call InlineVariable()<cr>

    source ~/.vim/scripts/todo.vim
    source ~/.vim/scripts/remote.vim

    function! <SID>SynStack()
        if !exists("*synstack")
            return
        endif
        echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
    endfunction
    nmap <silent> <C-S-P> :call <SID>SynStack()<CR>
" }

" Maps {
    " Session Management
    nmap <silent> <Leader>ss :wa<Bar>exe "mksession! " . v:this_session<CR>:echo 'Session saved to ' . v:this_session<CR>
    nmap <Leader>sa :wa<Bar>exe "mksession! " . v:this_session<CR>:bufdo bd<CR>:so ~/sessions/
    nmap <silent> <Leader>sq :wa<Bar>exe "mksession! " . v:this_session<CR>:qall<CR>

    " Auto insert slashes before () in search
    cmap ;\ \(\)<Left><Left>

    " Copy and paste using external clipboard
    vmap <silent> <Leader>y "+y
    vmap <silent> <Leader>Y "+Y
    nmap <silent> <Leader>p :set paste<CR>"+p:set nopaste<CR>
    vmap <silent> <Leader>p x:set paste<CR>"+p:set nopaste<CR>
    nmap <silent> <Leader>P :set paste<CR>"+P:set nopaste<CR>
    vmap <silent> <Leader>P x:set paste<CR>"+P:set nopaste<CR>

    " Work the arrow keys
    nmap <Left> :tabp<CR>
    nmap <Right> :tabn<CR>
    vmap <Left> <ESC>:tabp<CR>
    imap <Right> <ESC>:tabn<CR>
    imap <Left> <ESC>:tabp<CR>
    vmap <Right> <ESC>:tabn<CR>

    " Resize the windows
    nmap <S-Left> <C-w><
    nmap <S-Right> <C-w>>
    nmap <S-Up> <C-w>+
    nmap <S-Down> <C-w>-

    " Moving Text
    nmap <C-Up> ddkP
    nmap <C-Down> ddp
    vmap <C-Up> xkP'[V']
    vmap <C-Down> xp'[V']

    " Indent/Dedent
    vmap <C-Right> >'[V']
    vmap <C-Left> <'[V']

    "Power Write
    cmap w!! w !sudo tee %

    " Gundo
    nmap <Leader>gu :GundoToggle<CR>

    " Mouse Box for Python
    vmap <Leader>bm !boxes -d mouse<CR>4h<C-v>']5hr#7j<C-v>/_<CR>kr<space>2k$i_<ESC>j<C-v>/_<CR>$2hkc<space>#<ESC>/_<CR>$hi_<ESC>02j<C-v>?\^<CR>03klx:noh<CR>

    " replace word under cursor
    nmap <Leader>sw :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
" }
