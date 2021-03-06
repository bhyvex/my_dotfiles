"| File: ~/.vim/plugins.vim
"| Source: https://github.com/darnuria/my_dotFiles
"| Licence: UNLICENCE

" Required for plugins
filetype off

" Note: Skip initialization for vim-tiny or vim-small.
if !1 | finish | endif

if has('vim_starting')
    " Required:
    set runtimepath+=~/.vim/bundle/neobundle.vim/"
endif

call neobundle#begin(expand("~/.vim/bundle/"))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

"| Syntastics

let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=1
let g:syntastic_error_symbol = '★'
let g:syntastic_style_error_symbol = '@'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_style_warning_symbol = '#'
let g:syntastic_c_include_dirs = [ '.', '..', './includes', '../libopt/inc', '../*/includes', 'SDL2/include/SDL2' ]
let g:syntastic_ocaml_checkers = ['merlin']

NeoBundle 'scrooloose/syntastic.git'

"| QuickFixSign

" Show markers, quickfix and VCS status.
set lazyredraw
let g:quickfixsigns_events = ['BufEnter', 'CursorHold', 'CursorMoved', 'InsertLeave', 'InsertChange']
NeoBundle 'tomtom/quickfixsigns_vim'

"| Clang complete.
NeoBundleLazy "https://github.com/Rip-Rip/clang_complete", { 'build': {'linux': 'make'}}
let g:clang_library_path='/usr/lib/llvm-3.5/lib/libclang.so.1'
autocmd FileType c,cpp NeoBundleSource clang_complete

"| NERDTree

" autocmd vimenter * NERDTree
" autocmd vimenter * if !argc() | NERDTree | endif
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" function! s:CloseIfOnlyNerdTreeLeft()
"     if exists("t:NERDTreeBufName")
"         if bufwinnr(t:NERDTreeBufName) != -1
"             if winnr("$") == 1
"                 q
"             endif
"         endif
"     endif
" endfunction
" let NERDTreeIgnore = ['\.o$', '\.a$']
" NeoBundle 'scrooloose/nerdtree.git'

"| Vimproc

NeoBundle 'Shougo/vimproc.vim', {'build':{'linux' : 'make'}}

"| Unite
NeoBundle "https://github.com/Shougo/unite.vim"

" Let's provide fonctionnality like ctrl-p.
nnoremap <C-p> :Unite file_rec/async<cr>

" Let's use ag with vim.
nnoremap <space>/ :Unite ag:.<cr>

"| Gundo

nnoremap <F5> :GundoToggle<CR>
NeoBundle 'Gundo'

"| Rainbow Parentheses.

NeoBundle 'kien/rainbow_parentheses.vim'
" au VimEnter * RainbowParenthesesToggleAll
" au Syntax * RainbowParenthesesLoadRound
" au Syntax * RainbowParenthesesLoadSquare
" au Syntax * RainbowParenthesesLoadBraces

"| Solarized

NeoBundle 'https://github.com/altercation/vim-colors-solarized'
let g:solarized_termcolors=256
" let g:solarized_contrast="high"

"| Distinguished

NeoBundle 'https://github.com/Lokaltog/vim-distinguished'
let g:distinguished_termcolors=256

"| Vim fugitive.

NeoBundle 'https://github.com/tpope/vim-fugitive'

"| Ctrl-P

"NeoBundle 'http://github.com/kien/ctrlp.vim'
" let g:ctrlp_map = '<c-p>'
" let g:ctrlp_cmd = 'CtrlP'
" let g:ctrlp_match_window_bottom = 0
" let g:ctrlp_match_window_reversed = 0
" let g:ctrlp_custom_ignore = {
"   \ 'dir':  '\v[\/]\.(git|hg|svn)$',
"   \ 'file': '\v\.(exe|so|dll|swp|pyc|wav|mp3|o|ogg)$',
"   \ 'link': 'some_bad_symbolic_links',
"   \ }
" let g:ctrlp_working_path_mode = 'ra'
" let g:ctrlp_dotfiles = 0
" let g:ctrlp_switch_buffer = 0

"| AirLine

NeoBundle 'https://github.com/bling/vim-airline'
let g:airline_powerline_fonts = 0
let g:airline#extensions#tabline#enabled = 1

"| Haskell: vim2hs

NeoBundleLazy 'https://github.com/dag/vim2hs'

"| Haskell: ghcmod-vim

NeoBundleLazy 'https://github.com/eagletmt/ghcmod-vim'

autocmd FileType haskell NeoBundleSource vim2hs ghcmod-vim

"| Coq: Coquille

NeoBundleLazy 'https://github.com/the-lambda-church/coquille'

autocmd FileType coq NeoBundleSource coquille

"| Ocaml colorscheme by leo
" NeoBundle 'https://gist.github.com/LeoTestard/a96dcb4bc77e8a6e5a3d'

"| Ocaml: Merlin need to be install through opam
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"

"| ocp-indent
NeoBundleLazy "https://github.com/def-lkb/ocp-indent-vim"
autocmd FileType ocaml NeoBundleSource "ocp-indent-vim"

"| Rust: Rustsupport

NeoBundleLazy 'wting/rust.vim'

NeoBundleLazy 'https://github.com/phildawes/racer', {
            \   'build' : {
            \     'linux': 'cargo build --release',
            \   }
            \ }

set hidden
let g:racer_cmd="/home/darnuria/my_dotfiles/vim/bundle/racer/target/release/racer"
let $RUST_SRC_PATH="~/.local/"

autocmd FileType rust NeoBundleSource "rust.vim" "racer"

" Do not work :(
" NeoBundle 'https://github.com/fsharp/fsharpbinding/'

autocmd Filetype php NeoBundleSource 'better-indent-support-for-php-with-html'
NeoBundleLazy 'https://github.com/captbaritone/better-indent-support-for-php-with-html'

call neobundle#end()

" Required for plugins
filetype plugin indent on

" Installation Check
NeoBundleCheck
