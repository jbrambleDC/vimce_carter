" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
set rtp+=~/.vim/bundle/vundle
call vundle#rc()
Bundle 'gmarik/vundle'

Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
filetype plugin indent on
" Use pathogen to modify the runtime path to include all
" plugins under the ~/.vim/bundle directory
execute pathogen#infect()
execute pathogen#helptags()

" home brewed functions
source ~/.vim/functions/myfunctions.vim

"-----------------------------------------------------------------------------
" settings
"-----------------------------------------------------------------------------
set autoindent                  " always set autoindenting on
au FileType py set smartindent
au Filetype py set textwidth=79
"set complete-=i
"set smarttab

set modelines=0                 " blocks modelines from being executed
set nomodeline                  " blocks modelines from being executed

set backspace=indent,eol,start  " allow backspacing over everything
set history=1000                " remember more commands and search history
set undolevels=1000             " use many muchos levels of undo
set timeoutlen=500
"set ttimeout
"set ttimeoutlen=100
set lazyredraw
set ruler                       " show the cursor position all the time
set nospell
set showcmd                     " display incomplete commands
set incsearch                   " do incremental searching
set ignorecase                  " case-insensitive search
set smartcase                   " case-sensitive search if any caps
set title                       " change the terminal's title
set guifont=Sauce\ Code\ Powerline        " much nicer font
set nobackup                    " no more stupid ~ files
"set autoread                   " reload files when changed on disk, i.e. via `git checkout`
"set backupcopy=yes                                           " see :help crontab
set dir=~/.swp,/tmp,/var/tmp    " don't pollute swps
set clipboard+=unnamed          " use windows/osx clipboard with yank and paste
set nowrap                      " no line wrap
set splitbelow
set splitright
set noerrorbells                " don't beep
set visualbell                  " don't beep
set number                      " always show line numbers
set showmatch                   " set show matching parenthesis
set expandtab
set scrolloff=3                 " show context above/below cursorline
set sidescrolloff=3
set tabstop=4                   " actual tabs occupy 8 characters
set softtabstop=2               " let's be good ruby citizens
set shiftwidth=2                " let's be good ruby citizens
set wildmenu                    " Make the command-line completion better
set wildmode=full
"set wildignore=log/**,node_modules/**,target/**,tmp/**,*.rbc
set cursorline                  " faster without; needs to be set when first opening a file to work
autocmd WinLeave * setlocal nocursorline
autocmd WinEnter * setlocal cursorline
set nofoldenable
set nrformats=                  " treat all numbers as base 10
"set nrformats-=octal
set list
set listchars=tab:⮀∎,trail:∎,extends:▲,precedes:▲,nbsp:⌧
autocmd filetype html,xml set listchars-=tab:⮀∎

" for ctags
set tags=tags,./tags

filetype plugin on
set omnifunc=syntaxcomplete#Complete

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
  "set ttymouse=xterm2
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on
  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!
  " For all files set 'textwidth' to 90 characters.
  autocmd FileType * setlocal textwidth=128
  autocmd FileType py set textwidth=79
  autocmd FileType ruby setlocal textwidth=128
  " only auto enable spelling for these few types
  autocmd FileType svn,*commit* setlocal spell
  autocmd FileType help setlocal nospell
  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost * call SetCursorPosition()
  augroup END
else
  set autoindent    " always set autoindenting on
  set copyindent    " copy the previous indentation on autoindenting
endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
      \ | wincmd p | diffthis
endif

let python_highlight_all = 1

let g:netrw_dirhistmax=0

"-----------------------------------------------------------------------------
" mapping goodness
"-----------------------------------------------------------------------------
nnoremap ; :
let mapleader = ","           " change the mapleader from \ to ,
let g:mapleader = ","

" tab shortcuts
map <C-t> :tabnew<CR>
map <leader>tn :tabnew<CR>
map <leader>tc :tabclose<CR>

map <T-Right> :tabn<CR>
map <T-Left> :tabp<CR>
map <S-Up> :wincmd k<CR>
map <S-Down> :wincmd j<CR>
map <S-Left> :wincmd h<CR>
map <S-Right> :wincmd l<CR>

set pastetoggle=<leader>pt
map <F5> :buffers<CR>:b!

" reset search highlighting
nmap <silent> <leader>/ :nohlsearch<CR>

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" toggle spell check
map <silent> <leader>st :setlocal spell! spelllang=en_us<CR>

" toggle line wrap
map <silent> <leader>wt :setlocal wrap!<CR>

" removes all trailing whitespace
nmap <leader>sw :call StripTrailingWhitespace()<CR>

" Don't use Ex mode, use Q for formatting
map Q gq

" This allows for change paste motion cp{motion}
" so replace word with current buffer would be cpw
" 3 words would be cp3w
" rest of line would be cp$ and so on...
nmap <silent> cp :set opfunc=ChangePaste<CR>g@
function! ChangePaste(type, ...)
    silent exe "normal! `[v`]\"_c"
    silent exe "normal! p"
endfunction

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Mac OS X clipboard integration
nmap <F3> :set paste<CR>:r !pbpaste<CR>:set nopaste<CR>
vmap <F4> :w !pbcopy<CR><CR>

" reselect visual block after indent
vnoremap < <gv
vnoremap > >gv

" reselect last paste
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

"-----------------------------------------------------------------------------
" mouse mode toggle
"-----------------------------------------------------------------------------
fun! s:ToggleMouse()
    if !exists("s:old_mouse")
        let s:old_mouse = "a"
    endif

    if &mouse == ""
        let &mouse = s:old_mouse
        set number
        echo "Mouse is for Vim (" . &mouse . ")"
    else
        let s:old_mouse = &mouse
        let &mouse=""
        set nonumber
        echo "Mouse is for terminal"
    endif
endfunction

noremap <leader>mt :call <SID>ToggleMouse()<CR>
inoremap <leader>mt <Esc>:call <SID>ToggleMouse()<CR>a

"-----------------------------------------------------------------------------
" make cursor and status line purdy
"-----------------------------------------------------------------------------
colorscheme onedark

"set statusline=
"set statusline+=%1*  "switch to User1 highlight
"set statusline+=%F   "full filename
"set statusline+=%2*  "switch to User2 highlight
"set statusline+=%y   "filetype
"set statusline+=%3*  "switch to User3 highlight
"set statusline+=%l   "line number
"set statusline+=%*   "switch back to statusline highlight
"set statusline+=%P   "percentage thru file

" change cursor shape between modes
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" statusline setup
set statusline=%#identifier#
set statusline+=%{GitStatusline()}

set statusline+=%#identifier#
set statusline+=%h

" read only flag
set statusline+=%#warningmsg#
set statusline+=%{ReadOnlyFlag()}
set statusline+=%*

set statusline+=%#identifier#
set statusline+=[%-.100f]    "relative path is better than tail %t option
set statusline+=%*

set statusline+=%#warningmsg#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%*

set statusline+=%#warningmsg#
set statusline+=%{StatuslineLongLineWarning()}
set statusline+=%*

set statusline+=%#warningmsg#
set statusline+=%{StatuslineTrailingSpaceWarning()}
set statusline+=%*

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" display a warning if &paste is set
set statusline+=%#error#
set statusline+=%{&paste?'[paste]':''}
set statusline+=%*

" modified flag
set statusline+=%#identifier#
set statusline+=%m
set statusline+=%*

" left/right separator
set statusline+=%=
"set statusline+=[%03.b][0x%B] " ASCII and byte code under cursor
set statusline+=%{StatuslineCurrentHighlight()}
set statusline+=%#identifier#
set statusline+=%{&ft!=''?'['.&ft.']':''}     "filetype

" display a warning if fileformat isnt unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

" display a warning if file encoding isnt utf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

"set statusline+=%#identifier#
"set statusline+=[%{FileSize()}]

set statusline+=%#identifier#
set statusline+=[%c:%l\ %P]     " cursor column:line position

set laststatus=2

"-----------------------------------------------------------------------------
" for nerdtree plugin
"-----------------------------------------------------------------------------
let NERDTreeShowHidden=1 "Show hidden files in NerdTree
let NERDTreeIgnore=['\.svn$','\.git$']
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") &&
      \ b:NERDTreeType == "primary") | q | endif

map <silent> <leader>nt :NERDTreeTabsToggle<CR>
map <silent> <C-n> :NERDTreeTabsToggle<CR>
let g:NERDTreeMapOpenVSplit = 'v'
let g:NERDTreeMapOpenSplit = 's'

" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg)
 exec 'autocmd filetype nerdtree syn match ' . a:extension
       \ .' #^\s\+.*'. a:extension .'$#'
 exec 'autocmd filetype nerdtree highlight ' . a:extension
       \ .' ctermbg='. a:bg .' ctermfg='. a:fg
       \ .' guibg='. a:bg .' guifg='. a:fg
endfunction

"call NERDTreeHighlightFile('bash', 'green', 'black')
"call NERDTreeHighlightFile('sh', 'green', 'black')
"call NERDTreeHighlightFile('html', 'green', 'black')
"call NERDTreeHighlightFile('css', 'green', 'black')

"-----------------------------------------------------------------------------
" Fugitive; vim + git + gitv
"-----------------------------------------------------------------------------
autocmd User fugitive
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \  noremap <buffer> .. :edit %:h<cr> |
  \ endif
autocmd BufReadPost fugitive://* set bufhidden=delete

nmap <leader>gs :Gstatus<cr>
nmap <leader>gd :Gdiff<cr>
nmap <leader>gc :Gcommit<CR>
nmap <leader>gl :Glog<CR>
nmap <leader>ge :Gedit<cr>
nmap <leader>gw :Gwrite<cr>
nmap <leader>gr :Gread<cr>

"-----------------------------------------------------------------------------
" gitk implemented in vimscript (gitv)
"-----------------------------------------------------------------------------
nmap <leader>gv :Gitv<CR>
nmap <leader>gV :Gitv!<CR>

"-----------------------------------------------------------------------------
" Gundo stuff
"-----------------------------------------------------------------------------
nmap <silent> <leader>ut :GundoToggle<CR>

"-----------------------------------------------------------------------------
" for tagbar
"-----------------------------------------------------------------------------
nmap <silent> <leader>tt :TagbarToggle<CR>

"-----------------------------------------------------------------------------
" haz vimdiff ignore whitespace
"-----------------------------------------------------------------------------
"if &diff
"    " diff mode
"    set diffopt+=iwhite
"endif

"-----------------------------------------------------------------------------
" add syntax coloring for new filetypes
"-----------------------------------------------------------------------------
au BufNewFile,BufRead *.rabl set filetype=ruby
au BufNewFile,BufRead *.pill set filetype=ruby

au BufNewFile,BufRead *.kjb set filetype=xml
au BufNewFile,BufRead *.ktr set filetype=xml

au BufNewFile,BufRead *.hql set filetype=sql

au BufNewFile,BufRead *.bash* set filetype=sh

au BufNewFile,BufRead *.py set filetype=python

"-----------------------------------------------------------------------------
" autosave and autoload session if one exists
"-----------------------------------------------------------------------------
nmap <leader>zi :call InitZession()<CR>

function! InitZession()
  execute 'mksession! ' . getcwd() . '/.zession.vim'
endfunction

"autocmd VimLeave * call SaveZession()
"function! SaveZession()
"  if &ft != 'gitcommit' && filereadable(getcwd() . '/.zession.vim')
"    call InitZession()
"  endif
"endfunction

autocmd VimEnter * call RestoreZession()
function! RestoreZession()
  if argc() == 0
    if filereadable(getcwd() . '/.zession.vim')
      execute 'so ' . getcwd() . '/.zession.vim'
      if bufexists(1)
        for l in range(1, bufnr('$'))
          if bufwinnr(l) == -1
            exec 'sbuffer ' . l
          endif
        endfor
      endif
    endif
  endif
endfunction


"-----------------------------------------------------------------------------
" return the syntax highlight group under the cursor ''
"-----------------------------------------------------------------------------
function! GitStatusline()
  let status = fugitive#head(7)
  return '[⭠ '.status.']'
endfunction

function! StatuslineCurrentHighlight()
  let name = synIDattr(synID(line('.'),col('.'),1),'name')
  if name == ''
    return ''
  else
    return '[' . name . ']'
  endif
endfunction

function! StatuslineCurrentTrans()
  let name = synIDattr(synID(line('.'),col('.'),0),"name")
  if name == ''
    return ''
  else
    return '[' . name . ']'
  endif
endfunction

function! StatuslineCurrentLo()
  let name = synIDattr(synIDtrans(synID(line('.'),col('.'),1)),'name')
  if name == ''
    return ''
  else
    return '[' . name . ']'
  endif
endfunction

" Returns syntax highlighting group the current "thing" under the cursor
nmap <silent> ,qq :echo 'hi' . StatuslineCurrentHighlight() .
      \ ' trans' . StatuslineCurrentTrans() .
      \ ' lo' . StatuslineCurrentLo() <CR>

"-----------------------------------------------------------------------------
" trailing whitespace setter
"-----------------------------------------------------------------------------
" Recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning
" return '[\s]' if trailing white space is detected
" return '' otherwise
function! StatuslineTrailingSpaceWarning()
  if !exists("b:statusline_trailing_space_warning")
    if !&modifiable
      let b:statusline_trailing_space_warning = ''
      return b:statusline_trailing_space_warning
    endif
    if search('\s\+$', 'nw') != 0
      let b:statusline_trailing_space_warning = '[\s]'
    else
      let b:statusline_trailing_space_warning = ''
    endif
  endif
  return b:statusline_trailing_space_warning
endfunction

"-----------------------------------------------------------------------------
" mixed indentation warning setter
"-----------------------------------------------------------------------------
" Recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning
" return '[&et]' if &et is set wrong
" return '[mixed-indenting]' if spaces and tabs are used to indent
" return an empty string if everything is fine
function! StatuslineTabWarning()
  if !exists("b:statusline_tab_warning")
    let b:statusline_tab_warning = ''
    if !&modifiable
      return b:statusline_tab_warning
    endif
    let tabs = search('^\t', 'nw') != 0
    "find spaces that arent used as alignment in the first indent column
    let spaces = search('^ \{' . &ts . ',}[^\t]', 'nw') != 0
    if tabs && spaces
      let b:statusline_tab_warning = '[mixed-indenting]'
    elseif (spaces && !&et) || (tabs && &et)
      let b:statusline_tab_warning = '[&et]'
    endif
  endif
  return b:statusline_tab_warning
endfunction

"-----------------------------------------------------------------------------
" long line warning setter
"-----------------------------------------------------------------------------
" Recalculate the long line warning when idle and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_long_line_warning
" return a warning for "long lines" where
" long" is either &textwidth or 80 (if no &textwidth is set)
" return '' if no long lines
" return '[#x,my,$z] if long lines are found, were x is the number of long
" lines, y is the median length of the long lines and z is the length of the
" longest line
function! StatuslineLongLineWarning()
  if !exists("b:statusline_long_line_warning")
    if !&modifiable
      let b:statusline_long_line_warning = ''
      return b:statusline_long_line_warning
    endif
    let long_line_lens = s:LongLines()
    if len(long_line_lens) > 0
      let b:statusline_long_line_warning = "[" .
            \ '#' . len(long_line_lens) . "," .
            \ 'm' . s:Median(long_line_lens) . "," .
            \ '$' . max(long_line_lens) . "]"
    else
      let b:statusline_long_line_warning = ""
    endif
  endif
  return b:statusline_long_line_warning
endfunction

" return a list containing the lengths of the long lines in this buffer
function! s:LongLines()
  let threshold = (&tw ? &tw : 80)
  let spaces = repeat(" ", &ts)
  let line_lens = map(getline(1,'$'),
        \ 'len(substitute(v:val, "\\t", spaces,  "g"))')
  return filter(line_lens, 'v:val > threshold')
endfunction

" return the median of the given array of numbers
function! s:Median(nums)
  let nums = sort(a:nums)
  let l = len(nums)
  if l % 2 == 1
    let i = (l-1) / 2
    return nums[i]
  else
    return (nums[l/2] + nums[(l/2)-1]) / 2
  endif
endfunction

"-----------------------------------------------------------------------------
" read only flag setter
"-----------------------------------------------------------------------------
function! ReadOnlyFlag()
  return &ft !~? 'vimfiler\|gundo' && &readonly ? '[⭤]' : ''
endfunction

"-----------------------------------------------------------------------------
" jump to last cursor position when opening a file
" do not do it when writing a commit
"-----------------------------------------------------------------------------
function! SetCursorPosition()
  if &filetype !~ 'svn\|commit\c'
    if line("'\"") > 0 && line("'\"") <= line("$")
      exe "normal! g`\""
      normal! zz
    endif
  end
endfunction

"-----------------------------------------------------------------------------
" whitespace nuker
"-----------------------------------------------------------------------------
function! Preserve(command)
  " preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " do the business:
  execute a:command
  " clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

function! StripTrailingWhitespace()
  call Preserve("%s/\\s\\+$//e")
endfunction

"-----------------------------------------------------------------------------
" syntastic styles
"-----------------------------------------------------------------------------
let g:syntastic_error_symbol = '✗'
let g:syntastic_style_error_symbol = '✠'
let g:syntastic_warning_symbol = '∆'
let g:syntastic_style_warning_symbol = '≈'

"-----------------------------------------------------------------------------
" eval vimscript by line or visual selection
"-----------------------------------------------------------------------------
nmap <silent> <leader>ve :call Source(line('.'), line('.'))<CR>
vmap <silent> <leader>ve :call Source(line('v'), line('.'))<CR>

function! Source(begin, end)
  let lines = getline(a:begin, a:end)
  for line in lines
    execute line
  endfor
endfunction

"-----------------------------------------------------------------------------
" fetch file size
"-----------------------------------------------------------------------------
nmap <silent> <leader>fs :echo 'filesize:' . FileSize()<CR>
function! FileSize()
  let bytes = getfsize(expand("%:p"))
  if bytes <= 0
    return ""
  endif
  if bytes < 1024
    return bytes
  else
    return (bytes / 1024) . "K"
  endif
endfunction

"-----------------------------------------------------------------------------
" load local settings
"-----------------------------------------------------------------------------
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
" Python-mode
" Activate rope
" Keys:
" K             Show python docs
" <Ctrl-Space>  Rope autocomplete
" " <Ctrl-c>g     Rope goto definition
" " <Ctrl-c>d     Rope show documentation
" " <Ctrl-c>f     Rope find occurrences
" " <Leader>b     Set, unset breakpoint (g:pymode_breakpoint enabled)
" " [[            Jump on previous class or function (normal, visual, operator modes)
" " ]]            Jump on next class or function (normal, visual, operator modes)
" " [M            Jump on previous class or method (normal, visual, operator modes)
" " ]M            Jump on next class or method (normal, visual, operator modes)
let g:pymode_rope = 1

" " Documentation
let g:pymode_doc = 1
let g:pymode_doc_key = 'K'

" "Linting
let g:pymode_lint = 1
let g:pymode_lint_checker = "pyflakes,pep8"
" " Auto check on save
let g:pymode_lint_write = 1
"
" Support virtualenv
let g:pymode_virtualenv = 1
"
" Enable breakpoints plugin
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_bind = '<leader>b'
"
" " syntax highlighting
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all
"
" " Don't autofold code
let g:pymode_folding = 0
